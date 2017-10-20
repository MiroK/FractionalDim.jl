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

@test begin
    s = Box(Point(0, 0, 0), Point(1, 1, 1))
    p = Point(0.5, 0.5, 0.5)
    
    p ∈ s
end

@test begin
    s = Box(Point(0, 0, 0), Point(1, 1, 1))
    p = Point(1, 1, 1)
    
    p ∈ s
end

@test begin
    s = Box(Point(0, 0, 0), Point(1, 1, 1))
    p = Point(1, 0.5, 1)
    
    p ∈ s
end

@test begin
    s = Box(Point(0, 0, 0), Point(1, 1, 1))
    p = Point(3, 0.5, 0.5)
    
    p ∉ s
end
