
module test_mod_inv;

reg enable, clk, running1, running2;
reg [7:0] a, p, c, c0;
reg [255:0] la, lp, lc, lc0;

mod_inv #(
    .LEN(8)
) mod_inv_inst1 (
    .a(a),
    .p(p),
    .enable(enable),
    .clk(clk),
    .c(c),
    .running(running1)
);


mod_inv #(
    .LEN(256)
) mod_inv_inst2 (
    .a(la),
    .p(lp),
    .enable(enable),
    .clk(clk),
    .c(lc),
    .running(running2)
);

always #2 clk = ~clk;

initial begin
    $dumpfile("test_mod_inv.vcd");
    $dumpvars(0, test_mod_inv);
    clk = 1;
    enable = 0;

    a = 8'd7;
    p = 8'd23;
    c0 = 8'd10;
    #2;
    enable = 1;
    #100;
    enable = 0;
    $display(
        "Mod Inv\n  a = %h\n  p = %h\nres = %h\n    - %h\n",
        a, p, c0, c
    );

    la = 256'h2;
    lp = 256'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    lc0 = 256'h7fffffffffffffffffffffffffffffffffffffffffffffffffffffff7ffffe18;
    #2;
    enable = 1;
    #50;
    enable = 0;
    $display(
        "Mod Inv\n  a = %h\n  p = %h\nres = %h\n    - %h\nRunning: %d\n",
        la, lp, lc0, lc, running2
    );


    la = 256'h4de2e12850f1f10056912a0baf9931e1ca5f41d5600aefa3de1212cd5c185a5a;
    lp = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;
    lc0 = 256'ha8a6b1580b705473d5ffdfe190f48281dbab54c235c5b64d8f0c323b6aa62e7a;
    #2;
    enable = 1;
    #2;
    $display(
        "Mod Inv Running: %d",
        running2
    );
    #3000;
    enable = 0;
    $display(
        "Mod Inv\n  a = %h\n  p = %h\nres = %h\n    - %h\nRunning: %d",
        la, lp, lc0, lc, running2
    );

    #10;
    $finish;
end

endmodule
