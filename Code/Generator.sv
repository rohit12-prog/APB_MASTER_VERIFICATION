class master_generator;
  master_trans mt;
  mailbox #(master_trans)mbx_gd;
  
  function new(mailbox #(master_trans)mbx_gd);
    this.mbx_gd = mbx_gd;
    mt = new();
  endfunction
  
  task start();
    for(int i = 0; i < `num_trans; i++) begin
      assert(mt.randomize());
      mbx_gd.put(mt.copy());
      $display("[%0t] [%s] TXN#%0d | rst=%0b | transfer=%0b | dir=%-5s | addr=0x%0h | wdata=0x%0h | strb=0x%0h | prdata=0x%0h | pready=%0b | pslverr=%0b", $time, tag, txn_id,PRESETn, transfer,(write_read ? "WRITE" : "READ"),addr_in, wdata_in, strb_in,PRDATA, PREADY, PSLVERR);
    end
  endtask
endclass
      
