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
    b = 0.5 * sqrt(3.0)
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
