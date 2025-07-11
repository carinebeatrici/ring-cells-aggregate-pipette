module External_pressure_vectors

using Statistics

    export external_pressure_vectors
    # function external_pressure_vectors(normal_vectors_x, normal_vectors_y, hull_vec,
    #                                    centroide, N)
    #     for ext_part in 1:N
    #         prev_ext_part = ext_part == 1 ? N : ext_part - 1
    #         p_x = hull_vec[prev_ext_part, 1]
    #         p_y = hull_vec[prev_ext_part, 2]
    #         next_ext_part = ext_part == N ? 1 : ext_part + 1
    #         n_x = hull_vec[next_ext_part, 1]
    #         n_y = hull_vec[next_ext_part, 2]

    #         midpoint_x = (p_x + n_x)/2.0
    #         midpoint_y = (p_y + n_y)/2.0
            
    #         normal_x = - (n_x - p_x)
    #         normal_y =    n_y - p_y
    #         norm_normal = sqrt(normal_x^2+normal_y^2)
    #         normal_x = normal_x / norm_normal
    #         normal_y = normal_y / norm_normal

    #         dot = normal_x*(centroide[1]-midpoint_x) + normal_y*(centroide[2]-midpoint_y)
    #         if dot < 0
    #             normal_x = -normal_x
    #             normal_y = -normal_y
    #         end
    #         # normal_x = centroide[1] - hull_vec[ext_part, 1]
    #         # normal_y = centroide[2] - hull_vec[ext_part, 2]

    #         # norm_normal = sqrt(normal_x^2+normal_y^2)

    #         # normal_x = normal_x / norm_normal
    #         # normal_y = normal_y / norm_normal
            
    #         normal_vectors_x[ext_part] = normal_x
    #         normal_vectors_y[ext_part] = normal_y
    #     end
    #     # println(sum(normal_vectors_x), "  ", sum(normal_vectors_y)) 
        
    #     return nothing
    # end


    function external_pressure_vectors(normal_vectors_x, normal_vectors_y, hull_vec,
                                       centroide, N)
        for ext_part in 1:N
            p1x = hull_vec[ext_part, 1]
            p1y = hull_vec[ext_part, 2]
            next_ext_part = ext_part == N ? 1 : ext_part+1
            p2x = hull_vec[next_ext_part, 1]
            p2y = hull_vec[next_ext_part, 2]
            edge_x = p2x - p1x
            edge_y = p2y - p1y
            normal_x = -edge_y
            normal_y =  edge_x
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
            normal_vectors_x[ext_part] = normal_x
            normal_vectors_y[ext_part] = normal_y
        end
        # println(sum(normal_vectors_x), "  ", sum(normal_vectors_y))
        # println(std(normal_vectors_x), "  ", std(normal_vectors_y))
        # println("  ")
        return nothing
    end                         
end
