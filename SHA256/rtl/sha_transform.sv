`ifndef SHA_TRANSFORM
`define SHA_TRANSFORM


module sha_transform 
(
  input                 clk,
  input                 rst,
  input  logic [32-1:0] tra_start,
  input  logic [32-1:0] W_16[16],

  output logic [32-1:0] st_tra,
  output logic [32-1:0] hash[8]
);
logic [32-1:0]k[64];
int i,idx,st_tra0_cnt;
logic [32-1:0] s0,s1,S0,S1,ch,maj,W_64[64];
logic temp;
logic [32-1:0]a,b,c,d,e,f,g,h;

assign S1= {e[5:0],e[31:6]}^{e[10:0],e[31:11]}^{e[24:0],e[31:25]};
assign S0= {a[1:0],a[31:2]}^{a[12:0],a[31:13]}^{a[21:0],a[31:22]};
assign ch= (e&f)^((~e)&g);
assign maj=(a&b)^(a&c)^(b&c);

always_ff @( posedge clk ) begin 
  if(rst) begin
    for (i=0;i<64;i++) W_64[i]<=0;   
    idx<=32'd16;temp<=0;s0<=0;s1<=0;st_tra<=0;st_tra0_cnt<=0;
    hash[0]<=32'h6a09e667;hash[1]<=32'hbb67ae85;hash[2]<=32'h3c6ef372;hash[3]<=32'ha54ff53a;
    hash[4]<=32'h510e527f;hash[5]<=32'h9b05688c;hash[6]<=32'h1f83d9ab;hash[7]<=32'h5be0cd19; 
    a<=32'h6a09e667;b<=32'hbb67ae85;c<=32'h3c6ef372;d<=32'ha54ff53a;
    e<=32'h510e527f;f<=32'h9b05688c;g<=32'h1f83d9ab;h<=32'h5be0cd19;  
    k[0]<=32'h428a2f98;k[1]<=32'h71374491;k[2]<=32'hb5c0fbcf;k[3]<=32'he9b5dba5;k[4]<=32'h3956c25b;
    k[5]<=32'h59f111f1;k[6]<=32'h923f82a4;k[7]<=32'hab1c5ed5;k[8]<=32'hd807aa98;k[9]<=32'h12835b01;
    k[10]<=32'h243185be;k[11]<=32'h550c7dc3;k[12]<=32'h72be5d74;k[13]<=32'h80deb1fe;k[14]<=32'h9bdc06a7;
    k[15]<=32'hc19bf174;k[16]<=32'he49b69c1;k[17]<=32'hefbe4786;k[18]<=32'h0fc19dc6;k[19]<=32'h240ca1cc;
    k[20]<=32'h2de92c6f;k[21]<=32'h4a7484aa;k[22]<=32'h5cb0a9dc;k[23]<=32'h76f988da;k[24]<=32'h983e5152;
    k[25]<=32'ha831c66d;k[26]<=32'hb00327c8;k[27]<=32'hbf597fc7;k[28]<=32'hc6e00bf3;k[29]<=32'hd5a79147;
    k[30]<=32'h06ca6351;k[31]<=32'h14292967;k[32]<=32'h27b70a85;k[33]<=32'h2e1b2138;k[34]<=32'h4d2c6dfc;
    k[35]<=32'h53380d13;k[36]<=32'h650a7354;k[37]<=32'h766a0abb;k[38]<=32'h81c2c92e;k[39]<=32'h92722c85;
    k[40]<=32'ha2bfe8a1;k[41]<=32'ha81a664b;k[42]<=32'hc24b8b70;k[43]<=32'hc76c51a3;k[44]<=32'hd192e819;
    k[45]<=32'hd6990624;k[46]<=32'hf40e3585;k[47]<=32'h106aa070;k[48]<=32'h19a4c116;k[49]<=32'h1e376c08;
    k[50]<=32'h2748774c;k[51]<=32'h34b0bcb5;k[52]<=32'h391c0cb3;k[53]<=32'h4ed8aa4a;k[54]<=32'h5b9cca4f;
    k[55]<=32'h682e6ff3;k[56]<=32'h748f82ee;k[57]<=32'h78a5636f;k[58]<=32'h84c87814;k[59]<=32'h8cc70208;
    k[60]<=32'h90befffa;k[61]<=32'ha4506ceb;k[62]<=32'hbef9a3f7;k[63]<=32'hc67178f2;
  end else begin
    if(tra_start==0)begin  //idle
      temp<=0;st_tra<=0;st_tra0_cnt<=0;
    end else begin
          if(st_tra==32'd0)begin  //calculate W[16:63]     
              if(st_tra0_cnt==0)begin
                for(i=0;i<16;i++) W_64[i]<=W_16[i];
                st_tra0_cnt<=32'd1;idx<=16;
              end else begin
                W_64[idx]<=W_64[idx-16]+({W_64[idx-15][6:0],W_64[idx-15][31:7]}^{W_64[idx-15][17:0],W_64[idx-15][31:18]}^{3'b0,W_64[idx-15][31:3]})+W_64[idx-7]+({W_64[idx-2][16:0],W_64[idx-2][31:17]}^{W_64[idx-2][18:0],W_64[idx-2][31:19]}^{10'b0,W_64[idx-2][31:10]});       
                if(idx==63) begin st_tra<=32'd1; idx<=0;
                end else          idx<=idx+1;        
              end     
          end else if (st_tra==32'd1) begin   //calculate a~h   
              h<=g;
              g<=f;
              f<=e;
              e<=d+h+S1+ch+k[idx]+W_64[idx];
              d<=c;
              c<=b;
              b<=a;
              a<=h+S1+ch+k[idx]+W_64[idx]+S0+maj;
              if(idx==63) begin st_tra<=32'd2; idx<=0;
              end else idx<=idx+1;     
          end else if(st_tra==32'd2) begin 
              hash[0]<=hash[0]+a; hash[1]<=hash[1]+b;hash[2]<=hash[2]+c; hash[3]<=hash[3]+d;
              hash[4]<=hash[4]+e; hash[5]<=hash[5]+f;hash[6]<=hash[6]+g; hash[7]<=hash[7]+h;     

              a<=hash[0]+a; b<=hash[1]+b;c<=hash[2]+c; d<=hash[3]+d;
              e<=hash[4]+e; f<=hash[5]+f;g<=hash[6]+g; h<=hash[7]+h;  

              st_tra<=32'd3;
           end else temp<=0;                     
    end      
  end
end

endmodule
`endif

