push!(LOAD_PATH,pwd())
using Zimmermann

front = [collect(1:10);[12]];
middle = [14,15,16,18,20,21,22,24,27,28,30]
tail = [32,35,36,40] # 42,45,48,49,50,54,56] # ,60,63,64]

k = 20;

println("Front  = ", IntSet(front),"\t", length(front))
println("Middle = ", IntSet(middle),"\t", length(middle))
println("Tail   = ", IntSet(tail),"\t", length(tail))
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
