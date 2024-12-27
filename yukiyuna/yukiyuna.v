module yukiyuna (
    input  wire       rst,
    input  wire [2:0] sel,
    input  wire       clk,
    input  wire       inc_btn,
    input  wire       dec_btn,
    output wire [7:0] out,
    output reg  [7:0] cnt,      // exposed for simulation only
    output wire       vga_clk,
    output wire [7:0] led,
    output wire       rst_led
);
  reg [7:0] out_r;
  wire [7:0] si0_out, sq0_out, tr0_out, tr1_out, sa0_out, st0_out;
  sine si0 (
      .cnt(cnt),
      .clk(clk),
      .rst(rst),
      .out(si0_out)
  );
  square sq0 (
      .cnt(cnt),
      .rst(rst),
      .out(sq0_out)
  );
  triangle tr0 (
      .cnt(cnt),
      .rst(rst),
      .dir(1'b0),
      .out(tr0_out)
  );
  triangle tr1 (
      .cnt(cnt),
      .rst(rst),
      .dir(1'b1),
      .out(tr1_out)
  );
  saw sa0 (
      .cnt(cnt),
      .rst(rst),
      .out(sa0_out)
  );
  step st0 (
      .in (sa0_out),
      .rst(rst),
      .out(st0_out)
  );
  reg inc_btn_prev = 0;
  reg dec_btn_prev = 0;
  reg [7:0] acc = 1;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      cnt <= 0;
    end else begin
      if (inc_btn && !inc_btn_prev) begin
        acc <= acc + 8'd1;
      end

      if (dec_btn && !dec_btn_prev && acc > 2) begin
        acc <= acc - 8'd1;
      end
      inc_btn_prev <= inc_btn;
      dec_btn_prev <= dec_btn;
      if (cnt <= 8'd255) begin
        cnt <= cnt + acc;
      end else begin
        cnt <= 0;
      end
    end
  end

  always @(*) begin
    case (sel)
      3'd0: out_r <= si0_out;
      3'd1: out_r <= sq0_out;
      3'd2: out_r <= tr0_out;
      3'd3: out_r <= tr1_out;
      3'd4: out_r <= sa0_out;
      3'd5: out_r <= st0_out;
      default: out_r <= 8'd255;
    endcase
  end
  assign out = out_r;
  assign led = (8'd2 << sel);
  assign rst_led = rst;
  assign vga_clk = clk;
endmodule

module sine (
    input clk,
    input wire [7:0] cnt,
    input rst,
    output wire [7:0] out
);
  wire en = 1'b1;
  wire [7:0] s, c, c_tmp;
  wire signed [12:0] a;
  yukiyuna_cordic cordic0 (
      .clk   (clk),
      .areset(rst),
      .en    (en),
      .a     (a),
      .c     (c),
      .s     (s)
  );
  reg [7:0] out_r;
  localparam signed PI_SCALED = 13'd3216;  //3.14159 * (1 << 10)
  localparam signed STEP_SIZE = (13'd2 * PI_SCALED) / (1 << (13'd8));
  assign c_tmp = (c + 8'd64) >> 1;
  assign a = -PI_SCALED + (cnt * STEP_SIZE);
  always @(*) begin
    out_r = c_tmp;
  end
  assign out = out_r;

endmodule

module triangle (
    input wire [7:0] cnt,
    input rst,
    input dir,  // 0 - up, 1 - down
    output wire [7:0] out
);
  assign out = (rst ? 8'd0 : (dir ? (8'd128 - (cnt >> 1)) : (cnt >> 1)));
endmodule

module square (
    input wire [7:0] cnt,
    input rst,
    output wire [7:0] out
);
  assign out = (rst ? 8'd0 : ((cnt <= 8'd127) ? 8'd255 : 8'd0));
endmodule

module saw (
    input wire [7:0] cnt,
    input rst,
    output wire [7:0] out
);
  assign out = (rst ? 8'd0 : ((cnt <= 8'd127) ? cnt : (8'd255 - cnt)));
endmodule

module step (
    input wire [7:0] in,
    input rst,
    output wire [7:0] out
);
  localparam STEP = 8'd25;
  wire [7:0] remainder = in % STEP;
  assign out = (rst ? 8'd0 : (in - ((remainder < (STEP >> 1)) ? remainder : remainder - STEP)));
endmodule
