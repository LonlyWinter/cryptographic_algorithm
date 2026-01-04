
module test_point_add;

reg [255:0] p, p_prime, r2_mod_p;
reg [255:0] px, py, pz, qx, qy, qz;
reg [255:0] rx, ry, rz, rx_temp, ry_temp, rz_temp;

point_add #(
    .LEN(256)
) point_add_inst (
    .p(p),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .px(px),
    .py(py),
    .pz(pz),
    .qx(qx),
    .qy(qy),
    .qz(qz),
    .rx(rx),
    .ry(ry),
    .rz(rz)
);

initial begin
    $dumpfile("test_point_add.vcd");
    $dumpvars(0, test_point_add);

    p = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;
    p_prime = 256'hffffffff00000002000000000000000000000001000000000000000000000001;
    r2_mod_p = 256'h4fffffffdfffffffffffffffefffffffbffffffff0000000000000003;
    px = 256'h6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296;
    py = 256'h4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5;
    pz = 256'h1;
    qx = 256'h7cf27b188d034f7e8a52380304b51ac3c08969e277f21b35a60b48fc47669978;
    qy = 256'h07775510db8ed040293d9ac69f7430dbba7dafb84c35826416c97624876e55a4;
    qz = 256'h1;
    rx_temp = 256'hdf2ed7f585082cda490918bc98af28beaf17ec90231bd1852080f842170616e5;
    ry_temp = 256'h72b1a02d167748c88557e16644f86e67ed7e61c211db886040f3f244f90ee47e;
    rz_temp = 256'h11daa925abd70d369195511da110d9d14985ec614a06e794b16a0fb66ecdd6e2;
    #10;
    $display(
        "Point Add\nrx = %h\n   - %h\nry = %h\n   - %h\nrz = %h\n   - %h",
        rx, rx_temp,
        ry, ry_temp,
        rz, rz_temp
    );

    #10;
    $finish;
end


endmodule
