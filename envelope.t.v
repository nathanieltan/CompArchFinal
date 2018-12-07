`include "envelope.v"

module envelopeTest(); 
reg clk;
reg loop;
reg disableFlag;
reg resetFlag;
reg[3:0] n;
wire[3:0] volume;

initial
    clk <= 0;

always begin
    #5000
    clk <= ~clk;
end

envelope envy(clk, loop, disableFlag, resetFlag, n, volume);

initial begin
    $dumpfile("envelope.vcd");
    $dumpvars();
    assign loop = 1'b0;
    assign disableFlag = 1'b0;
    assign n = 4'd3;
    assign resetFlag = 1'b1;
    #10000
    assign resetFlag = 1'b0;
    assign loop = 1'b1;
    #500000
    assign loop = 1'b0;
    #100000
    assign disableFlag = 1'b1;
    #1000000
    $finish();
end

endmodule
