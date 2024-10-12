module check_cnt (input cnt_en,clk,check_rst,output reg check_done);
reg [2:0] cnt = 3'd3; 
always @(posedge clk) begin
    if(check_rst) begin
		cnt <= 3'd3;
		check_done <= 0;
	end
	if (cnt_en) begin
		{check_done,cnt} <= cnt + 1;

	end
	if (check_done)
		cnt <= 3'd3;

end
endmodule