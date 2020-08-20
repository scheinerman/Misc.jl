# For dealing with projective planes of prime order

using Mods

import Base.show, Base.hash, Base.*

immutable Projective
    a::Mod
    b::Mod
    c::Mod
    function Projective(aa::Integer,bb::Integer,cc::Integer,p::Integer)
        if ~isprime(p)
            warn("Modulus is supposed to be prime. Continuing...")
        end
        a = Mod(aa,p)
        b = Mod(bb,p)
        c = Mod(cc,p)

        if c != 0
            cinv = c'
            a *= cinv
            b *= cinv
            c  = Mod(1,p)
        elseif b != 0 # so c==0
            a *= b'
            b  = Mod(1,p)
        elseif a != 0
            a = Mod(1,p)
        else
            error("Values a,b,c cannot all be 0 mod " * string(p))
        end

        return new(a,b,c)
    end
end

function show(io::IO, P::Projective)
    print(io, "[", P.a.val, ",", P.b.val, ",",
          P.c.val,"]_(", P.a.mod, ")")
end

*(P::Projective, Q::Projective) = P.a*Q.a + P.b*Q.b + P.c*Q.c

incident(P::Projective, Q::Projective) = P*Q==0

function hash(P::Projective, h::UInt64 = uint64(0))
    h1::UInt64 = hash(P.a,h)
    h2::UInt64 = hash(P.b,h1)
    h3::UInt64 = hash(P.c,h2)
    return h3
end

getvals(P::Projective) = (P.a.val, P.b.val, P.c.val, P.a.mod)

function generate(p::Integer)
    if ~isprime(p)
        error("Modulus must be prime")
    end
    n = p*p+p+1
    A = Array(Projective,n)
    count = 1

    # case a = 1
    for b=0:p-1
        for c = 0:p-1
            A[count] = Projective(1,b,c,p)
            count += 1
        end
    end

    # case a=0, b=1
    for c=0:p-1
        A[count] = Projective(0,1,c,p)
        count += 1
    end

    # case a=b=0, c=1
    A[count] = Projective(0,0,1,p)

    return A
end

function incidence_matrix(p::Integer)
    pts = generate(p)
    n = p*p + p + 1
    A = zeros(Int,n,n)
    for u = 1:n
        P = pts[u]
        for v = 1:n
            Q = pts[v]
            if incident(P,Q)
                A[u,v] = 1
            end
        end
    end
    return A
end

using SimpleGraphs

# this is a bipartite point/line incidence graph
function incidence_graph(p::Integer)
    pts = generate(p)
    T = Tuple{Projective,Int}
    G = SimpleGraph{T}()

    for P in pts
        for Q in pts
            if incident(P,Q)
                add!(G,(P,1),(Q,2))
            end
        end
    end
    return G
end
