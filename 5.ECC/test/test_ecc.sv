
module test_ecc;

reg enable, clk, done, valid;
reg [255:0] a, b, p, p_prime, r2_mod_p;
reg [255:0] k, x, y, rx, ry, rx_temp, ry_temp;

ecc #(
    .LEN(256)
) ecc_inst (
    .a(a),
    .b(b),
    .p(p),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .clk(clk),
    .enable(enable),
    .x(x),
    .y(y),
    .k(k),
    .x_res(rx),
    .y_res(ry),
    .valid(valid),
    .done(done)
);

always #2 clk = ~clk;

initial begin
    $dumpfile("test_ecc.vcd");
    $dumpvars(0, test_ecc);
    clk = 1;
    enable = 0;

    a = 256'hffffffff00000001000000000000000000000000fffffffffffffffffffffffc;
    b = 256'h5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b;
    p = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;
    p_prime = 256'hffffffff00000002000000000000000000000001000000000000000000000001;
    r2_mod_p = 256'h4fffffffdfffffffffffffffefffffffbffffffff0000000000000003;
    x = 256'h6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296;
    y = 256'h4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5;

    // k = 256'd1;
    // rx_temp = 256'h6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296;
    // ry_temp = 256'h4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5;
    // #10;
    // enable = 1;
    // #2;
    // enable = 0;
    // #30;
    // $display(
    //     "ECC:  k = %d, valid = %d, done = %d\nax = %h\nrx = %h\n   - %h\nay = %h\nry = %h\n   - %h",
    //     k, valid, done,
    //     x, rx, rx_temp,
    //     y, ry, ry_temp
    // );

    // k = 256'd2;
    // rx_temp = 256'h7cf27b188d034f7e8a52380304b51ac3c08969e277f21b35a60b48fc47669978;
    // ry_temp = 256'h07775510db8ed040293d9ac69f7430dbba7dade63ce982299e04b79d227873d1;
    // #10;
    // enable = 1;
    // #2;
    // enable = 0;
    // #3000;
    // $display(
    //     "ECC:  k = %d, valid = %d, done = %d\nax = %h\nrx = %h\n   - %h\nay = %h\nry = %h\n   - %h",
    //     k, valid, done,
    //     x, rx, rx_temp,
    //     y, ry, ry_temp
    // );

    // k = 256'd3;
    // rx_temp = 256'h5ecbe4d1a6330a44c8f7ef951d4bf165e6c6b721efada985fb41661bc6e7fd6c;
    // ry_temp = 256'h8734640c4998ff7e374b06ce1a64a2ecd82ab036384fb83d9a79b127a27d5032;
    // #10;
    // enable = 1;
    // #2;
    // enable = 0;
    // #3000;
    // $display(
    //     "ECC:  k = %d, valid = %d, done = %d\nax = %h\nrx = %h\n   - %h\nay = %h\nry = %h\n   - %h",
    //     k, valid, done,
    //     x, rx, rx_temp,
    //     y, ry, ry_temp
    // );

    k = 256'd137;
    rx_temp = 256'h39daf267869de081f789324098661a15bb89d0874dde29ddba88c0c08a6329d2;
    ry_temp = 256'h9933f25abc0170dff9e7544c57f59ff0599b8653163ea8dcac923a1c5b00759d;
    #10;
    enable = 1;
    #2;
    enable = 0;
    #5000;
    $display(
        "ECC:  k = %d, valid = %d, done = %d\nax = %h\nrx = %h\n   - %h\nay = %h\nry = %h\n   - %h",
        k, valid, done,
        x, rx, rx_temp,
        y, ry, ry_temp
    );

    #10;
    $finish;
end


endmodule
