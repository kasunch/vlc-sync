`ifndef __GLOSSY_APP_CONFIG_VH__
`define __GLOSSY_APP_CONFIG_VH__

`ifdef GLOSSY_APP_CONF_CONFIG_H
`include `GLOSSY_APP_CONF_CONFIG_H
`endif

`ifdef GLOSSY_APP_CONF_T_GLOSSY_SLOT
`define GLOSSY_APP_T_GLOSSY_SLOT                        `GLOSSY_APP_CONF_T_GLOSSY_SLOT
`else
`define GLOSSY_APP_T_GLOSSY_SLOT                        32'd800000 // 20 ms with 40 MHz clock
`endif

`ifdef GLOSSY_APP_CONF_T_GLOSSY_PERIOD
`define GLOSSY_APP_T_GLOSSY_PERIOD                      `GLOSSY_APP_CONF_T_GLOSSY_PERIOD
`else
`define GLOSSY_APP_T_GLOSSY_PERIOD                       32'd20000000 // 500 ms with 40 MHz clock
`endif

`ifdef GLOSSY_APP_CONF_T_GLOSSY_GUARD
`define GLOSSY_APP_T_GLOSSY_GUARD                      `GLOSSY_APP_CONF_T_GLOSSY_GUARD
`else
`define GLOSSY_APP_T_GLOSSY_GUARD                       32'd10000 // Just for debugging
`endif

`ifdef  GLOSSY_APP_CONF_SYNC_IND_START
`define GLOSSY_APP_SYNC_IND_START                       `GLOSSY_APP_CONF_SYNC_IND_START
`else   
`define GLOSSY_APP_SYNC_IND_START                       64'd1000000
`endif

`ifdef  GLOSSY_APP_CONF_SYNC_IND_HIGH_TIME
`define GLOSSY_APP_SYNC_IND_HIGH_TIME                   `GLOSSY_APP_CONF_SYNC_IND_HIGH_TIME
`else   
`define GLOSSY_APP_SYNC_IND_HIGH_TIME                   64'd1000
`endif

`ifdef GLOSSY_APP_CONF_MAX_N_TX
`define GLOSSY_APP_MAX_N_TX                             `GLOSSY_APP_CONF_MAX_N_TX
`else
`define GLOSSY_APP_MAX_N_TX                             4'd3
`endif

`endif // __GLOSSY_APP_CONFIG_VH__