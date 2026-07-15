interface apb_master(input bit PCLK,PRESETn);
  logic transfer,write_read,transfer_done,error;
  logic [`ADDR_WIDTH-1:0] addr_in;
  logic [`DATA_WIDTH-1:0] wdata_in,rdata_out;
  logic [STRB_WIDTH-1:0] strb_in;
  
  logic PSEL,PENABLE,PWRITE,PREADY,PSLVERR;
  logic [`ADDR_WIDTH-1:0] PADDR;
  logic [`DATA_WIDTH-1:0] PWDATA,PRDATA;
  logic [STRB_WIDTH-1:0] PSTRB;
  
  clocking drv_cb @(PCLK);
    default input #0 output #0;
    output transfer,write_read,addr_in,wdata_in,strb_in,
    PRDATA,PREADY,PSLVERR;
    //input PRESETn;
  endclocking
  
  clocking mon_cb @(PCLK);
    input PRESETn, PADDR,PSEL,PENABLE,PWRITE,PWDATA,PSTRB,
    rdata_out,transfer_done,error;
    input transfer,write_read,addr_in,wdata_in,strb_in,
    PRDATA,PREADY,PSLVERR;
  endclocking
  
  modport DRV(clocking drv_cb,input PRESETn);
 modport MON(clocking mon_cb);
  
endinterface
    
    
