using Plots
using Base.Iterators
using StaticArrays
using DataFrames
using CSV

theme(:dark)

filename="cylinderJoinUnitCube2"
xl = 100
yl = 100
radius = 1
cylinderLength = 1
totalPoints = 10000
csvFile="results.csv"

function getXYZ(cylinderLength,xl,yl)
	xrange = range(-cylinderLength,cylinderLength,length=xl)
	yrange = range(-cylinderLength,cylinderLength,length=yl)
	xs = repeat(xrange,yl)
	ys = collect(flatten(repeat(yrange',xl)))
	#zs = map((x,y)->x^2+y^2)
	zs = map(cylinderZ,xs,ys)
	return xs,ys,zs
end


function inCylinderBounds(x,y,r,l)
		return abs(x) <= r && abs(y) <=l
end


function generateRandXYZ(n)
	# rand generates a random vector between (0,0,0) and (1,1,1)
	rs = rand(SVector{3,Float64},n)
	return reshape(vcat(rs...),3,n)
end

function inHalfVolume(x,y,z)
		#TODO: figure out how to do entire operation on Matrix at once
		cylinderNS = inCylinderBounds(x,y,radius,cylinderLength)
		cylinderEW = inCylinderBounds(x,y,cylinderLength,radius)
		if cylinderNS && cylinderEW
			return z <= max(sqrt(radius^2-x^2),sqrt(radius^2-y^2))
		elseif cylinderNS
			return z <= sqrt(radius^2-x^2)
		elseif cylinderEW
			return z <= sqrt(radius^2-y^2)
		else
			return false
		end
end

function cylinderZ(x,y)
		cylinderNS = inCylinderBounds(x,y,radius,cylinderLength)
		cylinderEW = inCylinderBounds(x,y,cylinderLength,radius)
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


x,y,z = getXYZ(cylinderLength,xl,yl)

rs = generateRandXYZ(totalPoints)
#Plots.plot(x,y,z,seriestype=:scatter)
#Plots.plot(x,y,z,seriestype=:surface,aspect_ratio=:equal)

bools = [inHalfVolume(rs[1,i],rs[2,i], rs[3,i]) for i in 1:totalPoints]
insidecube = sum(bools)
ratio = insidecube/totalPoints
println("$ratio ($insidecube/$totalPoints"))

function plot3d()
	anim = @animate for i in range(0, stop = 2π, length= 250)
		p = Plots.plot(x,y,z, seriestype = :surface, axis=nothing,aspect_ratio=:equal)
		Plots.plot!(rs[1,:],rs[2,:],rs[3,:], seriestype=:scatter)
		#Plots.plot!(p, camera = (10 * (1 + cos(i)), 40))
		Plots.plot!(p, camera = (40 * (1 + cos(i)), 30*(1+cos(i))))
	end
	#Plots.plot(vcat(x,x),vcat(y,y),vcat(z,-z),seriestype=:surface)
	gif(anim, "$filename-$totalPoints-$insidecube.webm", fps=10)
end
#plot3d()


#TODO: monte carlo estimate of volume by calculating ratio between
# sampled points inside vs total points of the enclosing rectangular cross

function volumeCrossedCuboid(r,l)
	# r == _
	# l == 3x |
 	#    __
	# _ |  |-
	#|_ |  |_ |  \ /
	#   |__|     / \  r (height)
	#
	return (4*r*l-4*r^2)*r
end

function estimatedVolume(r,l,insidecube)
	return volumeCrossedCuboid(r,l) * 4*(insidecube/totalPoints)
end

volEstimate = estimatedVolume(radius, cylinderLength, insidecube)
println("Volume estimate 1/2 V_x = $volEstimate")


function appendToFile()
	df = DataFrame([[totalPoints], [insidecube]], [:n, :inside])
	CSV.write(csvFile,df,append=true)
end

appendToFile()
