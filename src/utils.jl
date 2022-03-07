function wall_locations(grid::Grid{Rect})::Array{Int32,3}
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
