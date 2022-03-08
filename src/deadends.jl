function is_deadend(cell::Cell)
    return length(cell.connections) == 1
end

function get_deadends(grid::Grid)
    des = []
    for row in 1:(grid.nrows)
        for col in 1:(grid.ncols)
            cell = grid[row, col]
            if is_deadend(cell)
                push!(des, cell)
            end
        end
    end
    return des
end

function remove_deadends!(grid::Grid, p::Float64)
    @assert (p <= 1.0) & (p >= 0.0)
    deadends = shuffle(get_deadends(grid))
    for cell in deadends
        if is_deadend(cell) & (rand() < p)
            nbs = filter(x -> !is_connected(cell, x), neighbors(grid, cell))
            best = filter(x -> is_deadend(x), nbs)
            if isempty(best)
                best = nbs
            end
            neighbor = rand(best)
            connect!(cell, neighbor)
        end
    end
end
