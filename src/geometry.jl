"""
Dimless collision between bounding boxes. NOTE: if they don't collide 
then object don't.
"""
function bbox_collides{D}(b::Box{D}, B::Box{D})
    !any((b.Y[i] + EPS < B.X[i] || B.Y[i] < b.X[i] - EPS) for i in 1:D)
end

# Generate bbox collisions for other objects
for typeb in (:Segment, :Box)
    for typeB in (:Segment, :Box)
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
