module dividend(
    input clk,
    //곱셈 계산할 때
    //input
    input ld_multiplier, //이 신호를 받고, y에서 multiplier를 가져올 수 있다.
    input ad,
    input [4:1] multiplier, // multiplier 저장위치.
    //output
    output [8:1] res_mul, //곱셈 결과
    output c, //c가 1이라면, ad(ld)후 sh. 0이라면, 바로 sh.
    
    //나눗셈 계산할 때
    //input
    input ld_dividend, //이 신호를 받고, x에서 dividend를 가져올 수 있다.
    input [7:0] dividnd, //처음 dividend를 받아온다. 역순으로 ld해줘야 한다!
    input [3:0] sub_res, //매 loop마다의 뺄셈 결과를 가져온다.
    //output
    output [3:0] minuend, //나눗셈 중 매 loop마다 빼지는 부분. 비트는 역순으로 subtractor(ALU)에 전달된다.
    output [8:4] quot, //나눗셈 몫 결과
    output [3:0] remainder, //나눗셈 나머지 결과
    
    //공용
    input sh // -> 방향으로 shift.
    
);

reg [8:0] calculating; // [8:4]=quot, [4:1]= multiplier, [3:0]=remainder, [7:0]=dividend(역순으로해줘야한다.)

assign wire c = calculating[1];
assign minuend = {calculating[0],calculating[1],calculating[2],calculating[3]};

always@(posedge clk)begin
    if(ld_multiplier)begin
        calculating <= {};
    end
    else if(ld_dividend)begin
        calculating <= {};
    end
    else begin
        calculating <= {};
    end
end

endmodule