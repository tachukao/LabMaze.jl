using LabMaze
using Test

@testset "Connections" begin
    cell1 = Cell(Rect, ; row=3, col=4)
    cell2 = Cell(Rect, 3, 5)
    connect!(cell1, cell2)
    @test is_connected(cell1, cell2)
    @test length(cell1.connections) == 1
    @test length(cell2.connections) == 1
    disconnect!(cell1, cell2)
    @test !is_connected(cell1, cell2)
end

@testset "Triangle" begin
    nrows = 3
    ncols = 4
    grid = TriaGrid(nrows, ncols)
    @test grid.nrows == nrows
    @test grid.ncols == ncols
    periodic_grid = PeriodicTriaGrid(nrows, ncols)
    # periodic triagonal grids have to have even ncols
    @test_throws AssertionError PeriodicTriaGrid(nrows, 3)
    @test grid.nrows == nrows
    @test grid.ncols == ncols
end

@testset "Rectangle" begin
    nrows = 3
    ncols = 4
    grid = RectGrid(nrows, ncols)
    @test grid.nrows == nrows
    @test grid.ncols == ncols
    periodic_grid = PeriodicRectGrid(nrows, ncols)
    @test grid.nrows == nrows
    @test grid.ncols == ncols
end

@testset "Hexagon" begin
    nrows = 3
    ncols = 4
    grid = HexaGrid(nrows, ncols)
    @test grid.nrows == nrows
    @test grid.ncols == ncols
    periodic_grid = PeriodicHexaGrid(nrows, ncols)
    # periodic hexagonal grids have to have even ncols
    @test_throws AssertionError PeriodicHexaGrid(nrows, 3)
    @test grid.nrows == nrows
    @test grid.ncols == ncols
end

@testset "Deadends" begin
    nrows = 3
    ncols = 4
    grid = HexaGrid(nrows, ncols)
    # there should be no deadends in the beginning
    @test length(get_deadends(grid)) == 0
    recursive_backtracker!(grid)
    n_deadends = length(get_deadends(grid))
    remove_deadends!(grid, 0.8)
    new_n_deadends = length(get_deadends(grid))
    @assert new_n_deadends <= n_deadends
end
