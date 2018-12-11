`include "commonComponents.v"

module frameSequencer(
    input clk,
    input rst,
    output quarterFrame,
    output halfFrame
);

clkDivider divider1(clk, rst, 17'd89490, quarterFrame);    // should output 240 hz
clkDivider divider2(quarterFrame, rst, 17'd2, halfFrame);           // should output 120 hz

endmodule
