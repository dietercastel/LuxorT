using Images, FileIO, Colors, Plots
using Luxor
img = load("Crop1.png")
img_gray = Gray.(img)
#save("crop1_grey.png", img_gray)
#img2 = load("Crop2.png")
#img_gray2 = Gray.(img2)
#save("crop2_grey.png", img_gray2)
size(imedge(img_gray)[1])
gx, gy, mag, or = imedge(img_gray)
maximum(or)
y,x = size(mag)
println(y)
#yarr =vcat([repeat([i],928) for i in 1:1774]...)
#plot(repeat(1:928,1774),yarr,reshape(mag,(928*1774,)),st=:surface)
#save("sobel1.png",mag)

function luxorIdea(mag,or)
	maxY,maxX = size(or)
	maxMag = maximum(mag)
	Drawing(maxX,maxY)
	#origin()
	r1 = rect(Point(0,0),maxX,maxY,:stroke)
	bb = BoundingBox(r1)

	δ = 0.0001
	for y in 1:maxY
		for x in 1:maxX
			perct = mag[y,x]/maxMag
			bluecomp = perct<0.4 ? 4/5*perct : 2/5*perct
			setcolor(1/5*perct,perct,3/5*perct,bluecomp)
			#= rule(Point(x, y), or[y,x],boundingbox=bb) =#
			Luxor.arrow(Point(x,y),Point(x+δ*cos(or[y,x]),y+δ*sin(or[y,x])))
			# vector field with Luxor using arrow
		end
	end
	finish()
	preview()
end
luxorIdea(mag,or)
