using Luxor
using Random
Drawing()
origin()
D1 = [ Point(-200,200), Point(-200,-200), Point(100,0), Point(20,-100),Point(20,100)]
D2 = [ Point(-200,200), Point(-200,-200), Point(0,20),Point(0,-20), Point(-70,-150),Point(-70,150)]
D3 = [ Point(-200,200), Point(-200,-200), Point(0,20),Point(0,-20), Point(-70,-170),Point(-70,170), Point(-160,-185)]
D4 = [ Point(-200,200), Point(-200,-200), Point(0,20),Point(0,-20), Point(-20,80),Point(-20,-80), Point(-70,-170),Point(-70,170), Point(-160,-185)]

its = 1000000
start = Point(300,-300)

function drawGuidePoints(guides)
	sethue("green")
	for pt in guides 
		circle(pt, 5, :fill)
	end
end

function run(guides,its,startPt)
	drawGuidePoints(guides)
	rng = MersenneTwister(0)
	sethue("black")
	current = start

	altern = [0.87873, Base.MathConstants.golden,Base.MathConstants.pi]
	for i in 1:its
		circle(current, .3, :fill)
		current = midpoint(current,rand(rng,guides))
		#current = between(current,rand(rng,guides),Base.MathConstants.eulergamma)
		#current = between(current,rand(rng,guides),Base.MathConstants.catalan)
		#alti = 1+i%3
		#current = between(current,rand(rng,guides),altern[alti])
	end

	# Nice
	#current = between(current,rand(rng,guides),0.3*Base.MathConstants.e)
	#current = between(current,rand(rng,guides),0.012)
	# altern = [0.87873, Base.MathConstants.golden]
end

run(D4,its,start)

finish()
preview()
