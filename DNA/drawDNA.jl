using Luxor
# Colors for folding with https://origamisimulator.org/ 
borderColor = (0,0,0)
mountainColor = (1,0,0)
valleyColor = (0,0,1)
strandWidth = 1
strandLength = 6
borderSize = strandWidth/3

function drawStrand(xOffset; isStart=false, isEnd=false)
	sethue(borderColor...)
	newpath()
	line(Point(xOffset*strandWidth,0),Point((xOffset+1)*strandWidth,0))
	line(Point(xOffset*strandWidth,strandLength),Point((xOffset+1)*strandWidth,strandLength))
	if isStart
		line(Point(xOffset*strandWidth,0),Point(xOffset*strandWidth,strandLength))
	end
	if isEnd
		line(Point((xOffset+1)*strandWidth,0),Point((xOffset+1)*strandWidth,strandLength))
	end
	strokepath()
	sethue(mountainColor...)
	newpath()
	#Midline:
	line(Point(xOffset*strandWidth,strandLength/2),Point((xOffset+1)*strandWidth,strandLength/2))

	line(Point(xOffset*strandWidth,strandLength/2-borderSize),Point((xOffset+1)*strandWidth,strandLength/2-borderSize))

	#Bottom border
	line(Point(xOffset*strandWidth,strandLength-borderSize),Point((xOffset+1)*strandWidth,strandLength-borderSize))
	if !(isEnd)
		line(Point((xOffset+1)*strandWidth,strandLength/2),Point((xOffset+1)*strandWidth,strandLength))
	end
	line(Point(xOffset*strandWidth,strandLength/2-borderSize),Point((xOffset+1)*strandWidth,0+borderSize))
	strokepath()

	sethue(valleyColor...)
	newpath()
	line(Point(xOffset*strandWidth,strandLength/2+borderSize),Point((xOffset+1)*strandWidth,strandLength/2+borderSize))
	#top Border
	line(Point(xOffset*strandWidth,0+borderSize),Point((xOffset+1)*strandWidth,0+borderSize))
	if !(isEnd)
		line(Point((xOffset+1)*strandWidth,0),Point((xOffset+1)*strandWidth,strandLength/2))
	end
	line(Point(xOffset*strandWidth,strandLength/2+borderSize),Point((xOffset+1)*strandWidth,strandLength-borderSize))
	strokepath()
end

function drawDNA(nbOfStrands)
	strands = 1:nbOfStrands	
	map(x->drawStrand(x,isStart= (x==1), isEnd= (x == nbOfStrands)),strands)
end

Drawing(2000,600,"dna.svg")
background("white")
translate(20,20)
scale(80)
drawDNA(20)
finish()
preview()
