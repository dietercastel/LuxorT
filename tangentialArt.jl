# Inspired by https://www.youtube.com/watch?v=9TvpOzPKcy4 
# Author: Dieter Castel
using Test
using Luxor

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
