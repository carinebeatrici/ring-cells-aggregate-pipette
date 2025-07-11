module Compute_number_of_particles_in_boxes_and_matrix_list

using CUDA

export compute_number_of_particles_in_boxes_and_matrix_list
    function compute_number_of_particles_in_boxes_and_matrix_list(particle_box_index,
                                                                  counter,
                                                                  matrix_list_particles,
                                                                  num_boxes,
                                                                  total_particles)
    idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    counter .= 0
        if idx <= num_boxes
            for i in 1:total_particles
                if particle_box_index[i] == idx
                    counter[idx] += 1
                    matrix_list_particles[idx,counter[idx]]= i
                    #CUDA.@cuprintln("idx: ", idx, " counter=", counter[idx], " matrix_idx_counter = ", i)    
                end
            end
        end
    return nothing
end

end
