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
    return breadcrumbs, dists
end
