function draw_circle(x::Real, y::Real, r::Real; opts...)
    f(t) = r * cos(t) + x
    g(t) = r * sin(t) + y
    return plot!(f, g, 0, 2pi; opts...)
end

function line!((x1, y1), (x2, y2); opts...)
    return plot!([x1, x2], [y1, y2]; opts...)
end

function draw_grid(grid::Grid{Tria})
    p = plot(; aspectratio=1, legend=false, axis=false, grid=false, ticks=false)

    width = 1
    half_width = 0.5 * width
    height = sqrt(3) / 2
    half_height = 0.5 * height

    for (cond, color, linestyle) in [(true, :gray, :solid), (false, :black, :solid)]
        for row in 1:(grid.nrows)
            for col in 1:(grid.ncols)
                cell = grid[row, col]
                upright = iseven(cell.row + cell.col)
                cx = half_width + cell.col * half_width
                cy = half_height + cell.row * height
                west_x = (cx - half_width)
                mid_x = cx
                east_x = cx + half_width

                apex_y = upright ? -(cy - half_height) : -(cy + half_height)
                base_y = upright ? -(cy + half_height) : -(cy - half_height)

                if cond || !is_connected(cell, west(grid, cell))
                    line!((west_x, base_y), (mid_x, apex_y); color, linestyle)
                end
                if cond || !is_connected(cell, east(grid, cell))
                    line!((east_x, base_y), (mid_x, apex_y); color, linestyle)
                end

                ncond = (!upright && !is_connected(cell, north(grid, cell)))
                scond = (upright && !is_connected(cell, south(grid, cell)))
                if cond || ncond || scond
                    line!((east_x, base_y), (west_x, base_y); color, linestyle)
                end
            end
        end
    end

    return p
end

function draw_distance(::Type{Tria}, dists)
    @info "draw path"

    width = 1
    half_width = 0.5 * width
    height = sqrt(3) / 2
    half_height = 0.5 * height

    for (cell, d) in dists
        println("Cell($(cell.row),$(cell.col)): $(d)")
        cx = half_width + cell.col * half_width
        cy = half_height + cell.row * height

        x = cx
        y = -cy
        annotate!(x, y, "$(d)")
    end
end

function draw_solution(::Type{Tria}, path)
    @info "draw path"

    width = 1
    half_width = 0.5 * width
    height = sqrt(3) / 2
    half_height = 0.5 * height

    for (cell, d) in path
        println("Cell($(cell.row),$(cell.col)): $(d)")
        cx = half_width + cell.col * half_width
        cy = half_height + cell.row * height
        x = cx
        y = -cy
        draw_circle(x, y, 0.15; color=:red, seriestype=[:shape], fillalpha=1.0)
    end
end

function draw_grid(grid::Grid{Rect})
    p = plot(; aspectratio=1, legend=false, axis=false, grid=false, ticks=false)

    for row in 1:(grid.nrows)
        for col in 1:(grid.ncols)
            cell = grid[row, col]
            x1 = cell.col
            x2 = (1 + cell.col)
            # flip
            y1 = -cell.row + 1
            y2 = -(1 + cell.row) + 1
            if !is_connected(cell, north(grid, cell))
                line!((x1, y1), (x2, y1); color=:black)
            end
            if !is_connected(cell, west(grid, cell))
                line!((x1, y1), (x1, y2); color=:black)
            end
            if !is_connected(cell, east(grid, cell))
                line!((x2, y1), (x2, y2); color=:black)
            end
            if !is_connected(cell, south(grid, cell))
                line!((x1, y2), (x2, y2); color=:black)
            end
        end
    end

    return p
end

function draw_distance(::Type{Rect}, dists)
    @info "draw path"

    for (cell, d) in dists
        println("Cell($(cell.row),$(cell.col)): $(d)")
        x = cell.col + 0.5
        y = -(cell.row - 0.5)
        annotate!(x, y, "$(d)")
    end
end

function draw_solution(::Type{Rect}, path)
    @info "draw path"

    for (cell, d) in path
        println("Cell($(cell.row),$(cell.col)): $(d)")
        x = cell.col + 0.5
        y = -(cell.row - 0.5)
        draw_circle(x, y, 0.2; color=:red, seriestype=[:shape], fillalpha=1.0)
    end
end

function draw_grid(grid::Grid{Hexa})
    a = 0.5
    b = 0.5 * sqrt(3.0)
    width = 0.5
    height = b * 2

    p = plot(; aspectratio=1, legend=false, axis=false, grid=false, ticks=false)

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

function draw_distance(::Type{Hexa}, dists)
    @info "draw path"

    a = 0.5
    b = 0.5 * sqrt(3.0)
    height = b * 2

    for (cell, d) in dists
        println("Cell($(cell.row),$(cell.col)): $(d)")

        cx = 1 + 3 * cell.col * a
        cy = b + cell.row * height
        if isodd(cell.col)
            cy += b
        end
        x = cx
        y = -cy
        annotate!(x, y, "$(d)")
    end
end

function draw_solution(::Type{Hexa}, path)
    @info "draw path"

    a = 0.5
    b = 0.5 * sqrt(3.0)
    height = b * 2

    for (cell, d) in path
        println("Cell($(cell.row),$(cell.col)): $(d)")
        cx = 1 + 3 * cell.col * a
        cy = b + cell.row * height
        if isodd(cell.col)
            cy += b
        end
        x = cx
        y = -cy
        draw_circle(x, y, 0.3; color=:red, seriestype=[:shape], fillalpha=1.0)
    end
end
