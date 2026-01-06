module array_mult #(parameter N = 8) (
    input  logic [N-1:0] a, // multiplicand
    input  logic [N-1:0] b, // multiplier
    output logic [(2*N)-1:0] p // product
);

    // partial products (AND gates)
    logic [N-1:0] pp [0:N-1]; // N rows of partial products
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : pp_gen
            assign pp[i] = a & {N{b[i]}};
        end
    endgenerate

    // sum and carry between rows
    logic [N-1:0] sum  [1:N-1];
    logic         cout [1:N-1];

    // row 0
    assign p[0] = pp[0][0];

    // row 1
    // inputs: pp1 AND {0, pp0[N:1]}
    n_bit_adder #(N) row1 (
        .a(pp[1]), 
        .b({1'b0, pp[0][N-1:1]}), 
        .cin(1'b0), 
        .sum(sum[1]), 
        .cout(cout[1])
    );
    assign p[1] = sum[1][0];

    // row 2 to N
    // current PP + {previous carry, previous sum[N:1]}
    generate
        for (i = 2; i < N; i++) begin : row_gen
            n_bit_adder #(N) adder_row (
                .a(pp[i]),
                .b({cout[i-1], sum[i-1][N-1:1]}),
                .cin(1'b0),
                .sum(sum[i]),
                .cout(cout[i])
            );
            assign p[i] = sum[i][0];
        end
    endgenerate

    // final msb
    assign p[(2*N)-1:N] = {cout[N-1], sum[N-1][N-1:1]};

endmodule
