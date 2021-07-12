using Luxor
using Colors

const DARK_BLUE = Colors.RGB(1/256, 78/256, 192/256)
const LIGHT_BLUE = Colors.RGB(18/256, 208/256, 255/256)
const DARK_ORANGE =Colors.RGB(194/256, 98/256, 0/256)
const LIGHT_ORANGE =Colors.RGB(254/256, 243/256, 1/256)


Drawing(300,300, "wormholeJL-logo.svg")

origin()

offsetPoint = Point(20,0)
borderScale = 1.02

setcolor("black")
ellipse(Point(-100,0)+offsetPoint,50,200,:fill)

setline(7)
setcolor(LIGHT_BLUE)
ellipse(Point(-100,5)+offsetPoint,50,200,:stroke)

setline(6)
setcolor(DARK_BLUE)
ellipse(Point(-100,0)+offsetPoint,50,196,:stroke)

scale(borderScale)

setcolor("white")
fontsize(40)
fontface("Georgia")
text(".jl", Point(-117,40)+offsetPoint*borderScale, angle=0.7*pi/4)

scale(1/borderScale)

setcolor("black")
fontsize(40)
fontface("Georgia")
text(".jl", Point(-117,40)+offsetPoint, angle=0.7*pi/4)


setcolor("black")
ellipse(Point(100,0),50,200,:fill)

setline(7)
setcolor(LIGHT_ORANGE)
ellipse(Point(100,5),50,200,:stroke)

setline(6)
setcolor(DARK_ORANGE)
ellipse(Point(100,0),50,196,:stroke)

scale(borderScale)

setcolor("white")
fontsize(40)
fontface("Georgia")
text("Wormhole.", Point(-55,-60)*borderScale, angle=0.7*pi/4)

scale(1/borderScale)

setcolor("black")
fontsize(40)
fontface("Georgia")
text("Wormhole.", Point(-55,-60), angle=0.7*pi/4)



finish()

preview()