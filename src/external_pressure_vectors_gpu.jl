module External_pressure_vectors

using CUDA

export external_pressure_vectors
function external_pressure_vectors(normal_vectors_x, normal_vectors_y, hull_gpu,
                                   centroide, N)
    idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    if idx <= N
        p1x = hull_gpu[idx, 1]
        p1y = hull_gpu[idx, 2]
        idxplus = idx == N ? 1 : idx+1
        p2x = hull_gpu[idxplus, 1]
        p2y = hull_gpu[idxplus, 2]
        edge_x = p2x -p1x
        edge_y = p2y -p1y
        normal_x = -edge_y
        normal_y = edge_x
        norm_normal = sqrt(normal_x^2+normal_y^2)
        normal_x = normal_x / norm_normal
        normal_y = normal_y / norm_normal
        midpoint_x = (p1x+p2x)/2
        midpoint_y = (p1y+p2y)/2
        dot = normal_x*(centroide[1]-midpoint_x) + normal_y*(centroide[2]-midpoint_y)
        if dot < 0
            normal_x = -normal_x
            normal_y = -normal_y
        end
        # normal = [-edge[2], edge[1]]  # Perpendicular vector   
        # norm_normal = sqrt(normal[1]^2 + normal[2]^2)     
        # normal = normal / norm_normal  # Normalize  
        normal_vectors_x[idx] = normal_x
        normal_vectors_y[idx] = normal_y
        #CUDA.@cuprintln("p1x: ",p1x, " p1y: ",p1y,  " norm_x=", normal_x, " norm_y=", normal_y, " cenx \",centroide[1], " ceny ",centroide[2])     
    end
    return nothing
end
end 
