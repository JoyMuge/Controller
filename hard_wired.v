module CPU(
 SWB,
 SWA,
 SWC,
 clr,
 C,
 Z,
 IRH,
 T3,
 W1,
 W2,
 W3,
 SELCTL,
 ABUS,
 M,
 S,
 SEL0,
 SEL1,
 SEL2,
 SEL3,
 DRW,
 SBUS,
 LIR,
 MBUS,
 MEMW,
 LAR,
 ARINC,
 LPC,
 PCINC,
 PCADD,
 CIN,
 LONG,
 SHORT,
 CP1,CP2,CP3,
 QD,
 STOP,
 LDC,
 LDZ,
);
input SWB;
input SWA;
input SWC;
input clr;
input C;
input Z;
input [3:0] IRH;
input T3;
input W1;
input W2;
input W3;
input QD;
output SELCTL;
output ABUS;
output M;
output [3:0] S;
output SEL0;
output SEL1;
output SEL2;
output SEL3;
output DRW;
output SBUS;
output LIR;
output MBUS;
output MEMW;
output LAR;
output ARINC;
output LPC;
output PCINC;
output PCADD;
output CIN;
output LONG;
output SHORT;
output STOP;
output LDC;
output LDZ;
output CP1,CP2,CP3;
reg SELCTL;
reg ABUS;
reg M;
reg [3:0] S;
reg SEL0;
reg SEL1;
reg SEL2;
reg SEL3;
reg DRW;
reg SBUS;
reg LIR;
reg MBUS;
reg MEMW;
reg LAR;
reg ARINC;
reg LPC;
reg PCINC;
reg PCADD;
reg CIN;
reg LONG;
reg SHORT;
reg LDC;
reg LDZ;
wire[2:0] SWCBA;
wire ST0;
wire ST1;
reg ST0_reg;
reg ST1_reg;
reg SST0;
reg SST1;
wire STOP;
reg STOP_reg_reg;
reg STOP_reg_reg_reg;
reg STOP_reg;
parameter 
ADD=4'b0001,
SUB=4'B0010,
AND=4'B0011,
INC=4'B0100,
LD=4'B0101,
ST=4'B0110,
JC=4'B0111,
JZ=4'B1000,
JMP=4'B1001,
OUT=4'B1010,
STP=4'B1110,
OR=4'B1011,
XAND=4'B1100,
LSHIFT=4'B1101;
assign STOP=(SWCBA?(STOP_reg_reg|STOP_reg|STOP_reg_reg_reg):0);
assign CP1=1'b1;
assign CP2=1'b1;
assign CP3=QD;
assign SWCBA[2:0]={SWC,SWB,SWA};
assign ST0=ST0_reg;
assign ST1=ST1_reg;
always @(negedge clr or negedge T3)
begin
 if(clr==0)
 begin
  ST0_reg<=0;
  STOP_reg_reg<=1;
 end
 else
 begin
  if(SST0==1'b1) ST0_reg<=1'b1;
 end
end
always @(negedge clr or negedge T3)
begin
 if(clr==0)
 begin
  ST1_reg<=0;
  STOP_reg_reg_reg<=1;
 end
 else
 begin
  if((SST1==1'b1)&(ST1_reg==1'b0)) ST1_reg<=1'b1;
  else if((SST1==1'b1)&(ST1_reg==1'b1)) ST1_reg<=1'b0;
 end
end
always @ (W1 or W2 or W3 or ST0 or C or Z or SWCBA or IRH)
begin
 SELCTL <=0;
 ABUS  <=0;
 M   <=0;
 S   <=4'b0000;
 SEL0  <=0;
 SEL1  <=0;
 SEL2  <=0;
 SEL3  <=0;
 DRW  <=0;
 SBUS  <=0;
 LIR  <=0;
 MBUS  <=0;
 MEMW  <=0;
 LAR  <=0;
 ARINC  <=0;
 LPC  <=0;
 PCINC  <=0;
 CIN  <=0;
 LONG  <=0;
 SHORT  <=0;
 LDZ  <=0;
 LDC  <=0;
 PCADD  <=0;
 STOP_reg <=1;
 SST0  <=0;
 SST1  <=0;
 
 case(SWCBA)
  3'b000:
  begin
   if(ST0==0)
    begin
     SBUS<=W1;
     LPC<=W1;
     SHORT<=W1;
     SST0<=W1;
     STOP_reg<=0;
    end
   else if(ST0==1)
    begin
     LIR<=W1;
     PCINC<=W1;
     case(IRH)
      ADD:
       begin
        CIN<=W2;
        ABUS<=W2;
        DRW<=W2;
        LDZ<=W2;
        LDC<=W2;
        S<=4'b1001;
       end
      SUB:
       begin
        ABUS<=W2;
        DRW<=W2;
        LDZ<=W2;
        LDC<=W2;
        S<=4'b0110;
       end
      AND:
       begin
        M<=W2;
        ABUS<=W2;
        DRW<=W2;
        LDZ<=W2;
        S<=4'B1011;
       end
      INC:
       begin
        ABUS<=W2;
        DRW<=W2;
        LDZ<=W2;
        LDC<=W2;
        S<=4'B0000;
       end
      LD:
       begin
        M<=W2;
        ABUS<=W2;
        LAR<=W2;
        LONG<=W2;
        S<=4'B1010;
        MBUS<=W3;
        DRW<=W3;
       end
      ST:
       begin
        M<=W2|W3;
        ABUS<=W2|W3;
        LAR<=W2;
        LONG<=W2;
        S[3]<=1'B1;
        S[1]<=1'B1;
        S[2]<=W2;
        S[0]<=W2;
        MEMW<=W3;
       end
      JC:
       begin
        PCADD<=C&W2;
       end
      JZ:
       begin
        PCADD<=Z&W2;
       end
      JMP:
       begin
        M<=W2;
        S<=4'b1111;
        ABUS<=W2;
        LPC<=W2;
       end
      STP:
       begin
        STOP_reg<=W2;
       end
      OUT:
       begin
        M<=W2;
        S<=4'b1010;
        ABUS<=W2;
       end
      OR:
       begin
        M<=W2;
        ABUS<=W2;
        DRW<=W2;
        LDZ<=W2;
        S<=4'B1110;
       end
      XAND:
       begin
        M<=W2;
        ABUS<=W2;
        DRW<=W2;
        LDZ<=W2;
        S<=4'B0100;
       end
      LSHIFT:
       begin
        CIN<=W2;
        ABUS<=W2;
        DRW<=W2;
        LDZ<=W2;
        LDC<=W2;
        S<=4'b1100;
       end
      default:
       begin
       end
     endcase
    end
   end
 
   3'b001:
    begin
     SELCTL<=W1;
     SHORT<=W1;
     SBUS<=W1;
     STOP_reg<=W1;
     SST0<=W1;
     LAR<=W1&(~ST0);
     ARINC<=W1&ST0;
     MEMW<=W1&ST0;
    end
 
   3'b011:
    begin
     SELCTL<=1'b1;
     SEL0<=W1|W2;
     STOP_reg<=W1|W2;
     SEL3<=W2;
     SEL1<=W2;
    end
 
   3'b100:
    begin
     SELCTL<=1'b1;
     SST1<=W2;
     SBUS<=W1|W2;
     STOP_reg<=W1|W2;
     DRW<=W1|W2;
     if(ST1==0)
     begin
      SEL1<=W1;
     end
     else
     begin
      SEL3<=W1|W2;
      SEL1<=W2;
     end
     SEL2<=W2;
     SEL0<=W1;
    end
 
   3'b010:
    begin
     SUBS<=(~ST0)&W1;
     LAR<=(~ST0)&W1;
     STOP_reg<=W1;
     SST0<=(~ST0)&W1;
     SHORT<=W1;
     SELCTL<=W1;
     MUBS<=ST0&W1;
     ARINC<=ST0&W1;
    end
 
   default:
    begin
    end
 endcase
end
endmodule
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 