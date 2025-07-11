module Calculate_areas_direct


export calculate_areas_direct!
function calculate_areas_direct!(x_positions, y_positions, total_particles,
                                 particles_per_ring, areas)
    total_rings = length(areas)
    for ring_idx in 1:total_rings
        areas[ring_idx] = 0
        for i in 1:particles_per_ring
            idx = (ring_idx-1)*particles_per_ring + i
            next_in_ring = idx % particles_per_ring == 0 ? idx - particles_per_ring + 1 : idx + 1
            areas[ring_idx] += 0.5f0 * (x_positions[idx] * y_positions[next_in_ring] - y_positions[idx] * x_positions[next_in_ring])
        end
    end
end
end
