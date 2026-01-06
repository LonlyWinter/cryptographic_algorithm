
// https://oscca.gov.cn/sca/xxgk/2010-12/17/1002389/files/302a3ada057c4a73830536d03e683110.pdf

module test_expand;

reg [511:0] data;
reg [2175:0] msg;
wire [2047:0] msg0;

msg_expand expand_inst (
    .data(data),
    .msg(msg),
    .msg0(msg0)
);


initial begin
    $dumpfile("test_expand.vcd");
    $dumpvars(0, test_expand);

    data = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
    #10;
    $display(
        "Msg Expand:\n msg = %h - b99c0545\nmsg0 = %h - 49e260d5",
        msg[2144+:32],
        msg0[2016+:32]
    );

    data = 512'h61626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364;
    #10;
    $display(
        "Msg Expand:\n msg = %h - 51baf619\nmsg0 = %h - eda9692d",
        msg[2144+:32],
        msg0[2016+:32]
    );

    data = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200;
    #10;
    $display(
        "Msg Expand:\n msg = %h - 518300f7\nmsg0 = %h - b863c496",
        msg[2144+:32],
        msg0[2016+:32]
    );

    $finish;
end

endmodule
