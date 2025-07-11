module Radial_distribution

export radial_distribution
    function radial_distribution(total_rings)
        i = 0
        x = total_rings - 1
        number_in_circle = []
        while x > 0
            i += 1
            a = floor(Int, 2*pi*i)
            x -= a
            if x > 0
                number_in_circle = [number_in_circle;a]
            else
                number_in_circle = [number_in_circle;a+x]
            end
        end
        return number_in_circle
    end
end
