# For dealing with projective planes modulo a prime

using Mods

import Base.show

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
        if a != 0
            b *= a'
            c *= a'
            a = Mod(1,p)
        elseif b != 0
            c *= b'
            b = Mod(1,p)
        elseif c != 0
            c = Mod(1,p)
        else
            error("Values a,b,c cannot all be 0 in the given mod")
        end
        return new(a,b,c)
    end
end

function show(io::IO, P::Projective)
    print(io, "[", P.a.val, ",", P.b.val, ",",
          P.c.val,"]_(", P.a.mod, ")")
end

*(P::Projective, Q::Projective) = P.a*Q.a + P.b*Q.b + P.c*Q.c
