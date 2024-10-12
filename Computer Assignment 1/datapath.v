module datapath (input [4:0] inbus, input clk,rst,ldx, ldy, ldp, shlx, shlp, asu_mode, cnt_en,output [9:0] result, output [1 : 0] xout, output check_done);
    wire [9:0] asu_s;
    wire [4:0] x, y;
    assign xout[1] = x[4];
    assign xout[0] = x[3];
    wire shly;
    assign shly = 0;
    
    shreg_10b preg( clk,rst, shlp,ldp, asu_s,result);
    asu add_sub_unit({y[4],y[4],y[4],y[4],y[4],y}, result,asu_mode, asu_s);
    shreg_5b xreg (clk, rst, shlx, ldx, inbus, x), yreg (clk, rst, shly, ldy, inbus, y);
    check_cnt counter (cnt_en,clk,rst,check_done);

endmodule
