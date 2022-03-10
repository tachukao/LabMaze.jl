function HexaGrid(nrows, ncols)::Grid{Hexa,NonPeriodic}
    return Grid(Hexa, NonPeriodic, nrows, ncols)
end
function PeriodicHexaGrid(nrows, ncols)::Grid{Hexa,Periodic}
    @assert iseven(ncols)
    return Grid(Hexa, Periodic, nrows, ncols)
end
