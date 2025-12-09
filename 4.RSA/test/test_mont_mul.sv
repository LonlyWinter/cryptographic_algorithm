
module test_mont_mul;

reg [255:0] a, b, n, n_prime, res_real;
wire [255:0] res;

mont_mul #(
    .LEN(256)
) mont_mul_inst (
    .a(a),
    .b(b),
    .n(n),
    .n_prime(n_prime),
    .res(res)
);

initial begin
    $dumpfile("test_mont_mul.vcd");
    $dumpvars(0, test_mont_mul);
    a = 256'hA1B2C3D4E5F67890123456789012345678901234567890123456789012345678;
    b = 256'hFEDCBA9876543210FEDCBA9876543210FEDCBA9876543210FEDCBA9876543210;
    n = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
    n_prime = 256'hc9bd1905155383999c46c2c295f2b761bcb223fedc24a059d838091dd2253531;
    res_real = 256'h7aadc2413b5165dc519412c9bc08ed5664e6cb765385e169d15d7d144a67646a;
    #10;
    $display(
        "Montgomery Mul\n  a = %h\n  b = %h\n  n = %h\nres = %h\n    - %h",
        a, b, n, res, res_real
    );
    $finish;
end

endmodule
