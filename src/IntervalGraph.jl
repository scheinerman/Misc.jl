# Functions to create interval graphs in Julia

using SimpleGraphs
using ClosedIntervals

# Create an interval graph given a 1-dimensional array of
# ClosedInterval's.
function IntervalGraph{T}(Jlist::Array{ClosedInterval{T},1})
    n = length(Jlist)
    G = IntGraph(n)
    
    for u = 1:n-1
        J = Jlist[u]
        for v = u+1:n
            K = Jlist[v]
            if !isempty(J*K)
                add!(G,u,v)
            end
        end
    end

    return G
end

# Create an interval grpah from a dictionary that maps vertices to
# intervals.
function IntervalGraph{K,T}(f::Dict{K,ClosedInterval{T}})
    klist = collect(keys(f))
    G = SimpleGraph{K}()
    for v in klist 
        add!(G,v)
    end

    n = length(klist)

    for i = 1:n-1
        u = klist[i]
        for j = i+1:n
            v = klist[j]
            if !isempty( f[u]*f[v] )
                add!(G,u,v)
            end
        end
    end
    return G
end

# Generate n random intervals in [0,1] and form the intersection graph
# thereof.
function RandomIntervalGraph(n::Int)
    Jlist = [ ClosedInterval(rand(),rand()) for _ in 1:n ]
    return IntervalGraph(Jlist)
end
