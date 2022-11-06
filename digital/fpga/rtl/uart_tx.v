//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
// This file contains the UART Transmitter.  This transmitter is able
// to transmit 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When transmit is complete o_tx_done will be
// driven high for one clock cycle.
//
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of clk)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87

`define UART_TX_STATE_IDLE        3'h0
`define UART_TX_STATE_START_BIT   3'h1
`define UART_TX_STATE_DATA_BITS   3'h2
`define UART_TX_STATE_STOP_BIT    3'h3
`define UART_TX_STATE_CLEANUP     3'h4
  
module uart_tx (clk, i_tx_dv, i_tx_byte, 
                o_tx_active, o_tx_serial, o_tx_done);

    parameter CLKS_PER_BIT   = 87;

    input       clk;
    input       i_tx_dv;
    input [7:0] i_tx_byte;
    output      o_tx_active;
    output reg  o_tx_serial;
    output      o_tx_done;
      
    reg [2:0]    r_tx_state   = `UART_TX_STATE_IDLE;
    reg [15:0]   r_clk_cnt    = 0;
    reg [2:0]    r_bit_idx    = 0;
    reg [7:0]    r_tx_data    = 0;
    reg          r_tx_done    = 0;
    reg          r_tx_active  = 0;
     
    always @(posedge clk) begin
       
      case (r_tx_state)
          `UART_TX_STATE_IDLE: begin
              o_tx_serial   <= 1'b1;         // Drive Line High for Idle
              r_tx_done     <= 1'b0;
              r_clk_cnt <= 0;
              r_bit_idx   <= 0;
              if (i_tx_dv == 1'b1) begin
                  r_tx_active <= 1'b1;
                  r_tx_data   <= i_tx_byte;
                  r_tx_state   <= `UART_TX_STATE_START_BIT;
              end
              else
                r_tx_state <= `UART_TX_STATE_IDLE;
          end // case: s_IDLE

          // Send out Start Bit. Start bit = 0
          `UART_TX_STATE_START_BIT: begin
              o_tx_serial <= 1'b0;
              // Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
              if (r_clk_cnt < CLKS_PER_BIT-1) begin
                  r_clk_cnt <= r_clk_cnt + 16'd1;
                  r_tx_state <= `UART_TX_STATE_START_BIT;
              end 
              else begin
                  r_clk_cnt <= 0;
                  r_tx_state <= `UART_TX_STATE_DATA_BITS;
              end
          end // case: s_TX_START_BIT
         
        // Wait CLKS_PER_BIT-1 clock cycles for data bits to finish         
        `UART_TX_STATE_DATA_BITS: begin
            o_tx_serial <= r_tx_data[r_bit_idx]; 
            if (r_clk_cnt < CLKS_PER_BIT-1) begin
                r_clk_cnt <= r_clk_cnt + 16'd1;
                r_tx_state <= `UART_TX_STATE_DATA_BITS;
            end
            else begin
                r_clk_cnt <= 0;
                // Check if we have sent out all bits
                if (r_bit_idx < 7) begin
                    r_bit_idx <= r_bit_idx + 3'd1;
                    r_tx_state <= `UART_TX_STATE_DATA_BITS;
                end
                else begin
                    r_bit_idx <= 0;
                    r_tx_state <= `UART_TX_STATE_STOP_BIT;
                end
            end
        end // case: s_TX_DATA_BITS
         
        // Send out Stop bit.  Stop bit = 1
        `UART_TX_STATE_STOP_BIT: begin
            o_tx_serial <= 1'b1;
            // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
            if (r_clk_cnt < CLKS_PER_BIT-1) begin
                r_clk_cnt <= r_clk_cnt + 16'd1;
                r_tx_state <= `UART_TX_STATE_STOP_BIT;
            end
            else begin
                r_tx_done     <= 1'b1;
                r_clk_cnt <= 0;
                r_tx_state <= `UART_TX_STATE_CLEANUP;
                r_tx_active <= 1'b0;
            end
        end // case: s_Tx_STOP_BIT
         
        // Stay here 1 clock
        `UART_TX_STATE_CLEANUP: begin
            r_tx_done <= 1'b0;
            r_tx_state <= `UART_TX_STATE_IDLE;
        end
       
        default :
          r_tx_state <= `UART_TX_STATE_IDLE;
         
      endcase
    end
 
  assign o_tx_active = r_tx_active;
  assign o_tx_done   = r_tx_done;
   
endmodule
