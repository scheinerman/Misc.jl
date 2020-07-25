function test1()
    a = 2
    println("Out of block: a = $a")
    begin
        println("In block: a = $a")
    end
    println("Out of block: a = $a")

end


function test2()
    a = 2
    println("Out of block: a = $a")
    begin
        println("In block: a = $a")
        a += 1
    end
    println("Out of block: a = $a")
end



function test3()
    # println("Out of block: a = $a")
    begin
        a = 2
        println("In block: a = $a")
        a += 1
    end
    println("Out of block: a = $a")
end



a = 2
println("Out of block: a = $a")
begin
    println("In block: a = $a")
    a += 1
    b = 3
end
println("Out of block: a = $a")
println("Out of block: b = $b")

using Test
@testset "Hello" begin
    println("In testset: a = $a")
    println("In testset: b = $b")
    @test a == 3
    # b += 0
end

println("Out of block: a = $a")
println("Out of block: b = $b")
