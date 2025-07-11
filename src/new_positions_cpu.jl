module New_positions

export new_positions

function new_positions(force_particle_x, force_particle_y, x_positions,
                           y_positions, total_particles, dt)
    for part in 1:total_particles
        x_positions[part] +=  force_particle_x[part]*dt
        y_positions[part] +=  force_particle_y[part]*dt
    end
    return nothing
end
end
