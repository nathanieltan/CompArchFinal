`include "rectangle.v"
`include "frequency.v"
`include "envelope.v"

module pulseChannel(
    input clk,
    input [7:0] reg4000,
    input [7:0] reg4001,
    input [7:0] reg4002,
    input [0:7] reg4003,
    output [3:0] reg pulse
); 

reg [10:0] timer;
reg [1:0] duty_cycle;
reg counter_halt;
reg envelope;
reg [3:0] volume;
reg sweep_enable;
reg [2:0] period;
reg negate;
reg [2:0] shift;
reg [4:0] counter_load;

assign timer = {reg4003[2:0], reg4002[7:0]};
assign duty_cycle = reg4000[7:6];
assign envelope = reg4000[5];
assign counter_halt = reg4000[4];
assign volume = reg4000[3:0];
assign sweep_enable = reg4001[7];
assign period = reg4001[6:4];
assign negate = reg4001[3];
assign shift = reg4001[2:0];
assign counter_load <= reg4003[7:3];

rectangle myRectangle();
frequency myFrequency();
envelope myEnvelope();

always @(posedge clk) begin
end

endmodule
