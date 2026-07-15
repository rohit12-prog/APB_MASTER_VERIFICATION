`include "defines.svh"
`include "Packages.sv"
`include "Interface.sv"
module top();
  
  import master_package ::*;
  
  logic PCLK = 0;
  logic PRESETn;
  
  
  initial
 	begin
 		forever #10 PCLK =	~PCLK; 
	 end
  
  initial
 	begin
      @(posedge PCLK);
 			reset=0;
      repeat(1)@(posedge PCLK);
 			reset=1;
 end
  
  
  apb_master intrf(PCLK,PRESETn);
  
  apb_master apb#(`ADDR_WIDTH,`DATA_WIDTH)(
    .PCLK(intrf.PCLK),.PRESETn(intrf.PRESETn),.PADDR(intrf.PADDR),  .PSEL(intrf(PSEL),.PENABLE(intrf.PENABLE),.PWRITE(intrf.PWRITE), .PWDATA(intrf.PWDATA),.PSTRB(intrf.PSTRB),.PRDATA(intrf(PRDATA),.PREADY(intrf.PREADY),.PSLVERR(intrf.PSLVERR),
.transfer(intrf.transfer),.write_read(intrf.write_read), .addr_in(intrf.addr_in),.wdata_in(intrf.wdata_in),
.strb_in(intrf.strb_in),.rdata_out(intrf.rdata_out),  .transfer_done(intrf.transfer_done),.error(intrf.error));

  
  master_test test = new(intrf.DRV,intrf.MON);
  
  initial
 	begin
 		test.run();
 		$finish();
 	end
