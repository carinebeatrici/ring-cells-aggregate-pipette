module Calculate_internal_forces_and_particle_boxes


export calculate_internal_forces_and_particle_boxes!
function calculate_internal_forces_and_particle_boxes!(x_positions, y_positions,
                                areas,
                                force_area_modulus, force_particle_x, force_particle_y,
                                particle_box_index, number_boxes_x, box_lateral_size,
                                k, R0, ka, area_target, total_particles,
                                particles_per_ring)
    for part in 1:total_particles
        #calculating the particle box index, boxes start at zero        
        particle_box_index[part] = div( x_positions[part] , box_lateral_size) + number_boxes_x * div(y_positions[part],box_lateral_size)+1
        if particle_box_index[part] >= number_boxes_x^2
            println("part: ", part, " particle_box_index=",
                            particle_box_index[part])
        end

        #identifying ring and ring particle neighbors   
        ring_part = ceil(Int, part / particles_per_ring)
        particle_in_ring_part = (part - 1) % particles_per_ring + 1
        next = part % particles_per_ring == 0 ? part - particles_per_ring + 1 : part + 1
        previous = part % particles_per_ring == 1 ? part + particles_per_ring - 1 : part - 1
        #force module  due to springs         
        dx_next = x_positions[next] - x_positions[part]
        dy_next = y_positions[next] - y_positions[part]
        dist_next = sqrt(dx_next^2 + dy_next^2)
        force_next = k * (dist_next - R0)

        dx_prev = x_positions[previous] - x_positions[part]
        dy_prev = y_positions[previous] - y_positions[part]
        dist_prev = sqrt(dx_prev^2 + dy_prev^2)
        force_prev = k * (dist_prev - R0)

        #force components      
        force_particle_x[part] = force_next * dx_next / dist_next + force_prev * dx_prev / dist_prev
        force_particle_y[part] = force_next * dy_next / dist_next + force_prev * dy_prev / dist_prev

        #force module due to area      
        dx_2 =   x_positions[next] - x_positions[previous]
        dy_2 =   y_positions[next] - y_positions[previous]
        force_area_modulus[ring_part] = ka * ( areas[ring_part] - area_target )
        #adding to the force components           
        force_particle_x[part] += - force_area_modulus[ring_part] * dy_2
        force_particle_y[part] +=   force_area_modulus[ring_part] * dx_2
    end
    return nothing
end
end
