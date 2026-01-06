
module test_check;

reg clk, start, valid, done;
reg [63:0] p, q, g, y, r, s, z, p_prime, r2_mod_p, q_prime, r2_mod_q;

dsa_check #(
    .LEN(64)
) dsa_check_inst (
    .clk(clk),
    .start(start),
    .p(p),
    .q(q),
    .g(g),
    .y(y),
    .r(r),
    .s(s),
    .z(z),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .q_prime(q_prime),
    .r2_mod_q(r2_mod_q),
    .valid(valid),
    .done(done)
);

always #2 clk = ~clk;

initial begin
    $dumpfile("test_check.vcd");
    $dumpvars(0, test_check);
    clk = 0;
    start = 0;

    #10;
    start = 1;
    p = 64'd7879;
    q = 64'd101;
    g = 64'd170;
    y = 64'd4567;
    r = 64'd94;
    s = 64'd57;
    z = 64'd42;
    p_prime = 64'h256e1d0c1e8abd09;
    r2_mod_p = 64'h0000000000000d48;
    q_prime = 64'hc5b3f5dc83cd4e93;
    r2_mod_q = 64'h0000000000000050;
    #10;
    start = 0;
    #1000;
    $display(
        "DSA check\nvalid: %d, done: %d",
        valid,
        done
    );

    $finish;
end


endmodule
