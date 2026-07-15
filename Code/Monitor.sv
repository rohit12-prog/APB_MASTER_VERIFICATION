class master_mon;
  mailbox #(master_trans)mbx_ms;
  virtual apb_master.MON vif;
  master_trans mon_trans;
  
  function new(mailbox #(master_trans)mbx_ms, virtual apb_master.MON vif);
    this.mbx_ms = mbx_ms;
    this.vif = vif;
  endfunction
  
  
  task start();
    repeat(4) @(vif.mon_cb);
    for(int i = 0; i < `num_trans; i++) begin
      mon_trans = new();
      mon_trans.PADDR = vif.mon_cb.PADDR;
      mon_trans.PSEL = vif.mon_cb.PSEL;
      mon_trans.PENABLE = vif.mon_cb.PENABLE;
      mon_trans.PWRITE = vif.mon_cb.PWRITE;
      mon_trans.PWDATA = vif.mon_cb.PWDATA;
      mon_trans.PSTRB = vif.mon_cb.PSTRB;
      mon_trans.rdata_out = vif.mon_cb.rdata_out;
      mon_trans.transfer_done = vif.mon_cb.transfer_done;
      mon_trans.error = vif.mon_cb.error;
      
      $display("[%0t] [MON] PSEL=%0b PENABLE=%0b PWRITE=%0b PADDR=0x%0h PWDATA=0x%0h PSTRB=0x%0h | rdata_out=0x%0h transfer_done=%0b error=%0b",$time, mon_trans.PSEL, mon_trans.PENABLE, mon_trans.PWRITE, mon_trans.PADDR,
mon_trans.PWDATA, mon_trans.PSTRB, mon_trans.rdata_out,
mon_trans.transfer_done, mon_trans.error);
      
      mbx_ms.put(mon_trans);
    end
  endtask
endclass
    
  
