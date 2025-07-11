module New_position_initial

using CUDA

export new_position_initial
    function new_position_initial(force_particle_x, force_particle_y,
                                  x_positions, y_positions, total_particles, dt, delta_x)
        dt2 = dt/2
        idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x
        if idx <= total_particles
            x_positions[idx] +=  force_particle_x[idx]*dt2 + delta_x
            y_positions[idx] +=  force_particle_y[idx]*dt2
        end
        return nothing
    end
end

