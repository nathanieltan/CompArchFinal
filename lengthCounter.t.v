`include "commonComponents.v"

module lengthCounterTest();
reg clk, halt;
reg[4:0] counterLoad;
wire[6:0] out;

lengthCounter length(clk, halt, counterLoad, out);

initial
    clk <= 1'b0;

always begin
    #5000
    clk <= ~clk;
end

initial begin
    $dumpfile("lengthCounter.vcd");
    $dumpvars();
    assign halt = 1'b0;
    assign counterLoad = {4'ha,1'b0};
    #700000
    $finish();
end
endmodule
