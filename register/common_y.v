module co_y( //공용 y 레지스터.
    //clock 신호.
    input clk,
    //비동기reset 신호.
    input rst,
    
    
    input [3:0]y,
   
    
    //x와 y에 로드시킬 소스들로부터 오는 input.
    //mux의 en을 위한 mode 선택 신호들 {00}~{10}
   //계산기 외부 스위치로부터는 아래 신호 3개 모두 0일 때.
    input from_mul, //mode선택 신호들은 항상 키고 있어야 한다는 제약이 있다.
    input from_div,
    input from_sqr,
    
    
    //output
    //ALU로 가는 신호
    output reg [3:0]to_ALU,
    //multiplier로 가는 신호
    output reg [3:0]to_multplier,
    //divisor로 가는 신호
    output reg [3:0] to_divisor,
    //sqr로 가는 신호.
    
    
);

localparam toALU = 3'b000;
localparam toMUL = 3'b100;
localparam toDIV = 3'b010;
localparam toSQR = 3'b001;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        {to_ALU, to_multiplier, to_divisor} <= 16'b0;
    end
    else begin
        case ({from_mul, from_div, from_sqr})
            toALU : begin
                {to_ALU, to_multiplier, to_divisor} <= {x[3:0] , 8'b0};
            end
            toMUL : begin
                {to_ALU, to_multiplier, to_divisor} <= {4'b0, y[3:0], 4'b0};
            end
            toDIV : begin
                {to_ALU, to_multiplier, to_divisor} <= {4'b0, 4'b0, y[0], y[1], y[2], y[3] };
            end
            toSQR :begin
                {to_ALU, to_multiplier, to_divisor} <= {to_ALU, to_multiplier, to_divisor};
            end
            default : begin
                {to_ALU, to_multiplier, to_divisor} <= {to_ALU, to_multiplier, to_divisor};
            end
        endcase
    end
end

endmodule