
using Plots
using Base.Iterators

theme(:dark)

filename="phasors"
height = 5

steps = 100
phasorlength = 0.5

rad120deg = 2*π/3
angleOffset = cos(rad120deg)  + sin(rad120deg)*im
radStep = 2*π/steps
angleTimestep = cos(radStep) + sin(radStep)*im

function getStartFactors()
	start_phi_1 = im # Phase 1 points straight up at t=0
	start_phi_2 = start_phi_1 * angleOffset  # rotation cw in complex plane
	start_phi_3 = start_phi_1 / angleOffset  # rotation ccw in complex plane

	factor_phi_1_cw =  start_phi_1 /2
	factor_phi_1_ccw = start_phi_1 /2
	factor_phi_2_cw =  (start_phi_2 /2) *angleOffset
	factor_phi_2_ccw = (start_phi_2 /2) /angleOffset
	factor_phi_3_cw =  (start_phi_3 /2)*angleOffset*angleOffset
	factor_phi_3_ccw = ((start_phi_3 /2)/(angleOffset))/angleOffset

	return [factor_phi_1_cw factor_phi_2_cw factor_phi_3_cw; factor_phi_1_ccw factor_phi_2_ccw factor_phi_3_ccw]
end

function stepTransform(stepMatrix::Matrix{Complex},factors::Array{Complex,2})
		return stepMatrix*factors 
end

function stepX(x::Int, stepMatrix::Matrix{Complex}, factors::Array{Complex,2})
	return (stepMatrix^x)*factors
end

function simpleStartPlot()

	stepMatrix = [ angleTimestep  0  ; 0 1/angleTimestep ]
	factorMatrix = stepX(1,stepMatrix,getStartFactors())
	factors_phi_1 = factorMatrix[:,1] 
	factors_phi_2 = factorMatrix[:,2] 
	factors_phi_3 = factorMatrix[:,3] 
	phase_phi_1 = sum(factors_phi_1) 
	phase_phi_2 = sum(factors_phi_2) 
	phase_phi_3 = sum(factors_phi_3) 

	plot([factors_phi_1[1],factors_phi_1[2],phase_phi_1], seriestype=:scatter,markershape=[:ltriangle,:rtriangle,:hexagon],labels="ϕ_1", xlims = (-2,2), ylims=(-2,2))
	plot!([factors_phi_2[1],factors_phi_2[2],phase_phi_2], seriestype=:scatter,markershape=[:ltriangle,:rtriangle,:hexagon],labels="ϕ_2")
	plot!([factors_phi_3[1],factors_phi_3[2],phase_phi_3], seriestype=:scatter,markershape=[:ltriangle,:rtriangle,:hexagon],labels="ϕ_3")
	plot!([phase_phi_1+phase_phi_2+phase_phi_3],seriestype=:scatter,labels="summed")
end

simpleStartPlot()

function plotPhasors()

	factor_phi_1_cw, factor_phi_1_ccw, factor_phi_2_cw, factor_phi_2_ccw, factor_phi_3_cw, factor_phi_3_ccw = Tuple(getStartFactors())
	phase_phi_1 =  factor_phi_1_ccw+factor_phi_1_cw
	phase_phi_2 =  factor_phi_2_ccw+factor_phi_2_cw
	phase_phi_3 =  factor_phi_3_ccw+factor_phi_3_cw

	#p = plot([start_phi_1,start_phi_2,start_phi_3], seriestype=:scatter, labels="start")

	#plot!(p,[factor_phi_1_cw,factor_phi_1_ccw], seriestype=:scatter,labels="ϕ_1")
	#plot!(p,[factor_phi_2_cw,factor_phi_2_ccw], seriestype=:scatter,labels="ϕ_2")
	#plot!(p,[factor_phi_3_cw,factor_phi_3_ccw], seriestype=:scatter,labels="ϕ_3")

	anim = @animate for i in range(0, stop = 2π, length=steps)
		plot([factor_phi_1_cw,factor_phi_1_ccw,phase_phi_1], seriestype=:scatter,markershape=[:ltriangle,:rtriangle,:hexagon],labels="ϕ_1", xlims = (-1,7,1.7), ylims=(-1.7,1.7))
		plot!([factor_phi_2_cw,factor_phi_2_ccw,phase_phi_2], seriestype=:scatter,markershape=[:ltriangle,:rtriangle,:hexagon],labels="ϕ_2", xlims = (-1,7,1.7), ylims=(-1.7,1.7))
		plot!([factor_phi_3_cw,factor_phi_3_ccw,phase_phi_3], seriestype=:scatter,markershape=[:ltriangle,:rtriangle,:hexagon],labels="ϕ_3", xlims = (-1,7,1.7), ylims=(-1.7,1.7))
		plot!([phase_phi_1+phase_phi_2+phase_phi_3],seriestype=:scatter,labels="summed", xlims = (-1,7,1.7), ylims=(-1.7,1.7))
	end
	gif(anim, "$filename.webm", fps=10)
end
#plotPhasors()


# function parameters()
# 	startRange = range(0,2π,length=totalPoints)
# 	return startRange,startRange,repeat([0],totalPoints)
# end

# function startPoints(x,y,z)
# 	return cos(x),sin(y),z
# end

# # from sine/cosine formulas:
# # https://math.libretexts.org/Bookshelves/Precalculus/Book%3A_Precalculus_(OpenStax)/07%3A_Trigonometric_Identities_and_Equations/7.02%3A_Sum_and_Difference_Identities
# # cos(α+β)=cosα*cosβ−sinα*sinβ
# # sin(α+β)=sinα*cosβ+cosα*sinβ
# function params2EndPoints(x,y,z)
# 	newX = cos(x)*cos(paramOffset) - sin(x)*sin(paramOffset)
# 	newY = sin(y)*cos(paramOffset) + cos(y)*sin(paramOffset)
# 	newZ = z+height
# 	return newX,newY,newZ
# end

# function drawLines(x,y,z,x2,y2,z2)
# 	Plots.plot!([x,x2],[y,y2],[z,z2], axis=nothing,aspect_ratio=:equal,label="")
# end

# function simplePlot()
# 		tx,ty,tz= parameters()
# 		starts = startPoints.(tx,ty,tz)
# 		#similar to start.
# 		all = params2EndPoints.(tx,ty,tz)
# 		x2, y2, z2 = map(x->x[1],all), map(x->x[2],all),getfield.(all,3)
# 		println(map(z->z[3],all))
# 		rlx,rly,rlz = radiusLow .* getfield.(starts,1),getfield.(starts,2),getfield.(starts,3)
# 		rhx,rhy,rhz = radiusHigh .* x2,y2,z2
# 		p = Plots.plot(rlx,rly,rlz, seriestype = :scatter, axis=nothing,aspect_ratio=:equal,label="")
# 		#p = Plots.plot(x,y,z, seriestype = :scatter, axis=nothing,aspect_ratio=:equal)
# 		drawLines.(rlx,rly,rlz,rhx,rhy,rhz)
# 		#return Plots.plot!(x2,y2,z2, seriestype = :scatter, axis=nothing,aspect_ratio=:equal)
# 		return Plots.plot!(rhx,rhy,rhz, seriestype = :scatter, axis=nothing,aspect_ratio=:equal,label="")
# end

# function plot3d()
# 	p = simplePlot()
# 	anim = @animate for i in range(0, stop = 2π, length=100)
# 		Plots.plot!(p, camera = (40 * (1 + cos(i)), 30*(1+cos(i))))
# 	end
# 	#Plots.plot(vcat(x,x),vcat(y,y),vcat(z,-z),seriestype=:surface)
# 	gif(anim, "$filename.webm", fps=10)
# end
#plot3d()
