# Tools for initial digits stuff

char2digit(c::Char) = c - '0'

function first_digit(x::Real, alert::Bool=false)
    if x==0
        if alert
            warn("Received 0, returning 0")
        end
        return 0
    end

    x = abs(x) # make sure it's positive

    while x < 1
        x *= 10
    end

    c = first(string(x))
    return char2digit(c)
end

function first_counts{T<:Real}(x::Array{T,1})
    digs = map(first_digit,x)
    n = length(digs)
    counts = int(zeros(9))
    for d in digs
        if d != 0
            counts[d] += 1
        end
    end
    return counts
end

function first_hists{T<:Real}(x::Array{T,1})
    counts = first_counts(x)
    hist = zeros(9)
    S = sum(counts)
    for k=1:9
        hist[k] = counts[k]/S
    end
    return counts, hist
end

function report{T<:Real}(x::Array{T,1})
    counts, hist = first_hists(x)
    for k=1:9
        println(k,"\t", counts[k], "\t", round(hist[k]*100,1), "%\t",
        log(10,k+1)-log(10,k))
    end
end


function experiment()
    n = 1000
    x = rand(n)
    println("Initial distribution")
    report(x)
    println("\n\n")
    sleep(1)

    count = 0
    while count <= 1000
        m = minimum(x)
        count += 1
        if m < 1
            x *= 100.
        end
        x = x .* rand(n)
        if count % 25 == 0
            println("step = ", count)
            report(x)
            println("-------------------------------")
            sleep(0.1)
        end
    end
end

function digit_split(n::Int)
    map(char2digit, collect(string(n)))
end

# create a 9^d multiplication table
function mult_table(d::Int)
    vals = Int[]
    for n=10^(d-1):10^d-1
        digs = digit_split(n)
        v = prod(digs)
        # println(digs, " --> ", v)
        if v != 0
            push!(vals,v)
        end
    end
    return vals
end


mult_report(d::Int) = report(mult_table(d))
