module Add_neighbors_to_hull

export add_neighbors_to_hull
    function add_neighbors_to_hull(hull, N,
                                   total_particles, x_positions, y_positions,
                                   particles_per_ring, num_neighbors)
        # try to add previous and next ring particle to each hull particle
        indeces = [trunc(Int, vec[3]) for vec in hull]
        ext_part = 1
        while ext_part != length(indeces)
            part = trunc(Int, hull[ext_part][3])
            next = part % particles_per_ring == 0 ? part - particles_per_ring + 1 : part + 1
            prev = part % particles_per_ring == 1 ? part + particles_per_ring - 1 : part - 1
            if num_neighbors[prev] == 0 && !(prev in indeces)
                # add prev particle to hull
                hull = [hull[1:ext_part-1]; 0.0; hull[ext_part:end]]
                hull[ext_part] = [x_positions[prev], y_positions[prev], prev]
                indeces = [indeces; prev]
            elseif num_neighbors[next] == 0 && !(next in indeces) 
                # add next particle to hull
                hull = [hull[1:ext_part]; 0.0; hull[ext_part+1:end]]
                hull[ext_part+1] = [x_positions[next], y_positions[next], next]
                indeces = [indeces; next]
                ext_part += 1
            else
                ext_part += 1
            end
        end
    return hull
  end
end
