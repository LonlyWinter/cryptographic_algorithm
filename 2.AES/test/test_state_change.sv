
module test_state_change;

reg [127:0] data;
reg [127:0] out;

wire [127:0] state_now;
wire [127:0] shift_now;
wire [127:0] mix_now;

state state_inst1 (
    .data_in(data),
    .data_out(state_now)
);

shift_rows shift_inst (
    .data_in(state_now),
    .data_out(shift_now)
);

mix_columns mix_inst (
    .data_in(shift_now),
    .data_out(mix_now)
);

state state_inst2 (
    .data_in(mix_now),
    .data_out(out)
);

initial begin
    $dumpfile("test_state_change.vcd");
    $dumpvars(0, test_state_change);
    data = 128'hd42711aee0bf98f1b8b45de51e415230;
    // after shift: d4bf5d30e0b452aeb84111f11e2798e5
    // after mix: 046681e5e0cb199a48f8d37a2806264c
    #5;
    $display("out: %h", out);
    #5;
    $finish;
end

endmodule
