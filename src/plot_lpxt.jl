module Plot_lpxt

using Plots
using Statistics

export plot_lpxt
function plot_lpxt(lp_cpu,time)
    title = "Evolution of cell length in pippete"
    title = " "
    xmax = ceil(Int,maximum(time))
    ymax = ceil(Int,maximum(lp_cpu))

    p2=scatter(time,lp_cpu,title=title, xlims=(0,xmax), ylims=(0,ymax),legend=false,
               xlabel = "t", ylabel = "Lp", markersize = 1)
    return p2
end

end 
