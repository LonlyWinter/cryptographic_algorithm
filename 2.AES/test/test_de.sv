
module test_de;

reg [127:0] data;
reg [127:0] key;
reg [127:0] out;

aes_de #(
    .LEN_KEY(128),
    .NUM_ROUND(10)
) aes_de_inst (
    .data_in(data),
    .key(key),
    .data_out(out)
);

initial begin
    $dumpfile("aes_de.vcd");
    $dumpvars(0, test_de);
    data = 128'h3925841d02dc09fbdc118597196a0b32;
    key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    #10;
    $display("AES: %h\n   - 3243f6a8885a308d313198a2e0370734", out);
    $finish;
end

endmodule
