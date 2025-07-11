module Forces_between_particles_in_neighbor_boxes

using CUDA

export forces_between_particles_in_neighbor_boxes
function forces_between_particles_in_neighbor_boxes(force_particle_x, force_particle_y,
         x_positions, y_positions, matrix_list_particles, num_boxes, box_around,
         counter, ring_particle_is_from, R0, l_adhesion,  k_adhesion, k_core,
         particles_per_ring, num_neighbors)
    box = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    if box <= num_boxes
        for particle_1 in 1:counter[box] # looping on the particles in box   
            part_1_index = matrix_list_particles[box, particle_1] # first particle to interact                                
            #CUDA.@cuprintln("box: ", box, " counter=", counter[box])# "counter2= ", counter[box_around[k,box]])
            num_neighbors[part_1_index] = 0
            for neighbor_box in 1:9 # looping on box box and all boxes around   
                if box_around[neighbor_box,box] > 0 # checking if not on the contour 
                    for particle_2 in 1:counter[box_around[neighbor_box,box]]  # looping all particles in the 9 boxes                       
                        part_2_index = matrix_list_particles[box_around[neighbor_box, box], particle_2] # second particle to interact                   
                        dx = x_positions[part_2_index]-x_positions[part_1_index]
                        dy = y_positions[part_2_index]-y_positions[part_1_index]
                        dr = sqrt(dx^2 + dy^2)
                        if dr < l_adhesion
                            num_neighbors[part_1_index] += 1
                            if ring_particle_is_from[part_1_index] == ring_particle_is_from[part_2_index]
                                if abs(part_1_index-part_2_index) > 1
                                    if abs(part_1_index-part_2_index) < particles_per_ring - 1
                                        fmod = dr > R0 ? 0 :  k_core*(dr/R0-1)
                                        force_particle_x[part_1_index] += fmod * dx/dr
                                        force_particle_y[part_1_index] += fmod * dy/dr
                                    end
                                end
                            end
                            if ring_particle_is_from[part_1_index] != ring_particle_is_from[part_2_index]
                                fmod = dr > R0 ? k_adhesion*(dr/R0-1) :  k_core*(dr/R0-1)
                                force_particle_x[part_1_index] += fmod * dx/dr
                                force_particle_y[part_1_index] += fmod * dy/dr
                            end
                        end
                    end
                end
            end
        end
    end
    return nothing
end
end
