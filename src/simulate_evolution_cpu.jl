module Simulate_evolution

using Printf

include("convex_hull.jl")
using .Convex_hull

include("particle_neighbors_cpu.jl")
using .Particle_neighbors

include("add_neighbors_to_hull_cpu.jl")
using .Add_neighbors_to_hull

include("extract_hull_elements_cpu.jl")
using .Extract_hull_elements_cpu

include("external_pressure_vectors_cpu.jl")
using .External_pressure_vectors

include("find_hull_index_cpu.jl")
using .Find_hull_index

include("define_arrays_cpu.jl")
using .Define_arrays

include("define_box_around_cpu.jl")
using .Define_box_around

include("update_positions_cpu.jl")
using .Update_positions

include("plot_particles.jl")
using .Plot_particles

include("save_state.jl")
using .Save_state

export simulate_evolution!
function simulate_evolution!(x_positions, y_positions, areas, total_rings,
            particles_per_ring, total_time, dt, k, R0, ka, l_adhesion,
            k_adhesion, k_core, area_target, external_pressure, number_boxes_x,
            box_lateral_size, plot_limits_x, plot_limits_y, wall_position,
            pipette_up_position, pipette_down_position, delta_x, delta,lpxt,
            input_path, output_path, output_images, init_step, save_fig, Ndt)
    num_steps = round(Int, total_time / dt)
    total_particles = total_rings * particles_per_ring

    box_around, force_area_modulus, force_particle_x, force_particle_y, areas, particle_box_index, matrix_list_particles, counter,  ring_particle_is_from, num_neighbors = define_arrays(total_particles, total_rings, number_boxes_x, particles_per_ring, box_lateral_size, area_target)
    
    # defining vectors out of the loop, julia does not like definitions inside loops  

    points = [ [x_positions[i],y_positions[i], i] for i in 1:length(x_positions) ]
    hull = convex_hull(points)

    num_boxes = number_boxes_x^2

    particle_neighbors(total_particles, x_positions, y_positions,
                       matrix_list_particles, num_boxes, box_around, counter,
                       ring_particle_is_from, R0, l_adhesion,
                       particles_per_ring, num_neighbors)


    N = length(hull)
    hull = add_neighbors_to_hull(hull, N,
                                   total_particles, x_positions, y_positions,
                                   particles_per_ring, num_neighbors)
    
    centroide, hull_vec, indices = extract_hull_elements_cpu(hull)
    lp_cpu = []
    time = []
    t0 = 0
    x0 = 0.
        
    #the size of the hull points on the gpu is defined on the fly         
    N = Int(length(hull_vec)/2)

    normal_vectors_x = zeros(N)
    normal_vectors_y = zeros(N)
    external_pressure_vectors(normal_vectors_x, normal_vectors_y, hull_vec,
                              centroide, N)
    
    # indices          = zeros(Int, N)
    # find_hull_index(hull_vec, x_positions, y_positions, indices,
    #                     total_particles, N)

    external_pressure_on="False"

    
    tprint = 0
    title = @sprintf("t%5d",tprint) #Particle Configurat  

    

    define_box_around(box_around, num_boxes, number_boxes_x)

    next_measure_step             = 1
    init_measure_step             = 0
    steps_to_calculate_hull       = 1
    total_steps_to_calculate_hull = 100*steps_to_calculate_hull
    #Evolution loop
    for step in init_step:num_steps
        update_positions!(x_positions, y_positions, areas, total_rings,
                  particles_per_ring, dt, k, R0, ka, l_adhesion, k_adhesion,
                  k_core,  number_boxes_x,  box_lateral_size, area_target,
                  box_around, force_area_modulus, force_particle_x,
                  force_particle_y, particle_box_index, matrix_list_particles,
                  counter,  ring_particle_is_from, total_particles, hull_vec,
                  normal_vectors_x, normal_vectors_y, indices, external_pressure,
                  external_pressure_on, wall_position, pipette_up_position,
                          pipette_down_position, delta_x, delta, step, num_neighbors)
        
        if (step % steps_to_calculate_hull == 0 &&
        step >= total_steps_to_calculate_hull) # find particles in the contour to be pressed at each 10 steps        
            if external_pressure_on == "False"
                println("Starting external force")
                external_pressure_on="True"
            end
            points = [[x_positions[i],y_positions[i], i] for i in 1:length(x_positions)]
            hull = convex_hull(points)

            particle_neighbors(total_particles, x_positions, y_positions,
                       matrix_list_particles, num_boxes, box_around, counter,
                       ring_particle_is_from, R0, l_adhesion,
                       particles_per_ring, num_neighbors)


            N = length(hull)
            hull = add_neighbors_to_hull(hull, N,
                                  total_particles, x_positions, y_positions,
                                  particles_per_ring, num_neighbors)
            
            centroide, hull_vec, indices = extract_hull_elements_cpu(hull)

            #the size of the hull points on the gpu is defined on the fly    
            N = Int(length(hull_vec)/2)

            #println("hull_calculated")
            normal_vectors_x = zeros(N)
            normal_vectors_y = zeros(N)
            external_pressure_vectors(normal_vectors_x, normal_vectors_y,
                                      hull_vec, centroide, N)

            #indices = zeros(Int, N)
            #find_hull_index(hull_vec, x_positions, y_positions, indices,
            #                    total_particles,N)

        end
        max_x = maximum(x_positions)
        if max_x < wall_position
            t0 = step * dt
            x0 = max_x
        end

        # ######## Printing measures for more initial time steps ######   
        if  next_measure_step < Ndt
            if (step - init_measure_step) >= next_measure_step
                #saving Lp and time    
                #println(max_x-wall_position)    
                #print(step, " ",init_measure_step , " \n")    
                #print(max_x, " ", wall_position, "\n")    
                if max_x > wall_position
                    if init_measure_step < 1
                        init_measure_step = step
                        next_measure_step = 1
                    else
                        next_measure_step += 10^(trunc(Int, log10(step - init_measure_step)))
                    end
                    push!(lp_cpu,max_x-x0)
                    push!(time,step*dt-t0)
                    println(lpxt,time[end]," ",lp_cpu[end])
                    flush(lpxt)
                end
            end
        elseif (step-init_measure_step) % Ndt == 0
            #saving Lp and time  
            #println(max_x-wall_position)  
            if max_x > wall_position
                push!(lp_cpu,max_x-x0)
                push!(time,step*dt-t0)
                println(lpxt,time[end]," ",lp_cpu[end])
                flush(lpxt)
            end
        end
        # Print Snapshot     
        if step % Ndt == 0
            tprint = floor(Int, (step/(Ndt)))
            title = @sprintf("t%05d",tprint) #Particle Configuration at t = $(step * dt)"
            plot_particles(x_positions, y_positions, total_rings, particles_per_ring, plot_limits_x, plot_limits_y, title ,box_lateral_size, hull_vec, normal_vectors_x, normal_vectors_y, wall_position, pipette_up_position, pipette_down_position, output_images, save_fig, force_particle_x, force_particle_y)
            #sleep(2.0)   
        end
        # Save State            
        if step % Ndt == 0
            save_state(step*dt, x_positions, y_positions, output_path)
        end
    end
    return x_positions, y_positions, points, hull_vec, normal_vectors_x, normal_vectors_y, lp_cpu, time
end
end
