
module test_sha1;

reg [511:0] data0;
reg [159:0] res0_temp;
wire [159:0] res0;

sha1 #(
    .NUM(1)
) sha1_inst0 (
    .data(data0),
    .sha_res(res0)
);



reg [1023:0] data1;
reg [159:0] res1_temp;
wire [159:0] res1;

sha1 #(
    .NUM(2)
) sha1_inst1 (
    .data(data1),
    .sha_res(res1)
);

initial begin
    $dumpfile("test_sha1.vcd");
    $dumpvars(0, test_sha1);

    data0 = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
    res0_temp = 160'hA9993E364706816ABA3E25717850C26C9CD0D89D;
    #10;
    $display(
        "SHA-1:\nres = %h\n    - %h",
        res0,
        res0_temp
    );


    data1 = 1024'h6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001C0;
    res1_temp = 160'h84983E441C3BD26EBAAE4AA1F95129E5E54670F1;
    #10;
    $display(
        "SHA-1:\nres = %h\n    - %h",
        res1,
        res1_temp
    );

    $finish;
end

endmodule
