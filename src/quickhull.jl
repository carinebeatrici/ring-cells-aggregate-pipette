module Quickhull

include("distance_line_to_point.jl")    
using .Distance_line_to_point

include("cross.jl")
using .Cross

export quickhull
function quickhull(points, a, b)
    if isempty(points)
        return []
    end

    # Encontrar o ponto mais distante da linha AB          
    distances = [distance_line_to_point(a, b, p) for p in points]
    farthest_idx = argmax(distances)
    farthest_point = points[farthest_idx]

    # Dividir os pontos em dois conjuntos      
    left_set = [p for p in points if cross(a, farthest_point, p) > 0]
    right_set = [p for p in points if cross(farthest_point, b, p) > 0]

    # Recursão                  
    hull_left = quickhull(left_set, a, farthest_point)
    hull_right = quickhull(right_set, farthest_point, b)

    return vcat(hull_left, [farthest_point], hull_right)
end

end 
