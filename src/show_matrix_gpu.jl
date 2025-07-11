module Show_matrix

using CUDA

export show_matrix
    function show_matrix(matrix_list_particles, num_boxes)
        idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x
        if idx <= num_boxes
            zz = matrix_list_particles[idx]
            if zz > 0
                CUDA.@cuprintln("idx = ", idx, " matrix = ", zz)
            end
        end
        return nothing
    end
end
