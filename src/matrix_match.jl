using ChooseOptimizer, JuMP, Multisets

"""
`matrix_match(A,B)` returns permutation matrices `P` and `Q` 
so that `P*A==B*Q` or throws an error if not possible. 
"""
function matrix_match(A::AbstractMatrix, B::AbstractMatrix)
    err_msg = "Matrices do not match"

    # Check that A and B have same dimensions and same elements
    r, c = size(A)
    if (r, c) != size(B) || Multiset(collect(A)) != Multiset(collect(B))
        error(err_msg)
    end

    m = Model(get_solver())

    # Set up P and Q are permutation matrices

    @variable(m, P[1:r, 1:r], Bin)
    @variable(m, Q[1:c, 1:c], Bin)

    for i = 1:r
        @constraint(m, sum(P[i, j] for j = 1:r) == 1)
        @constraint(m, sum(P[j, i] for j = 1:r) == 1)
    end

    for i = 1:c
        @constraint(m, sum(Q[i, j] for j = 1:c) == 1)
        @constraint(m, sum(Q[j, i] for j = 1:c) == 1)
    end

    # require P*A == B*Q

    for i = 1:r
        for j = 1:c
            @constraint(
                m,
                sum(P[i, k] * A[k, j] for k = 1:r) == sum(B[i, k] * Q[k, j] for k = 1:c)
            )
        end
    end

    optimize!(m)
    status = Int(termination_status(m))
    if status != 1
        error(err_msg)
    end

    PP = Int.(value.(P))
    QQ = Int.(value.(Q))
    return PP, QQ
end
