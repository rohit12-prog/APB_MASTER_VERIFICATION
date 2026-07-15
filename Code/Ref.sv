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
      
      if(ref_trans.PSEL==1) begin
        if(ref_trans.PENABLE==1)
  
