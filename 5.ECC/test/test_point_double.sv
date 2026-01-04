
module test_point_double;

reg [255:0] a, p, p_prime, r2_mod_p;
reg [255:0] px, py, pz;
reg [255:0] rx, ry, rz, rx_temp, ry_temp, rz_temp;

point_double #(
    .LEN(256)
) point_double_inst (
    .a(a),
    .p(p),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .px(px),
    .py(py),
    .pz(pz),
    .rx(rx),
    .ry(ry),
    .rz(rz)
);

initial begin
    $dumpfile("test_point_double.vcd");
    $dumpvars(0, test_point_double);

    a = 256'hffffffff00000001000000000000000000000000fffffffffffffffffffffffc;
    p = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;
    p_prime = 256'hffffffff00000002000000000000000000000001000000000000000000000001;
    r2_mod_p = 256'h4fffffffdfffffffffffffffefffffffbffffffff0000000000000003;


    px = 256'h6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296;
    py = 256'h4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5;
    pz = 256'h1;
    rx_temp = 256'h9a978f59acd1b5ad570e7d52dcfcde43804b42274f61ddcf1e7d848391d6c70f;
    ry_temp = 256'h4126885e7f786af905338238e5346d5fe77fc46388668bd0fd59be3190d2f5d1;
    rz_temp = 256'h9fc685c5fc34ff371dcfd694f81f3c2c579c66aed662bd9d976c80d06f7ea3ea;
    #10;
    $display(
        "Point double\nrx = %h\n   - %h\nry = %h\n   - %h\nrz = %h\n   - %h",
        rx, rx_temp,
        ry, ry_temp,
        rz, rz_temp
    );

    #10;
    $finish;
end


endmodule
