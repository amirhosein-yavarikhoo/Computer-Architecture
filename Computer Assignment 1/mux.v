module mux (input a, b, p_sel, output p_write);
    assign p_write = p_sel ? b : a;
endmodule
