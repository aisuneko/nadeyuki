`timescale 1 us / 1 us
module tb_yukiyuna ();

  reg clk, rst;
  reg  [2:0] sel;
  wire [7:0] cnt;
  wire [7:0] out;
  reg inc, dec;
  yukiyuna dut0 (
      .clk    (clk),
      .rst    (rst),
      .sel    (sel),
      .out    (out),
      .cnt    (cnt),
      .inc_btn(inc),
      .dec_btn(dec)
  );
  initial begin
    clk = 1'b0;
    rst = 1'b0;
    sel = 3'b0;
    inc = 1'b0;
    dec = 1'b0;
  end
  always #20 clk <= ~clk;

  integer i;
  always begin
    for (i = 0; i < 8; i = i > 7 ? 0 : i + 1) begin
      #20000 sel = i;
    end
  end
  initial begin
    #1000 rst = 0;
    #180000
      repeat (5) begin
        #10000 inc = 1'b1;
        #10000 inc = 1'b0;
      end
    repeat (5) begin
      #10000 dec = 1'b1;
      #10000 dec = 1'b0;
    end
    #10000 $finish;
  end

  initial $monitor("Time: %0dus, cnt: %d, sel: %d, out: %d", $time, cnt, sel, out);
endmodule
