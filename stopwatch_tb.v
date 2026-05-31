module tbsw;
    reg clk;
    reg rst;
    reg start;
    reg stop;
    wire [3:0] m1;
    wire [3:0] m0;
    wire [3:0] s1;
    wire [3:0] s0;
    digi_clock uut (
        .clk(clk), 
        .rst(rst), 
        .start(start), 
        .stop(stop), 
        .m1(m1), 
        .m0(m0), 
        .s1(s1), 
        .s0(s0)
    );
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        stop = 0;
        #100;
        rst = 0;
        #500;
        start = 1;
        #200; 
          start = 0;
        #150; 
        stop = 1;
        #150;
        stop = 0;
        #500;
        $finish;
    end
endmodule
