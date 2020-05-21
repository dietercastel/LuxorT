using Plots
pi = Base.MathConstants.pi

function rotateFunc(func,u,v)
	return [u; func(u)*sin(v); func(u)*cos(v)]
end

func = function f(x)
	return -0.5x^2+30
end

vs = 0:0.1:2*pi
xs = -7:0.1:7

inputs = [ (x,v) for v in vs, x in xs ]

si = size(inputs)
rinputs = reshape(inputs,(1,si[1]*si[2]))
println(size(rinputs))

points = hcat(map(val->rotateFunc(func,val[1],val[2]),rinputs)...)
println(size(points))

p = Plots.plot(points[1,:],points[2,:],points[3,:], seriestype = :scatter, axis=nothing, markeralpha=0.2, markerstrokewidth=1)
