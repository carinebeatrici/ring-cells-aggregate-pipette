
module Extract_hull_elements_cpu
using Statistics


export extract_hull_elements_cpu
  function extract_hull_elements_cpu(hull)
    x_coords = [vec[1] for vec in hull]
    y_coords = [vec[2] for vec in hull]
    indices  = [trunc(Int, vec[3]) for vec in hull]
    hull_vec = hcat(x_coords,y_coords)
    centroide = [mean(x_coords), mean(y_coords)]
    return centroide, hull_vec, indices
  end
end
