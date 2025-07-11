module Create_circular_rings

export create_circular_rings

    include("radial_distribution.jl")  
    using .Radial_distribution

    function create_circular_rings(total_rings, particles_per_ring, ring_diameter,
                                   offset_x, offset_y)
        total_particles  = total_rings * particles_per_ring
        
        x_positions      = zeros(total_particles)
        y_positions      = zeros(total_particles)
        areas            = zeros(total_rings)
        
        number_in_circle = radial_distribution(total_rings)
        
        #constructing the central ring           
        ring_idx         = 1
        center_x         = offset_x
        center_y         = offset_y
        start_idx        = (ring_idx - 1) * particles_per_ring + 1
        end_idx          = ring_idx * particles_per_ring
        angles           = range(0f0, 2f0π, length=particles_per_ring+1)[1:end-1]
        x_positions[start_idx:end_idx] = 0.9*ring_diameter/2 * cos.(angles) .+ center_x
        y_positions[start_idx:end_idx] = 0.9*ring_diameter/2 * sin.(angles) .+ center_y
        
        k=0
        for i in number_in_circle
            delta_angle = 2*pi/i
            k +=1
            for j in 1:i
                ring_idx += 1
                center_x = offset_x + k*ring_diameter*cos(j*delta_angle)
                center_y = offset_y + k*ring_diameter*sin(j*delta_angle)
                start_idx = (ring_idx - 1) * particles_per_ring + 1
                end_idx = ring_idx * particles_per_ring
                angles = range(0f0, 2f0π, length=particles_per_ring+1)[1:end-1]
                x_positions[start_idx:end_idx] = 0.9*ring_diameter/2 * cos.(angles) .+ center_x
                y_positions[start_idx:end_idx] = 0.9*ring_diameter/2 * sin.(angles) .+ center_y
            end
        end
        return x_positions, y_positions, areas
    end
end

