using FractionalDim
using LightXML


function read_xml_mesh(mesh::AbstractString)::Vector{Segment{3}}
    xroot = root(parse_file(mesh))
    mesh = first(child_elements(xroot))
    @assert attribute(mesh, "celltype") == "interval"
    
    dim = parse(attribute(mesh, "dim"))
    
    nodes, cells, _ = child_elements(mesh)

    nnodes = parse(attribute(nodes, "size"))
    X = zeros((dim, nnodes))

    get_coords = if dim == 2
        (e, col) -> begin
            X[dim*col + 1] = parse(attribute(e, "x"))
            X[dim*col + 2] = parse(attribute(e, "y"))
        end
    else
        (e, col) -> begin
            X[dim*col + 1] = parse(attribute(e, "x"))
            X[dim*col + 2] = parse(attribute(e, "y"))
            X[dim*col + 3] = parse(attribute(e, "z"))
        end
    end

    col = 0
    for node in child_elements(nodes)
        get_coords(node, col)
        col += 1
    end

    segments = Vector{Segment{dim}}()
    for cell in child_elements(cells)
        v0 = X[:, parse(attribute(cell, "v0")) + 1]
        v1 = X[:, parse(attribute(cell, "v1")) + 1]
        
        push!(segments, Segment{dim}(Point{dim}(v0), Point{dim}(v1)))
    end
    segments
end

# Read
maybe_fractal = read_xml_mesh("vasc_mesh.xml");

# And now estimate the dimension
counter = BoxCounter(maybe_fractal)
sizes, counts = Vector{Float64}(), Vector{Int}()
    
state = start(counter, 16)

rate, rate_lsq = Inf, Inf
while !done(counter, state)
    state = next(counter, state)
    size, count = last(state)
    push!(sizes, size)
    push!(counts, count)
        
    if length(sizes) > 1
        rate = -log(counts[end]/counts[end-1])/log(sizes[end]/sizes[end-1])
    end
    
    println((size, count, rate))
    writedlm("vasc_mesh_FD.txt", [sizes counts])
end


