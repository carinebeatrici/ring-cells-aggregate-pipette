module Define_arrays

using CUDA

export define_arrays
function define_arrays(total_particles, total_rings, number_boxes_x,
                       particles_per_ring, box_lateral_size, area_target)
    num_boxes          = number_boxes_x^2
    box_around         = CUDA.zeros(Int, 9, num_boxes, number_boxes_x)
    force_area_modulus = CUDA.zeros(Float32,total_rings)
    force_particle_x   = CUDA.zeros(Float32,total_particles)
    force_particle_y   = CUDA.zeros(Float32,total_particles)
    num_neighbors      = CUDA.zeros(Int, total_particles)
    areas              = CUDA.zeros(Float32, total_rings)
    particle_box_index = CUDA.zeros(Int, total_particles)
    # teste alocando mais particulas por caixa, original 4   
    max_particles_per_box=10*ceil(Int,particles_per_ring*box_lateral_size^2/area_target)
    #println("maximum of particles per box ",max_particles_per_box)    
    matrix_list_particles  = CUDA.zeros(Int,num_boxes, max_particles_per_box) #use 0 to indicate empty boxes                   
    counter = CUDA.zeros(Int,num_boxes) #counts the number of particles in each box       
    ring_particle_is_from_cpu = ceil.(collect(1:total_particles)/particles_per_ring) .|> Int
    ring_particle_is_from = CUDA.CuArray(ring_particle_is_from_cpu)

    return box_around, force_area_modulus, force_particle_x, force_particle_y, areas, particle_box_index, matrix_list_particles, counter,  ring_particle_is_from, num_neighbors
end

end
