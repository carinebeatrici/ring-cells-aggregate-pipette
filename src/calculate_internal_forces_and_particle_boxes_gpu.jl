module Calculate_internal_forces_and_particle_boxes

using CUDA

export calculate_internal_forces_and_particle_boxes!
    function calculate_internal_forces_and_particle_boxes!(x_positions, y_positions,
                                                           areas, force_area_modulus,
                                                           force_particle_x,
                                                           force_particle_y,
                                                           particle_box_index,
                                                           number_boxes_x,
                                                           box_lateral_size, k, R0,
                                                           ka, area_target,
                                                           total_particles,
                                                           particles_per_ring)
    idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    if idx <= total_particles
        #calculating the particle box index, boxes start at zero 
        particle_box_index[idx] = div( x_positions[idx] , box_lateral_size) + number_boxes_x * div(y_positions[idx],box_lateral_size)+1
        if particle_box_index[idx] >= number_boxes_x^2
            CUDA.@cuprintln("idx: ", idx, " particle_box_index=",
                            particle_box_index[idx])
        end

        #identifying ring and ring particle neighbors   
        ring_idx = ceil(Int, idx / particles_per_ring)
        particle_in_ring_idx = (idx - 1) % particles_per_ring + 1
        next = idx % particles_per_ring == 0 ? idx - particles_per_ring + 1 : idx + 1
        previous = idx % particles_per_ring == 1 ? idx + particles_per_ring - 1 : idx - 1

        #force module  due to springs   
        dx_next = x_positions[next] - x_positions[idx]
        dy_next = y_positions[next] - y_positions[idx]
        dist_next = sqrt(dx_next^2 + dy_next^2)
        force_next = k * (dist_next - R0)

        dx_prev = x_positions[previous] - x_positions[idx]
        dy_prev = y_positions[previous] - y_positions[idx]
        dist_prev = sqrt(dx_prev^2 + dy_prev^2)
        force_prev = k * (dist_prev - R0)

        #force components    
        force_particle_x[idx] = force_next * dx_next / dist_next + force_prev * dx_prev / dist_prev
        force_particle_y[idx] = force_next * dy_next / dist_next + force_prev * dy_prev / dist_prev
        #force module due to area   
        dx_2 =   x_positions[next] - x_positions[previous]
        dy_2 =   y_positions[next] - y_positions[previous]
        force_area_modulus[ring_idx] = ka * ( areas[ring_idx] - area_target )

        #adding to the force components 
        force_particle_x[idx] += - force_area_modulus[ring_idx] * dy_2
        force_particle_y[idx] +=   force_area_modulus[ring_idx] * dx_2
    end
    return nothing
end
end
