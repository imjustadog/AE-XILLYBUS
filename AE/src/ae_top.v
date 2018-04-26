module ae_inst(
   
	input CLK_IN_50M, //时钟模块
   input RESET,
	output CLK_AD_10M_1,
	output CLK_AD_10M_2,
	input [0:13] DATA_AD_IN_1,
	input [0:13] DATA_AD_IN_2,
	
   input  PCIE_250M_N,
   input  PCIE_250M_P,
   input  PCIE_PERST_B_LS,
   input  PCIE_RX0_N,
   input  PCIE_RX0_P,
   output  PCIE_TX0_N,
   output  PCIE_TX0_P
);

// Clock and quiesce
wire  bus_clk;
wire  quiesce;

// Wires related to /dev/xillybus_read_32
wire  user_r_read_32_rden;
wire  user_r_read_32_empty;
wire [31:0] user_r_read_32_data;
wire  user_r_read_32_eof;
wire  user_r_read_32_open;

// Wires related to /dev/xillybus_write_32
wire  user_w_write_32_wren;
wire  user_w_write_32_full;
wire [31:0] user_w_write_32_data;
wire  user_w_write_32_open;

xillybus xillybus_ins(
	// Ports related to /dev/xillybus_read_32
	// FPGA to CPU signals:
	.user_r_read_32_rden(user_r_read_32_rden),
	.user_r_read_32_empty(user_r_read_32_empty),
	.user_r_read_32_data(user_r_read_32_data),
	.user_r_read_32_eof(user_r_read_32_eof),
	.user_r_read_32_open(user_r_read_32_open),
	// Ports related to /dev/xillybus_write_32
	// CPU to FPGA signals:
	.user_w_write_32_wren(user_w_write_32_wren),
	.user_w_write_32_full(user_w_write_32_full),
	.user_w_write_32_data(user_w_write_32_data),
	.user_w_write_32_open(user_w_write_32_open),
	// General signals
	.PCIE_250M_N(PCIE_250M_N),
	.PCIE_250M_P(PCIE_250M_P),
	.PCIE_PERST_B_LS(PCIE_PERST_B_LS),
	.PCIE_RX0_N(PCIE_RX0_N),
	.PCIE_RX0_P(PCIE_RX0_P),
	.GPIO_LED(GPIO_LED),
	.PCIE_TX0_N(PCIE_TX0_N),
	.PCIE_TX0_P(PCIE_TX0_P),
	.bus_clk(bus_clk),
	.quiesce(quiesce)
);

assign  user_r_read_32_eof = 0;

wire clk_10M;
wire clk_50M;

s6_clock pll_inst (
	.CLK_IN1(CLK_IN_50M), 
	.CLK_OUT1(clk_50M), 
	.CLK_OUT2(clk_10M), 
	.RESET(RESET), 
	.LOCKED(LOCKED)
);

ODDR2 #(
   .DDR_ALIGNMENT("NONE"), // Sets output alignment
   .INIT(1'b0),    // Sets initial state of the Q 
   .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC"
) ODDR2_inst_1 (
   .Q(CLK_AD_10M_1),   // 1-bit DDR output data
   .C0(~clk_10M), // 1-bit clock input
   .C1(clk_10M), // 1-bit clock input
   .CE(1'b1), // 1-bit clock enable input
   .D0(1'b1), // 1-bit data input (associated with C0)
   .D1(1'b0), // 1-bit data input (associated with C1)
   .R(1'b0),   // 1-bit reset input
   .S(1'b0)    // 1-bit set input
);

ODDR2 #(
   .DDR_ALIGNMENT("NONE"), // Sets output alignment
   .INIT(1'b0),    // Sets initial state of the Q 
   .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC"
) ODDR2_inst_2 (
   .Q(CLK_AD_10M_2),   // 1-bit DDR output data
   .C0(~clk_10M), // 1-bit clock input
   .C1(clk_10M), // 1-bit clock input
   .CE(1'b1), // 1-bit clock enable input
   .D0(1'b1), // 1-bit data input (associated with C0)
   .D1(1'b0), // 1-bit data input (associated with C1)
   .R(1'b0),   // 1-bit reset input
   .S(1'b0)    // 1-bit set input
);

reg [2:0] cnt;
wire [31:0] din_wire;
reg [31:0] din;
assign din_wire = din;
wire wr_en;
assign wr_en = (user_w_write_32_full==0 && cnt==5)?1:0 ;//非满时写，且满后就不再写了，即便之后数据被读取导致非满

always@(posedge clk_10M or posedge RESET) 
begin
	if(RESET) 
		begin
			din <= 32'h00000000;
		end
	else 
		begin
			if(wr_en)
				begin
					din[13:0] <= DATA_AD_IN_1;
					din[29:16] <= DATA_AD_IN_2;
				end
			else 
				din <= din;
		end
	end

always@(posedge clk_10M or posedge RESET)
	if(RESET) 
		cnt <= 0;
	else 
		begin
			if(cnt == 3'd5) 
				cnt <= cnt;
			else 
				cnt <= cnt + 1;
	end

s6_fifo fifo_inst(
  .rst(!user_r_read_32_open), // input rst
  .wr_clk(clk_10M), // input wr_clk
  .rd_clk(bus_clk), // input rd_clk 
  .wr_en(wr_en), // input wr_en
  .rd_en(user_r_read_32_rden), // input rd_en
  .din(din_wire), // input din
  .dout(user_r_read_32_data), // output dout
  .full(user_w_write_32_full), // output full
  .empty(user_r_read_32_empty) // output empty
);

endmodule