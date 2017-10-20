# Check here that bbox counting gets approx the right dims
include("curves.jl")

# Diagonal of one piece
@test begin
    c = [Segment(Point(0, 0), Point(1, 1))]

    counter = BoxCounter(c)
    sizes, counts = [], []
    
    state = start(counter, 13)

    rate = Inf
    while !done(counter, state)
        state = next(counter, state)
        size, count = last(state)
        push!(sizes, size)
        push!(counts, count)
        
        if length(sizes) > 1
            rate = -log(counts[end]/counts[end-1])/log(sizes[end]/sizes[end-1])
        end
        # println((size, count, rate))       
    end
    abs(rate - 1) < 1E-3
end

# Diagonal of more pieces
@test begin
    x = collect(linspace(0, 1, 10000))
    c = [Segment(Point(x[i], x[i]), Point(x[i+1], x[i+1])) for i in 1:length(x)-1]

    counter = BoxCounter(c)
    sizes, counts = [], []
    
    state = start(counter, 13)

    rate = Inf
    while !done(counter, state)
        state = next(counter, state)
        size, count = last(state)
        push!(sizes, size)
        push!(counts, count)
        
        if length(sizes) > 1
            rate = -log(counts[end]/counts[end-1])/log(sizes[end]/sizes[end-1])
        end
        # println((size, count, rate))       
    end
    abs(rate - 1) < 1E-3
end

# Circle
@test begin
    c = unit_circle(10000)

    counter = BoxCounter(c)
    sizes, counts = [], []
    
    state = start(counter, 13)

    rate = Inf
    while !done(counter, state)
        state = next(counter, state)
        size, count = last(state)
        push!(sizes, size)
        push!(counts, count)
        
        if length(sizes) > 1
            rate = -log(counts[end]/counts[end-1])/log(sizes[end]/sizes[end-1])
        end
        # println((size, count, rate))       
    end
    abs(rate - 1) < 1E-3
end

# Koch
@test begin
    c = koch_flake(9)

    counter = BoxCounter(c)
    sizes, counts, rates = [], [], []
    
    state = start(counter, 13)
    
    rate = Inf
    while !done(counter, state)
        state = next(counter, state)
        size, count = last(state)
        push!(sizes, size)
        push!(counts, count)
        
        if length(sizes) > 1
            rate = -log(counts[end]/counts[end-1])/log(sizes[end]/sizes[end-1])
            push!(rates, rate)
        end
        # println((size, count, rate))       
    end
    approx = mean(rates[end-5:end])
    exact = log(4)/log(3)
    @show (approx, exact)
    abs(approx - exact) < 1E-2
end


@test begin
    c = koch_quadratic_1(8)

    counter = BoxCounter(c)
    sizes, counts, rates = [], [], []
    
    state = start(counter, 13)
    
    rate = Inf
    while !done(counter, state)
        state = next(counter, state)
        size, count = last(state)
        push!(sizes, size)
        push!(counts, count)
        
        if length(sizes) > 1
            rate = -log(counts[end]/counts[end-1])/log(sizes[end]/sizes[end-1])
            push!(rates, rate)
        end
        # println((size, count, rate))       
    end
    approx = mean(rates[end-5:end])
    exact = log(5)/log(3)
    @show (approx, exact)
    abs(approx - exact) < 1E-2
end

@test begin
    c = koch_quadratic_2(7)

    counter = BoxCounter(c)
    sizes, counts, rates = [], [], []
    
    state = start(counter, 10)
    
    rate = Inf
    while !done(counter, state)
        state = next(counter, state)
        size, count = last(state)
        push!(sizes, size)
        push!(counts, count)
        
        if length(sizes) > 1
            rate = -log(counts[end]/counts[end-1])/log(sizes[end]/sizes[end-1])
            push!(rates, rate)
        end
        # println((size, count, rate))       
    end
    approx = round(mean(rates[end-3:end]), 2) 
    exact = 1.5
    @show (approx, exact)
    approx == exact
end

@test begin
    c = dragon_curve(17)

    counter = BoxCounter(c)
    sizes, counts, rates = [], [], []
    
    state = start(counter, 13)
    
    rate = Inf
    while !done(counter, state)
        state = next(counter, state)
        size, count = last(state)
        push!(sizes, size)
        push!(counts, count)
        
        if length(sizes) > 1
            rate = -log(counts[end]/counts[end-1])/log(sizes[end]/sizes[end-1])
            push!(rates, rate)
        end
        # println((size, count, rate))       
    end
    approx = mean(rates[end-5:end])
    exact = 1.5236270
    @show (approx, exact)
    abs(approx - exact) < 1E-2
end
