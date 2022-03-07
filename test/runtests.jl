using LabMaze
using Test

@testset "LabMaze.jl" begin
    # Write your tests here.
    cell1 = Cell(Rect, ; row=3, col=4)
    cell2 = Cell(Rect, 3, 5)
    connect!(cell1, cell2)
    @test is_connected(cell1, cell2)
    disconnect!(cell1, cell2)
    @test !is_connected(cell1, cell2)
end
