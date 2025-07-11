module Find_hull_index

export find_hull_index
function find_hull_index(hull_vec, x_positions, y_positions, indices,
                             total_particles, N)
    for ext_part in 1:N
        for particle in 1:total_particles
            dr2 = (hull_vec[ext_part, 1] - x_positions[particle])^2
                 +(hull_vec[ext_part, 2] - y_positions[particle])^2
            if dr2 < 0.000005
                indices[ext_part] = particle
                break
            end
        end
    end
    return nothing
end
end
