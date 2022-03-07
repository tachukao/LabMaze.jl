function recursive_backtracker!(grid, start_pos=(1, 1))
    start_at = grid[start_pos...]
    stack = [start_at]
    while !isempty(stack)
        current = stack[end]
        nbs = filter(x -> isempty(x.connections), neighbors(grid, current))
        if isempty(nbs)
            pop!(stack)
        else
            neighbor = rand(nbs)
            connect!(current, neighbor)
            push!(stack, neighbor)
        end
    end
    return grid
end
