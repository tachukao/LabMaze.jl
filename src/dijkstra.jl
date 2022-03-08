function distances(src::Cell)
    dists = Dict{Cell,Int64}()
    dists[src] = 0
    frontier = [src]
    while !isempty(frontier)
        new_frontier = []
        for cell in frontier
            for next in cell.connections
                if !haskey(dists, next)
                    dists[next] = dists[cell] + 1
                    push!(new_frontier, next)
                end
            end
        end
        frontier = new_frontier
    end
    return dists
end

function dijkstra(src::Cell, target::Cell)
    dists = distances(src)
    current = target
    breadcrumbs = Dict{Cell,Int64}()
    breadcrumbs[current] = dists[current]
    while current != src
        for neighbor in current.connections
            if dists[neighbor] < dists[current]
                breadcrumbs[neighbor] = dists[neighbor]
                current = neighbor
                break
            end
        end
    end

    path = sort(collect(breadcrumbs); by=x -> x[2])
    return path, dists
end

function astar(src::Cell, goal::Cell, heuristic::Function)
    open_set = PriorityQueue()
    enqueue!(open_set, src, 0)
    came_from = Dict{Cell,Cell}()
    gscore = Dict{Cell,Int64}()
    gscore[src] = 0
    while !isempty(open_set)
        current = dequeue!(open_set)
        if current == goal
            break
        end
        for neighbor in current.connections
            tentative_gscore = gscore[current] + 1
            if !haskey(gscore, neighbor) || tentative_gscore < gscore[neighbor]
                came_from[neighbor] = current
                gscore[neighbor] = tentative_gscore
                neighbor_fscore = tentative_gscore + heuristic(neighbor, goal)
                if !haskey(open_set, neighbor)
                    enqueue!(open_set, neighbor, neighbor_fscore)
                end
            end
        end
    end

    return astar_reconstruct_path(came_from, gscore, goal), gscore
end

function astar_reconstruct_path(came_from, gscore, goal)
    path = Dict{Cell,Int64}()
    path[goal] = gscore[goal]
    current = goal
    while haskey(came_from, current)
        current = came_from[current]
        path[current] = gscore[current]
    end
    path = sort(collect(path); by=x -> x[2])
    return path
end
