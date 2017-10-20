@test begin
    b0 = Box(Point(0, 0), Point(1, 1))
    b1 = Box(Point(2, 0), Point(3, 2))

    !bbox_collides(b0, b1)
end

@test begin
    b0 = Box(Point(0, 0), Point(1, 1))
    b1 = Box(Point(1, 0), Point(2, 1))

    bbox_collides(b0, b1)
end

@test begin
    b0 = Box(Point(0, 0), Point(1, 1))
    b1 = Box(Point(0.75, 0.25), Point(1.25, 0.75))

    bbox_collides(b0, b1)
end

@test begin
    b0 = Box(Point(0, 0), Point(1, 1))
    b1 = Box(Point(1, 1), Point(2, 2))

    bbox_collides(b0, b1)
end

# 3d stuff
@test begin
    b0 = Box(Point(0, 0, 0), Point(1, 1, 1))
    b1 = Box(Point(2, 0, 0), Point(3, 1, 1))
    !bbox_collides(b0, b1)
end

@test begin
    b0 = Box(Point(0, 0, 0), Point(1, 1, 1))
    b1 = Box(Point(1, 0, 0), Point(2, 1, 1))
    bbox_collides(b0, b1)
end

@test begin
    b0 = Box(Point(0, 0, 0), Point(1, 1, 1))
    b1 = Box(Point(1, 1, 1), Point(2, 2, 2))
    bbox_collides(b0, b1)
end

@test begin
    b0 = Box(Point(0, 0, 0), Point(1, 1, 1))
    b1 = Box(Point(0.25, 0.25, 0.25), Point(0.75, 0.75, 0.75))
    bbox_collides(b0, b1)
end

@test begin
    b0 = Box(Point(0, 0, 0), Point(1, 1, 1))
    b1 = Box(Point(0.5, 0, 0), Point(1.5, 1, 1))
    bbox_collides(b0, b1)
end
