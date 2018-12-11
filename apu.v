`include "dac.v"
`include "triangleChannel.v"
`include "frameSequencer.v"

module apu();
reg clk;
wire clk240;
wire clk120;
reg[7:0] inputReg1;
reg[7:0] inputReg2;
reg[7:0] inputReg3;
wire triangleOut;

initial begin
    clk <= 0;
    forever #1 clk <= ~clk;
end

frameSequencer frame(clk, clk240, clk120);

triangleChannel triangle(clk, clk240, clk120,



endmodule
