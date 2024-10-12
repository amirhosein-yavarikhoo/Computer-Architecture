module shreg_5b (input clk, rst, shl, ld, input [4:0] inbus, output reg [4:0] q);
    always @(posedge clk, posedge rst) begin
        if (rst) q <= 0;
        else if (shl) q <= q << 1;
        else if (ld) q <= inbus;
        end
endmodule

