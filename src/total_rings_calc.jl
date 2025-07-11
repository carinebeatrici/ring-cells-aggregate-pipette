module Total_rings_calc

export total_rings_calc
#creates a vector with the number of rings in sucessive circles around a central ring
    function total_rings_calc(n_circles_of_rings)
        total_rings = 1
        for i in 1:n_circles_of_rings
            total_rings += floor(Int,2*pi*i)
        end
        return total_rings
    end
end
