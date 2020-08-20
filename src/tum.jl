using Memoize
using Iterators

@memoize function mem_det(A::Array{Int,2})
  return round(Int,det(A))
end

"""
`istum(A)` determines if the integer matrix `A`
is totally unimodular. This may be called with an
optional second argument `istum(A,true)` that,
in case the matrix is not totally unimodular, will
report the first submatrix found whose determinant
is not in `{-1,0,1}`.

**Warning**: This is not an efficient function.
"""
function istum(A::Array{Int,2}, verbose::Bool=false)
  r,c = size(A)
  n = min(r,c)

  for k=1:n
    rows = subsets(collect(1:r),k)
    cols = subsets(collect(1:c),k)
    for x in rows
      for y in cols
        B = A[x,y]
        d = mem_det(B)
        if abs(d)>1
          if verbose
            println("Rows: ", x)
            println("Cols: ", y)
            println(B)
          end
          return false
        end
      end
    end
  end
  return true
end
