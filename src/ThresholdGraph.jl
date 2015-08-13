using SimpleGraphs

function ThresholdGraph{T<:Real}(w::Array{T,1})
    n = length(w)
    G = IntGraph(n)
    for i=1:n-1
        for j=i+1:n
            if w[i]+w[j] >= 1
                add!(G,i,j)
            end
        end
    end
    return G
end


function RandomThresholdGraph(n::Int)
    w = rand(n)
    return ThresholdGraph(w)
end


function degsort(G::SimpleGraph)
    vv = vlist(G)
    dd = [ deg(G,v) for v in vv ]
    p  = sortperm(dd)

    f = Dict(zip(p,vv))
    return relabel(G,f)
end
