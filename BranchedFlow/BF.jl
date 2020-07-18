using Plots
using Base.Iterators
include("PerlinsNoise.jl")
using .PerlinsNoise

xl = 10
yl = 10
avg = 1.3
function getNoise(xl,yl,avg)
	xrange = range(1.2,1.4,length=xl)
	yrange = range(1.2,1.4,length=yl)
	xs = repeat(xrange,yl)
	ys = collect(flatten(repeat(yrange',xl)))
	zs = map((x,y)->avg+perlinsnoise(x,y,3.14),xs,ys)
	return xs,ys,zs
end

xs,ys,zs = getNoise(xl,yl,1)
plot(xs,ys,zs,seriestype=:surface)
