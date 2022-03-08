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
east(nrows, ncols, cell::Cell{Rect}) = _move(nrows, ncols, cell, 1, 0)
west(nrows, ncols, cell::Cell{Rect}) = _move(nrows, ncols, cell, -1, 0)

north_diagonal_y(cell::Cell{Hexa}) = iseven(cell.col) ? -1 : 0
south_diagonal_y(cell::Cell{Hexa}) = iseven(cell.col) ? 0 : 1

function northwest(nrows, ncols, cell::Cell{Hexa})
    return _move(nrows, ncols, cell, -1, north_diagonal_y(cell))
end
function northeast(nrows, ncols, cell::Cell{Hexa})
    return _move(nrows, ncols, cell, 1, north_diagonal_y(cell))
end
function southwest(nrows, ncols, cell::Cell{Hexa})
    return _move(nrows, ncols, cell, -1, south_diagonal_y(cell))
end
function southeast(nrows, ncols, cell::Cell{Hexa})
    return _move(nrows, ncols, cell, 1, south_diagonal_y(cell))
end

north(grid::Grid, cell::Cell) = _move(grid, cell, 0, -1)
south(grid::Grid, cell::Cell) = _move(grid, cell, 0, 1)
east(grid::Grid{Rect}, cell::Cell{Rect}) = _move(grid, cell, 1, 0)
west(grid::Grid{Rect}, cell::Cell{Rect}) = _move(grid, cell, -1, 0)

function northwest(grid::Grid{Hexa}, cell::Cell{Hexa})
    return _move(grid, cell, -1, north_diagonal_y(cell))
end
function northeast(grid::Grid{Hexa}, cell::Cell{Hexa})
    return _move(grid, cell, 1, north_diagonal_y(cell))
end
function southwest(grid::Grid{Hexa}, cell::Cell{Hexa})
    return _move(grid, cell, -1, south_diagonal_y(cell))
end
function southeast(grid::Grid{Hexa}, cell::Cell{Hexa})
    return _move(grid, cell, 1, south_diagonal_y(cell))
end

north(grid::Grid, row, col) = north(grid, grid[row, col])
south(grid::Grid, row, col) = south(grid, grid[row, col])
east(grid::Grid{Rect}, row, col) = east(grid, grid[row, col])
west(grid::Grid{Rect}, row, col) = west(grid, grid[row, col])

northwest(grid::Grid{Hexa}, row, col) = northwest(grid, grid[row, col])
northeast(grid::Grid{Hexa}, row, col) = northeast(grid, grid[row, col])
southwest(grid::Grid{Hexa}, row, col) = southwest(grid, grid[row, col])
southeast(grid::Grid{Hexa}, row, col) = southeast(grid, grid[row, col])
