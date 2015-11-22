push!(LOAD_PATH,pwd())
using Zimmermann

front = [collect(1:10);[12]];
middle = [14,15,16,18,20,21,22]
tail = [24,26,27,28,30,32,33,34,35,36,38,39,40,42,44,45,46,48,49,50,51,52,54]

k = 20;

println("Front  = ", IntSet(front))
println("Middle = ", IntSet(middle))
println("Tail   = ", IntSet(tail))
println("k      = ", k)


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

tic();
A = super_try_all(front, middle, tail, k);
toc();
println(A)
println(k," --> ", length(sumprod(A)))

# println()

# try_both(front, middle, tail, k)
