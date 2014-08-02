using SimpleGraphs
using Permutations

function PermutationGraph(p::Permutation, q::Permutation)
    n = length(p)
    if length(q) != n
        error("Two permutations must be the same length")
    end
    G = IntGraph(n)
    for u=1:n-1
        for v=u+1:n
            if (p[u]-p[v])*(q[u]-q[v]) < 0
                add!(G,u,v)
            end
        end
    end
    return G
end

function PermutationGraph(p::Permutation)
    n = length(p)
    q = Permutation(n)
    return PermutationGraph(p,q)
end

function RandomPermutationGraph(n::Int)
    p = RandomPermutation(n)
    q = RandomPermutation(n)
    return PermutationGraph(p,q)
end
