`ifndef __GLOSSY_CUSTOM_CONFIG_VH__
`define __GLOSSY_CUSTOM_CONFIG_VH__

  
`define GLOSSY_CONF_TXRX_BYTE_TIME                   64'd1280 // 32 us with 40MHz clock
`define GLOSSY_CONF_TX_START_TO_TX_SFD               64'd2724
`define GLOSSY_CONF_TX_TO_RX_TURNAROUND              64'd640  // 4 us with 40 MHz clock
`define GLOSSY_CONF_RX_TO_TX_TURNAROUND              64'd1280 // 8 us with 40 MHz clock

//`define GLOSSY_CONF_RECV_EN_MIN_RL_CNT_VALIDATION    1
//`define GLOSSY_CONF_RECV_MIN_RL_CNT                  8'd0

`endif // __GLOSSY_CUSTOM_CONFIG_VH__