# See https://en.wikipedia.org/wiki/List_of_fractals_by_Hausdorff_dimension

const Fractal{D} = Vector{Segment{D}}

function unit_circle(npoints::Int)::Fractal{2}
    @assert npoints > 2
    θ = linspace(0, 2*pi, npoints)
    x = cos.(θ)
    y = sin.(θ)
    [Segment(Point(x[i], y[i]), Point(x[i+1], y[i+1])) for i in 1:npoints-1]
end


"""Step a segment into
   /\
--/  \--
"""
function koch_line(line::Segment{2})::Fractal{2}
    p0, p1, p2, p3 = line.O, line(1./3), line(2./3), line.B

    v = 0.5*(p1 + p2)
    v += Point(-line.t[2], line.t[1])*sqrt(3)/2*line.length/3
    
    [Segment(p0, p1), Segment(p1, v), Segment(v, p2), Segment(p2, p3)]
end

"""Grow by stepiing from straigt line. FD = log(4)/log(3)"""
function koch_line(depth::Int)::Fractal{2}
    @assert depth > 0
    lines = [Segment(Point(0, 0), Point(1, 0))]
    while depth > 0
        lines = vcat(map(koch_line, lines)...)
        depth -= 1
    end
    lines
end

"""Grow (outward) by stepping from quilateral triangle. FD = log(4)/log(3)"""
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

"""Like Kock flake but grows inward. Triflake in wiki?. FD = log(4)/log(3)"""
function triflake(depth::Int)::Fractal{2}
    @assert depth > 0
    lines = [Segment(Point(0, 0), Point(1, 0)),
             Segment(Point(1, 0), Point(0.5, sqrt(3)/2)),
             Segment(Point(0.5, sqrt(3)/2), Point(0, 0))]
    while depth > 0
        lines = vcat(map(koch_line, lines)...)
        depth -= 1
    end
    lines
end

# --------------------------------------------------------------------

"""                  |-|
--------  becomes   -| |-
"""
function koch_quadratic_1(line::Segment{2})
    v1, v2, v3, v4 = line.O, line(1./3), line(2./3), line.B
    shift = Point(-line.t[2], line.t[1])*line.length/3
   
    [Segment(v1, v2),        
     Segment(v2, v2 + shift), 
     Segment(v2 + shift, v3 + shift),
     Segment(v3 + shift, v3),
     Segment(v3, v4)]
end

"""Grow by stepping from (0, 0) - (1, 0). FD = log(5)/log(3)"""
function koch_quadratic_1(depth::Int)::Fractal{2}
    @assert depth > 0
    lines = [Segment(Point(0, 0), Point(1, 0))]
    while depth > 0
        lines = vcat(map(koch_quadratic_1, lines)...)
        depth -= 1
    end
    lines
end

# --------------------------------------------------------------------

"""                  |-|
--------  becomes   -| | |-
                       |-|
"""
function koch_quadratic_2(line::Segment{2})
    v1, v2, v3, v4, v5 = line.O, line(0.25), line(0.5), line(0.75), line.B
    shift = Point(-line.t[2], line.t[1])*line.length/4
   
    [Segment(v1, v2),        
     Segment(v2, v2 + shift), 
     Segment(v2 + shift, v3 + shift),
     Segment(v3 + shift, v3),
     Segment(v3, v3 - shift),
     Segment(v3 - shift, v4 - shift),
     Segment(v4 - shift, v4),
     Segment(v4, v5)]
end

"""Grow by stepping from (0, 0) - (1, 0). FD = 1.5"""
function koch_quadratic_2(depth::Int)::Fractal{2}
    @assert depth > 0
    lines = [Segment(Point(0, 0), Point(1, 0))]
    while depth > 0
        lines = vcat(map(koch_quadratic_2, lines)...)
        depth -= 1
    end
    lines
end

# --------------------------------------------------------------------

"""               _
\  / becomes   | |
 \/            |_|
"""
function dragon_curve(lines::NTuple{2, Segment{2}})
    line = first(lines)
    v1, v2 = line.O, line.B
    shift = Point(line.t[2], -line.t[1])*line.length/2
    m = 0.5*(v1 + v2) + shift

    l1 = (Segment(v1, m), Segment(m, v2))

    line = last(lines)
    v1, v2 = line.O, line.B
    shift = Point(-line.t[2], line.t[1])*line.length/2
    m = 0.5*(v1 + v2) + shift

    [l1, (Segment(v1, m), Segment(m, v2))]
end

"""Grow by stepping from (0, 0) - (1, -1) - (2, 0). FD = 1.526"""
function dragon_curve(depth::Int)::Fractal{2}
    @assert depth > 0
    pairs = [(Segment(Point(0, 0), Point(1, -1)),
              Segment(Point(1, -1), Point(2, 0)))]
    while depth > 0
        pairs = vcat(map(dragon_curve, pairs)...)
        depth -= 1
    end
    # Saw them together
    [l for pair in pairs for l in pair]
end
