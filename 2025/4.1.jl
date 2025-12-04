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

function number_of_accessible_rolls(I)
    K = centered(reshape([1, 1, 1, 1, 0, 1, 1, 1, 1], 3, 3))
    sum(I .* (ImageFiltering.imfilter(I, K, Fill(0)) .< 4))
end

rolls = read("inputs/4.sample.txt")
num_accessible_rolls = number_of_accessible_rolls(rolls)
println("Sample: ", num_accessible_rolls)

rolls = read("inputs/4.txt")
num_accessible_rolls = number_of_accessible_rolls(rolls)
println("Real: ", num_accessible_rolls)
