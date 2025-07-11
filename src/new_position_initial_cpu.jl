module New_position_initial

export new_position_initial
    function new_position_initial(force_particle_x, force_particle_y, x_positions,
                                      y_positions, total_particles, dt,  delta_x)
        dt2 = dt/2
        for part in 1:total_particles
            x_positions[part] +=  force_particle_x[part]*dt2 + delta_x
            y_positions[part] +=  force_particle_y[part]*dt2
        end
        return nothing
    end
end
