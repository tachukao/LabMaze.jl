module Run
using LabMaze
using Plots

function deadends()
    grid = PeriodicRectGrid(4, 4)
    recursive_backtracker!(grid)
    deadends = get_deadends(grid)
    ndeadends = length(deadends)
    println("# of deadends $(ndeadends)")
    display(grid)
    remove_deadends!(grid, 0.2)
    deadends = get_deadends(grid)
    ndeadends = length(deadends)
    println("# of deadends $(ndeadends)")
    display(grid)
    return nothing
end

function triangle(; periodic=false, nrows=4, ncols=4)
    grid = !periodic ? TriaGrid(nrows, ncols) : PeriodicTriaGrid(nrows, ncols)
    recursive_backtracker!(grid)
    remove_deadends!(grid, 0.5)
    p = draw_grid(grid)
    display(p)
    return nothing
end

function solve_triangle_astar(; periodic=false)
    grid = !periodic ? TriaGrid(4, 4) : PeriodicTriaGrid(4, 4)
    recursive_backtracker!(grid)
    remove_deadends!(grid, 0.5)
    p = draw_grid(grid)
    function heuristic(x, goal)
        return (x.col - goal.col)^2 + (x.row - goal.row)^2
    end
    path, dists = astar(grid[1, 1], grid[4, 4], heuristic)
    draw_distance(Tria, dists)
    draw_solution(Tria, path)
    display(p)
    suffix = periodic ? "_periodic" : ""
    savefig(p, "imgs/triangle$(suffix).png")
    return nothing
end

function rectangle(; periodic=false, nrows=4, ncols=4)
    grid = !periodic ? RectGrid(nrows, ncols) : PeriodicRectGrid(nrows, ncols)
    recursive_backtracker!(grid)
    display(grid)
    p = draw_grid(grid)
    display(p)
    return nothing
end

function solve_rectangle(; periodic=false)
    grid = !periodic ? RectGrid(4, 4) : PeriodicRectGrid(4, 4)
    recursive_backtracker!(grid)
    remove_deadends!(grid, 0.5)
    p = draw_grid(grid)
    path, dists = dijkstra(grid[1, 1], grid[4, 4])
    draw_distance(Rect, dists)
    draw_solution(Rect, path)
    display(p)
    suffix = periodic ? "_periodic" : ""
    savefig(p, "imgs/rectangle$(suffix).png")
    return nothing
end

function hexagon(; periodic=false, nrows=3, ncols=4)
    grid = !periodic ? HexaGrid(nrows, ncols) : PeriodicHexaGrid(nrows, ncols)
    recursive_backtracker!(grid)
    p = draw_grid(grid)
    display(p)
    return nothing
end

function solve_hexagon(; periodic=false)
    grid = !periodic ? HexaGrid(4, 4) : PeriodicHexaGrid(4, 4)
    recursive_backtracker!(grid)
    remove_deadends!(grid, 0.5)
    p = draw_grid(grid)
    path, dists = dijkstra(grid[1, 1], grid[4, 4])
    draw_distance(Hexa, dists)
    draw_solution(Hexa, path)
    display(p)
    suffix = periodic ? "_periodic" : ""
    savefig(p, "imgs/hexagon$(suffix).png")
    return nothing
end

function solve_hexagon_astar(; periodic=false)
    grid = !periodic ? HexaGrid(4, 4) : PeriodicHexaGrid(4, 4)
    recursive_backtracker!(grid)
    remove_deadends!(grid, 0.5)
    p = draw_grid(grid)
    function heuristic(x, goal)
        return (x.col - goal.col)^2 + (x.row - goal.row)^2
    end
    path, dists = astar(grid[1, 1], grid[4, 4], heuristic)
    draw_distance(Hexa, dists)
    draw_solution(Hexa, path)
    display(p)
    return nothing
end

end
