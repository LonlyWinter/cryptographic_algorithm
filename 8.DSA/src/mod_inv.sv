
// 模逆
module mod_inv #(
    parameter int LEN = 256
) (
    input [LENI:0] a,
    input [LENI:0] p,
    input clk,
    input enable,
    output reg [LENI:0] c,
    output reg running
);

localparam int LENI = LEN - 1;

reg [LENI:0] u, v, x1, x2;
reg [LEN:0] temp;
reg [11:0] index;
reg [3:0] cls;

always @(posedge clk) begin
    if (running) begin
        // $display("Mod Inv x1: %d %d %h %h", index, cls, x1, x2);
        index = index + 1;
        if (u == 1) begin
            c = (x1 >= p) ? (x1 - p) : x1;
            running <= 0;
            cls = 0;
        end else if (u[0] == 0) begin
            u = u >> 1;
            if (x1[0] == 0) begin
                x1 = x1 >> 1;
                cls = 1;
            end else begin
                temp = x1 + p;
                x1 = temp[LEN:1];
                cls = 2;
            end
        end else if (v[0] == 0) begin
            v = v >> 1;
            if (x2[0] == 0) begin
                x2 = x2 >> 1;
                cls = 3;
            end else begin
                temp = x2 + p;
                x2 = temp[LEN:1];
                cls = 4;
            end
        end else if (u >= v) begin
            u = u - v;
            x1 = x1 > x2 ? x1 - x2 : (x1 - x2 + p);
            cls = 5;
        end else begin
            v = v - u;
            x2 = x2 > x1 ? x2 - x1 : (x2 - x1 + p);
            cls = 6;
        end
        // $display("Mod Inv u: %h", u);
    end
end

always @(posedge enable) begin
    if (running) begin
    end else begin
        u = a;
        v = p;
        x1 = 1;
        x2 = 0;
        index = 0;
        running = 1;
    end
end

endmodule
