# FractionalDim

[![Build Status](https://travis-ci.org/mirok/FractionalDim.jl.svg?branch=master)](https://travis-ci.org/mirok/FractionalDim.jl)

This package implements a [box counting](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0041148) algorithm
for computing approximate fractional dimension of curves. The main objective is to compute
dimension of certain structures which are represented as `1d` in `3d` meshes (in FEniCS). A by product
of this effort is box counting for collection of segments. Animation below shows the process
for an approximation to the Koch curve.

<p align="center">
  <img src="https://github.com/MiroK/FractionalDim.jl/blob/master/apps/koch.gif">
</p>


## Warning
This is a learning project. In particular, I am sure the code can be made
to run faster if one knows more `Julia`.




