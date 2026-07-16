class master_driver;
  mailbox #(master_trans) mbx_gd;
  virtual apb_master.DRV vif;
  master_trans drv_trans;
  mailbox #(master_trans) mbx_dr;
  
  covergroup cg;
    TR: coverpoint drv_trans.transfer{bins t[] = {0,1};}
    W_R:coverpoint drv_trans.write_read{bins wr[] = {0,1};}
    AD: coverpoint drv_trans.addr_in{
	bins low_addr  = {[0:63]};
    	bins mid_addr  = {[64:127]};
    	bins high_addr = {[128:255]};}
    WI: coverpoint drv_trans.wdata_in;
    ST: coverpoint drv_trans.strb_in{bins si[]= {[0:15]};}
    RI: coverpoint drv_trans.PRDATA;
    R: coverpoint drv_trans.PREADY{bins ready[]= {0,1};}
    SL: coverpoint drv_trans.PSLVERR{bins sl[]= {0,1};}
  endgroup
                                      
    
  
  
  function new(mailbox #(master_trans)mbx_gd, mailbox #(master_trans)mbx_dr, virtual apb_master.DRV vif);
    this.mbx_gd = mbx_gd;
    this.mbx_dr = mbx_dr;
    this.vif    = vif;
    cg = new();
  endfunction
  
  
  task start();
    repeat(2) @(vif.drv_cb);
    for(int i=0;i<`num_trans;i++)
 		begin
          fork
 			begin
            repeat(1) @(vif.drv_cb)
 			begin
              drv_trans=new();

 			mbx_gd.get(drv_trans);

            $display("time = %0t Driver GET",$time);
              vif.drv_cb.transfer <= drv_trans.transfer;
              vif.drv_cb.write_read <= drv_trans.write_read;
              vif.drv_cb.addr_in <= drv_trans.addr_in;
              vif.drv_cb.wdata_in <= drv_trans.wdata_in;
              vif.drv_cb.strb_in <= drv_trans.strb_in;
              vif.drv_cb.PRDATA <= drv_trans.PRDATA;
            end
              repeat(`wait_state) @(vif.drv_cb);
              vif.drv_cb.PREADY <= drv_trans.PREADY;
              vif.drv_cb.PSLVERR <= drv_trans.PSLVERR;
            
            @(vif.drv_cb);
            cg.sample();
            mbx_dr.put(drv_trans);
        end
           
      
      
      begin
        wait(vif.drv_cb.reset == 0);
		vif.drv_cb.transfer <= 0;
                vif.drv_cb.write_read <= 0;
                vif.drv_cb.addr_in <= 0;
                vif.drv_cb.wdata_in <= 0;
                vif.drv_cb.strb_in <= 0;
                vif.drv_cb.PRDATA <= 0;
                vif.drv_cb.PREADY <= 0;
                vif.drv_cb.PSLVERR <= 0;
                
                drv_trans.transfer = 0;
                drv_trans.write_read = 0;
                drv_trans.addr_in = 0;
                drv_trans.wdata_in = 0;
                drv_trans.strb_in = 0;
                drv_trans.PRDATA = 0;
                drv_trans.PREADY = 0;
                drv_trans.PSLVERR = 0;
                
                $display("PUT DRIVER Reset = %0t",$time);
                mbx_dr.put(drv_trans);
      end
    join_any
    disable fork;
      
    	/*	vif.drv_cb.transfer <= 0;
                vif.drv_cb.write_read <= 0;
                vif.drv_cb.addr_in <= 0;
                vif.drv_cb.wdata_in <= 0;
                vif.drv_cb.strb_in <= 0;
                vif.drv_cb.PRDATA <= 0;
                vif.drv_cb.PREADY <= 0;
                vif.drv_cb.PSLVERR <= 0;
                
                drv_trans.transfer = 0;
                drv_trans.write_read = 0;
                drv_trans.addr_in = 0;
                drv_trans.wdata_in = 0;
                drv_trans.strb_in = 0;
                drv_trans.PRDATA = 0;
                drv_trans.PREADY = 0;
                drv_trans.PSLVERR = 0;
                
                $display("PUT DRIVER Reset = %0t",$time);
                mbx_dr.put(drv_trans);
	*/
                
                $display("[%0t] [DRV] Driving Interface |transfer=%0b | write_read=%0b | addr_in=0x%0h | wdata_in=0x%0h | strb_in=0x%0h | PRDATA=0x%0h | PREADY=%0b | PSLVERR=%0b",$time,drv_trans.transfer,drv_trans.write_read,drv_trans.addr_in,drv_trans.wdata_in,drv_trans.strb_in,drv_trans.PRDATA,drv_trans.PREADY,drv_trans.PSLVERR);
      
      end
      endtask
      endclass
      
    
    
              
                
