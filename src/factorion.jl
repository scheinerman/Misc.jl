# Functions for factorions

using Memoize

@memoize function fast_fact(n::Int)
    return factorial(n)
end


"""
`sum_fact_digs(n)` returns the sum of the factorials of the
base-10 digits of `n`.
"""
function sum_fact_digs(n::Int)
    digs = digits(n)
    sum( map(fast_fact, digs) )
end


"""
`is_factorion(n)` determines if `n` is a *factorion*; that is, if `n`
is equal to the sum of the factorials of its base-10 digits.
"""
function is_factorion(n::Int)
    if n <= 0
        return false
    end
    return n == sum_fact_digs(n)
end

"""
`fact_upper_bound()` returns an upper bound on the number of digits in
a factorion.
"""
function fact_upper_bound()
    n::Int = 1
    f9 = fast_fact(9)
    while 10^(n-1) < f9*n
        n += 1
    end
    return n
end


function find_all_factorions()
    stop = 10^fact_upper_bound()

    for n=1:stop
        if is_factorion(n)
            println(n)
        end
    end
end
