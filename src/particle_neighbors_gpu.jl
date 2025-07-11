module Particle_neighbors

using CUDA

export particle_neighbors
    function particle_neighbors(total_particles, x_positions, y_positions,
                                matrix_list_particles, num_boxes, box_around,
                                counter, ring_particle_is_from, R0,
                                l_adhesion, particles_per_ring, num_neighbors)
        l_adhesion_2 = l_adhesion * l_adhesion
        particle_1 = (blockIdx().x - 1) * blockDim().x + threadIdx().x
        if particle_1 < total_particles
            num_neighbors[particle_1] = 0
            ring_part_1 = ring_particle_is_from[particle_1]
            for particle_2 in 1:total_particles
                ring_part_2 = ring_particle_is_from[particle_2]
                if ring_part_1 != ring_part_2
                    dx = x_positions[particle_1] - x_positions[particle_2]
                    dy = y_positions[particle_1] - y_positions[particle_2]
                    dr2 = dx*dx + dy*dy
                    if dr2 < l_adhesion_2
                        num_neighbors[particle_1] += 1
                    end
                end
            end
        end
    return nothing
  end
end
