struct BoxCounter{D}
    fractal::Vector{Segment{D}}
    final_box_size
end

const BoxCounterState{D} = Tuple{Float64, Int, Vector{Box{D}}}

BoxCounter{D}(fractal::Vector{Segment{D}}) = BoxCounter{D}(fractal, 0.)

function start{D}(counter::BoxCounter{D})::BoxCounterState{D}
    X = Point((minimum(line.box.X[i] for line in counter.fractal)
               for i in 1:D)...)
    
    Y = Point((maximum(line.box.Y[i] for line in counter.fractal)
               for i in 1:D)...)

    dims = Y - X
    size = reduce(*, dims)^(1./length(dims))
    # The state is current box size, Number of hit boxes, boxes for next round
    (size, 1, [Box(X, Y)])
end

function next{D}(counter::BoxCounter{D}, state::BoxCounterState{D})::BoxCounterState{D}

    size, _, old_boxes = state

    count = 0
    new_boxes = Vector{Box{D}}()
    # Loop over current generation
    for box in old_boxes
        # Box is intesected by any segment
        for line in counter.fractal
            if collides(line, box)
                count += 1
                # Childen will be visitid in the next round
                for child in split(box)
                    push!(new_boxes, child)
                end
                break
            end
        end
    end
    (size/2, count, new_boxes)
end

function done{D}(counter::BoxCounter{D}, state::BoxCounterState{D})
    first(state) < counter.final_box_size
end
