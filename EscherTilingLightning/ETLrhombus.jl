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
function rhombus(centerpoint::Point, width, height, action=:none; vertices=false)
	 ptlist = [centerpoint - (width/2,0),
						 centerpoint - (0,height/2),
						 centerpoint + (width/2,0),
						 centerpoint + (0,height/2)]
	 if vertices == false && action != :none
		 return poly(ptlist, action, close=true)
	 end
	 return ptlist
end

# upright grid drawing
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


#45 grid drawing
function my45edGrid(grid)
		Luxor.rotate(-π/4)
		w=35
		h=20
		for x in 1:grid[1]
			 for y in 1:grid[2]
					 #drawRhombus(x,x+(y-1),w,h,:stroke)
					 drawRhombusCompl(x,x+(y-1),w,h,:stroke)
			 end
	 end
end

function drawRhombus(x,y,w,h,action=:none;vertices=false, color=:none)
	offset=w/2+h/2
	if isodd(x) & isodd(y)
		color == :none ? setcolor("darkgreen") : setcolor(color)
		return rhombus(Point(offset*x,offset*y),w,h,action,vertices=vertices)
	end
	if iseven(x) & isodd(y)
		color == :none ? setcolor("darkblue") : setcolor(color)
		return rhombus(Point(offset*x,offset*y),h,w,action,vertices=vertices)
	end
	if isodd(x) & iseven(y)
		color == :none ? setcolor("darkblue") : setcolor(color)
		return rhombus(Point(offset*x,offset*y),h,w,action,vertices=vertices)
	end
	if iseven(x) & iseven(y) 
		color == :none ? setcolor("darkgreen") : setcolor(color)
		return rhombus(Point(offset*x,offset*y),w,h,action,vertices=vertices)
	end
end

function drawRhombusCompl(x,y,w,h,action=:none;vertices=false, color=:none)
	offset=w/2+h/2
	if isodd(x) & isodd(y) # (1,1)
		color == :none ? setcolor("darkgreen") : setcolor(color)
		return rhombus(Point(offset*x,offset*y),w,h,action,vertices=vertices)
	end
	if iseven(x) & isodd(y) # (2,1)
		#Draw complementing polygon between two rhombhi on the same row.
		color == :none ? setcolor("darkblue") : setcolor(color)
		prevRhomb =rhombus(Point(offset*(x-1),offset*y),w,h,vertices=true)
		nextRhomb =rhombus(Point(offset*(x+1),offset*y),w,h,vertices=true)
		complVertices = [prevRhomb[4],prevRhomb[3],nextRhomb[2],nextRhomb[1]]
		if vertices == true
			return complVertices
		else
			return poly(complVertices, action, close=true)
		end
	end
	if isodd(x) & iseven(y) # (1,2)
		#Draw complementing polygon between two rhombhi on the same row.
		color == :none ? setcolor("darkblue") : setcolor(color)
		prevRhomb =rhombus(Point(offset*(x-1),offset*y),h,w,vertices=true)
		println("prev $prevRhomb")
		nextRhomb =rhombus(Point(offset*(x+1),offset*y),h,w,vertices=true)
		println("next $nextRhomb")
		complVertices = [prevRhomb[4],prevRhomb[3],nextRhomb[2],nextRhomb[1]]
		println("taking $complVertices")
		if vertices == true
			return complVertices
		else
			return poly(complVertices, action, close=true)
		end
	end
	if iseven(x) & iseven(y) # (2,2) 
		color == :none ? setcolor("darkgreen") : setcolor(color)
		return rhombus(Point(offset*x,offset*y),h,w,action,vertices=vertices)
	end
end

function test(grid)
	Drawing()
	my45edGrid(grid)
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

function draw(size,tileSize;edgeRemProb=0.8, rotation=-π/4)
	gridSize = size 
	g2, xs, ys = generateTiles(gridSize,edgeRemProb)	
	tileW,tileH = tileSize
	Luxor.rotate(rotation)
	#= origin() =#
	for v in vertices(g2)
		nbs = neighbors(g2,v)
		#= println(nbs) =#
		relNb = neighborsToRelCoord(v,nbs,gridSize)
		x = xs[v]
		y = ys[v]
		rectBox = drawRhombus(x,x+(y-1),tileW,tileH,vertices=true)
		#= rectBox = drawRhombusCompl(x,x+(y-1),tileW,tileH,vertices=true) =#
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
#	sethue("white")
	for v in lightningPath
		x = xs[v]
		y = ys[v]
		#= rectBox = drawRhombusCompl(x,x+(y-1),tileW,tileH,:fill,color="white") =#
		#
		rectBox = drawRhombus(x,x+(y-1),tileW,tileH,:fill,color="white")
		#
		rectBox = drawRhombus(x+1,x+(y-1),tileW,tileH,:fill,color="white")
		rectBox = drawRhombus(x-1,x+(y-1),tileW,tileH,:fill,color="white")
		rectBox = drawRhombus(x,x+(y),tileW,tileH,:fill,color="white")
		rectBox = drawRhombus(x,x+(y-2),tileW,tileH,:fill,color="white")
	end
end

function main()
	Drawing(1600,800)
	draw((30,30),(35,20),edgeRemProb=0.3,rotation=-π/6)
	finish()
	preview()
end

main()
