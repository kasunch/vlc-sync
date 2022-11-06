`ifndef __GLOSSY_CONFIG_VH__
`define __GLOSSY_CONFIG_VH__

`ifdef GLOSSY_CONF_CONFIG_H
`include `GLOSSY_CONF_CONFIG_H
`endif

`ifdef  GLOSSY_CONF_TXRX_BYTE_TIME
`define GLOSSY_TXRX_BYTE_TIME                   `GLOSSY_CONF_TXRX_BYTE_TIME
`else   
`define GLOSSY_TXRX_BYTE_TIME                   64'd1280 // 32 us in 40MHz clock
`endif

`ifdef  GLOSSY_CONF_TX_START_TO_TX_SFD
`define GLOSSY_TX_START_TO_TX_SFD               `GLOSSY_CONF_TX_START_TO_TX_SFD
`else
`define GLOSSY_TX_START_TO_TX_SFD               64'd2724
`endif

`ifdef GLOSSY_CONF_TX_TO_RX_TURNAROUND
`define GLOSSY_TX_TO_RX_TURNAROUND              `GLOSSY_CONF_TX_TO_RX_TURNAROUND
`else
`define GLOSSY_TX_TO_RX_TURNAROUND              64'd640 // 16 us in 40MHz clock
`endif

`ifdef GLOSSY_CONF_RX_TO_TX_TURNAROUND
`define GLOSSY_RX_TO_TX_TURNAROUND              `GLOSSY_CONF_RX_TO_TX_TURNAROUND
`else
`define GLOSSY_RX_TO_TX_TURNAROUND              64'd1280 // 32 us in 40MHz clock
`endif

`ifdef GLOSSY_CONF_RECV_EN_MIN_RL_CNT_VALIDATION
`define GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION         1
`else
`undef GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION     
`endif

`ifdef GLOSSY_CONF_RECV_MIN_RL_CNT
`define GLOSSY_RECV_MIN_RL_CNT                      `GLOSSY_CONF_RECV_MIN_RL_CNT
`else
`define GLOSSY_RECV_MIN_RL_CNT                      8'd0
`endif

`endif // __GLOSSY_CONFIG_VH__