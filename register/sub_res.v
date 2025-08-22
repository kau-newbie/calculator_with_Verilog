module sub_res(
    //input clk
    input clk,
    //subtractor로부터 오는 신호.
    input ld_subres,
    input [3:0] subres,
    //중간 결과를(빼고 남은 결과) ld해준다.
    output reg[3:0] subres_
);

always@(posedge clk)begin
    if(ld_subres)begin
        subres_ <= {subres[0],subres[1],subres[2],subres[3]}; //ld 할 때 역방향으로 넣어준다.
    end
    else begin
        subres_ <= subres_;
    end
end


endmodule