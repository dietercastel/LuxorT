using Plots

theme(:dark)
function between(p1,p2,offset)
	return p1+(offset*(p2-p1))
end
its = 300000

# Multiplies the elements at indexes of vector v with the corresponding elements of the given tuple
function multVec(v,tuple,indexes)
	k = ones((length(v),1))
	for (i,t) in enumerate(tuple)
		k[indexes[i]] = tuple[i]
	end
	return k .* v
end

# Generates all permutations of myVec of which the elements at indexes are negated
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


function getCube()
	p1 = [1;1;1]
	result = negPermut(p1,[1,2,3])
	return ("cube",result)
end

function getOctahedron()
	p1 = [ 1, 0 , 0]
	#p2 = [ -1, 0 , 0]
	p3 = [ 0, 1 , 0]
	#p4 = [ 0, -1, 0 ]
	p5 = [ 0, 0 , 1]
	#p6 = [ 0, 0 , -1]
	#result = [p1,p2,p3,p4,p5,p6]
	result = vcat(negPermut(p1,[1]),negPermut(p3,[2]),negPermut(p5,[3]))
	return ("octahedron",result)
end

function getDodecahedron()
	g = MathConstants.golden
	p1 = [ 1, 1 , 1]
	p2 = [0, g, 1/g]
	permp2 = negPermut(p2,2:3)
	permp3 = negPermut(circshift(p2,1),[1,3])
	permp4 = negPermut(circshift(p2,2),1:2)
	result = vcat(negPermut(p1,1:3),permp2,permp3,permp4)
	return ("dodecahedron3",result)
end

#fileName,guidePoints = getTethrahedron()
#fileName,guidePoints = getOctahedron() 
#fileName,guidePoints = getDodecahedron() 
fileName,guidePoints = getCube() 

function doLoop(its,betweenRatio,dataset)
	for i in 1:its-1
		dataset[:,i+1] = between(dataset[:,i],dataset[:,i+1],betweenRatio) 
		#println(dataset[:,i+1])
	end
end

function calcDataset(its, betweenRatio)
	startpoint = [0.0; 0.0 ; 0.0]
	dataset = hcat(startpoint, rand(guidePoints,its)...)
	doLoop(its, betweenRatio, dataset)
	return dataset[:,1:end-1]
end
					
numOfGp = length(guidePoints)

points = hcat(guidePoints..., calcDataset(its,0.5))
#println(points)
group = append!(repeat(["Guide Points"],numOfGp),repeat(["points"],its))
markersizes = append!(repeat([5.0],numOfGp),repeat([0.5],its))
markercolors = append!(repeat([:blue],numOfGp),repeat([:green],its))
#println(group)

println(size(points))
#between(p1,p2,0.5), between(p2,p1,0.5), between(p1,p2,0.7) ,between(p2,p1,0.7))

#println(points[1,:])
#println(points[2,:])
#println(points[3,:])
anim = @animate for i in range(0, stop = 2π, length= 250)
	p = Plots.plot(points[1,:],points[2,:],points[3,:], seriestype = :scatter, group = group, axis=nothing, markersize = markersizes, markeralpha=0.1, markercolor = markercolors, markerstrokewidth=1)
	#Plots.plot!(p, camera = (10 * (1 + cos(i)), 40))
	Plots.plot!(p, camera = (50 * (1 + cos(i)), 40*(1+cos(i))))
end

webm(anim, "$fileName.webm", fps=10)
