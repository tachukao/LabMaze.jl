struct Grid{T<:Shape,B<:Boundary}
    nrows::Int
    ncols::Int
    cells::Array{Cell{T},2}
end

function Grid(T1::Type{S}, T2::Type{B}, nrows, ncols) where {S<:Shape,B<:Boundary}
    cells = Array{Cell{T1},2}(undef, nrows, ncols)
    for row in 1:nrows
        for col in 1:ncols
            cells[row, col] = Cell(T1, row, col)
        end
    end
    return Grid{T1,T2}(nrows, ncols, cells)
end

function Base.getindex(grid::Grid, i::Int64, j::Int64)
    return grid.cells[i, j]
end

function Base.setindex!(grid::Grid, X, i, j)
    return grid.cells[i, j] = X
end

function size(grid::Grid)
    return grid.ncols * grid.nrows
end
