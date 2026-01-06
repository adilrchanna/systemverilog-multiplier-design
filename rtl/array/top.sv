module top #(parameter N = 8) (
    input  logic        clk,
    input  logic        rst_n, 
    input  logic        ea,     // enable A
    input  logic        eb,     // enable B

    input  logic [N-1:0] data_a, 
    input  logic [N-1:0] data_b, 
    output logic [2*N-1:0] p_out 
);

    logic [N-1:0] reg_a;
    logic [N-1:0] reg_b;
    logic [2*N-1:0] mult_result;

    // 1. parallel input registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_a <= 0;
            reg_b <= 0;
        end else begin
            if (ea) reg_a <= data_a; // load data to reg A
            if (eb) reg_b <= data_b; // load data to reg B
        end
    end

    // 2. multiplier core
    array_mult #(N) core ( .a(reg_a), .b(reg_b), .p(mult_result) );

    // 3. output register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) p_out <= 0;
        else        p_out <= mult_result;
    end

endmodule
