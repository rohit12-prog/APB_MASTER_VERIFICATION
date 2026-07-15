class master_trans;
  rand logic PREADY,PSLVERR;
  rand logic [`DATA_WIDTH-1:0] PRDATA;
  rand logic transfer,write_read;
  rand logic [`ADDR_WIDTH-1:0] addr_in;
  rand logic [`DATA_WIDTH-1:0] wdata_in;
  rand logic [STRB_WIDTH-1:0] strb_in;
  
  logic PSEL,PENABLE,PWRITE,transfer_done,error;
  logic [`ADDR_WIDTH-1:0] PADDR;
  logic [`DATA_WIDTH-1:0] PWDATA,rdata_out;
  logic [STRB_WIDTH-1:0] PSTRB;
  
  
  function master_trans copy();
    copy = new();
    copy.PREADY = this.PREADY;
    copy.PSLVERR = this.PSLVERR;
    copy.PRDATA = this.PRDATA;
    copy.transfer = this.transfer;
    copy.write_read = this.write_read;
    copy.addr_in = this.addr_in;
    copy.wdata_in = this.wdata_in;
    copy.strb_in = this.strb_in;
    return copy;
  endfunction
