using Distributed

while nprocs() < 4
    addprocs(1)
end

@everywhere using JuliaDB
@everywhere using JuliaDBMeta
@everywhere using Statistics

const tbl = load("bin")

function popstateage(lower::Int64, upper::Int64, state::Int64)
    @applychunked tbl begin
        @where :ST == state &&
        !ismissing(:AGEP) &&
        upper >= :AGEP >= lower
        @groupby :ST {
            total = sum(:PWGTP),
            se = sqrt(4/80 * sum([(sum(column(_, Symbol("PWGTP$n"))) - sum(:PWGTP))^2 for n in 1:80])),
            lower = sum(:PWGTP) - 1.645 * sqrt(4/80 * sum([(sum(column(_, Symbol("PWGTP$n"))) - sum(:PWGTP))^2 for n in 1:80])),
            upper = sum(:PWGTP) + 1.645 * sqrt(4/80 * sum([(sum(column(_, Symbol("PWGTP$n"))) - sum(:PWGTP))^2 for n in 1:80]))
        }
    end
end

popstateage(20, 24, 12)
