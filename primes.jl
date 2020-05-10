using Primes
using Plots

#Inspired by Uitwiskeling 36/2 lente p. 50

"""
Shows a histogram of sampleSize samples of the amount 
of factors in Ints with lenght intLength
"""
function showHistogram(sampleSize,intLength)
	max = 10^intLength-1 
	min = 1 
	randInts = rand(min:max, sampleSize)
	factors =  map(x->factor(x), randInts)
	# Multiplicity is stored as value of a dictionary
	numOfFactors =  map(x->sum(values(x)), factors)
	plot(numOfFactors,seriestype=:histogram)
end

its = 1000
intLength = 18
showHistogram(its,intLength)
