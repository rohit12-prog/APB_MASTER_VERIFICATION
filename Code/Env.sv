class master_environment;
  virtual apb_master drv_vif;
  virtual apb_master mon_vif;
  
  mailbox #(master_trans)mbx_gd;
  mailbox #(master_trans)mbx_dr;
  mailbox #(master_trans)mbx_rs;
  mailbox #(master_trans)mbx_ms;
  
  master_generator gen;
  master_driver drv;
  master_ref ref_m;
  master_mon mn;
  master_sc sc;
  
  
  function new (virtual apb_master drv_vif,virtual apb_master mon_vif);
 			this.drv_vif=drv_vif;
 			this.mon_vif=mon_vif;
 endfunction
  
  task build();
    begin
      
    	mbx_gd=new();
 		mbx_dr=new();
 		mbx_rs=new();
 		mbx_ms=new();
 
 		gen=new(mbx_gd);
 		drv=new(mbx_gd,mbx_dr,drv_vif);
 		mn=new(mbx_ms,mon_vif);
 		ref_m=new(mbx_dr,mbx_rs);
 		sc=new(mbx_rs,mbx_ms);
 	end
 endtask
  
  
  task start();
 	fork
 		gen.start();
 		drv.start();
 		mn.start();
 		sc.start();
 		ref_m.start();
 	join
 	//sc.report();
 endtask
endclass
  
  
