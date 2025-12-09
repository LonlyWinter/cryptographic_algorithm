
module test_mont_redc;

reg [511:0] x;
reg [255:0] n, n_prime, res_real;
wire [255:0] res;

mont_redc #(
    .LEN(256)
) mont_redc_inst (
    .x(x),
    .n(n),
    .n_prime(n_prime),
    .res(res)
);

initial begin
    $dumpfile("test_mont_redc.vcd");
    $dumpvars(0, test_mont_redc);
    x = 512'ha0fac9c9b64ab578361181fef55d4ae50ef6949462362ff7a4636d7974cb9ccf590cf086ca09bed7c3f638518af7296aeb1125bc1e1e445855a44cd70b88d780;
    n = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
    n_prime = 256'hc9bd1905155383999c46c2c295f2b761bcb223fedc24a059d838091dd2253531;
    res_real = 256'h7aadc2413b5165dc519412c9bc08ed5664e6cb765385e169d15d7d144a67646a;
    #10;
    $display(
        "Montgomery Redc\n  x = %h\n  n = %h\nres = %h\n    - %h",
        x, n, res, res_real
    );
    $finish;
end

endmodule
