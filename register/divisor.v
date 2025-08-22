module divisor(
    //input clk
    input clk,
    // y로부터오는 값.
    input [3:0]y,
    // ld_y신호가 오면 그때 y값을 받는다.
    input ld_y,
    //ld신호가 div contoler로부터 오면, to_ALU에 y값을 ld한다.
    //to_ALU는 subtractor와 이어질 예정이다.
    output reg [3:0] to_ALU
);

always@(posedge clk)begin
    if(ld_y)begin
        to_ALU <= y;
    end
    else begin
        to_ALU <= to_ALU;
    end
end


endmodule