`include "pulseChannel.v"

module pulseChannelTest();
reg clk;
reg channel_enable;
reg channel_reset;
reg iLength_clk;
reg iEnvelope_clk;
reg iSweep_clk;
reg [7:0] reg4000;
reg [7:0] reg4001;
reg [7:0] reg4002;
reg [7:0] reg4003;
wire [3:0] wave;

reg reset_flag;
reg reset;
wire halfFrame;
wire quarterFrame;

clkDivider divider1(clk, reset, 17'd49, quarterFrame);    // should output 240 hz
clkDivider divider2(quarterFrame, reset, 17'd2, halfFrame);           // should output 120 hz

pulseChannel pulse(clk, channel_enable, channel_reset, halfFrame, quarterFrame, halfFrame, reg4000, reg4001, reg4002, reg4003, wave);

initial begin
    clk <= 0;
    reset_flag <= 1;
end
always begin
    #5
    clk <= ~clk;
    if (reset_flag) begin
	reset <= 1;
	reset_flag <= 0;
    end
    else begin
	reset <= 0;
    end
end

initial begin
    $dumpfile("pulseChannel.vcd");
    $dumpvars();
    assign channel_enable = 1'b1;
    assign channel_reset = 1'b0;
    assign reg4000 = 8'b11001010;
    assign reg4001 = 8'b1110111;
    assign reg4002 = 8'b0000001;
    assign reg4003 = 8'b1111001;
    #10000000
    $finish();
end
endmodule
