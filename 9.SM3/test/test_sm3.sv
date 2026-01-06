
// https://oscca.gov.cn/sca/xxgk/2010-12/17/1002389/files/302a3ada057c4a73830536d03e683110.pdf
// pdf附录A.1示例2，填充后的消息第四行第一位应该为0，在下面新版本已更正
// http://c.gb688.cn/bzgk/gb/showGb?type=online&hcno=45B1A67F20F3BF339211C391E9278F5E

module test_sm3;

reg [511:0] data0;
reg [255:0] res0_temp;
wire [255:0] res0;

sm3 #(
    .NUM(1)
) sm3_inst0 (
    .data(data0),
    .res(res0)
);



reg [1023:0] data1;
reg [255:0] res1_temp;
wire [255:0] res1;

sm3 #(
    .NUM(2)
) sm3_inst1 (
    .data(data1),
    .res(res1)
);

initial begin
    $dumpfile("test_sm3.vcd");
    $dumpvars(0, test_sm3);

    data0 = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
    res0_temp = 256'h66c7f0f462eeedd9d1f2d46bdc10e4e24167c4875cf2f7a2297da02b8f4ba8e0;
    #10;
    $display(
        "SM3:\nres = %h\n    - %h",
        res0,
        res0_temp
    );


    data1 = 1024'h6162636461626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200;
    res1_temp = 256'hdebe9ff92275b8a138604889c18e5a4d6fdb70e5387e5765293dcba39c0c5732;
    #10;
    $display(
        "SM3:\nres = %h\n    - %h",
        res1,
        res1_temp
    );

    $finish;
end

endmodule
