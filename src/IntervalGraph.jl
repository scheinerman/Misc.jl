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

# Likewise for directed graphs
function IntervalDigraph{T}(
         send_list::Array{ClosedInterval{T},1},
         rec_list::Array{ClosedInterval{T},1}
                            )
    n = length(send_list)
    if length(rec_list) != n
        error("send_list and rec_list must be same length")
    end

    G = IntDigraph(n)
    forbid_loops!(G)

    for u=1:n
        A = send_list[u]
        for v=1:n
            if u!=v
                B = rec_list[v]
                if !isempty(A*B)
                    add!(G,u,v)
                end
            end
        end
    end
    return G
end

# Create an interval graph from a dictionary that maps vertices to
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

# Likewise for digraphs
function IntervalDigraph{K,T}(snd::Dict{K,ClosedInterval{T}} ,
                              rec::Dict{K,ClosedInterval{T}})
    if length(snd) != length(rec)
        error("send and receive dictionaries must have same keys")
    end

    klist = keys(snd)
    for k in klist
        if !haskey(rec)
            error("send and receive dictionaries must have same keys")
        end
    end

    n = length(klist)
    G = SimpleGraph{K}()
    forbid_loops!(G)

    for i=1:n
        u = klist[i]
        A = snd[u]
        for j=1:n
            if i!=j
                v = klist[j]
                B = rec[v]
                if !isempty(A*B)
                    add!(G,u,v)
                end
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

# And likewise for digraphs
function RandomIntervalDigraph(n::Int)
    snd_list = [ ClosedInterval(rand(),rand()) for _ in 1:n ]
    rec_list  = [ ClosedInterval(rand(),rand()) for _ in 1:n ]
    return IntervalDigraph(snd_list, rec_list)
end
