class scoreboard #(parameter N=8);
    mailbox mon2scb;
    int transactions_verified = 0;

    function new(mailbox mon2scb);
        this.mon2scb = mon2scb;
    endfunction

    task main();
        transaction #(N) trans;
        bit [2*N-1:0] expected;

        forever begin
            mon2scb.get(trans);

	          // expected result
            expected = trans.a * trans.b;

            // actual result
            if (trans.p_out == expected) begin
                $display("[SCB] PASS: %0d * %0d = %0d", trans.a, trans.b, trans.p_out);
            end else begin
                $error("[SCB] FAIL: A=%0d B=%0d | Exp=%0d Got=%0d", 
                        trans.a, trans.b, expected, trans.p_out);
            end

            transactions_verified++;
        end
    endtask
endclass
