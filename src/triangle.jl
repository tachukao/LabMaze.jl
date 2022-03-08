function TriaGrid(nrows, ncols)::Grid{Tria,NonPeriodic}
    return Grid(Tria, NonPeriodic, nrows, ncols)
end

function PeriodicTriaGrid(nrows, ncols)::Grid{Tria,Periodic}
    @assert iseven(ncols)
    return Grid(Tria, Periodic, nrows, ncols)
end
