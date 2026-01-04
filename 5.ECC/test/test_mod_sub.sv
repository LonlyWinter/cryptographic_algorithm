
module test_mod_sub;

reg [7:0] a;
reg [7:0] b;
reg [7:0] p;
reg [7:0] c;
reg [7:0] c0;

mod_sub #(
    .LEN(8)
) mod_sub_inst (
    .a(a),
    .b(b),
    .p(p),
    .c(c)
);

initial begin
    $dumpfile("test_mod_sub.vcd");
    $dumpvars(0, test_mod_sub);
    a = 8'd78;
    b = 8'd31;
    p = 8'd113;
    c0 = 8'd47;
    #2;
    $display(
        "Mod Sub\n  a = %d\n  b = %d\n  p = %d\nres = %d\n    - %d",
        a, b, p, c0, c
    );

    a = 8'd28;
    b = 8'd37;
    p = 8'd47;
    c0 = 8'd38;
    #2;
    $display(
        "Mod Sub\n  a = %d\n  b = %d\n  p = %d\nres = %d\n    - %d",
        a, b, p, c0, c
    );

    #10;
    $finish;
end

endmodule
