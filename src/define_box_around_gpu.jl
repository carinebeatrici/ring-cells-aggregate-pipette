module Define_box_around

using CUDA

export define_box_around
    function define_box_around(box_around, num_boxes, number_boxes_x)
        box = (blockIdx().x - 1) * blockDim().x + threadIdx().x
        if box <= num_boxes
            box_around[1,box] = box # The box itself      
            box_around[2,box] = ( box % number_boxes_x == 1) ? 0 : box -1  #box left 
            box_around[3,box] = ( box % number_boxes_x == 0 ) ? 0 : box + 1 # box right 
            box_around[4,box] = ( box % number_boxes_x == 1|| box > num_boxes - number_boxes_x) ? 0 : box + number_boxes_x - 1 #box up left  
        box_around[5,box] = (box > num_boxes - number_boxes_x ) ? 0 : box + number_boxes_x  #box up 
        box_around[6,box] = ( box % number_boxes_x == 0 || box > num_boxes - number_boxes_x) ? 0 : box +  number_boxes_x + 1 #box up right  
        box_around[7,box] = ( box % number_boxes_x == 1 || box < number_boxes_x ) ? 0 : box - number_boxes_x - 1 #box down left   
        box_around[8,box] = ( box < number_boxes_x ) ? 0 : box - number_boxes_x  # box down 
        box_around[9,box] = ( box % number_boxes_x == 0 || box < number_boxes_x ) ? 0 : box - number_boxes_x + 1 #box down right  
    end
    return nothing
end

end
