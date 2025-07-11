module Simulate_evolution

using CUDA
using Printf

include("convex_hull.jl")
using .Convex_hull

include("particle_neighbors_cpu.jl")
using .Particle_neighbors

include("add_neighbors_to_hull_cpu.jl")
using .Add_neighbors_to_hull

include("extract_hull_elements_put_in_gpu.jl")
using .Extract_hull_elements_put_in_gpu

include("external_pressure_vectors_gpu.jl")
using .External_pressure_vectors

include("find_hull_index_gpu.jl")
using .Find_hull_index

include("define_arrays_gpu.jl")
using .Define_arrays

include("define_box_around_gpu.jl")
using .Define_box_around

include("update_positions_gpu.jl")
using .Update_positions

include("plot_particles.jl")
using .Plot_particles

include("save_state.jl")
using .Save_state

export simulate_evolution!
   function simulate_evolution!(x_positions, y_positions, areas, total_rings,
            particles_per_ring, total_time, dt, k, R0, ka, l_adhesion,
            k_adhesion, k_core, area_target, external_pressure, number_boxes_x,
            box_lateral_size, plot_limits_x, plot_limits_y, wall_position,
            pipette_up_position, pipette_down_position, delta_x, delta,lpxt,
            input_path, output_path, output_images, init_step, save_fig, Ndt)

       num_steps = round(Int, total_time / dt)
       threads = 256
       total_particles = total_rings * particles_per_ring

       #CUDA arrays                             
       #println("define arrays")
       box_around, force_area_modulus, force_particle_x, force_particle_y, areas, particle_box_index, matrix_list_particles, counter,  ring_particle_is_from, num_neighbors = define_arrays(total_particles, total_rings, number_boxes_x, particles_per_ring, box_lateral_size, area_target) 
       
       # defining vectors out of the loop, julia does not like definitions inside loops    
       x_positions_cpu = Array(x_positions)
       y_positions_cpu = Array(y_positions)
       points = [ [x_positions_cpu[i],y_positions_cpu[i], i] for i in 1:length(x_positions_cpu) ]
       hull = convex_hull(points)

       particle_neighbors(total_particles, x_positions, y_positions,
                          matrix_list_particles, num_boxes, box_around,
                          counter, ring_particle_is_from, R0, l_adhesion,
		          particles_per_ring, num_neighbors)

       N = length(hull)
       hull = add_neighbors_to_hull(hull, N,
                                    total_particles, x_positions, y_positions,
                                    particles_per_ring, num_neighbors)
       
       
       hull_gpu,centroide, hull_vec = extract_hull_elements_put_in_gpu(hull)
       lp_cpu = []
       time = []
       t0 = 0
       x0 = 0.
           
       #the size of the hull points on the gpu is defined on the fly                              
       N = Int(length(hull_gpu)/2)
       
       # ################################################################ #                
       # Paralelismos diferentes, para partículas, caixas, aneis e  
       # particulas externas                                           
       # ################################################################ #        
       
       blocks_particles  = cld(total_particles, threads)
       blocks_rings = cld(total_rings, threads)
       blocks_external_part = cld(N, threads)


       
       #println("hull_calculated_first")           
       normal_vectors_x=CUDA.zeros(Float32,N)
       normal_vectors_y=CUDA.zeros(Float32,N)
       indices = CUDA.zeros(Int,N)
       @cuda threads=threads blocks=blocks_external_part external_pressure_vectors(normal_vectors_x, normal_vectors_y, hull_gpu, centroide, N)
       @cuda threads=threads blocks=blocks_particles find_hull_index(hull_gpu,x_positions,y_positions, indices, total_particles,N)
       vec_x = Array(normal_vectors_x)
       vec_y = Array(normal_vectors_y)
       external_pressure_on="False"

       tprint = 0
       title = @sprintf("t%5d",tprint) #Particle Configurat                     
       #title = "Initial Configuration"          
       #initial configuration plot        
       #defining the neighboring boxes                              
       num_boxes=number_boxes_x^2
       
       blocks_boxes = cld(num_boxes, threads)
       #threads = 256
       #blocks = min(65535, cld(total_particles, threads))
       @cuda threads=threads blocks=blocks_boxes define_box_around(box_around,num_boxes,number_boxes_x)

       next_measure_step = 1
       init_measure_step = 0
       steps_to_calculate_hull = 1
       total_steps_to_calculate_hull = 100*steps_to_calculate_hull
       #Evolution loop
       for step in init_step:num_steps
           #try
           update_positions!(x_positions, y_positions, areas, total_rings,
                             particles_per_ring, dt, k, R0, ka, l_adhesion, k_adhesion,
                             k_core,  number_boxes_x,  box_lateral_size, area_target,
                             box_around, force_area_modulus, force_particle_x,
                             force_particle_y, particle_box_index, matrix_list_particles,
                             counter,  ring_particle_is_from, total_particles, hull_gpu,
                             normal_vectors_x, normal_vectors_y, indices, external_pressure,
                             external_pressure_on, wall_position, pipette_up_position,
                             pipette_down_position, delta_x, delta, step, num_neighbors)
           #catch
           #    println("step:", step)  
           #    exit()  
           #end 
           # println(step%steps_to_calculate_hull, " ", total_steps_to_calculate_hull, " ",step)
           if (step % steps_to_calculate_hull == 0 &&
               step >= total_steps_to_calculate_hull) # find particles in the contour to be pressed at each 10 steps  
               if external_pressure_on == "False"
                   println("Starting external force")
                   external_pressure_on="True"
               end
               x_positions_cpu = Array(x_positions)
               y_positions_cpu = Array(y_positions)
               points = [ [x_positions_cpu[i],y_positions_cpu[i], i] for i in 1:length(x_positions_cpu) ]
               hull = convex_hull(points)

               particle_neighbors(total_particles, x_positions, y_positions,
                          matrix_list_particles, num_boxes, box_around,
                          counter, ring_particle_is_from, R0, l_adhesion,
                          particles_per_ring, num_neighbors)

               N = length(hull)
               hull = add_neighbors_to_hull(hull, N,
                                    total_particles, x_positions, y_positions,
                                    particles_per_ring, num_neighbors)
               
               hull_gpu, centroide, hull_vec = extract_hull_elements_put_in_gpu(hull)

               #the size of the hull points on the gpu is defined on the fly  
               N = Int(length(hull_gpu)/2)
               #println("Total number of external particles = ", N)   
               blocks_external_part = cld(N, threads)
               
               #println("hull_calculated")    
               normal_vectors_x=CUDA.zeros(Float32,N)
               normal_vectors_y=CUDA.zeros(Float32,N)
               @cuda threads=threads blocks=blocks_external_part external_pressure_vectors(normal_vectors_x, normal_vectors_y, hull_gpu,centroide, N)

                           indices = CUDA.zeros(Int,N)
            @cuda threads=threads blocks=blocks_particles find_hull_index(hull_gpu,x_positions,y_positions, indices, total_particles,N)
            #println("hull_mapped")     
            vec_x = Array(normal_vectors_x)
            vec_y = Array(normal_vectors_y)
           end
           max_x = maximum(x_positions)
           if max_x < wall_position
               t0 = step * dt
               x0 = max_x
           end
           # ######## Printing measures for more initial time steps ######    
           if  next_measure_step < Ndt
               if (step - init_measure_step) >= next_measure_step
                   #saving Lp and time            
                   #println(max_x-wall_position)
                   #print(step, " ",init_measure_step , " \n")
                   #print(max_x, " ", wall_position, "\n")         
                   if max_x > wall_position
                       if init_measure_step < 1
                           init_measure_step = step
                           next_measure_step = 1
                       else
                           next_measure_step += 10^(trunc(Int, log10(step - init_measure_step)))
                       end
                       push!(lp_cpu,max_x-x0)
                       push!(time,step*dt-t0)
                       println(lpxt,time[end]," ",lp_cpu[end])
                       flush(lpxt)
                   end
               end
           elseif (step-init_measure_step) % Ndt == 0
               #saving Lp and time  
               #println(max_x-wall_position)   
               if max_x > wall_position
                   push!(lp_cpu,max_x-x0)
                   push!(time,step*dt-t0)
                   println(lpxt,time[end]," ",lp_cpu[end])
                   flush(lpxt)
               end
           end
           # Print Snapshot       
           if step % Ndt == 0
               tprint = floor(Int, (step/(Ndt)))
               title = @sprintf("t%05d",tprint) #Particle Configuration at t = $(step * dt)"  
               plot_particles(x_positions_cpu, y_positions_cpu, total_rings, particles_per_ring, plot_limits_x, plot_limits_y, title ,box_lateral_size, hull_vec, vec_x, vec_y,  wall_position, pipette_up_position, pipette_down_position, output_images, save_fig)
               #sleep(2.0)   
           end
           # Save State                          
           if step % Ndt == 0
               x_positions_cpu = Array(x_positions)
               y_positions_cpu = Array(y_positions)
               #println(output_path)                    
               save_state(step*dt, x_positions_cpu, y_positions_cpu, output_path)
           end
       end
       x_positions_cpu = Array(x_positions)
       y_positions_cpu = Array(y_positions)
       vec_x = Array(normal_vectors_x)
       vec_y = Array(normal_vectors_y)
       return x_positions_cpu, y_positions_cpu, points, hull_vec, vec_x, vec_y,lp_cpu,time
   end  
end
