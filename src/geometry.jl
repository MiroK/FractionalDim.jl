# FIXME
function Triangle(A::Point{2}, B::Point{2}, C::Point{2})
    t1 = B - A
    t2 = C - A
    area = 0.5*norm(cross(t1, t2))
    @assert area > EPS

    normal = Point(0, 0, area)

    X = Point((min(A[i], B[i], C[i]) for i in 1:2)...)
    Y = Point((max(A[i], B[i], C[i]) for i in 1:2)...)

    Triangle{2}(A, t1, t2, normal, area, Box(X, Y))
end

# FIXME
function Triangle(A::Point{3}, B::Point{3}, C::Point{3})
    t1 = B - A
    t2 = C - A
    normal = cross(t1, t2)
    area = 0.5*norm(normal)
    @assert area > EPS

    X = Point((min(A[i], B[i], C[i]) for i in 1:3)...)
    Y = Point((max(A[i], B[i], C[i]) for i in 1:3)...)

    Triangle{3}(A, t1, t2, normal, area, Box(X, Y))
end

"""
Dimless collision between bounding boxes. NOTE: if they don't collide 
then object don't.
"""
function bbox_collides{D}(b::Box{D}, B::Box{D})
    !any((b.Y[i] + EPS < B.X[i] || B.Y[i] < b.X[i] - EPS) for i in 1:D)
end

# Generate bbox collisions for other objects
for typeb in (:Segment, :Triangle, :Box)
    for typeB in (:Segment, :Triangle, :Box)
        if !(typeb == :Box && typeB == :Box)

            @eval begin
                function bbox_collides{D}(b::$(typeb){D}, B::$(typeB){D})
                    bbox_collides(b.box, B.box)
                end
            end
        end
    end
end

# Collision of point and segment is dimless
"""Is point contained in the segment"""
function in{D}(p::Point{D}, line::Segment{D})
    t = dot(p - line.O, line.t)/line.length
    -EPS < t < 1 + EPS
end

"""Is point contained in the box"""
function in{D}(p::Point{D}, box::Box{D})
    all(box.X[i] - EPS < p[i] < box.Y[i] + EPS for i in 1:D)
end
