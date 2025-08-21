module ad_n_su_ctrl(
    //clk
    input clk,
    //비동기 rst
    input rst,
    //덧셈 시작신호.
    input ad,
    input su,
    //combinational circuit(ALU)로부터 ovf여부 신호를 받는다.
    input v,
    
    //x와 y를 로드시킨다.
    /*
        이거 wire 해야하나마나 고민 많이 했지만..., 
        FSM 만들 때, 게산기 ld스위치를 꺼도 State flow는 흘러가게끔 하려했더니,
        어쩔수가 없었다요....
    */
    output reg ld_x,
    output reg ld_y,
    output reg ld_y2c, //y를 2의 보수로 바꿔서 ld하라는 신호이다. 
    //alert_err.
    output reg v_,
    
    //reg에 조합회로(ALU)의 계산 결과를 올린다.
    output reg ld_res,
    //끝났다고 알리는 신호.
    output reg done
    
);

always@(posedge clk)begin
    v_ = v;
end
// done신호는 critical path를 지날떄의 delay보다 
// 1 clock period가 더 길게끔 설정해줘 해결한다.
always@(posedge clk, rst)begin
    if(rst)begin
        {ld_x, ld_y, ld_y2c, v_, ld_res, done} <= 6'b000000;
    end
    else begin
        //initializing : S0
        {ld_x, ld_y, ld_y2c, v_, ld_res, done} <= 6'b000000;
        //3'b000일때 : S1
        if({ld_x, ld_y, ld_y2c} == 3'b000)begin    
            if({ad,su}==2'b10)begin
                {ld_x, ld_y, ld_yc2} <= 3'b110;
            end
            else if({ad,su}==2'b01)begin
                {ld_x, ld_y, ld_y2c} <= 3'b101;
            end
        end
        //3'b111일 때 : S2: waiting state
        else begin
            done <= 1'b1;
            ld_res <= 1'b1;
        end
    end
end
endmodule