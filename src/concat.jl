"""
`concat(list1,list2)` concatenates two lists (Julia type `Vector`)
returning a new list. Designed for use with `@distributed`.

## Example 
```julia
julia> using Distributed

julia> addprocs(5)

julia> @everywhere include("concat.jl")

julia> combo = @distributed (concat) for j=1:100
       rand(100)
       end;

julia> length(combo)
10000
```
"""
function concat(x::Vector{T}, y::Vector{T}) where T
    nx = length(x)
    ny = length(y)
    result = Vector{T}(undef,nx + ny)
    for i = 1:nx
        @inbounds result[i] = x[i]
    end
    for i = 1:ny
        @inbounds result[i+nx] = y[i]
    end
    return result
end
