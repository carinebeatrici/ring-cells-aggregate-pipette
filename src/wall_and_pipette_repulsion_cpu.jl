module Wall_and_pipette_repulsion

export wall_and_pipette_repulsion
    function wall_and_pipette_repulsion(force_particle_x, force_particle_y,
                                            x_positions, y_positions, total_particles,
                                            R0, k_core, wall_position,
                                            pipette_up_position, pipette_down_position)
        for part in 1:total_particles
            #Test  particles above and below the channel      
            if (y_positions[part] > pipette_up_position || y_positions[part] < pipette_down_position)
                delta_xx = abs( wall_position - x_positions[part])
                if ( delta_xx <= R0)
                    force_particle_x[part] -= k_core *  (R0-delta_xx)
                end
            end
            #Test  particles in the channel and corner                                       
            #Up                                                                              
            if (y_positions[part] < pipette_up_position && y_positions[part] > pipette_down_position)
                delta_y_up = abs(pipette_up_position - y_positions[part])
                if (delta_y_up < R0 && x_positions[part] > wall_position - R0 )
                    force_particle_y[part] -= k_core * (R0-delta_y_up)
                    if x_positions[part] < wall_position
                        dx = wall_position - x_positions[part]
                        dy = pipette_up_position - y_positions[part]
                        dr = sqrt(dx*dx+dy*dy)
                        force_particle_y[part] += k_core * (R0-delta_y_up) # subtract what was added above
                        force_particle_x[part] -= k_core * (R0-dr)*dx/dr   # add the corner contribution
                        force_particle_y[part] -= k_core * (R0-dr)*dy/dr   # add the corner contribution
                    end
                end
            end
            #Down                        
            delta_y_down =  abs(y_positions[part] - pipette_down_position )
            if (delta_y_down < R0 && x_positions[part] > wall_position - R0)
                force_particle_y[part] += k_core * (R0 - delta_y_down)
                if x_positions[part] < wall_position
                    dx = wall_position - x_positions[part]
                    dy = y_positions[part] - pipette_down_position
                    dr = sqrt(dx*dx+dy*dy)
                    force_particle_y[part] -= k_core * (R0-delta_y_down)    # subtract what was added abo 
                    force_particle_x[part] -= k_core * (R0-dr)*dx/dr        # add the corner contribution     
                    force_particle_y[part] += k_core * (R0-dr)*dy/dr        # add the corner contribution    
                end
            end
            #end                   
        end
        return nothing
    end
end

