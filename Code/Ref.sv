class master_ref;
  mailbox #(master_trans)mbx_dr;
  mailbox #(master_trans)mbx_rs;
  master_trans ref_trans;
  
  
  reg [`DATA_WIDTH-1:0] MEM [`DATA_DEPTH-1:0];
  
  function new(mailbox #(master_trans)mbx_dr, mailbox #(master_trans)mbx_rs);
    this.mbx_dr = mbx_dr;
    this.mbx_rs = mbx_rs;
  endfunction
  
  task start();
    for(int i =0; i <`num_trans; i++) begin
      ref_trans = new();
      mbx_dr.get(ref_trans);
      
      if(ref_trans.transfer == 1) begin
        ref_trans.PSEL = 1'b1;
        ref_trans.PSTRB = ref_trans.strb_in ;
        ref_trans.PWRITE = ref_trans.write_read;
        ref_trans.PADDR = ref_trans.addr_in;
        ref_trans.PWDATA = ref_trans.wdata_in;
        ref_trans.PENABLE = 1'b1;
        
        
        if(ref_trans.PREADY == 1 && ref_trans.write_read == 1 && ref_trans.PSLVERR == 0)begin
          for(int i = 0; i < STRB_WIDTH; i++) begin
            if(ref_trans.strb_in[i] == 1)begin
              MEM[ref_trans.addr_in][i*8+:8] = ref_trans.wdata_in[i*8:8];
            end
          end
        end
        
        if(ref_trans.PREADY ==1 && ref_trans.write_read == 0 && ref_trans.PSLVERR == 0)begin
          ref_trans.rdata_out = MEM[ref_trans.addr_in];
        end
        
        if(ref_trans.PREADY == 1 && ref_trans.PSLVERR == 0)
          begin
            ref_trans.transfer_done = 1'b1;
          end
        
        if (ref_trans.PREADY ==1 && ref_trans.PSLVERR == 1'b1) 
          begin
            ref_trans.error = ref_trans.PSLVERR;
  			$display("[%0t] [REF] ERROR transaction: %s addr=0x%0h  MEM not updated/checked",$time, ref_trans.write_read ? "WRITE" : "READ", ref_trans.addr_in);
	 end
      end
      
      else begin
        ref_trans.PSEL          = 1'b0;
        ref_trans.PENABLE       = 1'b0;
        ref_trans.rdata_out     = '0;
        ref_trans.transfer_done = 1'b0;
        ref_trans.error         = 1'b0;
      end

      $display("[%0t] [REF] predicted PSEL=%0b PENABLE=%0b PWRITE=%0b PADDR=0x%0h PWDATA=0x%0h PSTRB=0x%0h | rdata_out=0x%0h transfer_done=%0b error=%0b",
                $time, ref_trans.PSEL, ref_trans.PENABLE, ref_trans.PWRITE, ref_trans.PADDR,
                ref_trans.PWDATA, ref_trans.PSTRB, ref_trans.rdata_out, ref_trans.transfer_done, ref_trans.error);

      mbx_rs.put(ref_trans); 
    end
  endtask
endclass

       			
          
          
  
