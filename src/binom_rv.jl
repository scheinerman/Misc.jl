import StatsFuns.RFunctions.binomrand
"""
`binom_rv(n,p)` generates a random binomial random value. `p` defaults
to `0.5`.
"""
binom_rv(n::Int,p::Float64=0.5) = Int(binomrand(n,p))
