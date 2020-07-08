# Inspired by https://twitter.com/matthen2/status/1266579585417613312

using Luxor
using Random
using Base.Iterators
using LightGraphs
using Plots
using GraphRecipes


"""
	rhombus(centerpoint, width, height, action, vertices=false)

Create a rhombus with the given centerpoint with `width` and `height` and then
do an action.

Use `vertices=true` to return an array of the four corner points: left, top, right, bottom.
"""
function rhombus(centerpoint::Point, width, height, action=:nothing; vertices=false)
	 ptlist = [centerpoint - (width/2,0),
						 centerpoint - (0,height/2),
						 centerpoint + (width/2,0),
						 centerpoint + (0,height/2)]
	 if vertices == false && action != :none
		 return poly(ptlist, action, close=true)
	 end
	 return ptlist
end

#TODO
function mandraw(grid)
	Drawing()
	w=35
	h=20
	offset=w/2+h/2
	rhombus(Point(0,0),w,h,:stroke)
	for x in 1:grid[1]
		for y in 1:grid[2]
			if isodd(x) & isodd(y)
				rhombus(Point(offset*x,offset*y),w,h,:stroke)
				rhombus(Point(offset*x+offset,offset*y-offset),w,h,:stroke)
				rhombus(Point(offset*x,offset*y-offset),h,w,:stroke)
				rhombus(Point(offset*x-offset,offset*y),h,w,:stroke)
			end
		end
	end
	finish()
	preview()
end


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

function neighborsToRelCoord(v,neighbors,gridSize)
	w,h = gridSize
	relNeighbors = neighbors .- v
	result = map(x->x == w || x == -w ? (0,Int(x/w)) : (x,0), relNeighbors)
	return result 
end

relToBoxIdx = Dict([(1,0) => [3,4], (-1,0) => [1,2], (0,-1) => [2,3], (0,1) => [1,4]])
allRelNbs = [(1,0),(-1,0),(0,1),(0,-1)]

function drawRelNb(relNB::Tuple, box::Array)
	#= println(relNB) =#
	idxs = relToBoxIdx[relNB]
	#= println(idxs) =#
	line(box[idxs[1]],box[idxs[2]],:stroke)	
end

function draw(size,tileSize;edgeRemProb=0.8)
	gridSize = size 
	g2, xs, ys = generateTiles(gridSize,edgeRemProb)	
	tileW,tileH = tileSize
	#= origin() =#
	for v in vertices(g2)
		nbs = neighbors(g2,v)
		#= println(nbs) =#
		relNb = neighborsToRelCoord(v,nbs,gridSize)
		x = xs[v]*tileW
		y = ys[v]*tileH
		rectBox = box(Point(x,y),tileW,tileH,vertices=true)
		# Draw a border where there is NO neighbor connection
		borders = filter(x-> x ∉ relNb, allRelNbs)
		map(nb->drawRelNb(nb,rectBox),borders)
	end
	drawLightning(g2,xs,ys,size,(tileW,tileH))
end

#= function shorterLength(x,y) =#
#= 	return length(x) < length(y) =#
#= end =#

function drawLightning(g,xs,ys,size, tileSize)
	tileW,tileH = tileSize 
	w,h = size
	randStart = rand(1:w)
	randStop = nv(g) - rand(1:w)
	#= lowerRow = nv(g) .- collect(1:2) =#
	lowerRow = nv(g) .- collect(1:w)
	DS = dijkstra_shortest_paths(g,[randStart])
	for p in enumerate_paths(DS,lowerRow)
	#= #= for p in enumerate_paths(DS,lowerRow) =# =#
		println(p)
		println(length(p))
	end
	sortedPaths = sort(collect(enumerate_paths(DS,lowerRow)), by=length)	
	println(sortedPaths)
	filter!(x->length(x) != 0, sortedPaths)
	println("Lightning= ", sortedPaths[1])
	lightningPath = sortedPaths[1]
	sethue("white")
	for v in lightningPath
		x = xs[v]*tileW
		y = ys[v]*tileH
		rectBox = box(Point(x,y),tileW,tileH,:fill)
	end
end

function main()
	Drawing()
	draw((40,40),(10,10),edgeRemProb=0.4)
	finish()
	preview()
end

main()
