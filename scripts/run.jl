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

function figure()
    grid = RectGrid(4, 4)
    recursive_backtracker!(grid)
    display(grid)
    p = draw_grid(grid)
    display(p)
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

function hex()
    grid = HexaGrid(2, 3)
    recursive_backtracker!(grid)
    display(grid)
    return nothing
end

end
