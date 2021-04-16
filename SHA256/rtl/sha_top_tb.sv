
`timescale 1ns/100ps

`define SHA256_TEST		"abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdef"
`define Length_TEST   120

`define SHA256_TEST1	"abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcda"
`define Length_TEST1   129
//3   24    abc
//55  440   abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcde
//56  448   abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdef
//57  456   abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefg
//63  504   abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabc
//64  512   abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcd
//67  536   abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdabc
//120 960   abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdef
//128 1024  abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcd
//129 1032  abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcda


module sha_top_tb;



logic clk,rst;
//message
parameter N=`Length_TEST;
parameter N1=`Length_TEST1;
logic     [N*8-1:0] str;
logic     [N1*8-1:0] str1;

//data
logic [7:0]     datain;
logic [32-1:0]  hash[8];
logic [256-1:0] Hash;
//control
logic FINISH_FLAG,FINISH_FLAG_LAST;
logic [32-1:0]st_tra,stop_sig;
//testbench count
int p1,p2;

always  #4 clk=~clk; 

initial 
  begin
    stop_sig=32'd3;//空闲
    clk = 1'b0;
    rst = 1'b1;    
    str=`SHA256_TEST;  
    str1=`SHA256_TEST1;  
    #7;  
    rst = 1'b0;

//第一个字符串转换
    for(p1=0;p1<=N;)
      @(posedge clk)  begin 
           if(p1==0) begin   
            stop_sig<=32'd0; //开启传输
            datain<=str[N*8-1:N*8-8];    
            str<=str<<8;   
            p1<=p1+1;
           end 

           if(p1%64==0  && p1!=N && p1!=0) begin       //传入满512位，但未结束
              if(st_tra==32'd3) begin 
                  stop_sig<=0;
                  datain<=str[N*8-1:N*8-8];    
                  str<=str<<8;   
                  p1<=p1+1;
              end else stop_sig<=32'd1;           //压入512位
           end else if(p1==N) begin   //传输结束
              if(FINISH_FLAG==32'd1)begin  //计算结束
                p1<=p1+1;stop_sig<=32'd3;   //idle             
              end else stop_sig<=32'd2;
           end else begin
            datain<=str[N*8-1:N*8-8];    
            str<=str<<8;   
            p1<=p1+1;
           end     
      end

    #300;  

//一个复位信号   
    rst = 1'b1;
    #7;  
    rst = 1'b0;

//第二个字符串转换
    for(p1=0;p1<=N1;)
      @(posedge clk)  begin 
           if(p1==0) begin   
            stop_sig<=32'd0; //开启传输
            datain<=str1[N1*8-1:N1*8-8];    
            str1<=str1<<8;   
            p1<=p1+1;
           end 

           if(p1%64==0  && p1!=N1 && p1!=0) begin       //传入满512位，但未结束
              if(st_tra==32'd3) begin 
                  stop_sig<=0;
                  datain<=str1[N1*8-1:N1*8-8];    
                  str1<=str1<<8;   
                  p1<=p1+1;
              end else stop_sig<=32'd1;           //压入512位
           end else if(p1==N1) begin   //传输结束
              if(FINISH_FLAG==32'd1)begin  //计算结束
                p1<=p1+1;stop_sig<=32'd3;   //idle             
              end else stop_sig<=32'd2;
           end else begin
            datain<=str1[N1*8-1:N1*8-8];    
            str1<=str1<<8;   
            p1<=p1+1;
           end     
      end


end    










sha_top  dut_sha_top (
.clk(clk),
.rst(rst),
.stop_sig(stop_sig),
.st_tra(st_tra),
.datain(datain),
.FINISH_FLAG(FINISH_FLAG),
.hash(hash)
);



always_ff@(posedge clk )begin
  FINISH_FLAG_LAST<=FINISH_FLAG;

  if(FINISH_FLAG_LAST==1&&FINISH_FLAG==0)begin //FINISH_FLAG下降沿
     Hash<={hash[0],hash[1],hash[2],hash[3],hash[4],hash[5],hash[6],hash[7]};              
     p2<=1;
  end 
  if(p2==1) begin $display("Hash=%h",Hash); p2<=0;
  end


end


endmodule
