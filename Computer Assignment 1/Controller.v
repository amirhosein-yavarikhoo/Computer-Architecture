module controller(input clk,start,rst, check_done, input [1:0] x, output reg done, ready, ldx, ldy, ldp, shlx, shlp, asu_mode, cnt_en,dp_rst);
    parameter [2:0] idle = 0, loadx = 1, loady = 2,chx = 3,
                    add = 4, sub = 5, shp = 6, fin = 7;
    reg [2:0] ps = 0, ns = 0;
    always @(posedge clk,posedge rst ) begin
        if (rst) begin
            ps <= idle;
        end
        else 
            ps <= ns;  
     end

    always @(ps, start, check_done) begin
        ldx = 0;
        ldy = 0; 
        ldp = 0;
        ready = 0;
        done = 0; 
        shlx = 0;
        cnt_en = 0;
        asu_mode = 0;
        shlp = 0;
        dp_rst = 0;

        case (ps)
            default : ns = idle;
            idle : begin 
                dp_rst = 1;
                ready = 1;
                if (start) 
                    ns = loadx;
                else
                    ns = idle;
            end
            loadx : begin
                ldx = 1;
                ns = loady;
                end
            loady : begin
                ldy = 1;
                ns = chx;
                end
            chx : begin
                cnt_en = 1;
                if (x == 2'b01)
                    ns = add;
                else if (x == 2'b10)
                    ns = sub;
                else 
                    ns = shp;
            end
            add : begin 
                asu_mode = 1;
                ldp = 1;
                ns = shp;
            end
            sub : begin
                asu_mode = 0;
                ldp = 1;
                ns = shp;
            end
            shp : begin
                if (check_done) ns = fin;
                else begin
                    shlp = 1;
                    shlx = 1;
                    ns = chx;
                end
            end
            fin : begin
                done = 1;
                ns = idle;
            end
        endcase
    end

endmodule
