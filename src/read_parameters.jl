module Read_parameters

export read_parameters

#Read simulation parameters 
    function read_parameters(input_path)
        parameter_file = open("$(input_path)/parameters.txt")
        lines = readlines(parameter_file)
        n_circles_of_rings = eval(Meta.parse((split(lines[1]))[2]))
        total_rings        = eval(Meta.parse((split(lines[2]))[2]))
        particles_per_ring = eval(Meta.parse((split(lines[3]))[2]))
        total_time         = eval(Meta.parse((split(lines[4]))[2])) 
        external_pressure  = eval(Meta.parse((split(lines[5]))[2]))
        box_lateral_size   = eval(Meta.parse((split(lines[6]))[2]))
        dt                 = eval(Meta.parse((split(lines[7]))[2]))
        k                  = eval(Meta.parse((split(lines[8]))[2]))
        ka                 = eval(Meta.parse((split(lines[9]))[2]))
        R0                 = eval(Meta.parse((split(lines[10]))[2]))
        l_adhesion         = eval(Meta.parse((split(lines[11]))[2]))
        k_adhesion         = eval(Meta.parse((split(lines[12]))[2]))
        k_core             = eval(Meta.parse((split(lines[13]))[2]))
        ring_diameter      = eval(Meta.parse((split(lines[14]))[2]))
        pipette_width      = eval(Meta.parse((split(lines[15]))[2]))
        p0                 = eval(Meta.parse((split(lines[16]))[2]))
        close(parameter_file)
        return n_circles_of_rings,total_rings, particles_per_ring, total_time, external_pressure, box_lateral_size, dt, k, ka, R0, l_adhesion, k_adhesion, k_core, ring_diameter, pipette_width, p0     
    end

end
