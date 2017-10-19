# Box first
@test begin
    p = Point(0.5, 0.5)
    s = Box(Point(0, 0), Point(1, 1))

    p ∈ s
end

@test begin
    p = Point(0.0, 0.5)
    s = Box(Point(0, 0), Point(1, 1))

    p ∈ s
end

@test begin
    p = Point(-1E-10, 0.5)
    s = Box(Point(0, 0), Point(1, 1))

    p ∉ s
end
