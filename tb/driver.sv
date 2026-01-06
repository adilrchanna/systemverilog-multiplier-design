class driver #(parameter N=8);
    mailbox gen2drv;
    virtual top_if #(N) vif; 

    function new(mailbox gen2drv, virtual top_if #(N) vif);
        this.gen2drv = gen2drv;
        this.vif = vif;
    endfunction

    task reset();
        $display("[DRIVER] --- Reset Started ---");
        vif.rst_n   <= 0;
        vif.ea      <= 0;
        vif.eb      <= 0;
        vif.data_a  <= 0;
        vif.data_b  <= 0;
        repeat(2) @(posedge vif.clk);
        vif.rst_n   <= 1;
        $display("[DRIVER] --- Reset Ended ---");
    endtask

    // helper task 1: drive a valid transaction
    task drive_valid(transaction #(N) trans);
        @(posedge vif.clk);
        vif.data_a <= trans.a;
        vif.data_b <= trans.b;
        vif.ea     <= 1;
        vif.eb     <= 1;
        
        trans.driver_disp("DRIVER"); 
    endtask

    // helper task 2: insert hold state (with random inputs)
    task verify_hold_state();
        @(posedge vif.clk);
        vif.ea <= 0;
        vif.eb <= 0;
        
	      // 30% chance of injecting noise
        if ($urandom_range(0, 100) < 30) begin
            vif.data_a <= $urandom; 
            vif.data_b <= $urandom;
            repeat($urandom_range(0, 3)) @(posedge vif.clk);
        end

        // insert random number of idle cycles
        repeat($urandom_range(0, 3)) @(posedge vif.clk);
    endtask

    task main();
        transaction #(N) trans;
        
        forever begin
            gen2drv.get(trans);
            drive_valid(trans);
	          // 30% chance of hold state
            if ($urandom_range(0, 100) < 30) begin
                verify_hold_state();
            end
        end
    endtask
endclass
