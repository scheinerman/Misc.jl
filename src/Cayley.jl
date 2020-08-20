# Functions for creating a Cayley digraph based on S_n and permtuation
# generators.

using Permutations
using SimpleGraphs

function Cayley(gens::Array{Permutation,1})
    ng = length(gens)
    if ng == 0
        return SimpleDigraph{Permutation}()
    end

    n = length(gens[1])

    for k=2:ng
        if length(gens[k]) != length(gens[k-1])
            error("All generators must be same length")
        end
    end


    verts = [ Permutation(p) for p in permutations(1:n) ]

    G = SimpleDigraph{Permutation}()

    for v in verts
        add!(G,v)
        for p in gens
            add!(G,v,v*p)
        end
    end

    return G
end
