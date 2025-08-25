module mul_n_div_ctrl(
    //clk
    input clk,
    
    //mode selection.
    input mul_st,
    input div_st,
    
    //중간과정에서서 받는 신호들.
    input msb, //msb=1, 뺄셈결과를 로드하지 않고 바로 shift.
    input c, //곱셈모드 중, 덧셈을 해도 좋다는 신호.
    
    //비동기 rst. 신호.
    input rst,
    
    //register들에게 보내는 신호.
    output reg sh,
    
    output reg ld_subres, //2가지 ver.이 있다. div/ mul
    //common_x와 common_y에 보낼 신호.
    //common_x
    output reg ld_dividend,
    output reg ld_multiplicand,
    //common_y
    output reg ld_divisor,
    output reg ld_multiplier,
    //곱셈/나눗셈을 위한 +,-회로에 보내는 모드선택신호.
    output reg ad,
    output reg sub,
    //done
    output reg done,
    output reg err
);



//labeling
localparam RESET = 3'b000;
localparam ADorSH = 3'b001;
localparam WAITING = 3'b010;
localparam LD_SUBRES = 3'b011;
localparam SHIFT = 3'b100;

localparam SUB = 3'b111; //나눗셈은 특별한 상태가 하나 더 필요하다.

//current state
reg [2:0] current_state, next_state;

//counter - 4번 반복했는지 여부를 확인하는 카운터.
reg [1:0] counter;

// reset이면 RESET. 아니면, next_state로.
always@(posedge clk or posedge rst)begin
    
    if(rst)begin
        current_state <= RESET;   
        counter <= 2'b00;
        done <= 1'b0;
    end
    else begin
        current_state <= next_state;
        
        //counter 업데이트
        if(current_state == SHIFT)begin
            counter <= counter +1;
        end
        else if(current_state == ADorSH && next_state == RESET)begin
            counter <= 2'b00;
            done <= 1'b1;
        end
        else counter <= counter;
    end
end

// next_state를 결정.
always@(*)begin
    case(current_state)
        
        RESET : begin
            if(mul_st ^ div_st )begin
                next_state = ADorSH;
            end
            else next_state = RESET; // = idle state
        end
        
        SUB : begin
            //counter가 4번 다 돌았을 때.
            if( counter == 2'b11)begin
                next_state = RESET;
            end
            //coutner < 4일 때
            else begin
                if(!msb) next_state = SHIFT;
                else next_state = WAITING;
            end
        end
        
        ADorSH : begin
            
            //counter가 4번 다 돌았을 때.
            if( counter == 2'b11)begin
                next_state = RESET;
            end
            //coutner < 4일 때
            else begin
                if(!c) next_state = SHIFT;
                else next_state = WAITING;
            end
        end
        
        WAITING : begin
            if(msb)begin
                next_state = SHIFT;
            end
            next_state = LD_SUBRES;
        end
        
        LD_SUBRES : begin
            next_state = SHIFT;
            
        end
        
        SHIFT : begin
            if(div_st)begin //나눗셈이면 SUB state로.
                next_state = SUB;
            end
            else begin      // 곱셈이면 ADorSH state로.
                next_state = ADorSH;
            end
        end
        
        default: next_state = RESET;
    endcase
        
end

//output
always@(*)begin

    {ld_multiplicand, ld_multiplier, ld_dividend, ld_divisor, sub, ad, sh, done, ld_subres, err} = 10'b0;

    case(current_state)
        RESET: begin
            if(mul_st && !div_st)begin
                {ld_multiplicand, ld_multiplier} = 2'b11;
            end
            else if(!mul_st && div_st)begin
                {ld_dividend, ld_divisor} = 2'b11;
            end
        end
        
        SUB : begin
            sub = 1'b1;
        end
        
        ADorSH : begin
            if(mul_st && !div_st)begin
                if(c) begin
                    ad = 1'b1;
                end
            end
        end
        WAITING : begin
        	

        end
        LD_SUBRES : begin
            ld_subres = 1'b1; 
        end
        SHIFT : begin
            sh = 1'b1;
        end
    endcase
end


endmodule