module Convex_hull

include("quickhull.jl")
using .Quickhull

include("cross.jl")
using .Cross

export convex_hull
function convex_hull(points)
    if length(points) <= 3
        return points
    end

    # Encontrar os pontos extremos (esquerda e direita)  
    a = points[argmin([p[1] for p in points])]
    b = points[argmax([p[1] for p in points])]

    # Dividir os pontos em dois conjuntos   
    left_set = [p for p in points if cross(a, b, p) > 0]
    right_set = [p for p in points if cross(a, b, p) < 0]

    # Calcular o fecho convexo em paralelo     
    hull_left = quickhull(left_set, a, b)
    hull_right = quickhull(right_set, b, a)

    return vcat([a], hull_left, [b], hull_right)
end
end
