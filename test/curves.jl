const Fractal{D} = Vector{Segment{D}}

function unit_circle(npoints::Int)::Fractal{2}
    @assert npoints > 2
    θ = linspace(0, 2*pi, npoints)
    x = cos.(θ)
    y = sin.(θ)
    [Segment(Point(x[i], y[i]), Point(x[i+1], y[i+1])) for i in 1:npoints-1]
end

function koch_line(line::Segment{2})::Fractal{2}
    p0, p1, p2, p3 = line.O, line(1./3), line(2./3), line.B

    v = 0.5*(p1 + p2)
    v += Point(-line.t[2], line.t[1])*sqrt(3)/2*line.length/3
    
    [Segment(p0, p1), Segment(p1, v), Segment(v, p2), Segment(p2, p3)]
end

function koch_line(depth::Int)::Fractal{2}
    @assert depth > 0
    lines = [Segment(Point(0, 0), Point(1, 0))]
    while depth > 0
        lines = vcat(map(koch_line, lines)...)
        depth -= 1
    end
    lines
end

function koch_flake(depth::Int)::Fractal{2}
    @assert depth > 0
    lines = [Segment(Point(0, 0), Point(0.5, sqrt(3)/2)),
             Segment(Point(0.5, sqrt(3)/2), Point(1, 0)),
             Segment(Point(1, 0), Point(0, 0))]
    while depth > 0
        lines = vcat(map(koch_line, lines)...)
        depth -= 1
    end
    lines
end
