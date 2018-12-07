`include "triangleChannel.v"

module triangleChannelTest();
reg clk;
wire[3:0] wave;
reg controlFlag;
reg[6:0] counterReload;
reg[10:0] timer;
reg[4:0] lengthCounterLoad;

triangleChannel triangle(clk, {controlFlag, counterReload}, timer[7:0], {lengthCounterLoad, timer[10:8]}, wave);

initial
    clk <= 0;
always begin
    #5000
    clk <= ~clk;
end

initial begin
    $dumpfile("triangleChannel.vcd");
    $dumpvars();
    assign controlFlag = 1'b1;
    assign counterReload = 7'd200;
    #5000
    assign controlFlag = 1'b0;
    #1000000
    $finish();
end
endmodule