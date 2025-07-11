module Extract_hull_elements_put_in_gpu

using CUDA
using Statistics

export extract_hull_elements_put_in_gpu

function extract_hull_elements_put_in_gpu(hull)
    x_coords = [vec[1] for vec in hull]
    y_coords = [vec[2] for vec in hull]
    hull_vec = hcat(x_coords,y_coords)
    centroide = CuArray([mean(x_coords),mean(y_coords)])
    hull_gpu = CuArray(hull_vec)
    return hull_gpu,centroide,hull_vec
end

end
