module multiplicand(
    //common x로부터 x값을 받는다.
    input [3:0]x,
    //mul_controler로부터 ld신호를 받는다.
    input ld_x,
    //mul_controler로부터 ad신호를 받는다.(사실상 load임.)
    input ad,
    //output
    //multiplicand 값을 가지고 있다가,
    //ad신호가 올 때 'dividend이자 계산중' reigster에 더한다(load).
    output reg [3:0] to_dividend
);



endmodule