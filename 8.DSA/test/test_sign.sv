
module test_sign;

reg clk, start, done;
reg [63:0] p, q, g, y, x, k, z, p_prime, r2_mod_p, q_prime, r2_mod_q;
reg [63:0] r, s, r_temp, s_temp;

dsa_sign #(
    .LEN(64)
) dsa_sign_inst (
    .clk(clk),
    .start(start),
    .p(p),
    .q(q),
    .g(g),
    .y(y),
    .x(x),
    .k(k),
    .z(z),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .q_prime(q_prime),
    .r2_mod_q(r2_mod_q),
    .r(r),
    .s(s),
    .done(done)
);

always #2 clk = ~clk;

initial begin
    $dumpfile("test_sign.vcd");
    $dumpvars(0, test_sign);
    clk = 0;
    start = 0;

    #10;
    start = 1;
    p = 64'd7879;
    q = 64'd101;
    g = 64'd170;
    y = 64'd4567;
    x = 64'd75;
    k = 64'd50;
    z = 64'd42;
    p_prime = 64'h256e1d0c1e8abd09;
    r2_mod_p = 64'h0000000000000d48;
    q_prime = 64'hc5b3f5dc83cd4e93;
    r2_mod_q = 64'h0000000000000050;
    r_temp = 64'd94;
    s_temp = 64'd57;
    #10;
    start = 0;
    #1000;
    $display(
        "DSA Sign\nr = %d\n  - %d\ns = %d\n  - %d %d",
        r, r_temp,
        s, s_temp,
        done
    );

    $finish;
end


endmodule
