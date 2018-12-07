
module rectangle 
    (
        output reg oData,
	input  clk,
        input  iReset,
	input  iEnable,
	input [1:0]  iDuty_cycle_type
    );
    reg [2:0] position;
    reg [7:0] waveform;
    initial begin
	position <= 0;
    end
    always @(posedge clk) begin
        case (iDuty_cycle_type)
            0: begin
    	        waveform = 8'b00000001;
            end
    
            1: begin
    	        waveform = 8'b00000011;
            end
    
            2: begin
    	        waveform = 8'b00001111;
            end
    
            3: begin
    	        waveform = 8'b11111100;
            end
	endcase
	// set things and update stuff
	if (position != 0) begin
	    position <= position - 1;
	    oData <= waveform[position] & iEnable;
	end
	else begin
	    position <= 7;
	    oData <= waveform[position] & iEnable;
	end
    end
endmodule
