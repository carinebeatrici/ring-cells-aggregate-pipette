module Distance_line_to_point

using LinearAlgebra

export distance_line_to_point
   # Função para calcular a distância de um ponto a uma linha     
function distance_line_to_point(a, b, p)
    return abs((b[2] - a[2]) * p[1] - (b[1] - a[1]) * p[2] + b[1] * a[2] - b[2] * a[1]) / norm(b - a)
end
end
