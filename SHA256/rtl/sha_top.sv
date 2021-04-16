`ifndef SHA_TOP
`define SHA_TOP


module sha_top 
(
  input                 clk,
  input                 rst,
  input  logic [32-1:0] stop_sig,
  input  logic [8-1:0]  datain,
 
  output logic [32-1:0] st_tra,
  output logic          FINISH_FLAG,
  output logic [32-1:0] hash[8]
);

logic [32-1:0]w[16];
logic [32-1:0]tra_start;




data_preprocess dut_data_preprocess(
.clk(clk),
.rst(rst),
.stop_sig(stop_sig),
.st_tra(st_tra),
.datain(datain),
.tra_start(tra_start),
.w(w),
.FINISH_FLAG(FINISH_FLAG)
);

sha_transform dut_sha_transform(
.clk(clk),
.rst(rst),
.tra_start(tra_start),
.W_16(w),
.st_tra(st_tra),
.hash(hash)
);

endmodule
`endif

