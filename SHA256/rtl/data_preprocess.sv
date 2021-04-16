`ifndef DATA_PREPROCESS
`define DATA_PREPROCESS


module data_preprocess 
(
  input                 clk,
  input                 rst,
  input  logic [32-1:0] stop_sig,
  input  logic [32-1:0] st_tra,
  input  logic [8-1:0]  datain,
 
  output logic [32-1:0] tra_start,
  output logic [32-1:0] w[16],
  output logic          FINISH_FLAG
);
int   i,idx,byte_cnt,pad_count;
int   temp;
logic [32-1:0] len;
logic [64-1:0] len_rawdata;
logic [32-1:0] len_frame;
logic [32-1:0] st_pad,st_pad1;

always_ff@(posedge clk )
  if (rst) begin
    for (i=0;i<16;i++)  w[i]<=32'b0;    
    idx<=0;len<=0;byte_cnt<=0;temp<=0;pad_count<=0;len_rawdata<=0;st_pad<=0;st_pad1<=0;tra_start<=0;len_frame<=0;FINISH_FLAG<=0;
  end else begin  
    if (stop_sig==0) begin   
          len<=len+8;
          len_rawdata<=len_rawdata+8;  
          len_frame<=len_frame+8;       
          w[idx]<=(w[idx]<<8)+datain;   

          if (byte_cnt==32'd3) begin 
              idx<=idx+1;byte_cnt<=32'b0;
          end else byte_cnt<=byte_cnt+1;       
    end else if(stop_sig==32'd1) begin     
      if(st_tra==32'd3) begin tra_start<=0;len<=0;len_frame<=0;idx<=0;
      end else  tra_start<=1;                
    end else if(stop_sig==32'd2) begin //pad 
        if(st_pad==0&&st_pad1==0)begin
            if(len_frame<448) st_pad<=32'd1;
            else st_pad1<=32'd1;
        end else if(st_pad>=32'd1 && st_pad1==32'd0)begin //<448
          if(st_pad==32'd1)begin                
              pad_count<=pad_count+1;    
              if(len==32'd448) st_pad<=32'd2;
              else begin
                if (pad_count==0) w[idx]<=(w[idx]<<8)+8'h80;  
                else              w[idx]<=(w[idx]<<8)+8'h00;        
                len<=len+8;
                byte_cnt<=byte_cnt+1;                           
                if (byte_cnt==32'd3) begin 
                  idx<=idx+1;
                  byte_cnt<=32'b0;
                end else temp<=0;                
              end               
          end else if(st_pad==32'd2) begin             
                w[14]<=len_rawdata[63:32];
                w[15]<=len_rawdata[31:0];    
                tra_start<=1;//开启transform
                len_rawdata<=0;//RESET
                len_frame<=0;
                len<=0; 
                st_pad<=32'd3;
                pad_count<=0;
                byte_cnt<=32'b0;
                idx<=0;               
          end else begin 
            if(st_tra==32'd3) begin FINISH_FLAG<=1;tra_start<=0;st_pad<=0; //等待transform完成
            end else temp<=0;  //idle
          end
        end else if(st_pad==32'd0 && st_pad1>=32'd1) begin //>=448
          if(st_pad1==31'd1)begin
            if(len==32'd512) begin
              st_pad1<=32'd2;tra_start<=32'd1;
            end else begin 
              pad_count<=pad_count+1;
              if (pad_count==0) w[idx]<=(w[idx]<<8)+8'h80;  
              else              w[idx]<=(w[idx]<<8)+8'h00;          
              len<=len+8;
              byte_cnt<=byte_cnt+1;                           
              if (byte_cnt==32'd3) begin 
                idx<=idx+1;
                byte_cnt<=32'b0;
              end else temp<=0;                 

            end
          end else if(st_pad1==31'd2)begin //idle,等待一次transfrom完成
            if(st_tra==32'd3) begin len<=0;idx<=0;tra_start<=0;st_pad1<=32'd3; //等待transform完成
            end else temp<=0;  //idle                      
          end else if(st_pad1==31'd3)begin              
              if(len==32'd448) st_pad1<=32'd4;
              else begin
                pad_count<=pad_count+1;   
                if (pad_count==0) w[idx]<=(w[idx]<<8)+8'h80;  
                else              w[idx]<=(w[idx]<<8)+8'h00;        
                len<=len+8;
                byte_cnt<=byte_cnt+1;                           
                if (byte_cnt==32'd3) begin 
                  idx<=idx+1;
                  byte_cnt<=32'b0;
                end else temp<=0;                
              end                
          end else if(st_pad1==31'd4)begin
              w[14]<=len_rawdata[63:32];
              w[15]<=len_rawdata[31:0];    
              tra_start<=1;//开启transform
              len_rawdata<=0;//RESET
              len_frame<=0;
              len<=0; 
              st_pad1<=32'd5;
              pad_count<=0;
              byte_cnt<=32'b0;
              idx<=0; 
          end else begin
              if(st_tra==32'd3) begin FINISH_FLAG<=1;tra_start<=0;st_pad1<=0; //等待transform完成
              end else temp<=0;  //idle
          end

        end else temp<=0;  //idle
    end else   FINISH_FLAG<=0;  //idle
  end
endmodule
`endif

