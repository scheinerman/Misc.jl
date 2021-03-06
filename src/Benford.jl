# Tools for initial digits stuff

char2digit(c::Char) = c - '0'

function first_digit(x::Real, alert::Bool = false)
    if x == 0
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

function first_counts(x::Array{T,1}) where {T<:Real}
    digs = map(first_digit, x)
    n = length(digs)
    counts = zeros(Int, 9)
    for d in digs
        if d != 0
            counts[d] += 1
        end
    end
    return counts
end

function first_hists(x::Array{T,1}) where {T<:Real}
    counts = first_counts(x)
    hist = zeros(9)
    S = sum(counts)
    for k = 1:9
        hist[k] = counts[k] / S
    end
    return counts, hist
end

function report(x::Array{T,1}) where {T<:Real}
    counts, hist = first_hists(x)
    for k = 1:9
        println(
            k,
            "\t",
            counts[k],
            "\t",
            round(hist[k] * 100, digits = 1),
            "%\t",
            log(10, k + 1) - log(10, k),
        )
    end
end

function report_array(x::Array{T,1}) where {T<:Real}
    counts, hist = first_hists(x)
    A = Array(Any, (9, 3))
    for k = 1:9
        A[k, 1] = k
        A[k, 2] = counts[k]
        A[k, 3] = round(hist[k] * 100, digits = 2)
    end
    return A
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
            x *= 100.0
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
function mult_table_old(d::Int)
    vals = Int[]
    for n = 10^(d-1):10^d-1
        digs = digit_split(n)
        v = prod(digs)
        # println(digs, " --> ", v)
        if v != 0
            push!(vals, v)
        end
    end
    return vals
end

function mult_table(d::Int)
    tic()
    counts = zeros(Int, 9)
    for n = 10^(d-1):10^d-1
        digs = digit_split(n)
        v = prod(digs)
        if v != 0
            d = first_digit(v)
            counts[d] += 1
        end
    end
    toc()
    return counts
end

mult_report_old(d::Int) = report(mult_table(d))

function mult_report(d::Int)
    counts = mult_table(d)
    N = sum(counts)

    A = Array(Any, (9, 3))
    for k = 1:9
        A[k, 1] = k
        A[k, 2] = counts[k]
        A[k, 3] = round(100 * counts[k] / N, 2)
    end
    return A
end
