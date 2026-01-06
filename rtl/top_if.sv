interface top_if #(parameter N = 8) (input bit clk);
    logic           rst_n;
    logic           ea;
    logic           eb;

    logic [N-1:0]   data_a;
    logic [N-1:0]   data_b;
    logic [(2*N-1):0] p_out;
endinterface
