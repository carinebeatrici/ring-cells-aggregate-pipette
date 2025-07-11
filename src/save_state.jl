module Save_state

export save_state

#Saves time, x and y for all rings 
    function save_state(time, x_positions_cpu, y_positions_cpu, output_path)
        partial_save = open("$(output_path)/save_state.txt", "a")
        println(partial_save, "#First line below - time -- Remaining lines - x and y ")
        println(partial_save, time)
        for  (xi, yi) in zip(x_positions_cpu, y_positions_cpu)
            println(partial_save, xi, " ",yi)
        end
        close(partial_save)
    end
end
