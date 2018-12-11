module dac #(parameter width = 4, sample_time = 656 /*Default 32768 Hz*/) (
    input [width-1:0] leftInput,
    input [width-1:0] rightInput
);
    reg[width-1:0] left;
    reg[width-1:0] right;

    reg clk;    
    initial begin
        left <= 4'b0;
        right <= 4'b0;
        clk = 1;
        forever begin
            #1 clk = 0;
            #(sample_time-1) clk = 1;
        end
    end

    initial $display("%d %d", width, sample_time); // begin with params so we can interpret the file

    always @(posedge clk) begin
        if(leftInput === 4'bx)
            left <= 4'b0;
        else
            left <= leftInput;
        if(rightInput === 4'bx)
            right <= 4'b0;
        else
            right <= rightInput;
        $display("%d %d %d", $time, left, right);
    end

endmodule
