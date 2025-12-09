
module test_modexp1;

reg [255:0] a, n, n_prime, r2, res_real;
wire [255:0] res;

modexp1 #(
    .LEN(256),
    .E(65537)
) modexp_inst (
    .a(a),
    .n(n),
    .n_prime(n_prime),
    .r2_mod_n(r2),
    .res(res)
);

initial begin
    $dumpfile("test_modexp1.vcd");
    $dumpvars(0, test_modexp1);
    a = 256'ha1b2c3d4e5f67890123456789012345678901234567890123456789012345678;
    n = 256'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    n_prime = 256'hc9bd1905155383999c46c2c295f2b761bcb223fedc24a059d838091dd2253531;
    r2 = 256'h000000000000000000000000000000000000000000000001000007a2000e90a1;
    res_real = 256'h6529839e9bf0ce322932bdcc612f5f3866cf4c7abf15bff66b324e253bb35bc3;
    #10;
    $display(
        "Montgomery ModExp\n  a = %h\n  n = %h\nres = %h\n    - %h",
        a, n, res, res_real
    );
    $finish;
end

endmodule
