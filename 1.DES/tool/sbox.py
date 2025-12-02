# # 生成sbox数据


# # %%
# data_in = """
# 13  2  8  4  6 15 11  1 10  9  3 14  5  0 12  7
#  1 15 13  8 10  3  7  4 12  5  6 11  0 14  9  2
#  7 11  4  1  9 12 14  2  0  6 10 13 15  3  5  8
#  2  1 14  7  4 10  8 13 15 12  9  0  3  5  6 11
# """
# data_index = 7
# data_list = data_in.replace("\n", " ").replace("  ", " ").replace("  ", " ").replace("  ", " ").strip().split(" ")

# data_out = """
# 3'd{64}: begin
#     case (row)
#         2'd0: begin
#             case(column)
#                 4'd0:  data_out = 4'd{0};
#                 4'd1:  data_out = 4'd{1};
#                 4'd2:  data_out = 4'd{2};
#                 4'd3:  data_out = 4'd{3};
#                 4'd4:  data_out = 4'd{4};
#                 4'd5:  data_out = 4'd{5};
#                 4'd6:  data_out = 4'd{6};
#                 4'd7:  data_out = 4'd{7};
#                 4'd8:  data_out = 4'd{8};
#                 4'd9:  data_out = 4'd{9};
#                 4'd10: data_out = 4'd{10};
#                 4'd11: data_out = 4'd{11};
#                 4'd12: data_out = 4'd{12};
#                 4'd13: data_out = 4'd{13};
#                 4'd14: data_out = 4'd{14};
#                 4'd15: data_out = 4'd{15};
#             endcase
#         end
#         2'd1: begin
#             case(column)
#                 4'd0:  data_out = 4'd{16};
#                 4'd1:  data_out = 4'd{17};
#                 4'd2:  data_out = 4'd{18};
#                 4'd3:  data_out = 4'd{19};
#                 4'd4:  data_out = 4'd{20};
#                 4'd5:  data_out = 4'd{21};
#                 4'd6:  data_out = 4'd{22};
#                 4'd7:  data_out = 4'd{23};
#                 4'd8:  data_out = 4'd{24};
#                 4'd9:  data_out = 4'd{25};
#                 4'd10: data_out = 4'd{26};
#                 4'd11: data_out = 4'd{27};
#                 4'd12: data_out = 4'd{28};
#                 4'd13: data_out = 4'd{29};
#                 4'd14: data_out = 4'd{30};
#                 4'd15: data_out = 4'd{31};
#             endcase
#         end
#         2'd2: begin
#             case(column)
#                 4'd0:  data_out = 4'd{32};
#                 4'd1:  data_out = 4'd{33};
#                 4'd2:  data_out = 4'd{34};
#                 4'd3:  data_out = 4'd{35};
#                 4'd4:  data_out = 4'd{36};
#                 4'd5:  data_out = 4'd{37};
#                 4'd6:  data_out = 4'd{38};
#                 4'd7:  data_out = 4'd{39};
#                 4'd8:  data_out = 4'd{40};
#                 4'd9:  data_out = 4'd{41};
#                 4'd10: data_out = 4'd{42};
#                 4'd11: data_out = 4'd{43};
#                 4'd12: data_out = 4'd{44};
#                 4'd13: data_out = 4'd{45};
#                 4'd14: data_out = 4'd{46};
#                 4'd15: data_out = 4'd{47};
#             endcase
#         end
#         2'd3: begin
#             case(column)
#                 4'd0:  data_out = 4'd{48};
#                 4'd1:  data_out = 4'd{49};
#                 4'd2:  data_out = 4'd{50};
#                 4'd3:  data_out = 4'd{51};
#                 4'd4:  data_out = 4'd{52};
#                 4'd5:  data_out = 4'd{53};
#                 4'd6:  data_out = 4'd{54};
#                 4'd7:  data_out = 4'd{55};
#                 4'd8:  data_out = 4'd{56};
#                 4'd9:  data_out = 4'd{57};
#                 4'd10: data_out = 4'd{58};
#                 4'd11: data_out = 4'd{59};
#                 4'd12: data_out = 4'd{60};
#                 4'd13: data_out = 4'd{61};
#                 4'd14: data_out = 4'd{62};
#                 4'd15: data_out = 4'd{63};
#             endcase
#         end
#     endcase
# end
# """.format(*data_list, data_index)
# # print(data_out)
# # print(data_list)
# %%





# %%

data_in = """
13  2  8  4  6 15 11  1 10  9  3 14  5  0 12  7
 1 15 13  8 10  3  7  4 12  5  6 11  0 14  9  2
 7 11  4  1  9 12 14  2  0  6 10 13 15  3  5  8
 2  1 14  7  4 10  8 13 15 12  9  0  3  5  6 11


 15  1  8 14  6 11  3  4  9  7  2 13 12  0  5 10
 3 13  4  7 15  2  8 14 12  0  1 10  6  9 11  5
 0 14  7 11 10  4 13  1  5  8 12  6  9  3  2 15
13  8 10  1  3 15  4  2 11  6  7 12  0  5 14  9


10  0  9 14  6  3 15  5  1 13 12  7 11  4  2  8
13  7  0  9  3  4  6 10  2  8  5 14 12 11 15  1
13  6  4  9  8 15  3  0 11  1  2 12  5 10 14  7
 1 10 13  0  6  9  8  7  4 15 14  3 11  5  2 12


  7 13 14  3  0  6  9 10  1  2  8  5 11 12  4 15
13  8 11  5  6 15  0  3  4  7  2 12  1 10 14  9
10  6  9  0 12 11  7 13 15  1  3 14  5  2  8  4
 3 15  0  6 10  1 13  8  9  4  5 11 12  7  2 14


  2 12  4  1  7 10 11  6  8  5  3 15 13  0 14  9
14 11  2 12  4  7 13  1  5  0 15 10  3  9  8  6
 4  2  1 11 10 13  7  8 15  9 12  5  6  3  0 14
11  8 12  7  1 14  2 13  6 15  0  9 10  4  5  3


12  1 10 15  9  2  6  8  0 13  3  4 14  7  5 11
10 15  4  2  7 12  9  5  6  1 13 14  0 11  3  8
 9 14 15  5  2  8 12  3  7  0  4 10  1 13 11  6
 4  3  2 12  9  5 15 10 11 14  1  7  6  0  8 13


 4 11  2 14 15  0  8 13  3 12  9  7  5 10  6  1
13  0 11  7  4  9  1 10 14  3  5 12  2 15  8  6
 1  4 11 13 12  3  7 14 10 15  6  8  0  5  9  2
 6 11 13  8  1  4 10  7  9  5  0 15 14  2  3 12


13  2  8  4  6 15 11  1 10  9  3 14  5  0 12  7
 1 15 13  8 10  3  7  4 12  5  6 11  0 14  9  2
 7 11  4  1  9 12 14  2  0  6 10 13 15  3  5  8
 2  1 14  7  4 10  8 13 15 12  9  0  3  5  6 11
"""
data_list = map(
    lambda d: ", ".join(map(
        lambda dd: "4'd{}".format(dd),
        d.replace("\n", " ").replace("  ", " ").replace("  ", " ").replace("  ", " ").strip().split(" ")
    )),
    data_in.strip().split("\n\n\n")
)
print(",\n".join(map(
    lambda d: "{{{}}}".format(d),
    data_list
)))