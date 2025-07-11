module Update_positions

include("calculate_areas_direct_cpu.jl") 
using .Calculate_areas_direct

include("calculate_internal_forces_and_particle_boxes_cpu.jl") 
using .Calculate_internal_forces_and_particle_boxes

include("compute_number_of_particles_in_boxes_and_matrix_list_cpu.jl") 
using .Compute_number_of_particles_in_boxes_and_matrix_list

include("forces_between_particles_in_neighbor_boxes_cpu.jl") 
using .Forces_between_particles_in_neighbor_boxes

include("external_pressure_forces_cpu.jl") 
using .External_pressure_forces

include("wall_and_pipette_repulsion_cpu.jl") 
using .Wall_and_pipette_repulsion

include("new_position_initial_cpu.jl") 
using .New_position_initial

include("new_positions_cpu.jl") 
using .New_positions


export update_positions!

function update_positions!(x_positions, y_positions, areas, total_rings,
particles_per_ring, dt, k, R0, ka, l_adhesion,  k_adhesion, k_core,
number_boxes_x,  box_lateral_size, area_target, box_around,
force_area_modulus, force_particle_x, force_particle_y,
particle_box_index, matrix_list_particles, counter,
ring_particle_is_from, total_particles, hull_vec, normal_vectors_x,
normal_vectors_y, indices, external_pressure, external_pressure_on,
wall_position, pipette_up_position, pipette_down_position, delta_x,
delta, step, num_neighbors)
    num_boxes=number_boxes_x^2

    # Numero de particulas externas  
    N = Int(length(hull_vec)/2)

    calculate_areas_direct!(x_positions, y_positions, total_particles,
                                                        particles_per_ring, areas)

    calculate_internal_forces_and_particle_boxes!(x_positions, y_positions,
                     areas, force_area_modulus, force_particle_x, force_particle_y,
                     particle_box_index, number_boxes_x, box_lateral_size, k, R0,
                     ka, area_target, total_particles, particles_per_ring)

    # Compute the number of particles in each box and construct a matrix of boxes with the list of particles in each  
    compute_number_of_particles_in_boxes_and_matrix_list(particle_box_index,
                          counter, matrix_list_particles, num_boxes, total_particles)

    forces_between_particles_in_neighbor_boxes(force_particle_x, force_particle_y, x_positions, y_positions, matrix_list_particles, num_boxes, box_around, counter, ring_particle_is_from, R0, l_adhesion,  k_adhesion, k_core, particles_per_ring, num_neighbors)
    if external_pressure_on == "True"
        external_pressure_forces(x_positions,
                             y_positions, force_particle_x, force_particle_y,
                             normal_vectors_x, normal_vectors_y, indices,
                             external_pressure, N, wall_position,
                             pipette_up_position ,pipette_down_position)
    end

    wall_and_pipette_repulsion(force_particle_x, force_particle_y, x_positions, y_positions, total_particles,R0, k_core, wall_position, pipette_up_position, pipette_down_position)

    max_x = -1.0
   try
        max_x = maximum(x_positions)
    catch e
       #       println()    
       println(" ====================================== ")
       println("positions length = ", length(x_positions))
       #println(x_positions)                                                                            
       println(" ====================================== ")
       println("N: ",N, " ", blocks_external_part, " ", blocks_external_part * threads,
                " particulas: ", total_particles, " ", blocks_particles,
                " ", blocks_particles   * threads,
                " boxes: ", num_boxes, " ", blocks_boxes, " ", blocks_boxes * threads)
        # throw(error())                                                 
        exit()
    end
    # if  step % 1000 == 0 # || max_x > wall_position  
    #   println("################# STEP = ", step, " ################ ")
    #   println("blocks_boxes = ", blocks_boxes,      
    #         " parallel units = ", threads * blocks_boxes)   
    #   println("Total number of boxes = ", num_boxes)  
    #   println("blocks_particles = ", blocks_particles,   
    #         " parallel units = ", threads * blocks_particles)  
    #   println("Total number of particles = ", total_particles)
    #   println("blocks_rings = ", blocks_rings,                
    #         " parallel units = ", threads * blocks_rings)               
    #   println("Total number of rings = ", total_rings)                  
    #   println("blocks_external_part = ", blocks_external_part,
    #         " parallel units = ", threads * blocks_external_part)                                     
    #   println("Total number of external particles = ", N)
    #   println("Max x = ", round(max_x; digits = 3), "  ",
    #           round(wall_position; digits = 3))  
    # end
    
    mark = 0
    
    if max_x < wall_position #blocks_particles     
        new_position_initial(force_particle_x, force_particle_y, x_positions,
                             y_positions, total_particles, dt,  delta_x)
    else
        new_positions(force_particle_x, force_particle_y, x_positions,
                          y_positions, total_particles, dt)
    end
    return areas,particle_box_index
end
end
