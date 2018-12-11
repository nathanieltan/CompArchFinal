`include "dac.v"
`include "triangleChannel.v"
`include "frameSequencer.v"

module apu();
reg clk;
wire clk240;
wire clk120;
reg reset;
reg controlFlag;
wire[7:0] inputReg1;
wire[7:0] inputReg2;
wire[7:0] inputReg3;
wire[3:0] triangleOut;
reg[6:0] counterReload;
reg[10:0] timer;
reg[5:0] lengthCounterLoad;

assign inputReg1 = {controlFlag, counterReload};
assign inputReg2 = timer[7:0];
assign inputReg3 = {lengthCounterLoad, timer[10:8]};

initial begin
    clk <= 0;
    forever #1 clk <= ~clk;
end

frameSequencer frame(clk, reset, clk240, clk120);

triangleChannel triangle(clk, clk240, clk120, inputReg1, inputReg2, inputReg3, triangleOut);

dac dacTriangle(triangleOut, triangleOut); 


initial begin
    $dumpfile("apu.vcd");
    $dumpvars();
    assign controlFlag = 1'b1;
    assign counterReload = 7'd100;
    assign timer = 11'd10;
    assign lengthCounterLoad = {4'hb,1'b0};
    assign reset = 1'b1;
    #1
    assign reset = 1'b0;
    assign controlFlag = 1'b0;
    #1000
    $finish();

end

endmodule
