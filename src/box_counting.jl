const Fractal{D} = Vector{Segment{D}}

"""Bounding CUBEoid of the fractal"""
function Box{D}(fractal::Fractal{D})
    X = Point((minimum(line.box.X[i] for line in fractal) for i in 1:D)...)
    Y = Point((maximum(line.box.Y[i] for line in fractal) for i in 1:D)...)
    dX = Y - X

    shift_size = 0.05*minimum(dX)
    shift = Point(tuple(shift_size*ones(D)...))
    # Shift both a bit not to have corner collisions
    X -= shift
    Y += shift
    dX = Y - X
    # Pick largest 
    dx = maximum(dX)
    # Smallest cuboid that contains it
    Y = X + dx*ones(D)
    
    return Box(X, Y)
end    

"""
Estimate the fractal dimension by succesively refining the bounding box
and counting on each level of refinement the number of intersecting boxes
"""
struct BoxCounter{D}
    # THe idea is to split the fractal into pieces
    fractal_pieces::Deque{Fractal{D}}
    # Which might collide with the boxes on this level
    boxes::Deque{Vector{Box{D}}}
    size::Float64  # size of the leaf box
    icount::Int    # segment count of fractal, just for printing
end

show{D}(io::IO, c::BoxCounter{D}) = begin
    print(io, "BoxCounter for curve with $(c.icount) pieces.")
end

"""BoxCounter for the fractal"""
function BoxCounter{D}(fractal::Fractal{D})
    icount = length(fractal)
    
    fractal_pieces = Deque{Fractal{D}}()
    boxes = Deque{Vector{Box{D}}}()
    # At the beginning there is one bounding box of fracal and
    # fractal is in one piece
    push!(fractal_pieces, fractal)

    box = Box(fractal)
    push!(boxes, [box])

    size = first(box.Y - box.X)

    BoxCounter{D}(fractal_pieces, boxes, size, icount)
end

# One box intersected. That box is bounding box
start{D}(c::BoxCounter{D}, nlevels::Int) = (nlevels, (2*c.size, 1))

"""
The iterator state is the (level of refinment,
                           (size of bbox on this level,
                            count of intersected boxes))
"""
function next{D}(c::BoxCounter{D}, state)
    
    level, (size, count) = state
    @assert length(c.boxes) == length(c.fractal_pieces)
    
    count *= 0
    for i in 1:length(c.boxes)
        box = shift!(c.boxes)
        fractal_piece = shift!(c.fractal_pieces)

        for b in box
            b_piece = Fractal{D}()
            # Let's get segments of the piece that can collide with box
            for fj in fractal_piece
                bbox_collides(fj.box, b) && push!(b_piece, fj)
            end
            # See that there really is an intersect
            for fi in b_piece
                if collides(fi, b)
                    count += 1 
                    push!(c.boxes, split(b))
                    push!(c.fractal_pieces, b_piece)
                    break
                end
            end
        end
    end
    size /= 2
    level -= 1 
    (level, (size, count))
end

done{D}(c::BoxCounter{D}, state) = first(state) < 0

# -------------------------------------------------------------------

# This is a non-iterator version of the above
function fractal_dimension{D}(fractal::Fractal{D}, terminate::Function)
    fractal_pieces = Deque{Fractal{D}}()
    boxes = Deque{Vector{Box{D}}}()
    # At the beginning there is one bounding box of fracal and
    # fractal is in one piece
    push!(fractal_pieces, fractal)

    box = Box(fractal)
    push!(boxes, [box])

    size = first(box.Y - box.X)
    level = 0
    
    while !terminate(level, size)
        # Intersect on this level
        count = 0
        @assert length(boxes) == length(fractal_pieces)
        for i in 1:length(boxes)
            box = shift!(boxes)
            fractal_piece = shift!(fractal_pieces)

            for b in box
                indices = IntSet(1:length(fractal_piece))
                # Let's get the segments of the piece that can collide with
                # the box
                for (j, fj) in enumerate(fractal_piece)
                    !bbox_collides(fj.box, b) && delete!(indices, j)
                end
                # See that there really is an intersect
                b_piece = fractal_piece[collect(indices)]
                for fi in b_piece
                    if collides(fi, b)
                        count +=1 
                        push!(boxes, split(b))
                        # Split box will have to deal with only part
                        push!(fractal_pieces, b_piece)
                        break
                    end
                end
            end
        end
        @show size, count
        size /= 2
        level += 1
    end
end
