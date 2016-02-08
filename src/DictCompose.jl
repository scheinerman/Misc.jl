import Base.*

"""
For dictionaries `f` and `g`, the composition `f*g` is a new
dictionary with the property that `(f*g)[x]` yields `f[g[x]]`.
"""
function *(f::Dict, g::Dict)
    KK = keys(g)
    faults::Int = 0   # Number of bad keys
    fg = Dict()

    for x in KK
        y = g[x]
        if haskey(f,y)
            fg[x] = f[y]
        else
            faults += 1
        end
    end

    if faults > 0
        warn("$faults keys were not mapped")
    end

    return fg
end
