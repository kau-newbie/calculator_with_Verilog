module multiplicand(
    //clk
    input clk,
    //common x로부터 x값을 받는다.
    input [3:0]x,
   
    //mul_controler로부터 ld신호를 받는다.
    input ld_x,
    //output
    //multiplicand 값을 가지고 있다가,
    //ad신호가 올 때 'dividend이자 계산중' reigster에 더한다(load).
    output reg [3:0] to_dividend
);

always@(posedge clk)begin
    if(ld_x)begin
        to_dividend <= x;
    end
    else begin
        to_dividend <= to_dividend;
    end
end
endmodule