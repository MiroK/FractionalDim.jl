const Fractal{D} = Vector{Segment{D}}

# Bounding box of fractal, (a hypercube)
function Box{D}(fractal::Fractal{D})
    X = Point((minimum(line.box.X[i] for line in fractal) for i in 1:D)...)
    Y = Point((maximum(line.box.Y[i] for line in fractal) for i in 1:D)...)
    dX = Y - X
    # Pick largest 
    dx = maximum(dX)
    # Smallest cuboid that contains it
    Y = X + dx*ones(D)
    
    return Box(X, Y)
end    

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
                #
                b_piece = fractal_piece[collect(indices)]
                for fi in fractal_piece
                    if collides(fi, b)
                        count +=1 
                        push!(boxes, split(b))
                        break
                    end
                end
                # Split box will have to deal with only part
                push!(fractal_pieces, b_piece)
            end
        end
        @show count, size
        
        size /= 2
        level += 1
    end
end
