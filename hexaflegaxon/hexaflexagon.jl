using Plots

theme(:dark)
fileName = "3DHexaFlexagon"

# Multiplies the elements at indexes of vector v with the corresponding elements of the given tuple
function multVec(v,tuple,indexes)
	k = ones((length(v),1))
	for (i,t) in enumerate(tuple)
		k[indexes[i]] = tuple[i]
	end
	return k .* v
end

# Generates all permutations of myVec of which the elements at indexes negated and not negated
# e.g. negPermut([1 2], [1]) gives [1 2] [-1 2]
function negPermut(myVec,indexes)
	neg = [1,-1]
	idl = length(indexes)
	resultLength = 2^length(indexes)
	cartesianProduct = Iterators.product(repeat([neg],idl)...)
	flattendProd = vcat(cartesianProduct...)
	return map(x->multVec(myVec,x,indexes),flattendProd)
end


function getTethrahedron()
	p1 = [1.0 ; 0.0 ; -1/sqrt(2)]
	#p2 = [-1.0 ; 0.0 ; -1/sqrt(2)]
	p3 = [0.0 ; 1.0 ; 1/sqrt(2)]
	#p4 = [0.0 ; -1.0 ; 1/sqrt(2)]
	result = vcat(negPermut(p1,[1]),negPermut(p3,[2]))
	#result = [p1,p2,p3,p4]
	return ("tetrahedron", result)
end

#fileName,guidePoints = getTethrahedron()

# numOfGp = length(guidePoints)
# group = append!(repeat(["t1"],numOfGp),repeat(["t2"],numOfGp))
# markersizes = append!(repeat([5.0],numOfGp),repeat([5.0],numOfGp))
# markercolors = append!(repeat([:blue],numOfGp),repeat([:green],numOfGp))


# println(guidePoints[1,:])
# println(vcat(guidePoints[1,:],guidePoints[1,:]))
# println(size(vcat(guidePoints[1,:],guidePoints[1,:])))

#p = Plots.plot(guidepoints[1,:],guidepoints[2,:],guidepoints[3,:], seriestype = :scatter, group = group, axis=nothing, markersize = markersizes, markeralpha=0.2, markercolor = markercolors, markerstrokewidth=1)


# #println(group)

# println(size(points))
# #between(p1,p2,0.5), between(p2,p1,0.5), between(p1,p2,0.7) ,between(p2,p1,0.7))

# #println(points[1,:])
# #println(points[2,:])
# #println(points[3,:])
# anim = @animate for i in range(0, stop = 2π, length= 250)
# 	p = Plots.plot(points[1,:],points[2,:],points[3,:], seriestype = :scatter, group = group, axis=nothing, markersize = markersizes, markeralpha=0.2, markercolor = markercolors, markerstrokewidth=1)
# 	#Plots.plot!(p, camera = (10 * (1 + cos(i)), 40))
# 	Plots.plot!(p, camera = (40 * (1 + cos(i)), 30*(1+cos(i))))
# end


function getStartPositions(;s=1, h = sqrt(3)/2*s)
    ht = [0,0,h] # Hinge Top
    hb = [0,0,-h] # Hinge Bottom
    bm = [1/2*s, 1/2*h,0]
    fm = [1/2*s, -1/2*h,0]
    c = [-s,0,0]
    e = [-2s,0,0]
    ft = [-3/4*s, -h, h]
    fb = [-3/4*s, -h, -h]
    bt = [-3/4*s, h, h]
    bb = [-3/4*s, h, -h]
                  #   g1     -  g2      - r1      -  r2     -  y1      -  y2
    startPoints = [ht hb c fm c fm ft fb ft fb e c bt bb e c ft fb c bm ht hb c bm]
    println(startPoints)
    println(startPoints[1,:])
    group = vcat(repeat(["g1"],4),repeat(["g2"],4),repeat(["r1"],4),repeat(["r2"],4),repeat(["y1"],4),repeat(["y2"],4))
    markersizes = vcat(repeat([5.0],4),repeat([3.0],5*4))
    markercolors = vcat(repeat([:green],2*4),repeat([:red],2*4),repeat([:yellow],2*4))

    return startPoints, group, markersizes,markercolors
end


function plotIt()
  points, group, markersizes,markercolors = getStartPositions()
  p = Plots.plot(points[1,:],points[2,:],points[3,:], seriestype = :scatter, group = group, axis=nothing, markersize = markersizes, markeralpha=0.2, markercolor = markercolors, markerstrokewidth=1)
end

function plotIt3D()
    points, group, markersizes,markercolors = getStartPositions()
    p = Plots.plot(points[1,:],points[2,:],points[3,:], seriestype = :scatter, group = group, axis=nothing, markersize = markersizes, markeralpha=0.2, markercolor = markercolors, markerstrokewidth=1)
    anim = @animate for i in range(0, stop = 2π, length= 250)
        Plots.plot!(p, camera = (40 * (1 + cos(i)), 30*(1+cos(i))))
    end
    gif(anim, "$fileName.webm", fps=10)
end

function plotSingle3D()
    points, group, markersizes,markercolors = getStartPositions()
    p = Plots.plot(points[1,1:8],points[2,1:8],points[3,1:8], seriestype = :surface, group = group[1:8], axis=nothing, markersize = markersizes[1:8], markeralpha=0.2, markercolor = markercolors[1:8], markerstrokewidth=1)
    anim = @animate for i in range(0, stop = 2π, length= 250)
        Plots.plot!(p, camera = (40 * (1 + cos(i)), 30*(1+cos(i))))
    end
    gif(anim, "GreenTetra.webm", fps=10)

end

#plotIt()
#plotIt3D()
plotSingle3D()