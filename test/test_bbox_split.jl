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
