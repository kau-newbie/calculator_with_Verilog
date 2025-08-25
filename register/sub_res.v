module sub_res(
    //input clk
    input clk,
   
    //adder나 subtractor로부터 오는 신호.
    input ld_subres, //아래 값을 로드시키라는 adder로부터의 신호.
    input [4:0] subres, //adder로부터 온 중간결과값.
    
    //중간 결과를(빼고 남은 결과) ld해준다.
    output reg[4:0] subres_
);

always@(posedge clk)begin
    subres_ = 5'b00000;
    if(ld_subres)begin
        subres_ <= subres;
    end
end


endmodule