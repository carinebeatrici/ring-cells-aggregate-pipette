module Plot_hull_and_normal

using Plots


export plot_hull_and_normal
function plot_hull_and_normal(hull_vec, vec_x, vec_y, output_images)
    scatter(hull_vec[:,1],hull_vec[:,2], label="Hull Points", color=:blue, aspect_ratio=:equal)
    # Plot the normal vectors    
    for i in 1:size(hull_vec, 1)
	# Starting point of the vector (hull point)
	x_start = hull_vec[i, 1]
        y_start = hull_vec[i, 2]
	# Ending point of the vector (hull point + normal vector) 
	x_end = x_start + vec_x[i]
        y_end = y_start + vec_y[i]
        # Plot the vector as an arrow 
        plot!([x_start, x_end], [y_start, y_end], arrow=true, label="", color=:red)
    end
    # Add labels and title   
    xlabel!("X")
    ylabel!("Y")
    #   title!("Hull Points and Normal Vectors")    
    # display(plot!())
    fig = "$(output_images)/" * "hull_normal" * ".png"
    savefig(fig)
    GC.gc()
end

end
