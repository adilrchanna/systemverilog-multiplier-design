class monitor #(parameter N=8);
    virtual top_if #(N) vif;
    mailbox mon2scb;

    function new(virtual top_if #(N) vif, mailbox mon2scb);
        this.vif = vif;
        this.mon2scb = mon2scb;
    endfunction

    task main();
        transaction #(N) trans;

        forever begin
            @(posedge vif.clk);

            // check for parallel load
            if (vif.ea && vif.eb) begin
                
            fork
        		begin
            		// 1. capture inputs
            		bit [N-1:0] saved_a = vif.data_a;
            		bit [N-1:0] saved_b = vif.data_b;
            
            		// 2. wait for 2 clk latency
            		// DUT: Input Reg -> [Comb Logic] -> Output Reg
            		repeat(2) @(posedge vif.clk);
            
            		// 3. output
            		trans = new();
            		trans.a     = saved_a;
            		trans.b     = saved_b;
            		trans.p_out = vif.p_out;
            
            		mon2scb.put(trans);
            		trans.monitor_disp("MONITOR");
        		end
    		    join_none
            end
        end
    endtask
endclass
