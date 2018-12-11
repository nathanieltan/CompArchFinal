`include "commonComponents.v"

module frequency 
    (
        output reg oData,
	input  clk,
        input  iSweep_clk,
        input  iSweep_reset,
	input  iSweep_enable,
	input  iSweep_refresh_rate,
	input  iSweep_mode,
	input [2:0] iSweep_shift,
	input  iPeriod_reset,
	input [10:0] iPeriod
    );
    reg [10:0] cur_period;
    reg [10:0] timer;
    wire update_clk;
    wire constant_signal;
    wire sweep_signal;

    timer myTimer(iSweep_clk, {8'b0, iSweep_refresh_rate}, update);  // controls  frequency of period updates
    clkDivider sweep_divider(iSweep_clk, iPeriod_reset, cur_period, sweep_signal); // output signal with frequency determined by the cur_period
    clkDivider constant_divider(iSweep_clk, iPeriod_reset, iPeriod, constant_signal); // output signal with frequency determined by the cur_period

    initial begin
        cur_period <= iPeriod;
    end

    always @(posedge clk) begin
	if (iSweep_enable == 0) begin
	    oData <= constant_signal;
	end
	else if (cur_period < 12'h7FF && cur_period > 8) begin
	    oData <= sweep_signal;
	end
	else begin
	    oData <= 0;
	end
	if (update == 1) begin
	    // update frequency
	    if (iSweep_mode == 0) begin
		cur_period <= cur_period + (cur_period >> iSweep_shift);
	    end
	    else begin
		cur_period <= cur_period - (cur_period >> iSweep_shift);
	    end
	end
    end
endmodule
