struct Grid{T<:Shape}
    nrows::Int
    ncols::Int
    cells::Array{Cell{T},2}
end

function Grid(T::Type{S}, nrows, ncols) where {S<:Shape}
    cells = Array{Cell{T},2}(undef, nrows, ncols)
    for row in 1:nrows
        for col in 1:ncols
            cells[row, col] = Cell(T, row, col)
        end
    end
    return Grid{T}(nrows, ncols, cells)
end

RectGrid(nrows, ncols)::Grid{Rect} = Grid(Rect, nrows, ncols)
HexaGrid(nrows, ncols)::Grid{Hexa} = Grid(Hexa, nrows, ncols)

function Base.getindex(grid::Grid, i::Int64, j::Int64)
    return grid.cells[i, j]
end

function Base.setindex!(grid::Grid, X, i, j)
    return grid.cells[i, j] = X
end

function _move(nrows::Int, ncols::Int, cell::Cell, x::Int, y::Int)
    col = (cell.col + x - 1 + ncols) % ncols + 1
    row = (cell.row + y - 1 + nrows) % nrows + 1
    return row, col
end

function _move(grid::Grid, cell::Cell, x, y)
    row, col = _move(grid.nrows, grid.ncols, cell, x, y)
    return grid[row, col]
end

north(nrows, ncols, cell::Cell) = _move(nrows, ncols, cell, 0, -1)
south(nrows, ncols, cell::Cell) = _move(nrows, ncols, cell, 0, 1)
east(nrows, ncols, cell::Cell) = _move(nrows, ncols, cell, 1, 0)
west(nrows, ncols, cell::Cell) = _move(nrows, ncols, cell, -1, 0)

northwest(nrows, ncols, cell::Cell) = _move(nrows, ncols, cell, -1, -1)
northeast(nrows, ncols, cell::Cell) = _move(nrows, ncols, cell, 1, -1)
southwest(nrows, ncols, cell::Cell) = _move(nrows, ncols, cell, -1, 1)
southeast(nrows, ncols, cell::Cell) = _move(nrows, ncols, cell, 1, 1)

north(grid::Grid, cell::Cell) = _move(grid, cell, 0, -1)
south(grid::Grid, cell::Cell) = _move(grid, cell, 0, 1)
east(grid::Grid, cell::Cell) = _move(grid, cell, 1, 0)
west(grid::Grid, cell::Cell) = _move(grid, cell, -1, 0)

northwest(grid::Grid{Hexa}, cell::Cell{Hexa}) = _move(grid, cell, -1, -1)
northeast(grid::Grid{Hexa}, cell::Cell{Hexa}) = _move(grid, cell, 1, -1)
southwest(grid::Grid{Hexa}, cell::Cell{Hexa}) = _move(grid, cell, -1, 1)
southeast(grid::Grid{Hexa}, cell::Cell{Hexa}) = _move(grid, cell, 1, 1)

north(grid::Grid, row, col) = north(grid, grid[row, col])
south(grid::Grid, row, col) = south(grid, grid[row, col])
east(grid::Grid, row, col) = east(grid, grid[row, col])
west(grid::Grid, row, col) = west(grid, grid[row, col])

northwest(grid::Grid{Hexa}, row, col) = northwest(grid, grid[row, col])
northeast(grid::Grid{Hexa}, row, col) = northeast(grid, grid[row, col])
southwest(grid::Grid{Hexa}, row, col) = southwest(grid, grid[row, col])
southeast(grid::Grid{Hexa}, row, col) = southeast(grid, grid[row, col])

function neighbors(grid::Grid{Rect}, cell::Cell{Rect})
    return [north(grid, cell), south(grid, cell), east(grid, cell), west(grid, cell)]
end

function neighbors(grid::Grid{Hexa}, cell::Cell{Hexa})
    return [
        north(grid, cell),
        south(grid, cell),
        east(grid, cell),
        west(grid, cell),
        northwest(grid, cell),
        northeast(grid, cell),
        southwest(grid, cell),
        southeast(grid, cell),
    ]
end

function size(grid::Grid)
    return grid.ncols * grid.nrows
end

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
