module FractionalDim

using StaticArrays
using DataStructures

import Base: in, split, start, next, done

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


struct Segment{D}
    O::Point{D}   # O + s * t is the segment; 0 <= s <= 1
    B::Point{D}
    t::Point{D}
    
    length
    
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

# Eval the curve using (0, 1) parametrization
(line::Segment)(s::Number) = line.O + s*line.length*line.t

struct Triangle{D}
    O::Point{D}     # O + s1*t1 + s2*t2 is the triangle; 0 <= s1 + s2 <= 1
    t1::Point{D}
    t2::Point{D}
    normal::Point{3}

    area
    
    box::Box{D}
end

#######################
# Geometry & collisions
#######################
# 
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
