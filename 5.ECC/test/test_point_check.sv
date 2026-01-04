
module test_point_check;

reg enable, clk;
reg [255:0] a, b, p, p_prime, r2_mod_p;
reg [255:0] x, y;
reg valid;

point_check #(
    .LEN(256)
) point_check_inst (
    .a(a),
    .b(b),
    .p(p),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .x(x),
    .y(y),
    .valid(valid)
);

always #2 clk = ~clk;

initial begin
    $dumpfile("test_point_check.vcd");
    $dumpvars(0, test_point_check);

    a = 256'hffffffff00000001000000000000000000000000fffffffffffffffffffffffc;
    b = 256'h5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b;
    p = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;
    p_prime = 256'hffffffff00000002000000000000000000000001000000000000000000000001;
    r2_mod_p = 256'h4fffffffdfffffffffffffffefffffffbffffffff0000000000000003;
    x = 256'h6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296;
    y = 256'h4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5;
    #2;
    $display(
        "Point check\na = %h\nb = %h\np = %h\nx = %h\ny = %h\n- = %d",
        a, b, p, x, y, valid
    );

    #10;
    $finish;
end


endmodule
