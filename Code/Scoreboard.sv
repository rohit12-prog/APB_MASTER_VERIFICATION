class master_sc;
  mailbox #(master_trans)mbx_rs;
  mailbox #(master_trans)mbx_ms;
  
  master_trans ref2sb_trans,mon2sb_trans;
//   logic [`DATA_WIDTH-1:0] ref_mem [`DATA_DEPTH-1:0];
//   logic [`DATA_WIDTH-1:0] mon_mem [`DATA_DEPTH-1:0];
  
  int MATCH = 0;
  int MISMATCH = 0;
  
  
  function new(mailbox #(master_trans)mbx_rs,mailbox #(master_trans)mbx_ms);
    this.mbx_rs = mbx_rs;
    this.mbx_ms = mbx_ms;
  endfunction
  
task start();  
  for(int i = 0; i < `num_trans; i++) begin
    mon2sb_trans = new();
    ref2sb_trans = new();
      fork
        mbx_rs.get(ref2sb_trans);
        mbx_ms.get(mon2sb_trans);
      join

      
    if (ref2sb_trans.PSEL == mon2sb_trans.PSEL   &&
          ref2sb_trans.PENABLE == mon2sb_trans.PENABLE &&
          ref2sb_trans.PWRITE == mon2sb_trans.PWRITE  &&
          ref2sb_trans.PADDR == mon2sb_trans.PADDR   &&
          ref2sb_trans.PWDATA == mon2sb_trans.PWDATA  &&
          ref2sb_trans.PSTRB == mon2sb_trans.PSTRB   &&
         ref2sb_trans.rdata_out == mon2sb_trans.rdata_out&&
     ref2sb_trans.transfer_done == mon2sb_trans.transfer_done 			&& ref2sb_trans.error == mon2sb_trans.error)
        begin
        MATCH++;
        $display("[%0t] [SCB] #%0d PASS", $time, i);
      end
      else begin
        MISMATCH++;
        $display("[%0t] [SCB] #%0d FAIL | exp: PSEL=%0b PENABLE=%0b PWRITE=%0b PADDR=0x%0h PWDATA=0x%0h PSTRB=0x%0h rdata_out=0x%0h transfer_done=%0b error=%0b | act: PSEL=%0b PENABLE=%0b PWRITE=%0b PADDR=0x%0h PWDATA=0x%0h PSTRB=0x%0h rdata_out=0x%0h transfer_done=%0b error=%0b",
                  $time, i,
                  ref2sb_trans.PSEL, ref2sb_trans.PENABLE, ref2sb_trans.PWRITE, ref2sb_trans.PADDR,
                  ref2sb_trans.PWDATA, ref2sb_trans.PSTRB, ref2sb_trans.rdata_out,
                  ref2sb_trans.transfer_done, ref2sb_trans.error,
                  mon2sb_trans.PSEL, mon2sb_trans.PENABLE, mon2sb_trans.PWRITE, mon2sb_trans.PADDR,
                  mon2sb_trans.PWDATA, mon2sb_trans.PSTRB, mon2sb_trans.rdata_out,
                  mon2sb_trans.transfer_done, mon2sb_trans.error);
      end
  end
  report();
endtask
 

  function void report();
    $display("=================================================");
 $display(" SCOREBOARD SUMMARY: total=%0d  match=%0d  mismatch=%0d",MATCH + MISMATCH, MATCH, MISMATCH);
    $display("=================================================");
 if (MISMATCH == 0) $display(" ***** TEST PASSED *****");
    else $display(" ***** TEST FAILED *****");
  endfunction

endclass
  
