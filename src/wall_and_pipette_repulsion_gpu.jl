module Wall_and_pipette_repulsion


using CUDA


export wall_and_pipette_repulsion
    function wall_and_pipette_repulsion(force_particle_x, force_particle_y, x_positions, y_positions,
                                        total_particles, R0, k_core, wall_position,
                                        pipette_up_position, pipette_down_position)
    idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    if idx <= total_particles
        #Test  particles above and below the channel                     
        if (y_positions[idx] > pipette_up_position || y_positions[idx] < pipette_down_position)
            delta_xx = abs( wall_position - x_positions[idx])
            if ( delta_xx <= R0)
                force_particle_x[idx] -= k_core *  (R0-delta_xx)
            end
        end
        #Test  particles in the channel and corner                 
        #Up                            
        if (y_positions[idx] < pipette_up_position && y_positions[idx] > pipette_down_position)
            delta_y_up = abs(pipette_up_position - y_positions[idx])
            if (delta_y_up < R0 && x_positions[idx] > wall_position - R0 )
                force_particle_y[idx] -= k_core * (R0-delta_y_up)
                if x_positions[idx] < wall_position
                    dx = wall_position - x_positions[idx]
                    dy = pipette_up_position - y_positions[idx]
                    dr = sqrt(dx*dx+dy*dy)
                    force_particle_y[idx] += k_core * (R0-delta_y_up) # subtract what was added above    
                    force_particle_x[idx] -= k_core * (R0-dr)*dx/dr   # add the corner contribution    
                    force_particle_y[idx] -= k_core * (R0-dr)*dy/dr   # add the corner contribution
                    #CUDA.@cuprintln("idx: ", idx, " x=", y_positions[idx])           
                end
            end
        end
        #Down             
        delta_y_down =  abs(y_positions[idx] - pipette_down_position )
        if (delta_y_down < R0 && x_positions[idx] > wall_position - R0)
            force_particle_y[idx] += k_core * (R0 - delta_y_down)
            if x_positions[idx] < wall_position
                dx = wall_position - x_positions[idx]
                dy = y_positions[idx] - pipette_down_position
                dr = sqrt(dx*dx+dy*dy)
                force_particle_y[idx] -= k_core * (R0-delta_y_down)    # subtract what was added abo       
                force_particle_x[idx] -= k_core * (R0-dr)*dx/dr        # add the corner contribution       
                force_particle_y[idx] += k_core * (R0-dr)*dy/dr        # add the corner contribution       
                #CUDA.@cuprintln("idx: ", idx, " x=", y_positions[idx])                                    
            end
        end
        #end                                
        #CUDA.@cuprintln("idx: ", idx, " total_particles= ", total_particles, " x=", y_positions[idx])  
    #else                                                                       
        #    CUDA.@cuprintln("ELSE idx: ", idx, " total_particles= ", total_particles)
    end
    #@cuprintln("idx: %d", round(Int, idx))                    
    # " force: ", force_particle_x[idx], " ", force_particle_y[idx])      
    #@cuprintln(threadIdx().x)                        
    return nothing
end
        
end
