module Find_hull_index

using CUDA

export find_hull_index
function find_hull_index(hull_gpu,x_positions,y_positions, indices, total_particles,N)
    idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    if idx <= total_particles
        for i in 1:N
            #CUDA.@cuprintln("idx= ",idx, " i= ",i, " N=",N) 
            distance = (hull_gpu[i,1]-x_positions[idx])^2
                      +(hull_gpu[i,2]-y_positions[idx])^2
            if distance < 0.000005
                #CUDA.@cuprintln(" i=", i, " idx=", idx)  
                indices[i] = idx
                #CUDA.@cuprintln("total_particles= ", total_particles," N= ", N, " i =",i, " idx= ", idx\)     
             end
        end
    end
    # ext_part = (blockIdx().x - 1) * blockDim().x + threadIdx().x 
    # if ext_part <= N 
    #     for particle in 1:total_particles 
    #         dr2 = (hull_gpu[ext_part, 1]-x_positions[particle])^2 
    #              +(hull_gpu[ext_part, 2]-y_positions[particle])^2
    #         if dr2 < 0.000005
    #             indices[ext_part] = particle
    #             break
    #         end
    #     end
    # end  
    return nothing
end
end
