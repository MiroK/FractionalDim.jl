module FractionalDim

using StaticArrays
using DataStructures

import Base: in, split, start, next, done, show, ==

export Point, Segment, Triangle, Box
export bbox_collides, collides, surface
export BoxCounter

# The precision for making comparisons
const EPS = 1E-13

# Primitives
const Point = SVector

"""Bounding box"""
struct Box{D}
    X::Point{D} # low bdry
    Y::Point{D} # up bdry

    function Box{D}(X::Point{D}, Y::Point{D})
        @assert all(X[i] <= Y[i] for i in 1:D)
        new(X, Y)
    end
end

Box(X::Point{2}, Y::Point{2}) = Box{2}(X, Y)
Box(X::Point{3}, Y::Point{3}) = Box{3}(X, Y)

show{D}(io::IO, b::Box{D}) = print(io, "$(b.X)-$(b.Y)")

=={D}(a::Box{D}, b::Box{D}) = norm(a.X-b.X) < EPS && norm(a.Y-b.Y) < EPS

"""A segment connecting two point in R^d"""
struct Segment{D}
    # O + length * s * t is the segment; 0 <= s <= 1
    O::Point{D}   
    B::Point{D}
    t::Point{D}
    # Handy for parametrization
    length
    # Bounxing box of the segment, for collisions
    box::Box{D}

    function Segment{D}(A::Point{D}, B::Point{D})
        t = B - A
        L = norm(t)
        @assert L > EPS

        X = Point((min(A[i], B[i]) for i in 1:D)...)
        Y = Point((max(A[i], B[i]) for i in 1:D)...)

        new(A, B, normalize(t), L, Box(X, Y))
    end
end

Segment(X::Point{2}, Y::Point{2}) = Segment{2}(X, Y)
Segment(X::Point{3}, Y::Point{3}) = Segment{3}(X, Y)

show{D}(io::IO, b::Segment{D}) = print(io, "$(b.O)-$(b.B)")

# Eval the curve using (0, 1) parametrization
(line::Segment)(s::Number) = line.O + s*line.length*line.t

=={D}(a::Segment{D}, b::Segment{D}) = norm(a.O-b.O) < EPS && norm(a.B-b.B) < EPS

#######################
# Geometry & collisions
#######################
include("geometry.jl")

# Collisions in gdim = 2
include("collisions2d.jl")

# Collisions in gdim = 3
include("collisions3d.jl")

##############
# Box counting
##############
include("box_counting.jl")

end # module
