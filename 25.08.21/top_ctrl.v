module top_ctrl(
    //비동기 입력.
    input rst,
    //start. 시작 이후에 mode선택이 이루어진다.
    input st,
    //mode 
    input ad,
    input su,
    input mul,
    input div,
    input sqr,
    
    //내부에서 전달받는 인풋들.
    input v, //ovf or something err else.
    input done, // 하위 mode ctrl로부터 done신호를 받은 후에, 계산기 출력으로 res값을 보낸다.
    
    
    //계산기 출력으로 보내는 신호들.
    output err,
    
    //res reg.에 값 갱신을 허가. (mux로 +-*/sqr 중 선택해 가져올 것.)
    output ld_res,
    
    //내부 모듈- 모드 ctrl들에게 보낼 신호들.
    output ad_,
    output su_,
    output mul_,
    output div_,
    output sqr_,
    

);





endmodule