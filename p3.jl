using Plots
using JSON
include("./metodos.jl")
import .Metodos
include("./pvc.jl")
import .PVC

function delta_x_plot(delta_x, d_out::Dict)
    d_out["delta_x = $delta_x"] = Dict()
    N, x = Metodos.calc_nx(delta_x, PVC.L)

    d_out["delta_x = $delta_x"]["Solucao Analítica"] = Metodos.analytic_solution(N, x, PVC.fy)
    func = plot(x, d_out["delta_x = $delta_x"]["Solucao Analítica"], marker=:circle, label="S. Analítica")

    d_out["delta_x = $delta_x"]["Diferenças Finitas"] = Metodos.dif_finitas(delta_x, PVC, N)
    plot!(x, d_out["delta_x = $delta_x"]["Diferenças Finitas"], marker=:circle, label="Dif. Finitas", xlabel="Posição da Barra", ylabel="Temperatura")

    filename = string("pvc_deltaX_", delta_x, ".png")
    savefig(func, filename)
end

function main()
    d_out = Dict()

    delta_x_plot(2.0, d_out)
    delta_x_plot(1.0, d_out)
    delta_x_plot(0.5, d_out)
    delta_x_plot(0.25, d_out)

    fout = open("output.json", "w")
    JSON.print(fout, sort(d_out, rev=true), 2)
    close(fout)
end

main()