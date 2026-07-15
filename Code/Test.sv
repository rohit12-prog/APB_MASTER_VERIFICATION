class master_test;
  virtual apb_master drv_vif;
  virtual apb_master mon_vif;
  
  master_trans env;
  
  function new(virtual apb_master drv_vif, virtual apb_master mon_vif);
    this.drv_vif = drv_vif;
    this.mon_vif = mon_vif;
  endfunction
  
  
  task run();
    env = new(drv_vif,mon_vif);
    env.build();
    env.start();
  endtask
endclass
