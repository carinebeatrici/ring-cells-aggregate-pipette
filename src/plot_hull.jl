module Plot_hull

using Plots

export plot_hull
function plot_hull(points,hull)
    # Plotar all points and the convex hull
    #scatter([p[1] for p in points], [p[2] for p in points], label="Points", color=:blue, markersize=1)
    #plot!([p[1] for p in hull], [p[2] for p in hull], label="Convex hull", color=:red, linewidth=3, seriestype=:shape, alpha=0.2)         
    #The line below plots the hull points connected by lines    
    #plot([p[1] for p in hull], [p[2] for p in hull], label="Convex hull")# color=:red, linewidth=3, seriestype=:shape, alpha=0.2)                                              
    title!("Convex Hull")
    xlabel!("X")
    ylabel!("Y")
    #display(plot!())        
end

end
