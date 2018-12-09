module lengthCounter(
    input clk,
    input halt,
    input[4:0] counterLoad,
    output reg[6:0] out
);
wire loadA;       // Bit 0 of counterLoad
wire[3:0] loadB;  // Bits 4-1 of counterLoad
assign loadA = counterLoad[0];
assign loadB = counterLoad[4:1];
wire[6:0] indexOut;

lengthIndex index(loadA, loadB, indexOut);

always @(indexOut) begin
    out <= indexOut;
end

always @(posedge clk) begin
    if(halt)
        out <= 7'h0;
    else begin
        if(out > 7'h0)
            out <= out - 7'h1;
    end
end

endmodule

////////////////////////////////////////////////////
// Length Index
////////////////////////////////////////////////////
module lengthIndex(
    input loadA,
    input[3:0] loadB,
    output reg[6:0] indexOut
);
wire[4:0] load;
assign load = {loadB,loadA};

// Lookup table
always @(load) begin
    if(loadA) begin
        if(loadB == 4'h0)
            indexOut <= 7'hfe;
        if(loadB == 4'h1)
            indexOut <= 7'h02;
        if(loadB == 4'h2)
            indexOut <= 7'h04;
        if(loadB == 4'h3)
            indexOut <= 7'h06;
        if(loadB == 4'h4)
            indexOut <= 7'h08;
        if(loadB == 4'h5)
            indexOut <= 7'h0a;
        if(loadB == 4'h6)
            indexOut <= 7'h0c;
        if(loadB == 5'h7)
            indexOut <= 7'h0E;
        if(loadB == 5'h8)
            indexOut <= 7'h10;
        if(loadB == 5'h9)
            indexOut <= 7'h12;
        if(loadB == 5'ha)
            indexOut <= 7'h14;
        if(loadB == 5'hb)
            indexOut <= 7'h16;
        if(loadB == 5'hc)
            indexOut <= 7'h18;
        if(loadB == 5'hd)
            indexOut <= 7'h1a;
        if(loadB == 5'he)
            indexOut <= 7'h1c;
        if(loadB == 5'hf)
            indexOut <= 7'h1e;
    end
    else begin
        if(loadB == 4'h0)
            indexOut <= 7'h0a;
        if(loadB == 4'h1)
            indexOut <= 7'h14;
        if(loadB == 4'h2)
            indexOut <= 7'h28;
        if(loadB == 4'h3)
            indexOut <= 7'h50;
        if(loadB == 4'h4)
            indexOut <= 7'ha0;
        if(loadB == 4'h5)
            indexOut <= 7'h3c;
        if(loadB == 4'h6)
            indexOut <= 7'h0e;
        if(loadB == 5'h7)
            indexOut <= 7'h1a;
        if(loadB == 5'h8)
            indexOut <= 7'h0c;
        if(loadB == 5'h9)
            indexOut <= 7'h18;
        if(loadB == 5'ha)
            indexOut <= 7'h30;
        if(loadB == 5'hb)
            indexOut <= 7'h60;
        if(loadB == 5'hc)
            indexOut <= 7'hc0;
        if(loadB == 5'hd)
            indexOut <= 7'h48;
        if(loadB == 5'he)
            indexOut <= 7'h10;
        if(loadB == 5'hf)
            indexOut <= 7'h20;
    end
end
endmodule

//////////////////////////////////////////////////////
// Envleope Generator
//////////////////////////////////////////////////////
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
