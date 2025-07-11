# -*- mode: julia;-*-
#v5.0 - including matrix of boxes with lists of particles
#v6.0 - new method to calculate matrix of boxes with lists of particles
# Hull around the set of particles
# Vectors on hull directed to the center
# v8.0 - Detailing input-output
# v8.1 - Reading more than one simulation in main_pars
# v8.4 - Mudando a escala de tempo de saida dos dados de Lp
# v8.5 - Medindo lp para intervalo de tempo logaritmico para step < Ndt
# v8.6 - Criando blocks para paralelismo em particulas, caixas, aneis separadamente
# 


using Plots
using Statistics
using LinearAlgebra
using Printf
#using Cthulhu
#using Setfield
#using Debugger

USE_CPU   =   true

#if !USE_CPU
    using CUDA
#end


include("src/main_parameters.jl")        
using .Main_parameters  


include("src/saving_parameters.jl")        
using .Saving_parameters  

include("src/save_state.jl")
using .Save_state

if USE_CPU
    include("src/read_saved_state_cpu.jl")
    using .Read_saved_state
else
    include("src/read_saved_state_gpu.jl")
    using .Read_saved_state
end

include("src/read_parameters.jl")
using .Read_parameters


include("src/total_rings_calc.jl")
using .Total_rings_calc


# include("src/radial_distribution.jl")
# using .Radial_distribution


if USE_CPU
    include("src/create_circular_rings_cpu.jl")
    using .Create_circular_rings
else
    include("src/create_circular_rings_gpu.jl")
    using .Create_circular_rings
end

include("src/extract_hull_elements_cpu.jl")        
using .Extract_hull_elements_cpu  


include("src/plot_hull_and_normal.jl")
using .Plot_hull_and_normal


include("src/plot_lpxt.jl")
using .Plot_lpxt


include("src/plot_particles.jl")
using .Plot_particles


include("src/plot_hull.jl")
using .Plot_hull


#include("src/quickhull.jl")
#using .Quickhull


include("src/convex_hull.jl")
using .Convex_hull


if USE_CPU
    include("src/calculate_areas_direct_cpu.jl")
    using .Calculate_areas_direct
else
    include("src/calculate_areas_direct_gpu.jl")
    using .Calculate_areas_direct
end


if USE_CPU
    include("src/calculate_internal_forces_and_particle_boxes_cpu.jl")
    using .Calculate_internal_forces_and_particle_boxes
else
    include("src/calculate_internal_forces_and_particle_boxes_gpu.jl")
    using .Calculate_internal_forces_and_particle_boxes
end


if USE_CPU
    include("src/compute_number_of_particles_in_boxes_and_matrix_list_cpu.jl")
    using .Compute_number_of_particles_in_boxes_and_matrix_list
else
    include("src/compute_number_of_particles_in_boxes_and_matrix_list_gpu.jl")
    using .Compute_number_of_particles_in_boxes_and_matrix_list
end


if USE_CPU
    include("src/forces_between_particles_in_neighbor_boxes_cpu.jl")
    using .Forces_between_particles_in_neighbor_boxes
else
    include("src/forces_between_particles_in_neighbor_boxes_gpu.jl")
    using .Forces_between_particles_in_neighbor_boxes
end


if USE_CPU
    include("src/wall_and_pipette_repulsion_cpu.jl")
    using .Wall_and_pipette_repulsion
else
    include("src/wall_and_pipette_repulsion_gpu.jl")
    using .Wall_and_pipette_repulsion
end


if USE_CPU
    include("src/new_position_initial_cpu.jl")
    using .New_position_initial
else
    include("src/new_position_initial_gpu.jl")
    using .New_position_initial
end


if USE_CPU
    include("src/new_positions_cpu.jl")
    using .New_positions
else
    include("src/new_positions_gpu.jl")
    using .New_positions
end


if USE_CPU
    include("src/define_box_around_cpu.jl")
    using .Define_box_around
else
    include("src/define_box_around_gpu.jl")
    using .Define_box_around
end


if USE_CPU
    include("src/external_pressure_vectors_cpu.jl")
    using .External_pressure_vectors
else
    include("src/external_pressure_vectors_gpu.jl")
    using .External_pressure_vectors
end


if USE_CPU
    include("src/find_hull_index_cpu.jl")
    using .Find_hull_index
else
    include("src/find_hull_index_gpu.jl")
    using .Find_hull_index
end


if USE_CPU
    include("src/external_pressure_forces_cpu.jl")
    using .External_pressure_forces
else
    include("src/external_pressure_forces_gpu.jl")
    using .External_pressure_forces
end


if USE_CPU
    include("src/define_arrays_cpu.jl")
    using .Define_arrays
else
    include("src/define_arrays_gpu.jl")
    using .Define_arrays
end


if USE_CPU
    include("src/show_matrix_cpu.jl")
    using .Show_matrix
else
    include("src/show_matrix_gpu.jl")
    using .Show_matrix
end


if USE_CPU
    include("src/update_positions_cpu.jl")
    using .Update_positions
else
    include("src/update_positions_gpu.jl")
    using .Update_positions
end


if USE_CPU
    include("src/simulate_evolution_cpu.jl")
    using .Simulate_evolution
else
    include("src/simulate_evolution_gpu.jl")
    using .Simulate_evolution
end


include("src/remaining_parameters.jl")
using .Remaining_parameters


if USE_CPU
    include("src/main_cpu.jl")
    using .Main_prog
else
    include("src/main_gpu.jl")
    using .Main_prog
end

# Run the main function
#try
main()
#catch err
#    @show typeof(err)
#    code_typed(err; interactive = true)
#end
