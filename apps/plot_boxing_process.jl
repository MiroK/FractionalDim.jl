# Here I demo how the box counting process works
using FractionalDim

using PyCall
@pyimport matplotlib.pyplot as plt

# Curves
include("../test/curves.jl")

# Use flake
fractal = koch_line(8);

function plot(fractal::Vector{Segment{2}}, color="k")
    x = map(segment -> segment.O[1], fractal)
    y = map(segment -> segment.O[2], fractal)
    push!(x, last(fractal).B[1])
    push!(y, last(fractal).B[2])
    plt.plot(x, y, "-"*color)
end

counter = BoxCounter(fractal)
sizes, counts = [], []
    
state = start(counter, 8)

level, count = 0, 1
rate = Inf
while !done(counter, state)

    plt.figure()
    # Background
    plot(fractal)
    # Boxes on where the intersect are computed on current level
    for boxes in counter.boxes
        for box in boxes
            for line in surface(box)
                plt.plot([line.O[1], line.B[1]], [line.O[2], line.B[2]], "b")
            end
        end
    end

    state = next(counter, state)
    size, count = last(state)
    push!(sizes, size)
    push!(counts, count)
        
    if length(sizes) > 1
        rate = -log(counts[end]/counts[end-1])/log(sizes[end]/sizes[end-1])
    end
    plt.xlim((-0.05, 1.05))
    plt.ylim((-0.05, 1.05))
    plt.axis("off")
    plt.title("$(count)/$(4^level) -> $(rate)")
    # plt.show()
    plt.savefig("./koch_$(level).png", bbox_inches="tight")
    level += 1
end

