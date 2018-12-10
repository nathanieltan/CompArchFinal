`include "rectangle.v"
`include "frequency.v"
`include "commonComponents.v"

module pulseChannel(
    input clk,
    input iLength_clk,
    input iEnvelope_clk,
    input iSweep_clk,
    input [7:0] reg4000,
    input [7:0] reg4001,
    input [7:0] reg4002,
    input [7:0] reg4003,
    output reg[3:0] pulse
); 

wire [10:0] timer;
wire [1:0] duty_cycle;
wire counter_halt;
wire constant_volume;
wire [3:0] volume_period;
wire sweep_enable;
wire [2:0] period;
wire negate;
wire [2:0] shift;
wire [4:0] counter_load;
wire frequency_data;
wire rectangle_out;
wire [3:0] envelope_volume;
wire [6:0] length_out;

assign timer = {reg4003[2:0], reg4002[7:0]};
assign duty_cycle = reg4000[7:6];
assign constant_volume = reg4000[5];
assign counter_halt = reg4000[4];
assign volume_period = reg4000[3:0];
assign sweep_enable = reg4001[7];
assign period = reg4001[6:4];
assign negate = reg4001[3];
assign shift = reg4001[2:0];
assign counter_load = reg4003[7:3];

reg rectangle_reset;
reg sweep_reset;
reg envelope_reset;
reg length_reset;

rectangle myRectangle(
    .oData(rectangle_out),
    .clk(clk),
    .iReset(rectangle_reset),
    .iEnable(frequency_data),
    .iDuty_cycle_type(duty_cycle)
);
frequency myFrequency(
    .oData(frequency_data),
    .clk(clk),
    .iSweep_clk(iSweep_clk),
    .iSweep_reset(sweep_reset),
    .iSweep_enable(sweep_enable),
    .iSweep_refresh_rate(),  // TODO
    .iSweep_mode(negate),
    .iSweep_shift(shift),
    .iPeriod_reset(),  // TODO
    .iPeriod(timer)
);
envelope myEnvelope(
    .clk(clk),
    .loop(counter_halt),
    .disableFlag(constant_volume),
    .resetFlag(envelope_reset),
    .n(volume_period),
    .volume(envelope_volume)
);
lengthCounter myLengthCounter(
    .clk(clk),
    .halt(counter_halt),
    .counterLoad(counter_load),
    .out(length_out)
);

always @(posedge clk) begin
    // update flags as needed
end

endmodule
