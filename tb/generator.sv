class generator #(parameter N=8);
    transaction #(N) trans;
    mailbox gen2drv;
    event ended;
    int repeat_count;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task main();
        repeat(repeat_count) begin
        trans = new();
            
	    // randomize check
        if (!trans.randomize()) begin
            $fatal("[GEN] Transaction randomization failed!");
        end
            
        gen2drv.put(trans);
        end
        -> ended; // end of generation
    endtask
endclass
