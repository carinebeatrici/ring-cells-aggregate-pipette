module Compute_number_of_particles_in_boxes_and_matrix_list


export compute_number_of_particles_in_boxes_and_matrix_list

function compute_number_of_particles_in_boxes_and_matrix_list(particle_box_index,
                           counter, matrix_list_particles, num_boxes, total_particles)
    counter .= 0
    for part in 1:total_particles
        box = particle_box_index[part]
        counter[box] += 1
        matrix_list_particles[box, trunc(Int, counter[box])] = part
    end
    return nothing
end

end
