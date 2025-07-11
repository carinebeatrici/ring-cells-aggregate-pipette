module External_pressure_forces

export external_pressure_forces
    function external_pressure_forces(x_positions, y_positions, force_particle_x,
                                          force_particle_y, normal_vectors_x,
                                          normal_vectors_y, indices, external_pressure,
                                          N, wall_position, pipette_up_position,
                                          pipette_down_position)
        for ext_part in 1:N
            index = indices[ext_part] #ext_part runs on the hull, index finds the corresponding particle index     
            if x_positions[index] < wall_position
                force_particle_x[index] += normal_vectors_x[ext_part]*(external_pressure)
                force_particle_y[index] += normal_vectors_y[ext_part]*(external_pressure)
            end
        end
        return nothing
    end
end
