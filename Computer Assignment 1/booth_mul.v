module booth_mul (input [4:0] inbus, input clk , rst, start, output done,ready , output [9:0] result);
    wire [1:0] xout;
    datapath dp (inbus, clk,p_rst,ldx, ldy, ldp, shlx, shlp, asu_mode, cnt_en,result, xout, check_done);
    controller ccu(clk,start,rst, check_done, xout, done, ready, ldx, ldy, ldp, shlx, shlp, asu_mode, cnt_en,p_rst);
    //wire ldx,ldy,ldp,shlx,shlp,asu_mode,cnt_en,check_done;
    

endmodule
