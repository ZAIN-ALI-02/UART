
`timescale 1ns / 1ps
// `include"UART_8bit.v"

module uart_tb;
    initial begin
        $dumpfile("./temp/UART_tb_8bit.vcd");
        $dumpvars(0,uart_tb); 
    end

   reg clk;                 // Clock input
   reg reset;               // Reset input 
   reg [1:0] address;       // Addresses of the registers
   reg [7:0] w_data;        // Data to be sent
   wire [7:0] r_data;       // Data to be received
   reg write;               // write enable signal
   reg read;                // read enable signal
   reg R_X ;


// Instantiate the uart module    
uart dut (
    .clk(clk),
    .reset(reset),
    .address(address),
    .w_data(w_data),
    .r_data(r_data),
    .write(write),
    .read(read),
    .R_X(R_X)
);

// Clock generation (20 MHz clock)
always begin
    #25 clk = ~clk;
end

// Testbench initialization
initial begin
    clk = 1;
    reset = 1;
    write = 1'b0;
    read = 1'b0;
    address = 2'b00;
    w_data = 8'b0;
    #50 
    reset = 0;
    address = 2'b00;
    w_data = 8'b10000010;
    #50
    write = 1'b1;
    #50 
    address = 2'b10;
    w_data = 8'b01101001;
    #50
    write = 1'b1;
    #50 
    address = 2'b01;
    w_data = 8'b10000011;
    #50
    write = 1'b1;
    #50 
    address = 2'b11;
    #944000
    read = 1'b1;
    // End simulation
    #3000000
    $finish;
end

endmodule

