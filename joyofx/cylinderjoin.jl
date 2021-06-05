using Plots
using Base.Iterators

theme(:dark)

filename="cylinderJoin"
xl = 100
yl = 100
radius = 1
length = 2

function getXYZ(xl,yl)
	xrange = range(-2,2,length=xl)
	yrange = range(-2,2,length=yl)
	xs = repeat(xrange,yl)
	ys = collect(flatten(repeat(yrange',xl)))
	#zs = map((x,y)->x^2+y^2)
	zs = map(cylinderZ,xs,ys)
	return xs,ys,zs
end


function inCylinderBounds(x,y,r,l)
		return abs(x) <= r && abs(y) <=l
end

function cylinderZ(x,y)
		cylinderNS = inCylinderBounds(x,y,radius,length)
		cylinderEW = inCylinderBounds(x,y,length,radius)
		if cylinderNS && cylinderEW
			return max(sqrt(radius^2-x^2),sqrt(radius^2-y^2))
		elseif cylinderNS
			return sqrt(radius^2-x^2)
		elseif cylinderEW
			return sqrt(radius^2-y^2)
		else
			return 0
		end
end


x,y,z = getXYZ(xl,yl)

#Plots.plot(x,y,z,seriestype=:scatter)
#Plots.plot(x,y,z,seriestype=:surface,aspect_ratio=:equal)

anim = @animate for i in range(0, stop = 2π, length= 250)
	p = Plots.plot(x,y,z, seriestype = :surface, axis=nothing,aspect_ratio=:equal)
	#Plots.plot!(p, camera = (10 * (1 + cos(i)), 40))
	Plots.plot!(p, camera = (40 * (1 + cos(i)), 30*(1+cos(i))))
end
#Plots.plot(vcat(x,x),vcat(y,y),vcat(z,-z),seriestype=:surface)

gif(anim, "$filename.webm", fps=10)
