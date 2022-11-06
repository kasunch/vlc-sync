`ifndef __GLOSSY_APP_CUSTOM_CONFIG_VH__
`define __GLOSSY_APP_CUSTOM_CONFIG_VH__
 
`define GLOSSY_APP_CONF_T_GLOSSY_SLOT                        32'd200000 // Just for debugging
`define GLOSSY_APP_CONF_T_GLOSSY_PERIOD                      32'd220000 // Just for debugging
`define GLOSSY_APP_CONF_T_GLOSSY_GUARD                       32'd10000 // Just for debugging

`define GLOSSY_APP_CONF_SYNC_IND_START                       64'd210000 // 25 ms with 40 MHz clock
`define GLOSSY_APP_CONF_SYNC_IND_HIGH_TIME                   64'd1000

`define GLOSSY_APP_CONF_MAX_N_TX                             4'd6

`endif // __GLOSSY_APP_CUSTOM_CONFIG_VH__