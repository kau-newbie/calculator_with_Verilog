module dividend(
    input clk,
    //common_x와 y
    input [7:0]x,
    input [3:0]y,
    //곱셈 계산할 때
    //input
    input ld_multiplier, //이 신호를 받고, y에서 multiplier를 가져올 수 있다.
    // [4:1] multiplier, // multiplier 저장위치.
    //output
    output [7:0] res_mul, //곱셈 결과
    output [3:0] summend, //곱셈 중간에 더해질 수수
    output wire c, //c가 1이라면, ad(ld)후 sh. 0이라면, 바로 sh.
    
    //나눗셈 계산할 때
    //input
    input ld_dividend, //이 신호를 받고, x에서 dividend를 가져올 수 있다.
    //[7:0] dividnd, //처음 dividend를 받아온다. 역순으로 ld해줘야 한다!
    
    //output
    output [3:0] minuend, //나눗셈 중 매 loop마다 빼지는 부분. 비트는 역순으로 subtractor(ALU)에 전달된다.
    output [8:4] quot, //나눗셈 몫 결과
    output [3:0] remainder, //나눗셈 나머지 결과
    
    //공용
    input [3:0] sub_res, //매 loop마다의 덧셈/뺄셈 결과를 가져온다.
    input sh // -> 방향으로 shift.
    
);
integer i;

reg [8:0] calculating; // [8:4]=quot, [4:1]= multiplier, [3:0]=remainder(역순), [7:0]=dividend(역순으로해줘야한다.)

//나눗셈 결과, 중간결과
assign minuend = {calculating[0],calculating[1],calculating[2],calculating[3]};

assign quot = {calculating[4],calculating[5], calculating[6],calculating[7],calculating[8]};
assign remainder = {calculating[0],calculating[1],calculating[2],calculating[3]};

//곱셈결과, 중간 결과
assign c = calculating[1];

assign summend = calculating[8:5];
assign res_mul = calculating[8:1];

always@(posedge clk)begin
    if(ld_multiplier)begin //y를 multiplier위치에 넣어준다.
        calculating[4:1] <= y[3:0];
    end
    else if(ld_dividend)begin //x를 dividend위치에 역순으로 넣어준다.
        for (i = 0; i < 8; i = i + 1) begin
            calculating[i] <= x[7-i];
        end
    end
    else if(sub_res)begin
        if(ld_dividend)begin
           calculating[3:0] <= {sub_res[0],sub_res[1],sub_res[2],sub_res[3] };  
        end
        else if(ld_multiplier)begin
            calculating[8:4] <= sub_res[3:0];
        end
    end
    else if(sh)begin         //그다음우선순위인 shift.
        calculating <= {1'b0, calculating[8:1]};
    end
end

endmodule