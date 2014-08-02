# This is a function to convert arrays into latex output

function latex{T}(A::Array{T,2}, align::Char='c')
    (r,c) = size(A)
    # header row
    print("\\begin{array}{")
    for k=1:c
        print(align)
    end
    println("}")

    # print the rows
    for a=1:r
        print("\t")
        for b=1:c
            print(A[a,b])
            if b<c
                print(" & ")
            end
        end
        if a<r
            println("\\\\")
        end
    end
    println("\n\\end{array}")    
end
