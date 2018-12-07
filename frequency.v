
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
    reg curSweep_clk;
    reg oldSweep_clk;
    initial begin
	timer <= iPeriod;
	cur_period <= iPeriod;
    end

    always @(posedge clk) begin
	oldSweep_clk <= curSweep_clk;
	curSweep_clk <= iSweep_clk;
	if (iSweep_enable == 0) begin
	    // frequency determinied by iPeriod
	    if (timer == 0) begin
		oData <= !oData;
		timer <= iPeriod;
	    end
	    else begin
		timer <= timer - 1;
	    end
	end
	else if (cur_period < 12'h7FF && cur_period > 8) begin
	    // frequency determined by cur_period 
	    if (timer == 0) begin
		oData <= !oData;
		timer <= cur_period;
	    end
	    else begin
		timer <= timer - 1;
	    end
	end
	else begin
	    oData <= 0;
	end
	if (curSweep_clk && !oldSweep_clk && iSweep_enable) begin
	    // update frequency
	    if (iSweep_mode == 0) begin
		cur_period <= cur_period + (cur_period >> iSweep_shift);
//		case (iSweep_shift)
//		    3'b000: cur_period = cur_period + {cur_period[0:0], cur_period[10:1]};
//		    3'b001: cur_period = cur_period + {cur_period[1:0], cur_period[10:2]};
//		    3'b010: cur_period = cur_period + {cur_period[2:0], cur_period[10:3]};
//		    3'b011: cur_period = cur_period + {cur_period[3:0], cur_period[10:4]};
//		    3'b100: cur_period = cur_period + {cur_period[4:0], cur_period[10:5]};
//		    3'b101: cur_period = cur_period + {cur_period[5:0], cur_period[10:6]};
//		    3'b110: cur_period = cur_period + {cur_period[6:0], cur_period[10:7]};
//		    3'b111: cur_period = cur_period + {cur_period[7:0], cur_period[10:8]};
//		endcase
	    end
	    else begin
		cur_period <= cur_period - (cur_period >> iSweep_shift);
//		case (iSweep_shift)
//		    3'b000: cur_period = cur_period - {cur_period[0:0], cur_period[10:1]};
//		    3'b001: cur_period = cur_period - {cur_period[1:0], cur_period[10:2]};
//		    3'b010: cur_period = cur_period - {cur_period[2:0], cur_period[10:3]};
//		    3'b011: cur_period = cur_period - {cur_period[3:0], cur_period[10:4]};
//		    3'b100: cur_period = cur_period - {cur_period[4:0], cur_period[10:5]};
//		    3'b101: cur_period = cur_period - {cur_period[5:0], cur_period[10:6]};
//		    3'b110: cur_period = cur_period - {cur_period[6:0], cur_period[10:7]};
//		    3'b111: cur_period = cur_period - {cur_period[7:0], cur_period[10:8]};
//		endcase
	    end
	end
    end
endmodule
