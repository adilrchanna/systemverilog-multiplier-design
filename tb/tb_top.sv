module tb_top;

    import multiplier_pkg::*;
    parameter N = 8;
    
    bit clk;
    always #5 clk = ~clk;

    // 1. interface instantiation
    top_if #(N) intf(clk);

    // 2. DUT instantiation
    top #(N) dut (
        .clk(intf.clk),
        .rst_n(intf.rst_n),
        .ea(intf.ea),
        .eb(intf.eb), 
        
        // bus A and bus B
        .data_a(intf.data_a),   
        .data_b(intf.data_b),   
        
        .p_out(intf.p_out)      // result (width = 2*N)
    );

    // 3. environment instantiation
    environment #(N) env;

    initial begin
        env = new(intf);
        
        env.gen.repeat_count = 50;
        env.run();
    end

endmodule
