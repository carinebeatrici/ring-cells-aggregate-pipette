module Cross

export cross
function cross(a, b, c)
    return (b[1] - a[1]) * (c[2] - a[2]) - (b[2] - a[2]) * (c[1] - a[1])
end

end
