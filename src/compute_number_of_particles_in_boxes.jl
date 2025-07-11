# # Function to compute the size of the output matrix for particles in each box          
# function compute_number_of_particles_in_boxes(particle_box_index, counter, total_parti\cles)                                                                                    
#     # Calculate the number of particles                                                
#     idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x                            
#     if idx <= total_particles  # Check bounds                                          
#        box_index = particle_box_index[idx]                                             
#         CUDA.@atomic counter[box_index] += 1                                           
#     end                                                                                
#     return nothing                                                                     
# end                                                                                    


# function compute_number_of_particles_in_boxes_cpu(particle_box_index, counter, total_p\articles)                                                                                
#     # Calculate the number of particles                                                
#     for part in 1:total_particles  # Check bounds                                      
#         box_index = particle_box_index[part]                                           
#         counter[box_index] += 1                                                        
#     end                                                                                
#     return nothing                                                                     
# end
