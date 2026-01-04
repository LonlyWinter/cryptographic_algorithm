
module test_point_affine;

reg enable, clk, done;
reg [255:0] p, p_prime, r2_mod_p;
reg [255:0] x, y, z;
reg [255:0] rx, ry, rz, rx_temp, ry_temp;

point_affine #(
    .LEN(256)
) point_affine_inst (
    .p(p),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .enable(enable),
    .clk(clk),
    .x(x),
    .y(y),
    .z(z),
    .rx(rx),
    .ry(ry),
    .done(done)
);

always #2 clk = ~clk;


initial begin
    $dumpfile("test_point_affine.vcd");
    $dumpvars(0, test_point_affine);
    clk = 0;
    enable = 0;

    p = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;
    p_prime = 256'hffffffff00000002000000000000000000000001000000000000000000000001;
    r2_mod_p = 256'h4fffffffdfffffffffffffffefffffffbffffffff0000000000000003;

    x = 256'hdf2ed7f585082cda490918bc98af28beaf17ec90231bd1852080f842170616e5;
    y = 256'h72b1a02d167748c88557e16644f86e67ed7e61c211db886040f3f244f90ee47e;
    z = 256'h11daa925abd70d369195511da110d9d14985ec614a06e794b16a0fb66ecdd6e2;
    rx_temp = 256'heb38c810652b534a266a884168da2a4c08cf143590755e93224453fbd45d5d2f;
    ry_temp = 256'h76145e5c2851aa9b5261b72dd059b6a802f578773b9def27c1fd783e5507bee2;
    #10;
    enable = 1;
    #3000;
    enable = 0;
    $display(
        "Point Affine\nrx = %h\n   - %h\nry = %h\n   - %h %d",
        rx, rx_temp,
        ry, ry_temp,
        done
    );

    x = 256'h9a978f59acd1b5ad570e7d52dcfcde43804b42274f61ddcf1e7d848391d6c70f;
    y = 256'h4126885e7f786af905338238e5346d5fe77fc46388668bd0fd59be3190d2f5d1;
    z = 256'h9fc685c5fc34ff371dcfd694f81f3c2c579c66aed662bd9d976c80d06f7ea3ea;
    rx_temp = 256'h7cf27b188d034f7e8a52380304b51ac3c08969e277f21b35a60b48fc47669978;
    ry_temp = 256'h07775510db8ed040293d9ac69f7430dbba7dade63ce982299e04b79d227873d1;
    #10;
    enable = 1;
    #3000;
    $display(
        "Point Affine\nrx = %h\n   - %h\nry = %h\n   - %h %d",
        rx, rx_temp,
        ry, ry_temp,
        done
    );

    #10;
    $finish;
end


endmodule
