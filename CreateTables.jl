using JuliaDB

const vars = [:ST, :AGEP, :PWGTP]
const compweights = [Symbol("PWGTP$n") for n in 1:80]
const datacols = vcat(vars, compweights)

loadtable(glob("*.csv", "src_data/"), output="bin", datacols = datacols, type_detect_rows = 2000, chunks = 4)
