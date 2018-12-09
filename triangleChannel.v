

module triangleChannel(
    input clk,
    input[7:0] inputReg1,
    input[7:0] inputReg2,
    input[7:0] inputReg3,
    output reg[3:0] wave
);

wire controlFlag;       // Control Flag (also the length counter halt flag)
wire[6:0] counterReload;
wire[10:0] timer;
wire[4:0] lengthCounterIn;
wire[3:0] triangleOut;
wire sequenceClk;
wire[4:0] lengthCounterOut;

reg setHaltFlag;

wire[6:0] linearCounter;
reg[7:0] inputReg3prev;

// Redistributes inputs to more helpful wire collections
assign controlFlag = inputReg1[7];
assign counterReload = inputReg1[6:0];
assign timer = {inputReg3[2:0],inputReg2};
assign lengthCounterIn = inputReg3[7:3];

timer myTimer(clk, timer, sequenceClk);                  // Generates the clk for the sequencer
triangleSequencer sequence(sequenceClk, triangleOut);    // Sequencese a Triangle
linearCounter linear(clk, setHaltFlag, controlFlag, counterReload, linearCounter);

always @(inputReg3) begin
    setHaltFlag <= 1'b1;
end

always @(posedge clk) begin

    if((linearCounter > 7'b0)&&(lengthCounterIn > 5'b0))
        wave <= triangleOut; 
end
endmodule

////////////////////////////////////////////////////////////////
// Linear Counter
////////////////////////////////////////////////////////////////
module linearCounter(
    input clk,
    input setHaltFlag,
    input controlFlag,
    input[6:0] counterReloadValue,
    output[6:0] linearCounterOut
);
reg haltFlag;
reg[6:0] counter;
assign linearCounterOut = counter;

always @(posedge setHaltFlag)
    haltFlag <= 1'b1;

always @(posedge clk) begin
    if(haltFlag)
        counter <= counterReloadValue;
    else begin
        if(counter !== 7'b0)
            counter <= counter - 7'b1; 
    end
    if(controlFlag)
        haltFlag <= 1'b0;

end
endmodule

////////////////////////////////////////////////////////////////
// Timer
////////////////////////////////////////////////////////////////
module timer(
    input clk,
    input [10:0] timer,
    output reg pulse
);
reg[10:0] t;

initial begin
    t <= 0;
    pulse <= 0;
end

always @(posedge clk) begin
    if(t == 11'b0) begin
        pulse <= 1;
        t <= timer;
    end
    else begin
        pulse <= 0;
        t <= t-1;
    end
end
endmodule

////////////////////////////////////////////////////////////////
// Sequencer (generates triangle wave)
////////////////////////////////////////////////////////////////
module triangleSequencer(
    input clk,
    output reg[3:0] wave
);
reg direction;
reg linger;         // The wave outputs 0 twice, this flag makes that happen

initial begin
    linger <= 1'b0;
    direction <= 1'b0;
    wave <= 4'd15;
end

always @(posedge clk) begin
    if(direction) begin
        if(wave == 4'd14)
            direction <= 0;
        if(linger)
            linger <= 0;
        else
            wave <= wave+1;
    end
    else begin
        if(wave == 4'd1) begin
            linger <= 1;
            direction <=1;
        end
        wave <= wave-1;
    end
end
endmodule
