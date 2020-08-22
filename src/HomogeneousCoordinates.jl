module HomogenousCoordinates

export Homogeneous

struct Homogeneous{T}  
    data::Vector{T}
    function Homogeneous(dat::Vector{T}) where T 
        data = dat .// one(T)
        S = typeof(sum(data))
        new{S}(data)
    end 

end

Homogeneous(x...) = Homogeneous(collect(x))

function normalize!(x::Homogeneous{T}) where T
    if length(x.data) == 0 || iszero(x.data)
        return 
    end 
    idx = findlast(x.data .!= 0)
    x.data .//= x.data[idx]
    nothing
end

function show(io::IO, x::Homogeneous)
    print(io,"Homogeneous(")
    n = length(x.data)
    for j=1:n-1
        print(io,"$(x.data[j]), ")
    end 
    print(io,x.data[end],")")
end

end