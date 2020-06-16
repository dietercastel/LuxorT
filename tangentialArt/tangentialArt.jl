# Inspired by https://www.youtube.com/watch?v=9TvpOzPKcy4 
# Author: Dieter Castel
using Test
using Luxor
using LinearAlgebra
using QuadGK

function shiftLeft(s)
	return s[2:end]
end

function pows(s::Array)
	pows = 0:(length(s)-1)
end

function getOGF(s::Array{T}) where T<:Real
	xs(x) = x .^ pows(s)
	return function(x)
			return sum(s .* xs(x))
	end
end

function derivate(s::Array{T}, n::Int)where T<:Real
	if n == 0
		return s
	else 
		return derivate(derivate(s),n-1)
	end
end

function derivate(s::Array{T}) where T<:Real
	return shiftLeft(s) .* shiftLeft(pows(s))
end


# Implementation of the function at https://youtu.be/9TvpOzPKcy4?t=164
function getFunIndex(s::Array{T,1}, idx::Int) where T<:Real
	f = getOGF(derivate(s,idx-1)) # julia is 1 based
	return f(0) / factorial(idx-1)
end

function runTests()
	@testset "test MakeFn(seq)" begin
		f = getOGF([1,2,3])
		manF(x) = 1 + 2*x^1 + 3*x^2
		for x in 1:10
			@test f(x) == manF(x)
		end
	end

	@testset "test derivate" begin
		#td = @dFn(getOGF([1,2,3]))
		td = getOGF(derivate([1,2,3]))
		td1 = getOGF(derivate([1,2,3],1))
		td2 = getOGF(derivate([1,2,3],2))
		mandfx(x) = 2*x^0 + 3*2*x^1
		mand2fx(x) = 3*2*x^0
		for x in 1:10
			@test td(x) == mandfx(x)
			@test td1(x) == mandfx(x)
			@test td2(x) == mand2fx(x)
		end
	end

	@testset "getFunIndex test." begin
		testarray = [1,2,3,4]
		for i in 1:length(testarray)
			@test getFunIndex(testarray,i) == testarray[i]
		end
	end
end

# Toyed with a macro first.
#= macro dFn(fExpr) =#
#= 	dump(fExpr)  =#
#= 	if fExpr.head == :macrocall =#
#= 		println(fExpr.args[1]) =#
#= 		return quote =#
#= 			getOGF(shiftLeft($oldS) .* shiftLeft(pows($oldS))) =#
#= 		end =#
#= 	else =#
#= 		local oldS = fExpr.args[2] =#
#= 		return quote =#
#= 			getOGF(shiftLeft($oldS) .* shiftLeft(pows($oldS))) =#
#= 		end =#
#= 	end =#
#= end =#

function makeSeq(f,len)
	map(f,0:len)
end

function p2(p::Vector, size)
	return	p .* 2/size 
	#= return	p .* 2/size .+ 0.0000001 =#
end

function colorize!(z)
	perct = angle(z)/(2π)
	bluecomp = perct<0.4 ? 4/5*perct : 2/5*perct
	setcolor(1/5*perct,0.2+3/5*perct,bluecomp,0.8)
end

function main(seq, size, upper_bound, filename)
	bounds = -size/2:size/2
	points = [[x,y] for x in bounds for y in bounds]
	filtered  = filter(x->norm(p2(x,size))<1,points)
	myseq = makeSeq(seq,upper_bound)
	println(length(filtered))

	Drawing(size,size,filename)
	#= origin() =#
	for (i,p) in enumerate(filtered)
		mp2 = p2(p,size)
		z0 = complex(mp2...)
		z1 = getOGF(myseq)(z0)
		#= print(z1) =#
		colorize!(z1)
		actualP  = Point((p .+ size/2)...)
		#= println("$p gives $mp2 at $actualP") =#
		circle(actualP, 1, :fill)
	end
	finish()
	preview()
end


#https://en.wikipedia.org/wiki/Fresnel_integral
function S(x)
		 integral, err = quadgk(t->sin(t^2),0,x,rtol=1e-8)
		 return integral
end

function C(x)
		 integral, err = quadgk(t->cos(t^2),0,x,rtol=1e-8)
		 return integral
end

function fourier(f,x)
		integral, err = quadgk(ζ->f(ζ)*ℯ^(2π*im*x*ζ),-200,200,rtol=1e-3)
		return integral
end

function normal(x)
	return 1/(2π)* ℯ^(-1/2*x^2)
end

function weierstrass(N::Int,a::Real,b::Int)
	@assert b > 0
	@assert isodd(b)
	@assert 0 < a && a < 1
	@assert a*b > 1+3\2*π
	@assert N > 0 
	return function W(x)
		ns = 0:N
		as = a .^ ns 
		bs = b .^ ns 
		return sum(as .* cos.(bs .* (π * x)))
	end
end

function s(x)
	f = floor(x)
	c = ceil(x)
	return abs(x - f) < abs(x-c) ? f : c
end

function blancmange(N)
	w = 1/2	
	@assert N > 0
	return function b(x)
		ns = 0:N
		twoPows = w .^ ns 
		return sum( s.(twoPows .* x) .* twoPows )
	end
end

main(x->S(x)*blancmange(10000)(x),800,2000, "blanc-S.png")
#main(blancmange(10000),400,500, "blancmange.png")
#main(x->weierstrass(10000,0.7,7)(x),400,500, "weierstrass.png")
#= main(x->fourier(t->tan(t),x), 400, 500, "fourier.png") =#
#main(x->normal(x),400, 500, "normal.png")
#main(x->S(x)^C(x), 400, 500, "Fresnel-cos.png")
#main(x->S(x), 400, 500, "Fresnel-sin.png")
#main(x->x^x, 400, 500, "exp8.png")
#main(x->exp(x),  400, 500, "exp7.png")
#main(x->tan(x)*(-30*x^2 +12)*tan(sin(1/(x+0.001)))*cosh(x/2),  400, 500, "exp5&6&tan.png")
#main(x->-30*x^2 +12,  400, 500, "exp5&6&tan.png")
#main(x->tan(sin(1/(x+0.001)))*cosh(x/2), 400, 500, "exp5.png")
#main(x->5*cosh(x/5), 400, 500, "catenary.png")
#main(x->tan(sin(x)), 400, 500, "tan o sin x.png")
#main(sin, 400, 500,"sin.png")
#main(tan, 400, 500,"tan.png")
#main(tan, 400, 500,"tanp2NOp0.1.png")





#= # Lemniscateof Bernoulli =#
#= # solved for y in wolframAlpha =#
#= # https://www.wolframalpha.com/input/?i=solve+for+y+a%5E2+x%5E2+-+a%5E2+y%5E2+-+x%5E4+-+2+x%5E2+y%5E2+-+y%5E4+%3D+0+ =#
#=  =#
#= function LB(y)  =#
#= 	println(y) =#
#= 	y = abs(y) =#
#= 	a = 82  =#
#= 	return sqrt(y*(a*sqrt(a^2 - 4(y+1))+a^2-2y)) / sqrt(2) =#
#= end =#
