
module test_mod_add;

reg [7:0] a;
reg [7:0] b;
reg [7:0] p;
reg [7:0] c;
reg [7:0] c0;

mod_add #(
    .LEN(8)
) mod_add_inst (
    .a(a),
    .b(b),
    .p(p),
    .c(c)
);

initial begin
    $dumpfile("test_mod_add.vcd");
    $dumpvars(0, test_mod_add);
    a = 8'd78;
    b = 8'd31;
    p = 8'd113;
    c0 = 8'd109;
    #2;
    $display(
        "Mod Add\n  a = %d\n  b = %d\n  p = %d\nres = %d\n    - %d",
        a, b, p, c0, c
    );

    a = 8'd28;
    b = 8'd37;
    p = 8'd47;
    c0 = 8'd18;
    #2;
    $display(
        "Mod Add\n  a = %d\n  b = %d\n  p = %d\nres = %d\n    - %d",
        a, b, p, c0, c
    );

    #10;
    $finish;
end

endmodule
