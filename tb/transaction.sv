class transaction #(parameter N=8);
    // randomizable inputs
    rand bit [N-1:0] a;
    rand bit [N-1:0] b;

    // observed output (double width of inputs)
    bit [2*N-1:0] p_out;

    // display for driver (inputs only)
    function void driver_disp(string tag = "DRIVER");
        $display("[%s] Injecting A=%0d B=%0d", tag, a, b);
    endfunction

    // display for monitor
    function void monitor_disp(string tag = "MONITOR");
        $display("[%s] A=%0d B=%0d | P_out=%0d", tag, a, b, p_out);
    endfunction
endclass
