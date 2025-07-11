module Saving_parameters

export saving_parameters
    # saves the whole set of parameters
    function saving_parameters(n_circles_of_rings, total_rings, particles_per_ring,
                               total_time, external_pressure, box_lateral_size, dt,
                               k, ka, R0, l_adhesion, k_adhesion, k_core,
                               ring_diameter, pipette_width, p0, area_target,
                               input_path, output_path, Ndt)
        #Saving initial parameters
        pars = open("$(input_path)/parameters.txt", "w")
        println(pars,"n_circles_of_rings = ", n_circles_of_rings)
        println(pars,"total_rings = ", total_rings)
        println(pars,"particles_per_ring = ",particles_per_ring)
        println(pars,"total_time = ",total_time)
        println(pars,"external_pressure = ",external_pressure)
        println(pars,"box_lateral_size = ",box_lateral_size)
        println(pars,"dt = ",dt)
        println(pars,"k = ",k)
        println(pars,"ka = ",ka)
        println(pars,"R0 = ",R0)
        println(pars,"l_adhesion = ",l_adhesion)
        println(pars,"k_adhesion = ",k_adhesion)
        println(pars,"k_core = ",k_core)
        println(pars,"ring_diameter = ",ring_diameter)
        println(pars,"pipette_width = ",pipette_width)
        println(pars,"p0 = ",p0)
        println(pars,"area_target = ",area_target)
        println(pars,"steps_between_measures = ",Ndt)
        close(pars)
        #Saving results   
        lpxt = open("$(output_path)/lpxt.txt", "w")
        println(lpxt,"#time x Lp")
        return lpxt
    end
end
