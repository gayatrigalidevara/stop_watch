module stop_watch(input clk,rst,start,stop, output reg [3:0]m1,m0,s1,s0);
    wire p_start,p_stop;
    debounce d1(clk,start,p_start);
    debounce d2(clk,stop,p_stop);
    reg en =0;
    always @(posedge clk )begin
    if(p_start==1)
    en<=1;
    else if(p_stop==1)
    en<=0;
    else
    en<=0;
    end
    always @(posedge clk )begin
        if(rst) begin
            m1<=0; m0<=0; s1<=0; s0<=0;
        end
        else begin
             if(en) begin
                s0<=s0+1;
                if(s0==9)begin
                    s0<=0; s1<=s1+1;
                    if(s1==5)begin
                        s0<=0; s1<=0; m0<=m1+1;
                        if(m0==9)begin
                            s0<=0; s1<=0; m0<=0; m1<=m1+1;
                            if(m1==5 && m0 == 9)begin
                                 m1<=0; m0<=0; s1<=0; s0<=0;
                            end
                        end
                    end
                end
            end
        end
    end
endmodule
module debounce(input clk,button,output reg clear_data);
    parameter max_count =10;
     reg [3:0]count =0;
    initial clear_data=0;
    always @(posedge clk)begin
        if(button == clear_data)
            count<=0;
        else begin 
        if(count==max_count)
            clear_data <= button;
        else
            count <= count+1;
    end
    end
endmodule
