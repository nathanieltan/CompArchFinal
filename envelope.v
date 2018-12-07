

module envelope(
    input clk,
    input loop,              // Controls whether the volume loops or not
    input disableFlag,       // Controls the disable
    input resetFlag,         // resetFlag==0 if the length counter is written to
    input[3:0] n,            // Period of the counter_clk. Volume defaults to n when disabled
    output reg[3:0] volume   // Output
);
reg reset;
reg[3:0] counter;
wire counter_clk; 

clkDivider divider(clk, reset, n+4'b1, counter_clk);

always @(posedge clk) begin
    if(resetFlag) begin
        counter <= 4'd15;
        reset <= 1;
    end
    else
        reset <= 0;
    if(disableFlag)
        volume <= n;
    else
        volume <= counter;
end

always @(posedge counter_clk) begin
    // If loop is set and counter is zero then it loops back to 15
    // If loop is not enabled and counter is not zero it decrements
    // If loop is not enabled, counter will decrease until it is zero
    if(loop && (counter == 0)) 
        counter <= 4'd15;
    if(counter !== 0)
        counter <= counter - 1;
end

endmodule

// Clk Divider Module, takes in clk and N(period of new clk)
// Ouputs new clk with period of N clk
module clkDivider(
    input clk,
    input rst,
    input[3:0] N,
    output clk_out
);
reg[3:0] n;
reg[3:0] r_reg;
wire[3:0] r_next;
reg clk_track;

initial begin
    n <= N/2;
    r_reg <= 0;
    clk_track <= 1'b0;
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        n <= N/2;
        r_reg <= 0;
        clk_track <= 1'b0;
    end
    else if(r_next == n) begin
        r_reg <= 0;
        clk_track <= ~clk_track;
    end
    else
        r_reg <= r_next;
end
assign r_next = r_reg+1;
assign clk_out = clk_track;
endmodule
