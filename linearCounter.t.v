`include "triangleChannel.v"

module linearCounterTest();
reg clk, setHaltFlag, controlFlag;
reg[6:0] counterReloadValue;
wire[6:0] linearCounterOut;

linearCounter linear(clk, setHaltFlag, controlFlag, counterReloadValue, linearCounterOut);

initial
    clk <= 1'b0;

always begin
    #5000
    clk <= ~clk;
end

initial begin
    $dumpfile("linearCounter.vcd");
    $dumpvars();
    assign setHaltFlag = 1'b1;
    assign controlFlag = 1'b0;
    assign counterReloadValue = 7'd10;
    #10000
    assign setHaltFlag = 1'b0;
    assign controlFlag = 1'b1;
    #500000
    $finish();
end

endmodule
