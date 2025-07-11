module Plot_particles

using Plots

export plot_particles
    function plot_particles(x_positions_cpu, y_positions_cpu, total_rings,
                            particles_per_ring, plot_limits_x, plot_limits_y,
                            title, box_lateral_size, hull_vec, vec_x, vec_y,
                            wall_position, pipette_up_position,
                            pipette_down_position, output_images,
                            save_fig, force_particle_x, force_particle_y)
        dy = 0.5
        N = total_rings*particles_per_ring
        x_ticks = collect(0:plot_limits_x/10:plot_limits_x)
        y_ticks = collect(0:plot_limits_y/10:plot_limits_y)
        x = x_positions_cpu
        y = y_positions_cpu
        p = plot(aspect_ratio=:equal, title=title, legend=false, xlim=(0,
                 plot_limits_x), ylim=(0, plot_limits_y), grid=true,
                 xticks=x_ticks,yticks=y_ticks)
        # Define a list of colors for the rings      
        colors = [:blue, :red, :green, :purple, :orange, :brown, :pink, :gray, :cyan, :magenta]
        # Plotting the rings
        for ring in 1:total_rings
            start_idx = (ring - 1) * particles_per_ring + 1
            end_idx = ring * particles_per_ring
            # Extract the x and y positions for the current ring     
            x_ring = x_positions_cpu[start_idx:end_idx]
            y_ring = y_positions_cpu[start_idx:end_idx]
            # Append the first particle to the end to close the ring      
            x_ring_closed = vcat(x_ring, x_ring[1])
            y_ring_closed = vcat(y_ring, y_ring[1])
            # Get the color for the current ring                       
            ring_color = colors[mod1(ring,length(colors))]
            # Plot the particles and the connecting lines   
            scatter!(x_ring, y_ring, markersize=0.1, markercolor=:blue,
                     markerstrokewidth=0)
            plot!(x_ring_closed, y_ring_closed, linecolor=ring_color)
            # for j in start_idx:end_idx  
            #     annotate!(x_positions_cpu[j], y_positions_cpu[j]+dy, text(string(j), :center, font(3)))  
            # end 
        end
        # Plotting the hull external particles
        # scatter!(hull_vec[:,1],hull_vec[:,2], label="Hull Points", color=:blue,
        #          aspect_ratio=:equal)
        # Plot the pressure normal vectors
        # for i in 1:size(hull_vec, 1)             
        #     # Starting point of the vector (hull point)         
        #     x_start = hull_vec[i, 1] - (particles_per_ring/2)*vec_x[i]
        #     y_start = hull_vec[i, 2] - (particles_per_ring/2)*vec_y[i]
        #     # Ending point of the vector (hull point + normal vector)     
        #     x_end = hull_vec[i, 1]          
        #     y_end = hull_vec[i, 2]                 
        #     # Plot the vector as an arrow         
        #     plot!([x_start, x_end], [y_start, y_end], arrow=false,
        #           label="", color=:red) 
        # end

        # # plot the forces
        #     for particle in 1:total_rings * particles_per_ring
        #         x_start = x_positions_cpu[particle]
        #         y_start = y_positions_cpu[particle]
        
        #         x_end   = x_positions_cpu[particle] + force_particle_x[particle]
        #         y_end   = y_positions_cpu[particle] + force_particle_y[particle]
        #     plot!([x_start, x_end], [y_start, y_end], arrow=false, label="", color=:green)
        # end
        
        #Plot the wall and the pipette lines    
        wall_sup_x = [wall_position,wall_position]
        wall_inf_x = [wall_position,wall_position]
        wall_sup_y = [pipette_up_position, plot_limits_y]
        wall_inf_y = [pipette_down_position, 0]
        pipette_up_line_x = [wall_position,plot_limits_x]
        pipette_down_line_x = [wall_position,plot_limits_x]
        pipette_up_line_y = [pipette_up_position, pipette_up_position]
        pipette_down_line_y = [pipette_down_position, pipette_down_position]
        plot!(wall_sup_x,wall_sup_y, linecolor=:black)
        plot!(wall_inf_x,wall_inf_y, linecolor=:black)
        plot!(pipette_up_line_x,pipette_up_line_y , linecolor=:black)
        plot!(pipette_down_line_x,pipette_down_line_y , linecolor=:black)
        #display(p)  
        fig = "$(output_images)/" * title * ".png"
        if save_fig == 1
            savefig(fig)
            GC.gc()
        end
    end
end
