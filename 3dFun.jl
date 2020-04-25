using Plots

theme(:dark)
function between(p1,p2,offset)
	return p1+(offset*(p2-p1))
end

p1 = [1.0 ; 0.0 ; -1/sqrt(2)]
p2 = [-1.0 ; 0.0 ; -1/sqrt(2)]
p3 = [0.0 ; 1.0 ; 1/sqrt(2)]
p4 = [0.0 ; -1.0 ; 1/sqrt(2)]

its = 10000
guidePoints = [p1,p2,p3,p4]

function doLoop(its,betweenRatio,dataset)
	for i in 1:its-1
		dataset[:,i+1] = between(dataset[:,i],dataset[:,i+1],betweenRatio) 
		println(dataset[:,i+1])
	end
end

function calcDataset(its, betweenRatio)
	startpoint = [0.0; 0.0 ; 0.0]
	dataset = hcat(startpoint, rand(guidePoints,its)...)
	doLoop(its, betweenRatio, dataset)
	return dataset[:,1:end-1]
end
					
numOfGp = length(guidePoints)

points = hcat(p1, p2, p3, p4, calcDataset(its,0.5))
#println(points)
group = append!(repeat(["Guide Points"],numOfGp),repeat(["points"],its))
#println(group)

println(size(points))
#between(p1,p2,0.5), between(p2,p1,0.5), between(p1,p2,0.7) ,between(p2,p1,0.7))

#println(points[1,:])
#println(points[2,:])
#println(points[3,:])
anim = @animate for i in range(0, stop = 2π, length= 100)
	p = Plots.plot(points[1,:],points[2,:],points[3,:], seriestype = :scatter, group = group, axis=nothing)
	#Plots.plot!(p, camera = (10 * (1 + cos(i)), 40))
	Plots.plot!(p, camera = (10 * (1 + cos(i)), 10*(1+cos(i))))
end

gif(anim, "3dfun.gif", fps=10)
