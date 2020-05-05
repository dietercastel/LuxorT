using Plots

theme(:dark)
function between(p1,p2,offset)
	return p1+(offset*(p2-p1))
end
its = 200000

function getParaboloid(mx)
	parab = x->-x^2 + mx
	pts = -10:5:10
	len = length(pts) 
	x = vcat(pts,repeat([0.0],len))
	println(x)
	y = vcat(repeat([0.0],len),pts)
	z = vcat(map(parab,x[1:len]),map(parab,y[len+1:end]))
	xyz = [ [a[1];a[2];a[3]] for a in zip(x,y,z)]
	return ("paraboloid",xyz)
end

#fileName,guidePoints = getTethrahedron()
#fileName,guidePoints = getCube() 
#fileName,guidePoints = getOctahedron() 
#fileName,guidePoints = getDodecahedron() 
fileName,guidePoints = getParaboloid(10) 

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
markersizes = append!(repeat([5.0],numOfGp),repeat([0.7],its))
markercolors = append!(repeat([:blue],numOfGp),repeat([:green],its))
#println(group)

println(size(points))
#between(p1,p2,0.5), between(p2,p1,0.5), between(p1,p2,0.7) ,between(p2,p1,0.7))

#println(points[1,:])
#println(points[2,:])
#println(points[3,:])
anim = @animate for i in range(0, stop = 2π, length= 250)
	p = Plots.plot(points[1,:],points[2,:],points[3,:], seriestype = :scatter, group = group, axis=nothing, markersize = markersizes, markeralpha=0.2, markercolor = markercolors, markerstrokewidth=1)
	#Plots.plot!(p, camera = (10 * (1 + cos(i)), 40))
	Plots.plot!(p, camera = (40 * (1 + cos(i)), 30*(1+cos(i))))
end

webm(anim, "$fileName.webm", fps=10)
