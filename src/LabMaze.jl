module LabMaze

using Random
using Plots

include("exports.jl")
include("shapes.jl")
include("cell.jl")
include("grid.jl")

function recursive_backtracker!(grid, start_pos=(1, 1))
    start_at = grid[start_pos...]
    stack = [start_at]
    while !isempty(stack)
        current = stack[end]
        nbs = filter(x -> isempty(x.connections), neighbors(grid, current))
        if isempty(nbs)
            pop!(stack)
        else
            neighbor = rand(nbs)
            connect!(current, neighbor)
            push!(stack, neighbor)
        end
    end
    return grid
end

function wall_locations(grid::Grid)::Array{Int32,3}
    nrows, ncols = grid.nrows, grid.ncols
    walls = zeros(Int32, (nrows, ncols, 4))
    directions = [north, south, east, west]
    for row in 1:nrows
        for col in 1:ncols
            cell = grid[row, col]
            for i in 1:4
                d = directions[i]
                if !is_connected(cell, d(grid, cell))
                    walls[row, col, i] = 1
                end
            end
        end
    end
    return walls
end

function draw_grid(grid::Grid{Rect})
    p = plot(; aspectratio=1, legend=false, axis=false, grid=false, ticks=false)
    function line!((x1, y1), (x2, y2))
        return plot!([x1, x2], [y1, y2]; color=:black)
    end

    for row in 1:(grid.nrows)
        for col in 1:(grid.ncols)
            cell = grid[row, col]
            x1 = cell.col
            x2 = (1 + cell.col)
            # flip
            y1 = grid.nrows - cell.row + 1
            y2 = grid.nrows - (1 + cell.row) + 1
            if !is_connected(cell, north(grid, cell))
                line!((x1, y1), (x2, y1))
            end
            if !is_connected(cell, west(grid, cell))
                line!((x1, y1), (x1, y2))
            end
            if !is_connected(cell, east(grid, cell))
                line!((x2, y1), (x2, y2))
            end
            if !is_connected(cell, south(grid, cell))
                line!((x1, y2), (x2, y2))
            end
        end
    end

    return p
end

function draw_grid(grid::Grid{Hexa})
    a = 0.5
    b = 0.5 * sqrt(3.)
    width = 0.5
    height = b * 2


    p = plot(; aspectratio=1, legend=false, axis=false, grid=false, ticks=false)
    function line!((x1, y1), (x2, y2))
        return plot!([x1, x2], [y1, y2]; color=:black)
    end

    for row in 1:(grid.nrows)
        for col in 1:(grid.ncols)
            cell = grid[row, col]
            x1 = cell.col
            x2 = (1 + cell.col)
            # flip
            y1 = grid.nrows - cell.row + 1
            y2 = grid.nrows - (1 + cell.row) + 1
            if !is_connected(cell, north(grid, cell))
                line!((x1, y1), (x2, y1))
            end
            if !is_connected(cell, west(grid, cell))
                line!((x1, y1), (x1, y2))
            end
            if !is_connected(cell, east(grid, cell))
                line!((x2, y1), (x2, y2))
            end
            if !is_connected(cell, south(grid, cell))
                line!((x1, y2), (x2, y2))
            end
        end
    end

    return p
end


include("dijkstra.jl")

end
