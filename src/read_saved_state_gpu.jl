module Read_saved_state

using CUDA

export read_saved_state
function read_saved_state(output_path)
    partial_read = open("$(output_path)/save_state.txt" , "r")
    readline(partial_read)
    time = eval(Meta.parse(readline(partial_read)))
    x_cpu = eval(Meta.parse(readline(partial_read))) #reads string and converts to float 
    y_cpu = eval(Meta.parse(readline(partial_read))) #reads string and converts to float 
    close(partial_read)
    x_positions = CUDA.CuArray(x_cpu)
    y_positions = CUDA.CuArray(x_cpu)

    return time, x_positions, y_positions
end

end
