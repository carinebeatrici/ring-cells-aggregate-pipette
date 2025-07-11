module Main_parameters


export main_parameters
    function main_parameters(main_pars)
        line = readline(main_pars)
        n_circles_of_rings = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        particles_per_ring = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        total_time         = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        external_pressure  = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        box_lateral_size   = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        dt                 = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        k                  = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        ka                 = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        R0                 = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        k_adhesion         = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        k_core             = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        pipette_width      = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        p0                 = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        save_fig      = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        continue_simu      = eval(Meta.parse(split(line)[2]))
        line = readline(main_pars)
        Ndt                = eval(Meta.parse(split(line)[2]))
        path = "../data/adh_$(k_adhesion)_press_$external_pressure"
        mkpath(path)
        input_path = "$(path)/input"
        mkpath(input_path)
        output_path = "$(path)/output"
        mkpath(output_path)
        output_images = "$(output_path)/images"
        mkpath(output_images)
        println(path)
        return n_circles_of_rings, particles_per_ring, total_time, external_pressure, box_lateral_size, dt, k, ka, R0, k_adhesion, k_core, pipette_width, p0, input_path, output_path, output_images, save_fig, continue_simu, Ndt
    end
end
