"""
`concat(list1,list2)` concatenates two lists (Julia type `Vector`)
returning a new list. Designed for use with `@parallel`.
For example:

```
julia> @everywhere include("concat.jl")

julia> combo = @parallel (concat) for j=1:10
       rand(5)
       end;

julia> length(combo)
50
```
"""
function concat{T}(x::Vector{T},y::Vector{T})
  nx = length(x)
  ny = length(y)
  result = Vector{T}(nx+ny)
  for i=1:nx
    @inbounds result[i] = x[i]
  end
  for i=1:ny
    @inbounds result[i+nx] = y[i]
  end
  return result
end
