using Plots
using Base.Iterators

theme(:dark)

filename="coolingTower"
height = 5
radiusLow = 2
radiusHigh = 1
totalPoints = 30
paramOffset = π*2.5/4

function parameters()
	startRange = range(0,2π,length=totalPoints)
	return startRange,startRange,repeat([0],totalPoints)
end

function startPoints(x,y,z)
	return cos(x),sin(y),z
end

# from sine/cosine formulas:
# https://math.libretexts.org/Bookshelves/Precalculus/Book%3A_Precalculus_(OpenStax)/07%3A_Trigonometric_Identities_and_Equations/7.02%3A_Sum_and_Difference_Identities
# cos(α+β)=cosα*cosβ−sinα*sinβ
# sin(α+β)=sinα*cosβ+cosα*sinβ
function params2EndPoints(x,y,z)
	newX = cos(x)*cos(paramOffset) - sin(x)*sin(paramOffset)
	newY = sin(y)*cos(paramOffset) + cos(y)*sin(paramOffset)
	newZ = z+height
	return newX,newY,newZ
end

function drawLines(x,y,z,x2,y2,z2)
	Plots.plot!([x,x2],[y,y2],[z,z2], axis=nothing,aspect_ratio=:equal,label="")
end

function simplePlot()
		tx,ty,tz= parameters()
		starts = startPoints.(tx,ty,tz)
		#similar to start.
		all = params2EndPoints.(tx,ty,tz)
		x2, y2, z2 = map(x->x[1],all), map(x->x[2],all),getfield.(all,3)
		println(map(z->z[3],all))
		rlx,rly,rlz = radiusLow .* getfield.(starts,1),getfield.(starts,2),getfield.(starts,3)
		rhx,rhy,rhz = radiusHigh .* x2,y2,z2
		p = Plots.plot(rlx,rly,rlz, seriestype = :scatter, axis=nothing,aspect_ratio=:equal,label="")
		#p = Plots.plot(x,y,z, seriestype = :scatter, axis=nothing,aspect_ratio=:equal)
		drawLines.(rlx,rly,rlz,rhx,rhy,rhz)
		#return Plots.plot!(x2,y2,z2, seriestype = :scatter, axis=nothing,aspect_ratio=:equal)
		return Plots.plot!(rhx,rhy,rhz, seriestype = :scatter, axis=nothing,aspect_ratio=:equal,label="")
end

function plot3d()
	p = simplePlot()
	anim = @animate for i in range(0, stop = 2π, length=100)
		Plots.plot!(p, camera = (40 * (1 + cos(i)), 30*(1+cos(i))))
	end
	#Plots.plot(vcat(x,x),vcat(y,y),vcat(z,-z),seriestype=:surface)
	gif(anim, "$filename.webm", fps=10)
end
#plot3d()
