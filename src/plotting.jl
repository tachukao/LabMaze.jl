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
    function line!((x1, y1), (x2, y2); color=:red, linestyle)
        return plot!([x1, x2], [y1, y2]; color, linestyle)
    end

    for (cond, color, linestyle) in [(true, :gray, :dash), (false, :black, :solid)]
        for row in 1:(grid.nrows)
            for col in 1:(grid.ncols)
                cell = grid[row, col]
                cx = 1 + 3 * cell.col * a
                cy = b + cell.row * height
                if isodd(cell.col)
                    cy += b
                end
                x_fw = (cx - 1)
                x_nw = (cx - a)
                x_ne = (cx + a)
                x_fe = (cx + 1)

                y_n = -(cy - b)
                y_m = -cy
                y_s = -(cy + b)

                if cond || !is_connected(cell, southwest(grid, cell))
                    line!((x_fw, y_m), (x_nw, y_s); color, linestyle)
                end

                if cond || !is_connected(cell, northwest(grid, cell))
                    line!((x_fw, y_m), (x_nw, y_n); color, linestyle)
                end
                if cond || !is_connected(cell, north(grid, cell))
                    line!((x_nw, y_n), (x_ne, y_n); color, linestyle)
                end
                if cond || !is_connected(cell, northeast(grid, cell))
                    line!((x_ne, y_n), (x_fe, y_m); color, linestyle)
                end
                if cond || !is_connected(cell, southeast(grid, cell))
                    line!((x_fe, y_m), (x_ne, y_s); color, linestyle)
                end
                if cond || !is_connected(cell, south(grid, cell))
                    line!((x_ne, y_s), (x_nw, y_s); color, linestyle)
                end
            end
        end
    end

    return p
end
