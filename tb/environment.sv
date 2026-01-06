class environment #(parameter N=8);
    generator  #(N) gen;
    driver     #(N) drv;
    monitor    #(N) mon;
    scoreboard #(N) scb;

    mailbox gen2drv;
    mailbox mon2scb;

    virtual top_if #(N) vif;

    function new(virtual top_if #(N) vif);
        this.vif = vif;

        gen2drv = new();
        mon2scb = new();

        gen = new(gen2drv);
        drv = new(gen2drv, vif); // Driver gets the top_if handle
        mon = new(vif, mon2scb); // Monitor gets the top_if handle
        scb = new(mon2scb);
    endfunction

    task test();
        fork

            gen.main();
            begin 
                drv.reset(); 
                drv.main();  
            end
            mon.main();
            scb.main();
        join_any
    endtask

    task run();
        test();

        wait(gen.ended.triggered);
        wait(scb.transactions_verified == gen.repeat_count);
        
        $display("[ENV] All %0d transactions verified. Finishing...", gen.repeat_count);
        $finish;
    endtask
endclass
