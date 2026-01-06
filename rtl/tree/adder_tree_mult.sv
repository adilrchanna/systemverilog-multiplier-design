module adder_tree_mult #(parameter N = 16) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [2*N-1:0] p
);

    // 1. partial product generation
    logic [2*N-1:0] pp [N]; 
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : pp_gen
            // Zero-pad 'a' to full width then shift
            assign pp[i] = (b[i]) ? ({ {N{1'b0}}, a } << i) : '0;
        end
    endgenerate

    // 2. 2D adder tree
    // Calculate depth. For N=8, log2(8) = 3 levels
    localparam LEVELS = $clog2(N);
    
    // 2D array: [level][index within level]
    logic [2*N-1:0] tree [LEVELS+1][N];

    // load the leaves (partial products)
    genvar j;
    generate
        for (j = 0; j < N; j++) begin : leaves
            assign tree[0][j] = pp[j];
        end
    endgenerate

    // loop from 0 to LEVELS-1 to build the tree upwards
    genvar level, k;
    generate
        for (level = 0; level < LEVELS; level++) begin : stage
            // for each level, number of adders is half the previous level.
            // (N >> (level+1)) to divide N by 2^(level+1)
            for (k = 0; k < (N >> (level + 1)); k++) begin : adder
                assign tree[level+1][k] = tree[level][2*k] + tree[level][2*k+1];
            end
        end
    endgenerate

    // 3. output
    assign p = tree[LEVELS][0];

endmodule
