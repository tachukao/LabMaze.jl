struct Cell{T<:Shape}
    row::Int
    col::Int
    connections::Set{Cell{T}}
end

function Cell(T::Type{S}, row::Int, col::Int) where S <: Shape
    return Cell(row, col, Set{Cell{T}}())
end

function Cell(T::Type{S}; row::Int, col::Int) where S <: Shape
    return Cell(T, row, col)
end

function Base.display(cell::Cell)
    print("Cell($(cell.row), $(cell.col))\n")
    return nothing
end

function connect!(x::Cell, y::Cell; bidirection=true)
    push!(x.connections, y)
    if bidirection
        push!(y.connections, x)
    end
end

function disconnect!(x::Cell, y::Cell, bidirection=true)
    delete!(x.connections, y)
    if bidirection
        delete!(y.connections, x)
    end
end

function is_connected(x, y; bidirection=true)
    if bidirection
        return (y ∈ x.connections) & (x ∈ y.connections)
    else
        return y ∈ x.connections
    end
end
