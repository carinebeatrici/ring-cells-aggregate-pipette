module New_positions

    using CUDA

    export new_positions
    function new_positions(force_particle_x, force_particle_y, x_positions,
                           y_positions, total_particles, dt)
        idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x
        if idx <= total_particles
            x_positions[idx] +=  force_particle_x[idx]*dt
            y_positions[idx] +=  force_particle_y[idx]*dt
        end
        return nothing
    end
end
