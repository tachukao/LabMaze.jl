RectGrid(nrows, ncols)::Grid{Rect,NonPeriodic} = Grid(Rect, NonPeriodic, nrows, ncols)

PeriodicRectGrid(nrows, ncols)::Grid{Rect,Periodic} = Grid(Rect, Periodic, nrows, ncols)

function Base.display(grid::Grid{Rect})
    nrows, ncols = grid.nrows, grid.ncols
    output = "+"
    for col in 1:ncols
        output *= is_connected(grid[1, col], north(grid, 1, col)) ? "   +" : "---+"
    end
    output *= "\n"

    for row in 1:(nrows)
        top = is_connected(grid[row, 1], west(grid, row, 1)) ? " " : "|"
        bottom = "+"
        for col in 1:(ncols)
            cell = grid[row, col]
            body = "   "
            east_boundary = is_connected(cell, east(grid, cell)) ? " " : "|"
            top *= body * east_boundary
            south_boundary = is_connected(cell, south(grid, cell)) ? "   " : "---"
            corner = "+"
            bottom *= south_boundary * corner
        end
        output = output * top * "\n"
        output = output * bottom * "\n"
    end
    print(output)
    return nothing
end
