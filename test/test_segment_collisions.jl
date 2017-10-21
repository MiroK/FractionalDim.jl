@test begin
    l = Segment(Point(0, 0), Point(1, 1))
    L = Segment(Point(2, 0), Point(3, 1))
    !collides(l, L)
end

@test begin
    l = Segment(Point(0, 0), Point(1, 1))
    L = Segment(Point(1, 0), Point(2, 1))
    !collides(l, L)
end

@test begin
    l = Segment(Point(0, 0), Point(1, 1))
    L = Segment(Point(0.75, 0), Point(1, 0.25))
    !collides(l, L)
end

@test begin
    l = Segment(Point(0, 0), Point(1, 0))
    L = Segment(Point(0, 1), Point(1, 1))
    !collides(l, L)
end

@test begin
    l = Segment(Point(0, 0), Point(1, 0))
    L = Segment(Point(2, 0), Point(3, 0))
    !collides(l, L)
end

@test collides(Segment(Point(-1, 0), Point(0, 0)), Segment(Point(0, 0), Point(1, 0)))

@test begin
    l = Segment(Point(0, 0), Point(1, 0))
    L = Segment(Point(1, 0), Point(3, 0))
    collides(l, L)
end

@test begin
    l = Segment(Point(0, 0), Point(1, 1))
    L = Segment(Point(0, 1), Point(1, 0))
    collides(l, L)
end

@test begin
    l = Segment(Point(0, 0), Point(1, 1))
    collides(l, l)
end

# Box vs segment
@test begin
    b = Box(Point(0, 0), Point(1, 1))
    l = Segment(Point(2, 2), Point(3, 3))
    !collides(l, b)
end

@test begin
    b = Box(Point(0, 0), Point(1, 1))
    l = Segment(Point(1, 1), Point(3, 3))
    collides(l, b)
end

@test begin
    b = Box(Point(0, 0), Point(1, 1))
    l = Segment(Point(1, 1), Point(0, 1))
    collides(l, b)
end

@test begin
    b = Box(Point(0, 0), Point(1, 1))
    l = Segment(Point(1, 1), Point(0, 0))
    collides(l, b)
end

@test begin
    b = Box(Point(0, 0), Point(1, 1))
    l = Segment(Point(0.25, 0.25), Point(0.75, 0.75))
    collides(l, b)
end

# -------------------------------------------------------------------
# Both in
@test begin
    b = Box(Point(0, 0, 0), Point(1, 1, 1))
    l = Segment(Point(0.25, 0.25, 0.25), Point(0.75, 0.75, 0.75))
    collides(l, b)
end

# One in other out
@test begin
    b = Box(Point(0, 0, 0), Point(1, 1, 1))
    l = Segment(Point(0.5, 0.5, 0.5), Point(3, 3, 3))
    collides(l, b)
end

# # Both out but cross
# @test begin
#     b = Box(Point(0, 0, 0), Point(1, 1, 1))
#     l = Segment(Point(0.5, 0.5, -1), Point(0.5, 0.5, 3))
#     collides(l, b)
# end

# # Point collision
# @test begin
#     b = Box(Point(0, 0, 0), Point(1, 1, 1))
#     l = Segment(Point(1, 1, 1), Point(3, 3, 3))
#     collides(l, b)
# end

# # Entire segment collision
# @test begin
#     b = Box(Point(0, 0, 0), Point(1, 1, 1))
#     l = Segment(Point(0, 0, 0), Point(1, 0, 0))
#     collides(l, b)
# end

# # Both out
# @test begin
#     b = Box(Point(0, 0, 0), Point(1, 1, 1))
#     l = Segment(Point(2, 2, 2), Point(3, 3, 3))
#     !collides(l, b)
# end
