module Main_prog 

using CUDA

include("main_parameters.jl")
using .Main_parameters

include("total_rings_calc.jl")
using .Total_rings_calc

include("remaining_parameters.jl")
using .Remaining_parameters

include("saving_parameters.jl")
using .Saving_parameters

include("create_circular_rings_gpu.jl")
using .Create_circular_rings

include("read_saved_state_gpu.jl")
using .Read_saved_state

include("simulate_evolution_gpu.jl")
using .Simulate_evolution

export main

# Main function to set up and run the simulation
function main()
    # Setting environment variable to avoid GKS error on cluster
    ENV["GKSwstype"]="nul"
    # Reading simulation parameters from main_pars.txt
    main_pars = open("main_pars.txt","r")
    readline(main_pars) #Comment line, so ignored
    while !eof(main_pars)
        line = readline(main_pars)
        if isempty(split(line))
            println("End of input parameters file encountered.")
            close(main_pars)
            break
        else
            experiment_number = split(line)[2] #Experiment number
            n_circles_of_rings, particles_per_ring, total_time, external_pressure, box_lateral_size, dt, k, ka, R0, k_adhesion, k_core, pipette_width, p0, input_path, output_path, output_images, save_fig, continue_simu, Ndt  = main_parameters(main_pars)
            total_rings = total_rings_calc(n_circles_of_rings)

            println("Total number of rings = ", total_rings)
            total_particles = total_rings * particles_per_ring
            println("Total number of particles = ", total_particles)
            #println("Total number of external particles = ", N)
            #total_rings = 50 #you may change this directly  
            #Remaining parameters
            l_adhesion, ring_diameter, area_target, offset_x, offset_y, pipette_width, system_x_size, system_y_size, number_boxes_x, system_x_size, plot_limits_x, plot_limits_y, offset, pipette_up_position, pipette_down_position, delta_x, delta = remaining_parameters(R0, particles_per_ring, p0, n_circles_of_rings, pipette_width, box_lateral_size)
            # Saving simulation parameters
            lpxt = saving_parameters(n_circles_of_rings, total_rings, 
                particles_per_ring, total_time, external_pressure, 
                box_lateral_size, dt, k, ka, R0, l_adhesion, k_adhesion, 
                k_core, ring_diameter, pipette_width, p0, area_target, 
                input_path, output_path, Ndt)
            
            #decide if this is a continuation or a new simulation
            init_step = 0
            if continue_simu == 0
                # Create initial configuration in a circular grid of rings
                x_positions, y_positions, areas = create_circular_rings(
                    total_rings, particles_per_ring, ring_diameter, offset_x,
                    offset_y)
            else
                #reading system state to continue simulation
                time, x_positions, y_positions = read_saved_state(output_path)
                time = time + dt
                println("time ", time, " total_time =",total_time)
                if total_time <  time
                    println("Increase the final simulation time to continue")
                    exit()
                end
                init_step = floor(Int, time / dt)
                areas = CUDA.zeros(Float32, total_rings)
            end
            #Define wall position from max in x_positions
            wall_position = 1.1*ceil(Int,maximum(x_positions))
            #println("wall=", wall_position, " pip_up= ", pipette_up_position, pip_down= ", pipette_down_position)
            
            # Run simulation
            println("\n simulate evolution of experiment ", experiment_number)
            @time x_positions_cpu,y_positions_cpu, points, hull_vec, vec_x, vec_y, lp_cpu,time  = simulate_evolution!(x_positions, y_positions, areas, 
                total_rings, particles_per_ring, total_time, dt, k, R0, ka, 
                l_adhesion, k_adhesion, k_core, area_target, external_pressure, 
                number_boxes_x, box_lateral_size, plot_limits_x, plot_limits_y, 
                wall_position, pipette_up_position, pipette_down_position, delta_x, 
                delta,lpxt, input_path, output_path, output_images, init_step, 
                save_fig, Ndt)

            #plot_hull(points,hull)
            #println(hull[])
            #plot_hull_and_normal(hull_vec, vec_x, vec_y)
            #plot Lp x t  
            max_x = maximum(x_positions)
            #            if max_x > wall_position
            #p2=plot_lpxt(lp_cpu,time)          
                #display(p2)               
#            end           
            close(lpxt)
            println("Simulation of experiment number ",experiment_number," completed!")
            #readline()                   
            #savefig("$(output_path)/lpxt.png")  
        end
    end
end



end                
