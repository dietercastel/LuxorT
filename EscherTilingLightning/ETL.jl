# Inspired by https://twitter.com/matthen2/status/1266579585417613312

using Luxor
using Random
using Base.Iterators
using LightGraphs
using Plots
using GraphRecipes

function remEdgeProb!(g,e,edgeRemProb)
	if rand()<=edgeRemProb
		rem_edge!(g,e)
	end
end

function generateTiles(gridSize,edgeRemProb)
	w,h = gridSize
	g2 = LightGraphs.SimpleGraphs.grid(gridSize)
	#= plot(g2,curves=false) =#
	# adding collect is essential here, removing changes iterator while running.
	map(e->remEdgeProb!(g2,e,edgeRemProb), collect(edges(g2)))
	xs = repeat(1:w,h)
	ys = collect(flatten(repeat((1:h)',w)))
	@assert length(xs) == nv(g2)
	@assert length(ys) == nv(g2)
	#= println([xs ys]') =#
	#= plot(g2, x=xs, y=ys, nodeshape=:rect, curves=false, nodesize = 1) =#
	return g2, xs, ys
end

#= function sendFrontier() =#
#=  =#
#= end =#

function neighborsToRelCoord(v,neighbors,gridSize)
	w,h = gridSize
	relNeighbors = neighbors .- v
	result = map(x->x == w || x == -w ? (0,Int(x/w)) : (x,0), relNeighbors)
	return result 
end

relToBoxIdx = Dict([(1,0) => [3,4], (-1,0) => [1,2], (0,-1) => [2,3], (0,1) => [1,4]])

function drawRelNb(relNB::Tuple, box::Array)
	#= println(relNB) =#
	idxs = relToBoxIdx[relNB]
	#= println(idxs) =#
	line(box[idxs[1]],box[idxs[2]],:stroke)	
end

function draw(size;edgeRemProb=0.8)
	gridSize = size 
	g2, xs, ys = generateTiles(gridSize,edgeRemProb)	
	tileW = 20 
	tileH = 20 
	Drawing()
	#= origin() =#
	for v in vertices(g2)
		nbs = neighbors(g2,v)
		#= println(nbs) =#
		relNb = neighborsToRelCoord(v,nbs,gridSize)
		x = xs[v]*tileW
		y = ys[v]*tileH
		rectBox = box(Point(x,y),tileW,tileH,vertices=true)
		map(nb->drawRelNb(nb,rectBox),relNb)
	end
	finish()
	preview()
end


draw((40,40),edgeRemProb=0.5)
