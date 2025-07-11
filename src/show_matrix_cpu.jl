module Show_matrix

export show_matrix
    function show_matrix_cpu(matrix_list_particles, num_boxes)
        for box in 1:num_boxes
            zz = matrix_list_particles[box]
            if zz > 0
                println("idx = ", box, " matrix = ", zz)
            end
        end
        return nothing
    end
end
