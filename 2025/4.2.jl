using ImageFiltering

function is_paper_roll(c)
    c == '@'
end

function read(path)
    lines = []
    open(path) do f
        while ! eof(f)
            push!(lines, [is_paper_roll(c) for c in readline(f)])
        end
    end
    stack(lines, dims=1)
end

function iterate_remove_rolls(I)
    K = centered(reshape([1, 1, 1, 1, 0, 1, 1, 1, 1], 3, 3))
    while true
        removable_rolls = I .* (ImageFiltering.imfilter(I, K, Fill(0)) .< 4)
        if sum(removable_rolls) == 0
            return I
        end
        I = I - removable_rolls
    end
    I
end

I = read("inputs/4.sample.txt")
J = iterate_remove_rolls(I)
num_removed_rolls = sum(I) - sum(J)
println("Sample: ", num_removed_rolls)

I = read("inputs/4.txt")
J = iterate_remove_rolls(I)
num_removed_rolls = sum(I) - sum(J)
println("Real: ", num_removed_rolls)
