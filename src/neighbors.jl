# Rectangle neighbors
function neighbors(grid::Grid{Rect,Periodic}, cell::Cell{Rect})
    return [north(grid, cell), south(grid, cell), east(grid, cell), west(grid, cell)]
end

function neighbors(grid::Grid{Rect,NonPeriodic}, cell::Cell{Rect})
    nrows, ncols = grid.nrows, grid.ncols
    row, col = cell.row, cell.col
    nbs = []
    !(row == 1) && push!(nbs, north(grid, cell))
    !(row == nrows) && push!(nbs, south(grid, cell))
    !(col == 1) && push!(nbs, west(grid, cell))
    !(col == ncols) && push!(nbs, east(grid, cell))
    return nbs
end

# Hexagon neighbors
function neighbors(grid::Grid{Hexa,Periodic}, cell::Cell{Hexa})
    return [
        north(grid, cell),
        south(grid, cell),
        northwest(grid, cell),
        northeast(grid, cell),
        southwest(grid, cell),
        southeast(grid, cell),
    ]
end

function neighbors(grid::Grid{Hexa,NonPeriodic}, cell::Cell{Hexa})
    nrows, ncols = grid.nrows, grid.ncols
    row, col = cell.row, cell.col
    nbs = []
    !(row == 1) && push!(nbs, north(grid, cell))
    !(row == nrows) && push!(nbs, south(grid, cell))
    !(col == ncols) && !(row == nrows) && push!(nbs, southeast(grid, cell))
    !(col == 1) && !(row == nrows) && push!(nbs, southwest(grid, cell))
    !(col == ncols) && !(row == 1) && push!(nbs, northeast(grid, cell))
    !(col == 1) && !(row == 1) && push!(nbs, northwest(grid, cell))
    return nbs
end
