@test begin
    b = Box(Point(-1, -1), Point(1, 1))
    [Box(Point(-1, -1), Point(0, 0)),
     Box(Point(-1, 0), Point(0, 1)),
     Box(Point(0, -1), Point(1, 0)),
     Box(Point(0, 0), Point(1, 1))] == split(b)
end


@test begin
    b = Box(Point(-1, -1), Point(1, 1))
    [Segment(Point(-1, -1), Point(-1, 1)),
     Segment(Point(-1, 1), Point(1, 1)),
     Segment(Point(1, 1), Point(1, -1)),
     Segment(Point(1, -1), Point(-1, -1))] == surface(b)
end

@test begin
    b = Box(Point(0, 0, 0), Point(1, 1, 1))
    [Box(Point(0, 0, 0), Point(0.5, 0.5, 0.5)),
     Box(Point(0, 0.5, 0), Point(0.5, 1, 0.5)),
     Box(Point(0.5, 0, 0), Point(1, 0.5, 0.5)),
     Box(Point(0.5, 0.5, 0), Point(1, 1, 0.5)),
     Box(Point(0, 0, 0.5), Point(0.5, 0.5, 1)),
     Box(Point(0, 0.5, 0.5), Point(0.5, 1, 1)),
     Box(Point(0.5, 0, 0.5), Point(1, 0.5, 1)),
     Box(Point(0.5, 0.5, 0.5), Point(1, 1, 1))] == split(b)
end

@test begin
    x = [-1, 2]
    y = [-2, 3]
    z = [-3, 4]

    b = Box(Point(-1, -2, -3), Point(2, 3, 4))
    faces0 = [[f(0, 0), f(1, 0), f(0, 1), f(1, 1)] for f in surface(b)]
    
    pts = [Point(xi, yi, zi) for zi in z for yi in y for xi in x]

    faces = [[1, 2, 3, 4], [5, 6, 7, 8], [1, 3, 7, 5], [2, 4, 6, 8],
             [1, 2, 5, 6], [3, 4, 7, 8]]

    faces = [pts[f] for f in faces]

    function match_face(points0, points)
        for p0 in points0
            found = false
            for p in points
                found = norm(p0 - p) < 1E-13
                found && break
            end
            !found && return false
        end
        true
    end

    for f0 in faces0
        found = false
        for f in faces
            found = match_face(f0, f)
            found && break
        end
        @assert found
    end
    true
end
