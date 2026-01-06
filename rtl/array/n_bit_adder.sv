module n_bit_adder #(parameter N = 8) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic cin,
    output logic [N-1:0] sum,
    output logic cout
);
    wire [N:0] c;
    assign c[0] = cin;
    assign cout = c[N];

    genvar i;
    generate
        for (i = 0; i < N; i++) begin : adder_gen
            full_adder fa (
                .a(a[i]), 
                .b(b[i]), 
                .cin(c[i]), 
                .sum(sum[i]), 
                .cout(c[i+1])
            );
        end
    endgenerate
endmodule
