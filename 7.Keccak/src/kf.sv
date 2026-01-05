
// Keccak-f
module kf #(
    parameter int W = 64,
    parameter int NUM = 24
    // parameter int RHO [25] = {
    //     0, 36, 3, 41, 18,
    //     1, 44, 10, 45, 2,
    //     62, 6, 43, 15, 61,
    //     28, 55, 25, 21, 56,
    //     27, 20, 39, 8, 14
    // },
    // parameter logic [W-1:0] IOTA [NUM] = {
    //     64'h01,
    //     64'h02,
    //     64'h04,
    //     64'h08,
    //     64'h10,
    //     64'h20,
    //     64'h40,
    //     64'h80,
    //     64'h1B,
    //     64'h36,
    //     64'h6C,
    //     64'hD8,
    //     64'hAB,
    //     64'h4D,
    //     64'h9A,
    //     64'h2F,
    //     64'h5E,
    //     64'hBC,
    //     64'h63,
    //     64'hC6,
    //     64'h97,
    //     64'h35,
    //     64'h6A,
    //     64'hD4
    // }
) (
    input [LENI:0] state_inp,
    output [LENI:0] state_opt
);

wire [LENMI:0] state_mid;

localparam int LENU = 5 * 5 * W;
localparam int LENI = LENU - 1;
localparam int LENMI = LENU * 5 * NUM + LENI;

assign state_mid[LENI:0] = state_inp;

genvar index, ix, iy;
generate
    for (index = 0; index < NUM; index = index + 1) begin: gen_round
        localparam int IDXBASE = index * LENU * 5;
        // wire [LENI:0] round_inp = state_mid[IDXBASE+:LENU];
        // theta
        // state_mid[IDXBASE+:LENU]
        wire [W*5-1:0] c, d;
        for (ix = 0; ix < 5; ix = ix + 1) begin: gen_theta_c
            assign c[W*ix+:W] = state_mid[(ix*5+0)*W+IDXBASE+:W]
                                ^ state_mid[(ix*5+1)*W+IDXBASE+:W]
                                ^ state_mid[(ix*5+2)*W+IDXBASE+:W]
                                ^ state_mid[(ix*5+3)*W+IDXBASE+:W]
                                ^ state_mid[(ix*5+4)*W+IDXBASE+:W];
        end
        for (ix = 0; ix < 5; ix = ix + 1) begin: gen_theta_d
            localparam int I0 = ((ix + 5 - 1) % 5) * W;
            localparam int I1 = ((ix + 1) % 5) * W;
            // wire [W-1:0] c0 = c[I0+:W];
            // wire [W-1:0] c1 = {c[I1+:W-1], c[I1+W-1]};
            assign d[W*ix+:W] = c[I0+:W] ^ {c[I1+:W-1], c[I1+W-1]};
        end
        for (ix = 0; ix < 5; ix = ix + 1) begin: gen_theta_x
            for (iy = 0; iy < 5; iy = iy + 1) begin: gen_theta_y
                localparam int T = (ix * 5 + iy) * W + IDXBASE;
                assign state_mid[T+LENU+:W] = state_mid[T+:W]
                                            ^ d[W*ix+:W];
            end
        end
        // wire [LENI:0] theta_res = state_mid[IDXBASE+LENU+:LENU];
        // rho
        // state_mid[IDXBASE+LENU+:LENU]
        for (ix = 0; ix < 5; ix = ix + 1) begin: gen_rho_x
            for (iy = 0; iy < 5; iy = iy + 1) begin: gen_rho_y
                localparam int TT = ix * 5 + iy;
                localparam int T = TT * W + IDXBASE + LENU;
                localparam int N0 = (TT == 0)  ? 0  :
                    (TT == 1)  ? 36 :
                    (TT == 2)  ? 3  :
                    (TT == 3)  ? 41 :
                    (TT == 4)  ? 18 :
                    (TT == 5)  ? 1  :
                    (TT == 6)  ? 44 :
                    (TT == 7)  ? 10 :
                    (TT == 8)  ? 45 :
                    (TT == 9)  ? 2  :
                    (TT == 10) ? 62 :
                    (TT == 11) ? 6  :
                    (TT == 12) ? 43 :
                    (TT == 13) ? 15 :
                    (TT == 14) ? 61 :
                    (TT == 15) ? 28 :
                    (TT == 16) ? 55 :
                    (TT == 17) ? 25 :
                    (TT == 18) ? 21 :
                    (TT == 19) ? 56 :
                    (TT == 20) ? 27 :
                    (TT == 21) ? 20 :
                    (TT == 22) ? 39 :
                    (TT == 23) ? 8  : 14;
                // localparam int N0 = RHO[TT];
                localparam int N1 = W - N0;
                if (N0 > 0)
                    assign state_mid[T+LENU+:W] = {state_mid[T+:N1], state_mid[T+N1+:N0]};
                else
                    assign state_mid[T+LENU+:W] = state_mid[T+:W];
            end
        end
        // wire [LENI:0] rho_res = state_mid[IDXBASE+LENU*2+:LENU];
        // pi
        // state_mid[IDXBASE+LENU*2+:LENU]
        for (ix = 0; ix < 5; ix = ix + 1) begin: gen_pi_x
            for (iy = 0; iy < 5; iy = iy + 1) begin: gen_pi_y
                localparam int NOWX = (ix + iy * 3) % 5;
                localparam int NOWY = ix;
                localparam int T0 = (NOWX * 5 + NOWY) * W + IDXBASE + LENU * 2;
                localparam int T1 = (ix * 5 + iy) * W + IDXBASE + LENU * 3;
                assign state_mid[T1+:W] = state_mid[T0+:W];
            end
        end
        // wire [LENI:0] pi_res = state_mid[IDXBASE+LENU*3+:LENU];
        // chi
        // state_mid[IDXBASE+LENU*3+:LENU]
        for (ix = 0; ix < 5; ix = ix + 1) begin: gen_chi_x
            for (iy = 0; iy < 5; iy = iy + 1) begin: gen_chi_y
                localparam int T0 = (ix * 5 + iy) * W + IDXBASE + LENU * 4;
                localparam int T1 = (ix * 5 + iy) * W + IDXBASE + LENU * 3;
                localparam int NOWX2 = (ix + 1) % 5;
                localparam int T2 = (NOWX2 * 5 + iy) * W + IDXBASE + LENU * 3;
                localparam int NOWX3 = (ix + 2) % 5;
                localparam int T3 = (NOWX3 * 5 + iy) * W + IDXBASE + LENU * 3;
                // wire [W-1:0] add0 = state_mid[T1+:W];
                // wire [W-1:0] add1 = state_mid[T2+:W];
                // wire [W-1:0] add2 = state_mid[T3+:W];
                assign state_mid[T0+:W] = state_mid[T1+:W]
                                            ^ ((~state_mid[T2+:W]) & state_mid[T3+:W]);
            end
        end
        // wire [LENI:0] chi_res = state_mid[IDXBASE+LENU*4+:LENU];
        // iota
        // state_mid[IDXBASE+LENU*4+:LENU]
        wire [63:0] iota_t = (index == 0)  ? 64'h0000000000000001 :
            (index == 1)  ? 64'h0000000000008082 :
            (index == 2)  ? 64'h800000000000808A :
            (index == 3)  ? 64'h8000000080008000 :
            (index == 4)  ? 64'h000000000000808B :
            (index == 5)  ? 64'h0000000080000001 :
            (index == 6)  ? 64'h8000000080008081 :
            (index == 7)  ? 64'h8000000000008009 :
            (index == 8)  ? 64'h000000000000008A :
            (index == 9)  ? 64'h0000000000000088 :
            (index == 10) ? 64'h0000000080008009 :
            (index == 11) ? 64'h000000008000000A :
            (index == 12) ? 64'h000000008000808B :
            (index == 13) ? 64'h800000000000008B :
            (index == 14) ? 64'h8000000000008089 :
            (index == 15) ? 64'h8000000000008003 :
            (index == 16) ? 64'h8000000000008002 :
            (index == 17) ? 64'h8000000000000080 :
            (index == 18) ? 64'h000000000000800A :
            (index == 19) ? 64'h800000008000000A :
            (index == 20) ? 64'h8000000080008081 :
            (index == 21) ? 64'h8000000000008080 :
            (index == 22) ? 64'h0000000080000001 : 64'h8000000080008008;
        assign state_mid[IDXBASE+LENU*5+:W] = state_mid[IDXBASE+LENU*4+:W] ^ iota_t;
        // assign state_mid[IDXBASE+LENU*5+:W] = state_mid[IDXBASE+LENU*4+:W] ^ iOTA[NUM-index-1];
        assign state_mid[IDXBASE+LENU*5+W+:W*24] = state_mid[IDXBASE+LENU*4+W+:W*24];
        // wire [LENI:0] iota_res = state_mid[IDXBASE+LENU*5+:W];
    end
endgenerate

assign state_opt = state_mid[LENMI+1-LENU+:LENU];

endmodule
