"""Quad tree like division"""
function split(box::Box{2})
    X, Y = box.X, box.Y
    M = 0.5(X + Y)
    [Box(Point(X[1], X[2]), Point(M[1], M[2])),
     Box(Point(X[1], M[2]), Point(M[1], Y[2])),
     Box(Point(M[1], X[2]), Point(Y[1], M[2])),
     Box(Point(M[1], M[2]), Point(Y[1], Y[2]))]
end

"""Four segments that are the boundary"""
function surface(box::Box{2})
    X, Y = box.X, box.Y
    [Segment(Point(X[1], X[2]), Point(X[1], Y[2])),
     Segment(Point(X[1], Y[2]), Point(Y[1], Y[2])),
     Segment(Point(Y[1], Y[2]), Point(Y[1], X[2])),
     Segment(Point(Y[1], X[2]), Point(X[1], X[2]))]
end

"""Do the 2 segments collide?"""
function collides(s1::Segment{2}, s2::Segment{2})
    # Discard
    !(bbox_collides(s1.box, s2.box)) && return false

    c = dot(s1.t, s2.t)
    DO = s2.O - s1.O
    #  Possible coplanar
    if(abs(c - 1) < EPS || abs(c + 1) < EPS)
        # If they lie on a same line then bbox colision implier collision
        return abs(dot(normalize(DO), s1.t) - 1) < EPS ||
               abs(dot(normalize(DO), s1.t) + 1) < EPS
    end

    #A = [1 -c; c -1]
    #b = [dot(DO, s1.t), dot(DO, s2.t)]
    #x = A\b
    #println((x, s1(x[1]), s2(x[2])))
    
    # We solve the 2x2 system
    α = (-dot(s1.t, DO) + c*dot(s2.t, DO))/(c^2-1)
    # Point would not lie on the first line
    !(-EPS < α < s1.length + EPS) && return false
    
    β = (-c*dot(s1.t, DO) + dot(s2.t, DO))/(c^2-1)
    !(-EPS < β < s2.length + EPS) && return false

    #@show (α, β)
    
    true
end

"""See if segment collides with a box"""
function collides(segment::Segment{2}, box::Box{2})
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
