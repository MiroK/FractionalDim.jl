"""A face of Box{3}"""
struct Rectangle
    # Origin
    O::Point{3}
    # Two perp vector defining the plane ...
    t1::Point{3}
    t2::Point{3}
    # ... with normal
    normal::Point{3}
    # Lengths of sides
    l1::Float64
    l2::Float64
    # A
    # |
    # O--B
    function Rectangle(O::Point{3}, t1::Point{3}, t2::Point{3}, n::Point{3})
        l1 = norm(t1)
        t1 /= l1

        l2 = norm(t2)
        t2 /= l2

        n0 = cross(t1, t2)
        @assert n == normalize(n0)
        new(O, t1, t2, n, l1, l2)
    end
end

"""Construct from enumerating"""
function Rectangle(b::Box{3}, facet::Int)
    const dX = b.Y - b.X

    facet == 1 && return Rectangle(b.X, Point(dX[1], 0, 0), Point(0, dX[2], 0), Point(0, 0, 1))
    facet == 2 && return Rectangle(b.X, Point(0, dX[2], 0), Point(0, 0, dX[3]), Point(1, 0, 0))
    facet == 3 && return Rectangle(b.X, Point(0, 0, dX[3]), Point(dX[1], 0, 0), Point(0, 1, 0))

    facet == 4 && return Rectangle(b.Y, Point(-dX[1], 0, 0), Point(0, -dX[2], 0), Point(0, 0, 1))
    facet == 5 && return Rectangle(b.Y, Point(0, -dX[2], 0), Point(0, 0, -dX[3]), Point(1, 0, 0))
    facet == 6 && return Rectangle(b.Y, Point(0, 0, -dX[3]), Point(-dX[1], 0, 0), Point(0, 1, 0))

end

# Eval the curve using [0, 1]^2 parametrization
(r::Rectangle)(s::Number, t::Number) = r.O + s*r.l1*r.t1 + t*r.l2*r.t2

show(io::IO, b::Rectangle) = print(io, "$(b.O)-$(b(1, 1))")

"""
    Quad tree like division

    Bottom part    Top part  
    |---|---|      |---|---|       
    | 2 | 4 |      | 6 | 8 |
    |---|---|      |---|---|
    | 1 | 3 |      | 5 | 7 |
    |---|---|      |---|---|

"""
function split(box::Box{3})
    X, Y = box.X, box.Y
    M = 0.5(X + Y)
    [Box(Point(X[1], X[2], X[2]), Point(M[1], M[2], M[2])),
     Box(Point(X[1], M[2], X[2]), Point(M[1], Y[2], M[2])),
     Box(Point(M[1], X[2], X[2]), Point(Y[1], M[2], M[2])),
     Box(Point(M[1], M[2], X[2]), Point(Y[1], Y[2], M[2])),
     Box(Point(X[1], X[2], M[2]), Point(M[1], M[2], Y[2])),
     Box(Point(X[1], M[2], M[2]), Point(M[1], Y[2], Y[2])),
     Box(Point(M[1], X[2], M[2]), Point(Y[1], M[2], Y[2])),
     Box(Point(M[1], M[2], M[2]), Point(Y[1], Y[2], Y[2]))]
end

"""6 faces of the prism"""
function surface(box::Box{3})
    map(i -> Rectangle(box, i), 1:6)
end

"""Does a face(rectangle) collide with segment"""
function collides(line::Segment{3}, box::Rectangle)
    D = line.O - box.O
    D1 = dot(D, box.t1)
    D2 = dot(D, box.t2)
    D3 = dot(D, line.t)
    
    c1 = dot(box.t1, line.t)
    c2 = dot(box.t2, line.t)
    C = c1^2 + c2^2 - 1

    # @show [1 0 -c1; 0 1 -c2; c1 c2 -1]\[D1, D2, D3]
    # We solve the 3x3 system
    α = (-c1*c1/C + 1)*D1 + (-c1*c2/C)*D2 + (c1/C)*D3
    # @show α
    !(-EPS < α < box.l1 + EPS) && return false

    β = (-c1*c2/C)*D1 + (-c2*c2/C + 1)*D2 + (c2/C)*D3
    # @show β
    !(-EPS < β < box.l2 + EPS) && return false

    γ = (-c1/C)*D1 + (-c2/C)*D2 + (1/C)*D3
    # @show γ
    !(-EPS < γ < line.length + EPS) && return false

    true
end

"""See if segment collides with a box"""
function collides(segment::Segment{3}, box::Box{3})
    !bbox_collides(segment.box, box) && return false

    (segment.O ∈ box && segment.O ∈ box) && return true

    # Check collisions with cases --[---]--
    for line in surface(box)
        collides(segment, line) && return true
    end

    false
end
