# Inspired by https://twitter.com/matthen2/status/1266579585417613312

using Luxor
using Random
using Base.Iterators
using LightGraphs
using Plots
using GraphRecipes


function generateTiles(gridSize)
	w,h = gridSize
	g2 = LightGraphs.SimpleGraphs.grid(gridSize)
	plot(g2,curves=false)
	map(e->(rand()<=0.5) ? rem_edge!(g2,e) : nothing, edges(g2))
	xs = repeat(1:w,h)
	ys = collect(flatten(repeat((1:h)',w)))
	@assert length(xs) == nv(g2)
	@assert length(ys) == nv(g2)
	println([xs ys]')
	plot(g2, x=xs, y=ys, nodeshape=:rect, curves=false, nodesize = 1)
	return g2, xs, ys
end

function sendFrontier()

end

function draw()
	Drawing()
end
