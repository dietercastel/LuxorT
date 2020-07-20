using Plots
using Luxor
using Base.Iterators
using Random: shuffle
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

#= xs,ys,zs = getNoise(xl,yl,1) =#
#= plot(xs,ys,zs,seriestype=:surface) =#


function drawSlope(pt::Point,slope,maxlength)
	bx = BoundingBox(box(pt+(maxlength/2,0), maxlength, maxlength, :none))
	r = rule(pt,slope,boundingbox=bx)
	#= println(r) =#
	return r[1]
end


function draw(lineNum,bbSize,its)
	setcolor(0,0.8,0.2,0.8)
	ys = range(1,800,length=lineNum)
	startPoints = map(y->Point(0,y),ys)
	currentPoints = map(y->Point(bbSize,y),ys)
	map((sp,cp)->line(sp,cp,:stroke),startPoints,currentPoints)
	for t in 1:its
		r = rand()
		erat = rand()
		if erat > 0.05 && erat < 0.95
			currentPoints = map(p->drawSlope(p,perlinsnoise(p[1]/lineNum,p[2]/lineNum,3.14),r*bbSize),currentPoints)
		else
			rndidxs = shuffle(1:lineNum)	
			regulars = view(rndidxs,1:floor(Int,0.95*lineNum))
			erratics = view(rndidxs,(floor(Int,0.95*lineNum)+1):lineNum)
			newregulars = map(p->drawSlope(p,perlinsnoise(p[1]/lineNum,p[2]/lineNum,3.14),r*bbSize),currentPoints[regulars])
			newerratics = map(p->drawSlope(p,perlinsnoise(p[1],p[2],3.14),r*bbSize),currentPoints[erratics])
			currentPoints = vcat(newregulars,newerratics)
		end
	end
end

function main()
	Drawing(1600,800)
	background("black")
	setline(0.5)
	draw(128,32,256)
	finish()
	preview()
end

@time main()
