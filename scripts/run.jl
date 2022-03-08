module Run
using LabMaze

function main()
    grid = RectGrid(4, 4)
    recursive_backtracker!(grid)
    walls = wall_locations(grid)
    deadends = get_deadends(grid)
    ndeadends = length(deadends)
    println()
    println("# of deadends $(ndeadends)")
    println()
    display(grid)
    remove_deadends!(grid, 0.2)
    deadends = get_deadends(grid)
    ndeadends = length(deadends)
    println()
    println("# of deadends $(ndeadends)")
    println()
    display(grid)
    return nothing
end

function shortest_path()
    grid = RectGrid(4, 4)
    recursive_backtracker!(grid)
    remove_deadends!(grid, 1.0)
    display(grid)
    path, dists = dijkstra(grid[1, 1], grid[4, 4])
    for (cell, d) in dists
        println("Cell($(cell.row),$(cell.col)): $(d)")
    end
    println("path")
    for (cell, d) in path
        println("Cell($(cell.row),$(cell.col)): $(d)")
    end
end

function rectangle(; periodic=false, nrows=4, ncols=4)
    grid = !periodic ? RectGrid(nrows, ncols) : PeriodicRectGrid(nrows, ncols)
    recursive_backtracker!(grid)
    display(grid)
    p = draw_grid(grid)
    display(p)
    return nothing
end

function hexagon(; periodic=false, nrows=3, ncols=4)
    grid = !periodic ? HexaGrid(nrows, ncols) : PeriodicHexaGrid(nrows, ncols)
    recursive_backtracker!(grid)
    p = draw_grid(grid)
    display(p)
    return nothing
end

end
