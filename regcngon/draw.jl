
function errorCNgon(n=3, s = 30; relpos=Point(0,0))
	l = s*3
	a = 2*π/n
	orig = relpos+Point(0,0)
	oneThird = relpos+Point(0,-l+s)
	oneThirdExt =  relpos+Point(cos(π/2-a)*l,-l+s+sin(-π/2-a)*l)
	outer = relpos+Point(cos(π/2-a)*l,-l+sin(-π/2-a)*l)
	flag, interPoint = intersectionlines(oneThird,oneThirdExt,outer,orig)
	flag, interPointTwo = intersectionlines(relpos+Point(s,0),relpos+Point(s,-l),oneThird,interPoint)
	println(interPoint)
	for i in 1:n
		sethue(0,0,1)
		newpath()
		line(relpos+Point(0,0),relpos+Point(s,0))
		line(relpos+Point(0,0),relpos+Point(0,-l))
		line(relpos+Point(0,-l),relpos+Point(cos(π/2-a)*l,-l+sin(-π/2-a)*l))
		line(relpos+Point(cos(π/2-a)*l,-l+sin(-π/2-a)*l), interPoint)
		line(interPoint,interPointTwo)
		line(interPointTwo,relpos+Point(s,0))
		strokepath()
		translate(s,0)
		rotate(a)
	end
end

function drawCNgon(n=3, s = 30; relpos=Point(0,0))
	l = s*3
	a = 2*π/n
	orig = Point(0,0)
	oneThird = Point(0,-l+s)
	oneThirdExt =  Point(cos(π/2-a)*l,-l+s+sin(-π/2-a)*l)
	outer = Point(cos(π/2-a)*l,-l+sin(-π/2-a)*l)
	flag, interPoint = intersectionlines(oneThird,oneThirdExt,outer,orig)
	flag, interPointTwo = intersectionlines(Point(s,0),Point(s,-l),oneThird,interPoint)
	println(interPoint)
	translate(relpos.x,relpos.y)
	for i in 1:n
		sethue(0,0,1)
		#circle(relpos,10,:stroke)
		newpath()
		line(Point(0,0),Point(s,0))
		line(Point(0,0),Point(0,-l))
		line(Point(0,-l),Point(cos(π/2-a)*l,-l+sin(-π/2-a)*l))
		line(Point(cos(π/2-a)*l,-l+sin(-π/2-a)*l), interPoint)
		line(interPoint,interPointTwo)
		line(interPointTwo,Point(s,0))
		strokepath()
		translate(s,0)
		rotate(a)
	end
end

using Luxor
#Drawing(2200,2200,"errCNgon.svg")
Drawing(2200,2200,"CNgonTile.svg")
background("white")
origin()
function errCNgon()
	tiles = Tiler(1000,1000,5,5,margin=90)
	for (pos,n) in tiles
		#ellipse(pos,100,50,:stroke)
		#translate(pos.x,pos.y)
		#newpath()
		#line(pos,pos+Point(0,30))
		#strokepath()
		errorCNgon(2+n,20,relpos=pos)
	end
end
function tileEm()
	tiles = Tiler(1000,1000,5,5,margin=10)
	prevpos = Point(0,0)
	for (pos,n) in tiles
		drawCNgon(2+n,10,relpos=pos-prevpos)
		prevpos = pos
	end

end
tileEm()
#errCNgon()
#drawCNgon(4,20,relpos=Point(0,100))
#drawCNgon(4,20,relpos=Point(100,200))
#drawCNgon(10,50)
finish()
preview()
