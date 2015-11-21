push!(LOAD_PATH,pwd())
using Zimmermann


front = collect(1:5);
middle = collect(6:10);
tail = collect(11:35);
k = 13;


function try_both(front, middle, tail, k)

    ultra = [ front; middle; tail]
    n = length(ultra)

    if IntSet(ultra) != IntSet(collect(1:n))
        warn("front/middle/tail is not 1:", n)
    end
    
    println("Considering ", binomial(n,k), " subsets of size ", k,
            " of 1:", n)

    println()
    println("Parallel execution")
    tic();
    A = super_try_all(front, middle, tail, k)
    println(A,"\t", length(sumprod(A)))
    toc();
    
    println()
    println("Serial execution")
    tic()
    B = try_all([middle;tail], k, front,false)
    println(B,"\t", length(sumprod(B)))
    toc()
end

# tic();
# A = super_try_all(front, middle, tail, k);
# toc();
# println(A)
# println(k," --> ", length(sumprod(A)))

# println()

try_both(front, middle, tail, k)