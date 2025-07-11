module Remaining_parameters

export remaining_parameters
    #Function with the derived parameters                                                  
    function remaining_parameters(R0, particles_per_ring, p0, n_circles_of_rings,
                                  pipette_width, box_lateral_size)
        l_adhesion = 1.5f0 * R0 # Limit distance for adhesion forces                       
        ring_diameter = particles_per_ring * R0  / π #R0 is  the equilibrium distance between particles in a ring                                                                
        area_target = (particles_per_ring * R0 )^2 / p0^2
        offset_x = 3.0*n_circles_of_rings*ring_diameter #3.0                               
        offset_y = 2.0*n_circles_of_rings*ring_diameter
        pipette_width = pipette_width*ring_diameter
        system_x_size = ceil(Int,ring_diameter * n_circles_of_rings *8.0)
        system_y_size = ceil(Int,ring_diameter * n_circles_of_rings  * 4.0)
        number_boxes_x = ceil(Int, system_x_size/box_lateral_size)
        system_x_size = number_boxes_x * box_lateral_size
        plot_limits_x = system_x_size
        plot_limits_y = system_y_size
        #println("plot_limits_x = ",plot_limits_x," plot_limits_y = ",plot_limits_y)       
        offset = 2*ring_diameter
        pipette_up_position = ceil(Int, offset_y + pipette_width/2 + R0  )
        pipette_down_position = ceil(Int, offset_y - pipette_width/2 - R0)
        delta_x = 0.002 # displace at each dt while not in wall                            
        delta = 0.1 # displace from the wall if to close                                   
        return l_adhesion, ring_diameter, area_target, offset_x, offset_y, pipette_width, system_x_size, system_y_size, number_boxes_x, system_x_size, plot_limits_x, plot_limits_y, offset, pipette_up_position, pipette_down_position, delta_x, delta
    end
end
