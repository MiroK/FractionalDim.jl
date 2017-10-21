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
    # Nope if bbox don't
    !(bbox_collides(s1.box, s2.box)) && return false

    c = dot(s1.t, s2.t)
     DO = s2.O - s1.O
#     #  Possible coplanar
#     if(abs(c - 1) < EPS || abs(c + 1) < EPS)
#         # Same line
#         norm(DO) < EPS && return true
#         # If they lie on a same line then bbox colision implier collision
#         return abs(dot(normalize(DO), s1.t) - 1) < EPS ||
#                abs(dot(normalize(DO), s1.t) + 1) < EPS
#     end

#     #A = [1 -c; c -1]
#     #b = [dot(DO, s1.t), dot(DO, s2.t)]
#     #x = A\b
#     #println((x, s1(x[1]), s2(x[2])))
    
#     # We solve the 2x2 system
#     α = (-dot(s1.t, DO) + c*dot(s2.t, DO))/(c^2-1)
#     # Point would not lie on the first line; [0, L] is in side
#     !(-EPS < α < s1.length + EPS) && return false
    
#     β = (-c*dot(s1.t, DO) + dot(s2.t, DO))/(c^2-1)
#     !(-EPS < β < s2.length + EPS) && return false

#     #@show (α, β)
    
#     true
end

"""See if segment collides with a box"""
function collides(segment::Segment{3}, box::Box{3})
    is_A_in = segment.O ∈ box
    is_B_in = segment.B ∈ box

    # At least on is inside
    (is_A_in || is_B_in) && return true

    # Check collisions with cases --[---]--
    for line in surface(box)
        collides(segment, line) && return true
    end

    false
end
