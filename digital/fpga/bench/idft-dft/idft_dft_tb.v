module idft_dft_tb();

    reg clk, reset;
    
    integer i;
    
    reg [15:0] counter;
    
    reg r_idft_next;
    wire w_idft_next_out;
    reg [9:0] r_idft_in [127:0];
    wire [9:0] w_idft_in [127:0];
    wire [9:0] w_idft_out [127:0];
    
    reg r_dft_next;
    wire w_dft_next;
    wire w_dft_next_out;
    reg [9:0] r_dft_in [127:0];
    wire [9:0] w_dft_in [127:0];
    wire [9:0] w_dft_out [127:0];

    wire [9:0] IDFT_IN0;
    wire [9:0] IDFT_IN1;
    wire [9:0] IDFT_IN2;
    wire [9:0] IDFT_IN3;
    wire [9:0] IDFT_IN4;
    wire [9:0] IDFT_IN5;
    wire [9:0] IDFT_IN6;
    wire [9:0] IDFT_IN7;
    wire [9:0] IDFT_IN8;
    wire [9:0] IDFT_IN9;
    wire [9:0] IDFT_IN10;
    wire [9:0] IDFT_IN11;
    wire [9:0] IDFT_IN12;
    wire [9:0] IDFT_IN13;
    wire [9:0] IDFT_IN14;
    wire [9:0] IDFT_IN15;
    wire [9:0] IDFT_IN16;
    wire [9:0] IDFT_IN17;
    wire [9:0] IDFT_IN18;
    wire [9:0] IDFT_IN19;
    wire [9:0] IDFT_IN20;
    wire [9:0] IDFT_IN21;
    wire [9:0] IDFT_IN22;
    wire [9:0] IDFT_IN23;
    wire [9:0] IDFT_IN24;
    wire [9:0] IDFT_IN25;
    wire [9:0] IDFT_IN26;
    wire [9:0] IDFT_IN27;
    wire [9:0] IDFT_IN28;
    wire [9:0] IDFT_IN29;
    wire [9:0] IDFT_IN30;
    wire [9:0] IDFT_IN31;
    wire [9:0] IDFT_IN32;
    wire [9:0] IDFT_IN33;
    wire [9:0] IDFT_IN34;
    wire [9:0] IDFT_IN35;
    wire [9:0] IDFT_IN36;
    wire [9:0] IDFT_IN37;
    wire [9:0] IDFT_IN38;
    wire [9:0] IDFT_IN39;
    wire [9:0] IDFT_IN40;
    wire [9:0] IDFT_IN41;
    wire [9:0] IDFT_IN42;
    wire [9:0] IDFT_IN43;
    wire [9:0] IDFT_IN44;
    wire [9:0] IDFT_IN45;
    wire [9:0] IDFT_IN46;
    wire [9:0] IDFT_IN47;
    wire [9:0] IDFT_IN48;
    wire [9:0] IDFT_IN49;
    wire [9:0] IDFT_IN50;
    wire [9:0] IDFT_IN51;
    wire [9:0] IDFT_IN52;
    wire [9:0] IDFT_IN53;
    wire [9:0] IDFT_IN54;
    wire [9:0] IDFT_IN55;
    wire [9:0] IDFT_IN56;
    wire [9:0] IDFT_IN57;
    wire [9:0] IDFT_IN58;
    wire [9:0] IDFT_IN59;
    wire [9:0] IDFT_IN60;
    wire [9:0] IDFT_IN61;
    wire [9:0] IDFT_IN62;
    wire [9:0] IDFT_IN63;
    wire [9:0] IDFT_IN64;
    wire [9:0] IDFT_IN65;
    wire [9:0] IDFT_IN66;
    wire [9:0] IDFT_IN67;
    wire [9:0] IDFT_IN68;
    wire [9:0] IDFT_IN69;
    wire [9:0] IDFT_IN70;
    wire [9:0] IDFT_IN71;
    wire [9:0] IDFT_IN72;
    wire [9:0] IDFT_IN73;
    wire [9:0] IDFT_IN74;
    wire [9:0] IDFT_IN75;
    wire [9:0] IDFT_IN76;
    wire [9:0] IDFT_IN77;
    wire [9:0] IDFT_IN78;
    wire [9:0] IDFT_IN79;
    wire [9:0] IDFT_IN80;
    wire [9:0] IDFT_IN81;
    wire [9:0] IDFT_IN82;
    wire [9:0] IDFT_IN83;
    wire [9:0] IDFT_IN84;
    wire [9:0] IDFT_IN85;
    wire [9:0] IDFT_IN86;
    wire [9:0] IDFT_IN87;
    wire [9:0] IDFT_IN88;
    wire [9:0] IDFT_IN89;
    wire [9:0] IDFT_IN90;
    wire [9:0] IDFT_IN91;
    wire [9:0] IDFT_IN92;
    wire [9:0] IDFT_IN93;
    wire [9:0] IDFT_IN94;
    wire [9:0] IDFT_IN95;
    wire [9:0] IDFT_IN96;
    wire [9:0] IDFT_IN97;
    wire [9:0] IDFT_IN98;
    wire [9:0] IDFT_IN99;
    wire [9:0] IDFT_IN100;
    wire [9:0] IDFT_IN101;
    wire [9:0] IDFT_IN102;
    wire [9:0] IDFT_IN103;
    wire [9:0] IDFT_IN104;
    wire [9:0] IDFT_IN105;
    wire [9:0] IDFT_IN106;
    wire [9:0] IDFT_IN107;
    wire [9:0] IDFT_IN108;
    wire [9:0] IDFT_IN109;
    wire [9:0] IDFT_IN110;
    wire [9:0] IDFT_IN111;
    wire [9:0] IDFT_IN112;
    wire [9:0] IDFT_IN113;
    wire [9:0] IDFT_IN114;
    wire [9:0] IDFT_IN115;
    wire [9:0] IDFT_IN116;
    wire [9:0] IDFT_IN117;
    wire [9:0] IDFT_IN118;
    wire [9:0] IDFT_IN119;
    wire [9:0] IDFT_IN120;
    wire [9:0] IDFT_IN121;
    wire [9:0] IDFT_IN122;
    wire [9:0] IDFT_IN123;
    wire [9:0] IDFT_IN124;
    wire [9:0] IDFT_IN125;
    wire [9:0] IDFT_IN126;
    wire [9:0] IDFT_IN127;
    
    wire [9:0] IDFT_OUT0;
    wire [9:0] IDFT_OUT1;
    wire [9:0] IDFT_OUT2;
    wire [9:0] IDFT_OUT3;
    wire [9:0] IDFT_OUT4;
    wire [9:0] IDFT_OUT5;
    wire [9:0] IDFT_OUT6;
    wire [9:0] IDFT_OUT7;
    wire [9:0] IDFT_OUT8;
    wire [9:0] IDFT_OUT9;
    wire [9:0] IDFT_OUT10;
    wire [9:0] IDFT_OUT11;
    wire [9:0] IDFT_OUT12;
    wire [9:0] IDFT_OUT13;
    wire [9:0] IDFT_OUT14;
    wire [9:0] IDFT_OUT15;
    wire [9:0] IDFT_OUT16;
    wire [9:0] IDFT_OUT17;
    wire [9:0] IDFT_OUT18;
    wire [9:0] IDFT_OUT19;
    wire [9:0] IDFT_OUT20;
    wire [9:0] IDFT_OUT21;
    wire [9:0] IDFT_OUT22;
    wire [9:0] IDFT_OUT23;
    wire [9:0] IDFT_OUT24;
    wire [9:0] IDFT_OUT25;
    wire [9:0] IDFT_OUT26;
    wire [9:0] IDFT_OUT27;
    wire [9:0] IDFT_OUT28;
    wire [9:0] IDFT_OUT29;
    wire [9:0] IDFT_OUT30;
    wire [9:0] IDFT_OUT31;
    wire [9:0] IDFT_OUT32;
    wire [9:0] IDFT_OUT33;
    wire [9:0] IDFT_OUT34;
    wire [9:0] IDFT_OUT35;
    wire [9:0] IDFT_OUT36;
    wire [9:0] IDFT_OUT37;
    wire [9:0] IDFT_OUT38;
    wire [9:0] IDFT_OUT39;
    wire [9:0] IDFT_OUT40;
    wire [9:0] IDFT_OUT41;
    wire [9:0] IDFT_OUT42;
    wire [9:0] IDFT_OUT43;
    wire [9:0] IDFT_OUT44;
    wire [9:0] IDFT_OUT45;
    wire [9:0] IDFT_OUT46;
    wire [9:0] IDFT_OUT47;
    wire [9:0] IDFT_OUT48;
    wire [9:0] IDFT_OUT49;
    wire [9:0] IDFT_OUT50;
    wire [9:0] IDFT_OUT51;
    wire [9:0] IDFT_OUT52;
    wire [9:0] IDFT_OUT53;
    wire [9:0] IDFT_OUT54;
    wire [9:0] IDFT_OUT55;
    wire [9:0] IDFT_OUT56;
    wire [9:0] IDFT_OUT57;
    wire [9:0] IDFT_OUT58;
    wire [9:0] IDFT_OUT59;
    wire [9:0] IDFT_OUT60;
    wire [9:0] IDFT_OUT61;
    wire [9:0] IDFT_OUT62;
    wire [9:0] IDFT_OUT63;
    wire [9:0] IDFT_OUT64;
    wire [9:0] IDFT_OUT65;
    wire [9:0] IDFT_OUT66;
    wire [9:0] IDFT_OUT67;
    wire [9:0] IDFT_OUT68;
    wire [9:0] IDFT_OUT69;
    wire [9:0] IDFT_OUT70;
    wire [9:0] IDFT_OUT71;
    wire [9:0] IDFT_OUT72;
    wire [9:0] IDFT_OUT73;
    wire [9:0] IDFT_OUT74;
    wire [9:0] IDFT_OUT75;
    wire [9:0] IDFT_OUT76;
    wire [9:0] IDFT_OUT77;
    wire [9:0] IDFT_OUT78;
    wire [9:0] IDFT_OUT79;
    wire [9:0] IDFT_OUT80;
    wire [9:0] IDFT_OUT81;
    wire [9:0] IDFT_OUT82;
    wire [9:0] IDFT_OUT83;
    wire [9:0] IDFT_OUT84;
    wire [9:0] IDFT_OUT85;
    wire [9:0] IDFT_OUT86;
    wire [9:0] IDFT_OUT87;
    wire [9:0] IDFT_OUT88;
    wire [9:0] IDFT_OUT89;
    wire [9:0] IDFT_OUT90;
    wire [9:0] IDFT_OUT91;
    wire [9:0] IDFT_OUT92;
    wire [9:0] IDFT_OUT93;
    wire [9:0] IDFT_OUT94;
    wire [9:0] IDFT_OUT95;
    wire [9:0] IDFT_OUT96;
    wire [9:0] IDFT_OUT97;
    wire [9:0] IDFT_OUT98;
    wire [9:0] IDFT_OUT99;
    wire [9:0] IDFT_OUT100;
    wire [9:0] IDFT_OUT101;
    wire [9:0] IDFT_OUT102;
    wire [9:0] IDFT_OUT103;
    wire [9:0] IDFT_OUT104;
    wire [9:0] IDFT_OUT105;
    wire [9:0] IDFT_OUT106;
    wire [9:0] IDFT_OUT107;
    wire [9:0] IDFT_OUT108;
    wire [9:0] IDFT_OUT109;
    wire [9:0] IDFT_OUT110;
    wire [9:0] IDFT_OUT111;
    wire [9:0] IDFT_OUT112;
    wire [9:0] IDFT_OUT113;
    wire [9:0] IDFT_OUT114;
    wire [9:0] IDFT_OUT115;
    wire [9:0] IDFT_OUT116;
    wire [9:0] IDFT_OUT117;
    wire [9:0] IDFT_OUT118;
    wire [9:0] IDFT_OUT119;
    wire [9:0] IDFT_OUT120;
    wire [9:0] IDFT_OUT121;
    wire [9:0] IDFT_OUT122;
    wire [9:0] IDFT_OUT123;
    wire [9:0] IDFT_OUT124;
    wire [9:0] IDFT_OUT125;
    wire [9:0] IDFT_OUT126;
    wire [9:0] IDFT_OUT127;
    
    wire [9:0] DFT_IN0;
    wire [9:0] DFT_IN1;
    wire [9:0] DFT_IN2;
    wire [9:0] DFT_IN3;
    wire [9:0] DFT_IN4;
    wire [9:0] DFT_IN5;
    wire [9:0] DFT_IN6;
    wire [9:0] DFT_IN7;
    wire [9:0] DFT_IN8;
    wire [9:0] DFT_IN9;
    wire [9:0] DFT_IN10;
    wire [9:0] DFT_IN11;
    wire [9:0] DFT_IN12;
    wire [9:0] DFT_IN13;
    wire [9:0] DFT_IN14;
    wire [9:0] DFT_IN15;
    wire [9:0] DFT_IN16;
    wire [9:0] DFT_IN17;
    wire [9:0] DFT_IN18;
    wire [9:0] DFT_IN19;
    wire [9:0] DFT_IN20;
    wire [9:0] DFT_IN21;
    wire [9:0] DFT_IN22;
    wire [9:0] DFT_IN23;
    wire [9:0] DFT_IN24;
    wire [9:0] DFT_IN25;
    wire [9:0] DFT_IN26;
    wire [9:0] DFT_IN27;
    wire [9:0] DFT_IN28;
    wire [9:0] DFT_IN29;
    wire [9:0] DFT_IN30;
    wire [9:0] DFT_IN31;
    wire [9:0] DFT_IN32;
    wire [9:0] DFT_IN33;
    wire [9:0] DFT_IN34;
    wire [9:0] DFT_IN35;
    wire [9:0] DFT_IN36;
    wire [9:0] DFT_IN37;
    wire [9:0] DFT_IN38;
    wire [9:0] DFT_IN39;
    wire [9:0] DFT_IN40;
    wire [9:0] DFT_IN41;
    wire [9:0] DFT_IN42;
    wire [9:0] DFT_IN43;
    wire [9:0] DFT_IN44;
    wire [9:0] DFT_IN45;
    wire [9:0] DFT_IN46;
    wire [9:0] DFT_IN47;
    wire [9:0] DFT_IN48;
    wire [9:0] DFT_IN49;
    wire [9:0] DFT_IN50;
    wire [9:0] DFT_IN51;
    wire [9:0] DFT_IN52;
    wire [9:0] DFT_IN53;
    wire [9:0] DFT_IN54;
    wire [9:0] DFT_IN55;
    wire [9:0] DFT_IN56;
    wire [9:0] DFT_IN57;
    wire [9:0] DFT_IN58;
    wire [9:0] DFT_IN59;
    wire [9:0] DFT_IN60;
    wire [9:0] DFT_IN61;
    wire [9:0] DFT_IN62;
    wire [9:0] DFT_IN63;
    wire [9:0] DFT_IN64;
    wire [9:0] DFT_IN65;
    wire [9:0] DFT_IN66;
    wire [9:0] DFT_IN67;
    wire [9:0] DFT_IN68;
    wire [9:0] DFT_IN69;
    wire [9:0] DFT_IN70;
    wire [9:0] DFT_IN71;
    wire [9:0] DFT_IN72;
    wire [9:0] DFT_IN73;
    wire [9:0] DFT_IN74;
    wire [9:0] DFT_IN75;
    wire [9:0] DFT_IN76;
    wire [9:0] DFT_IN77;
    wire [9:0] DFT_IN78;
    wire [9:0] DFT_IN79;
    wire [9:0] DFT_IN80;
    wire [9:0] DFT_IN81;
    wire [9:0] DFT_IN82;
    wire [9:0] DFT_IN83;
    wire [9:0] DFT_IN84;
    wire [9:0] DFT_IN85;
    wire [9:0] DFT_IN86;
    wire [9:0] DFT_IN87;
    wire [9:0] DFT_IN88;
    wire [9:0] DFT_IN89;
    wire [9:0] DFT_IN90;
    wire [9:0] DFT_IN91;
    wire [9:0] DFT_IN92;
    wire [9:0] DFT_IN93;
    wire [9:0] DFT_IN94;
    wire [9:0] DFT_IN95;
    wire [9:0] DFT_IN96;
    wire [9:0] DFT_IN97;
    wire [9:0] DFT_IN98;
    wire [9:0] DFT_IN99;
    wire [9:0] DFT_IN100;
    wire [9:0] DFT_IN101;
    wire [9:0] DFT_IN102;
    wire [9:0] DFT_IN103;
    wire [9:0] DFT_IN104;
    wire [9:0] DFT_IN105;
    wire [9:0] DFT_IN106;
    wire [9:0] DFT_IN107;
    wire [9:0] DFT_IN108;
    wire [9:0] DFT_IN109;
    wire [9:0] DFT_IN110;
    wire [9:0] DFT_IN111;
    wire [9:0] DFT_IN112;
    wire [9:0] DFT_IN113;
    wire [9:0] DFT_IN114;
    wire [9:0] DFT_IN115;
    wire [9:0] DFT_IN116;
    wire [9:0] DFT_IN117;
    wire [9:0] DFT_IN118;
    wire [9:0] DFT_IN119;
    wire [9:0] DFT_IN120;
    wire [9:0] DFT_IN121;
    wire [9:0] DFT_IN122;
    wire [9:0] DFT_IN123;
    wire [9:0] DFT_IN124;
    wire [9:0] DFT_IN125;
    wire [9:0] DFT_IN126;
    wire [9:0] DFT_IN127;
    
    wire [9:0] DFT_OUT0;
    wire [9:0] DFT_OUT1;
    wire [9:0] DFT_OUT2;
    wire [9:0] DFT_OUT3;
    wire [9:0] DFT_OUT4;
    wire [9:0] DFT_OUT5;
    wire [9:0] DFT_OUT6;
    wire [9:0] DFT_OUT7;
    wire [9:0] DFT_OUT8;
    wire [9:0] DFT_OUT9;
    wire [9:0] DFT_OUT10;
    wire [9:0] DFT_OUT11;
    wire [9:0] DFT_OUT12;
    wire [9:0] DFT_OUT13;
    wire [9:0] DFT_OUT14;
    wire [9:0] DFT_OUT15;
    wire [9:0] DFT_OUT16;
    wire [9:0] DFT_OUT17;
    wire [9:0] DFT_OUT18;
    wire [9:0] DFT_OUT19;
    wire [9:0] DFT_OUT20;
    wire [9:0] DFT_OUT21;
    wire [9:0] DFT_OUT22;
    wire [9:0] DFT_OUT23;
    wire [9:0] DFT_OUT24;
    wire [9:0] DFT_OUT25;
    wire [9:0] DFT_OUT26;
    wire [9:0] DFT_OUT27;
    wire [9:0] DFT_OUT28;
    wire [9:0] DFT_OUT29;
    wire [9:0] DFT_OUT30;
    wire [9:0] DFT_OUT31;
    wire [9:0] DFT_OUT32;
    wire [9:0] DFT_OUT33;
    wire [9:0] DFT_OUT34;
    wire [9:0] DFT_OUT35;
    wire [9:0] DFT_OUT36;
    wire [9:0] DFT_OUT37;
    wire [9:0] DFT_OUT38;
    wire [9:0] DFT_OUT39;
    wire [9:0] DFT_OUT40;
    wire [9:0] DFT_OUT41;
    wire [9:0] DFT_OUT42;
    wire [9:0] DFT_OUT43;
    wire [9:0] DFT_OUT44;
    wire [9:0] DFT_OUT45;
    wire [9:0] DFT_OUT46;
    wire [9:0] DFT_OUT47;
    wire [9:0] DFT_OUT48;
    wire [9:0] DFT_OUT49;
    wire [9:0] DFT_OUT50;
    wire [9:0] DFT_OUT51;
    wire [9:0] DFT_OUT52;
    wire [9:0] DFT_OUT53;
    wire [9:0] DFT_OUT54;
    wire [9:0] DFT_OUT55;
    wire [9:0] DFT_OUT56;
    wire [9:0] DFT_OUT57;
    wire [9:0] DFT_OUT58;
    wire [9:0] DFT_OUT59;
    wire [9:0] DFT_OUT60;
    wire [9:0] DFT_OUT61;
    wire [9:0] DFT_OUT62;
    wire [9:0] DFT_OUT63;
    wire [9:0] DFT_OUT64;
    wire [9:0] DFT_OUT65;
    wire [9:0] DFT_OUT66;
    wire [9:0] DFT_OUT67;
    wire [9:0] DFT_OUT68;
    wire [9:0] DFT_OUT69;
    wire [9:0] DFT_OUT70;
    wire [9:0] DFT_OUT71;
    wire [9:0] DFT_OUT72;
    wire [9:0] DFT_OUT73;
    wire [9:0] DFT_OUT74;
    wire [9:0] DFT_OUT75;
    wire [9:0] DFT_OUT76;
    wire [9:0] DFT_OUT77;
    wire [9:0] DFT_OUT78;
    wire [9:0] DFT_OUT79;
    wire [9:0] DFT_OUT80;
    wire [9:0] DFT_OUT81;
    wire [9:0] DFT_OUT82;
    wire [9:0] DFT_OUT83;
    wire [9:0] DFT_OUT84;
    wire [9:0] DFT_OUT85;
    wire [9:0] DFT_OUT86;
    wire [9:0] DFT_OUT87;
    wire [9:0] DFT_OUT88;
    wire [9:0] DFT_OUT89;
    wire [9:0] DFT_OUT90;
    wire [9:0] DFT_OUT91;
    wire [9:0] DFT_OUT92;
    wire [9:0] DFT_OUT93;
    wire [9:0] DFT_OUT94;
    wire [9:0] DFT_OUT95;
    wire [9:0] DFT_OUT96;
    wire [9:0] DFT_OUT97;
    wire [9:0] DFT_OUT98;
    wire [9:0] DFT_OUT99;
    wire [9:0] DFT_OUT100;
    wire [9:0] DFT_OUT101;
    wire [9:0] DFT_OUT102;
    wire [9:0] DFT_OUT103;
    wire [9:0] DFT_OUT104;
    wire [9:0] DFT_OUT105;
    wire [9:0] DFT_OUT106;
    wire [9:0] DFT_OUT107;
    wire [9:0] DFT_OUT108;
    wire [9:0] DFT_OUT109;
    wire [9:0] DFT_OUT110;
    wire [9:0] DFT_OUT111;
    wire [9:0] DFT_OUT112;
    wire [9:0] DFT_OUT113;
    wire [9:0] DFT_OUT114;
    wire [9:0] DFT_OUT115;
    wire [9:0] DFT_OUT116;
    wire [9:0] DFT_OUT117;
    wire [9:0] DFT_OUT118;
    wire [9:0] DFT_OUT119;
    wire [9:0] DFT_OUT120;
    wire [9:0] DFT_OUT121;
    wire [9:0] DFT_OUT122;
    wire [9:0] DFT_OUT123;
    wire [9:0] DFT_OUT124;
    wire [9:0] DFT_OUT125;
    wire [9:0] DFT_OUT126;
    wire [9:0] DFT_OUT127;
    
    assign IDFT_IN0 = r_idft_in[0];
    assign IDFT_IN1 = r_idft_in[1];
    assign IDFT_IN2 = r_idft_in[2];
    assign IDFT_IN3 = r_idft_in[3];
    assign IDFT_IN4 = r_idft_in[4];
    assign IDFT_IN5 = r_idft_in[5];
    assign IDFT_IN6 = r_idft_in[6];
    assign IDFT_IN7 = r_idft_in[7];
    assign IDFT_IN8 = r_idft_in[8];
    assign IDFT_IN9 = r_idft_in[9];
    assign IDFT_IN10 = r_idft_in[10];
    assign IDFT_IN11 = r_idft_in[11];
    assign IDFT_IN12 = r_idft_in[12];
    assign IDFT_IN13 = r_idft_in[13];
    assign IDFT_IN14 = r_idft_in[14];
    assign IDFT_IN15 = r_idft_in[15];
    assign IDFT_IN16 = r_idft_in[16];
    assign IDFT_IN17 = r_idft_in[17];
    assign IDFT_IN18 = r_idft_in[18];
    assign IDFT_IN19 = r_idft_in[19];
    assign IDFT_IN20 = r_idft_in[20];
    assign IDFT_IN21 = r_idft_in[21];
    assign IDFT_IN22 = r_idft_in[22];
    assign IDFT_IN23 = r_idft_in[23];
    assign IDFT_IN24 = r_idft_in[24];
    assign IDFT_IN25 = r_idft_in[25];
    assign IDFT_IN26 = r_idft_in[26];
    assign IDFT_IN27 = r_idft_in[27];
    assign IDFT_IN28 = r_idft_in[28];
    assign IDFT_IN29 = r_idft_in[29];
    assign IDFT_IN30 = r_idft_in[30];
    assign IDFT_IN31 = r_idft_in[31];
    assign IDFT_IN32 = r_idft_in[32];
    assign IDFT_IN33 = r_idft_in[33];
    assign IDFT_IN34 = r_idft_in[34];
    assign IDFT_IN35 = r_idft_in[35];
    assign IDFT_IN36 = r_idft_in[36];
    assign IDFT_IN37 = r_idft_in[37];
    assign IDFT_IN38 = r_idft_in[38];
    assign IDFT_IN39 = r_idft_in[39];
    assign IDFT_IN40 = r_idft_in[40];
    assign IDFT_IN41 = r_idft_in[41];
    assign IDFT_IN42 = r_idft_in[42];
    assign IDFT_IN43 = r_idft_in[43];
    assign IDFT_IN44 = r_idft_in[44];
    assign IDFT_IN45 = r_idft_in[45];
    assign IDFT_IN46 = r_idft_in[46];
    assign IDFT_IN47 = r_idft_in[47];
    assign IDFT_IN48 = r_idft_in[48];
    assign IDFT_IN49 = r_idft_in[49];
    assign IDFT_IN50 = r_idft_in[50];
    assign IDFT_IN51 = r_idft_in[51];
    assign IDFT_IN52 = r_idft_in[52];
    assign IDFT_IN53 = r_idft_in[53];
    assign IDFT_IN54 = r_idft_in[54];
    assign IDFT_IN55 = r_idft_in[55];
    assign IDFT_IN56 = r_idft_in[56];
    assign IDFT_IN57 = r_idft_in[57];
    assign IDFT_IN58 = r_idft_in[58];
    assign IDFT_IN59 = r_idft_in[59];
    assign IDFT_IN60 = r_idft_in[60];
    assign IDFT_IN61 = r_idft_in[61];
    assign IDFT_IN62 = r_idft_in[62];
    assign IDFT_IN63 = r_idft_in[63];
    assign IDFT_IN64 = r_idft_in[64];
    assign IDFT_IN65 = r_idft_in[65];
    assign IDFT_IN66 = r_idft_in[66];
    assign IDFT_IN67 = r_idft_in[67];
    assign IDFT_IN68 = r_idft_in[68];
    assign IDFT_IN69 = r_idft_in[69];
    assign IDFT_IN70 = r_idft_in[70];
    assign IDFT_IN71 = r_idft_in[71];
    assign IDFT_IN72 = r_idft_in[72];
    assign IDFT_IN73 = r_idft_in[73];
    assign IDFT_IN74 = r_idft_in[74];
    assign IDFT_IN75 = r_idft_in[75];
    assign IDFT_IN76 = r_idft_in[76];
    assign IDFT_IN77 = r_idft_in[77];
    assign IDFT_IN78 = r_idft_in[78];
    assign IDFT_IN79 = r_idft_in[79];
    assign IDFT_IN80 = r_idft_in[80];
    assign IDFT_IN81 = r_idft_in[81];
    assign IDFT_IN82 = r_idft_in[82];
    assign IDFT_IN83 = r_idft_in[83];
    assign IDFT_IN84 = r_idft_in[84];
    assign IDFT_IN85 = r_idft_in[85];
    assign IDFT_IN86 = r_idft_in[86];
    assign IDFT_IN87 = r_idft_in[87];
    assign IDFT_IN88 = r_idft_in[88];
    assign IDFT_IN89 = r_idft_in[89];
    assign IDFT_IN90 = r_idft_in[90];
    assign IDFT_IN91 = r_idft_in[91];
    assign IDFT_IN92 = r_idft_in[92];
    assign IDFT_IN93 = r_idft_in[93];
    assign IDFT_IN94 = r_idft_in[94];
    assign IDFT_IN95 = r_idft_in[95];
    assign IDFT_IN96 = r_idft_in[96];
    assign IDFT_IN97 = r_idft_in[97];
    assign IDFT_IN98 = r_idft_in[98];
    assign IDFT_IN99 = r_idft_in[99];
    assign IDFT_IN100 = r_idft_in[100];
    assign IDFT_IN101 = r_idft_in[101];
    assign IDFT_IN102 = r_idft_in[102];
    assign IDFT_IN103 = r_idft_in[103];
    assign IDFT_IN104 = r_idft_in[104];
    assign IDFT_IN105 = r_idft_in[105];
    assign IDFT_IN106 = r_idft_in[106];
    assign IDFT_IN107 = r_idft_in[107];
    assign IDFT_IN108 = r_idft_in[108];
    assign IDFT_IN109 = r_idft_in[109];
    assign IDFT_IN110 = r_idft_in[110];
    assign IDFT_IN111 = r_idft_in[111];
    assign IDFT_IN112 = r_idft_in[112];
    assign IDFT_IN113 = r_idft_in[113];
    assign IDFT_IN114 = r_idft_in[114];
    assign IDFT_IN115 = r_idft_in[115];
    assign IDFT_IN116 = r_idft_in[116];
    assign IDFT_IN117 = r_idft_in[117];
    assign IDFT_IN118 = r_idft_in[118];
    assign IDFT_IN119 = r_idft_in[119];
    assign IDFT_IN120 = r_idft_in[120];
    assign IDFT_IN121 = r_idft_in[121];
    assign IDFT_IN122 = r_idft_in[122];
    assign IDFT_IN123 = r_idft_in[123];
    assign IDFT_IN124 = r_idft_in[124];
    assign IDFT_IN125 = r_idft_in[125];
    assign IDFT_IN126 = r_idft_in[126];
    assign IDFT_IN127 = r_idft_in[127];
    
    assign DFT_IN0 = r_dft_in[0];
    assign DFT_IN1 = r_dft_in[1];
    assign DFT_IN2 = r_dft_in[2];
    assign DFT_IN3 = r_dft_in[3];
    assign DFT_IN4 = r_dft_in[4];
    assign DFT_IN5 = r_dft_in[5];
    assign DFT_IN6 = r_dft_in[6];
    assign DFT_IN7 = r_dft_in[7];
    assign DFT_IN8 = r_dft_in[8];
    assign DFT_IN9 = r_dft_in[9];
    assign DFT_IN10 = r_dft_in[10];
    assign DFT_IN11 = r_dft_in[11];
    assign DFT_IN12 = r_dft_in[12];
    assign DFT_IN13 = r_dft_in[13];
    assign DFT_IN14 = r_dft_in[14];
    assign DFT_IN15 = r_dft_in[15];
    assign DFT_IN16 = r_dft_in[16];
    assign DFT_IN17 = r_dft_in[17];
    assign DFT_IN18 = r_dft_in[18];
    assign DFT_IN19 = r_dft_in[19];
    assign DFT_IN20 = r_dft_in[20];
    assign DFT_IN21 = r_dft_in[21];
    assign DFT_IN22 = r_dft_in[22];
    assign DFT_IN23 = r_dft_in[23];
    assign DFT_IN24 = r_dft_in[24];
    assign DFT_IN25 = r_dft_in[25];
    assign DFT_IN26 = r_dft_in[26];
    assign DFT_IN27 = r_dft_in[27];
    assign DFT_IN28 = r_dft_in[28];
    assign DFT_IN29 = r_dft_in[29];
    assign DFT_IN30 = r_dft_in[30];
    assign DFT_IN31 = r_dft_in[31];
    assign DFT_IN32 = r_dft_in[32];
    assign DFT_IN33 = r_dft_in[33];
    assign DFT_IN34 = r_dft_in[34];
    assign DFT_IN35 = r_dft_in[35];
    assign DFT_IN36 = r_dft_in[36];
    assign DFT_IN37 = r_dft_in[37];
    assign DFT_IN38 = r_dft_in[38];
    assign DFT_IN39 = r_dft_in[39];
    assign DFT_IN40 = r_dft_in[40];
    assign DFT_IN41 = r_dft_in[41];
    assign DFT_IN42 = r_dft_in[42];
    assign DFT_IN43 = r_dft_in[43];
    assign DFT_IN44 = r_dft_in[44];
    assign DFT_IN45 = r_dft_in[45];
    assign DFT_IN46 = r_dft_in[46];
    assign DFT_IN47 = r_dft_in[47];
    assign DFT_IN48 = r_dft_in[48];
    assign DFT_IN49 = r_dft_in[49];
    assign DFT_IN50 = r_dft_in[50];
    assign DFT_IN51 = r_dft_in[51];
    assign DFT_IN52 = r_dft_in[52];
    assign DFT_IN53 = r_dft_in[53];
    assign DFT_IN54 = r_dft_in[54];
    assign DFT_IN55 = r_dft_in[55];
    assign DFT_IN56 = r_dft_in[56];
    assign DFT_IN57 = r_dft_in[57];
    assign DFT_IN58 = r_dft_in[58];
    assign DFT_IN59 = r_dft_in[59];
    assign DFT_IN60 = r_dft_in[60];
    assign DFT_IN61 = r_dft_in[61];
    assign DFT_IN62 = r_dft_in[62];
    assign DFT_IN63 = r_dft_in[63];
    assign DFT_IN64 = r_dft_in[64];
    assign DFT_IN65 = r_dft_in[65];
    assign DFT_IN66 = r_dft_in[66];
    assign DFT_IN67 = r_dft_in[67];
    assign DFT_IN68 = r_dft_in[68];
    assign DFT_IN69 = r_dft_in[69];
    assign DFT_IN70 = r_dft_in[70];
    assign DFT_IN71 = r_dft_in[71];
    assign DFT_IN72 = r_dft_in[72];
    assign DFT_IN73 = r_dft_in[73];
    assign DFT_IN74 = r_dft_in[74];
    assign DFT_IN75 = r_dft_in[75];
    assign DFT_IN76 = r_dft_in[76];
    assign DFT_IN77 = r_dft_in[77];
    assign DFT_IN78 = r_dft_in[78];
    assign DFT_IN79 = r_dft_in[79];
    assign DFT_IN80 = r_dft_in[80];
    assign DFT_IN81 = r_dft_in[81];
    assign DFT_IN82 = r_dft_in[82];
    assign DFT_IN83 = r_dft_in[83];
    assign DFT_IN84 = r_dft_in[84];
    assign DFT_IN85 = r_dft_in[85];
    assign DFT_IN86 = r_dft_in[86];
    assign DFT_IN87 = r_dft_in[87];
    assign DFT_IN88 = r_dft_in[88];
    assign DFT_IN89 = r_dft_in[89];
    assign DFT_IN90 = r_dft_in[90];
    assign DFT_IN91 = r_dft_in[91];
    assign DFT_IN92 = r_dft_in[92];
    assign DFT_IN93 = r_dft_in[93];
    assign DFT_IN94 = r_dft_in[94];
    assign DFT_IN95 = r_dft_in[95];
    assign DFT_IN96 = r_dft_in[96];
    assign DFT_IN97 = r_dft_in[97];
    assign DFT_IN98 = r_dft_in[98];
    assign DFT_IN99 = r_dft_in[99];
    assign DFT_IN100 = r_dft_in[100];
    assign DFT_IN101 = r_dft_in[101];
    assign DFT_IN102 = r_dft_in[102];
    assign DFT_IN103 = r_dft_in[103];
    assign DFT_IN104 = r_dft_in[104];
    assign DFT_IN105 = r_dft_in[105];
    assign DFT_IN106 = r_dft_in[106];
    assign DFT_IN107 = r_dft_in[107];
    assign DFT_IN108 = r_dft_in[108];
    assign DFT_IN109 = r_dft_in[109];
    assign DFT_IN110 = r_dft_in[110];
    assign DFT_IN111 = r_dft_in[111];
    assign DFT_IN112 = r_dft_in[112];
    assign DFT_IN113 = r_dft_in[113];
    assign DFT_IN114 = r_dft_in[114];
    assign DFT_IN115 = r_dft_in[115];
    assign DFT_IN116 = r_dft_in[116];
    assign DFT_IN117 = r_dft_in[117];
    assign DFT_IN118 = r_dft_in[118];
    assign DFT_IN119 = r_dft_in[119];
    assign DFT_IN120 = r_dft_in[120];
    assign DFT_IN121 = r_dft_in[121];
    assign DFT_IN122 = r_dft_in[122];
    assign DFT_IN123 = r_dft_in[123];
    assign DFT_IN124 = r_dft_in[124];
    assign DFT_IN125 = r_dft_in[125];
    assign DFT_IN126 = r_dft_in[126];
    assign DFT_IN127 = r_dft_in[127];

    assign w_idft_out[0] = IDFT_OUT0;
    assign w_idft_out[1] = IDFT_OUT1;
    assign w_idft_out[2] = IDFT_OUT2;
    assign w_idft_out[3] = IDFT_OUT3;
    assign w_idft_out[4] = IDFT_OUT4;
    assign w_idft_out[5] = IDFT_OUT5;
    assign w_idft_out[6] = IDFT_OUT6;
    assign w_idft_out[7] = IDFT_OUT7;
    assign w_idft_out[8] = IDFT_OUT8;
    assign w_idft_out[9] = IDFT_OUT9;
    assign w_idft_out[10] = IDFT_OUT10;
    assign w_idft_out[11] = IDFT_OUT11;
    assign w_idft_out[12] = IDFT_OUT12;
    assign w_idft_out[13] = IDFT_OUT13;
    assign w_idft_out[14] = IDFT_OUT14;
    assign w_idft_out[15] = IDFT_OUT15;
    assign w_idft_out[16] = IDFT_OUT16;
    assign w_idft_out[17] = IDFT_OUT17;
    assign w_idft_out[18] = IDFT_OUT18;
    assign w_idft_out[19] = IDFT_OUT19;
    assign w_idft_out[20] = IDFT_OUT20;
    assign w_idft_out[21] = IDFT_OUT21;
    assign w_idft_out[22] = IDFT_OUT22;
    assign w_idft_out[23] = IDFT_OUT23;
    assign w_idft_out[24] = IDFT_OUT24;
    assign w_idft_out[25] = IDFT_OUT25;
    assign w_idft_out[26] = IDFT_OUT26;
    assign w_idft_out[27] = IDFT_OUT27;
    assign w_idft_out[28] = IDFT_OUT28;
    assign w_idft_out[29] = IDFT_OUT29;
    assign w_idft_out[30] = IDFT_OUT30;
    assign w_idft_out[31] = IDFT_OUT31;
    assign w_idft_out[32] = IDFT_OUT32;
    assign w_idft_out[33] = IDFT_OUT33;
    assign w_idft_out[34] = IDFT_OUT34;
    assign w_idft_out[35] = IDFT_OUT35;
    assign w_idft_out[36] = IDFT_OUT36;
    assign w_idft_out[37] = IDFT_OUT37;
    assign w_idft_out[38] = IDFT_OUT38;
    assign w_idft_out[39] = IDFT_OUT39;
    assign w_idft_out[40] = IDFT_OUT40;
    assign w_idft_out[41] = IDFT_OUT41;
    assign w_idft_out[42] = IDFT_OUT42;
    assign w_idft_out[43] = IDFT_OUT43;
    assign w_idft_out[44] = IDFT_OUT44;
    assign w_idft_out[45] = IDFT_OUT45;
    assign w_idft_out[46] = IDFT_OUT46;
    assign w_idft_out[47] = IDFT_OUT47;
    assign w_idft_out[48] = IDFT_OUT48;
    assign w_idft_out[49] = IDFT_OUT49;
    assign w_idft_out[50] = IDFT_OUT50;
    assign w_idft_out[51] = IDFT_OUT51;
    assign w_idft_out[52] = IDFT_OUT52;
    assign w_idft_out[53] = IDFT_OUT53;
    assign w_idft_out[54] = IDFT_OUT54;
    assign w_idft_out[55] = IDFT_OUT55;
    assign w_idft_out[56] = IDFT_OUT56;
    assign w_idft_out[57] = IDFT_OUT57;
    assign w_idft_out[58] = IDFT_OUT58;
    assign w_idft_out[59] = IDFT_OUT59;
    assign w_idft_out[60] = IDFT_OUT60;
    assign w_idft_out[61] = IDFT_OUT61;
    assign w_idft_out[62] = IDFT_OUT62;
    assign w_idft_out[63] = IDFT_OUT63;
    assign w_idft_out[64] = IDFT_OUT64;
    assign w_idft_out[65] = IDFT_OUT65;
    assign w_idft_out[66] = IDFT_OUT66;
    assign w_idft_out[67] = IDFT_OUT67;
    assign w_idft_out[68] = IDFT_OUT68;
    assign w_idft_out[69] = IDFT_OUT69;
    assign w_idft_out[70] = IDFT_OUT70;
    assign w_idft_out[71] = IDFT_OUT71;
    assign w_idft_out[72] = IDFT_OUT72;
    assign w_idft_out[73] = IDFT_OUT73;
    assign w_idft_out[74] = IDFT_OUT74;
    assign w_idft_out[75] = IDFT_OUT75;
    assign w_idft_out[76] = IDFT_OUT76;
    assign w_idft_out[77] = IDFT_OUT77;
    assign w_idft_out[78] = IDFT_OUT78;
    assign w_idft_out[79] = IDFT_OUT79;
    assign w_idft_out[80] = IDFT_OUT80;
    assign w_idft_out[81] = IDFT_OUT81;
    assign w_idft_out[82] = IDFT_OUT82;
    assign w_idft_out[83] = IDFT_OUT83;
    assign w_idft_out[84] = IDFT_OUT84;
    assign w_idft_out[85] = IDFT_OUT85;
    assign w_idft_out[86] = IDFT_OUT86;
    assign w_idft_out[87] = IDFT_OUT87;
    assign w_idft_out[88] = IDFT_OUT88;
    assign w_idft_out[89] = IDFT_OUT89;
    assign w_idft_out[90] = IDFT_OUT90;
    assign w_idft_out[91] = IDFT_OUT91;
    assign w_idft_out[92] = IDFT_OUT92;
    assign w_idft_out[93] = IDFT_OUT93;
    assign w_idft_out[94] = IDFT_OUT94;
    assign w_idft_out[95] = IDFT_OUT95;
    assign w_idft_out[96] = IDFT_OUT96;
    assign w_idft_out[97] = IDFT_OUT97;
    assign w_idft_out[98] = IDFT_OUT98;
    assign w_idft_out[99] = IDFT_OUT99;
    assign w_idft_out[100] = IDFT_OUT100;
    assign w_idft_out[101] = IDFT_OUT101;
    assign w_idft_out[102] = IDFT_OUT102;
    assign w_idft_out[103] = IDFT_OUT103;
    assign w_idft_out[104] = IDFT_OUT104;
    assign w_idft_out[105] = IDFT_OUT105;
    assign w_idft_out[106] = IDFT_OUT106;
    assign w_idft_out[107] = IDFT_OUT107;
    assign w_idft_out[108] = IDFT_OUT108;
    assign w_idft_out[109] = IDFT_OUT109;
    assign w_idft_out[110] = IDFT_OUT110;
    assign w_idft_out[111] = IDFT_OUT111;
    assign w_idft_out[112] = IDFT_OUT112;
    assign w_idft_out[113] = IDFT_OUT113;
    assign w_idft_out[114] = IDFT_OUT114;
    assign w_idft_out[115] = IDFT_OUT115;
    assign w_idft_out[116] = IDFT_OUT116;
    assign w_idft_out[117] = IDFT_OUT117;
    assign w_idft_out[118] = IDFT_OUT118;
    assign w_idft_out[119] = IDFT_OUT119;
    assign w_idft_out[120] = IDFT_OUT120;
    assign w_idft_out[121] = IDFT_OUT121;
    assign w_idft_out[122] = IDFT_OUT122;
    assign w_idft_out[123] = IDFT_OUT123;
    assign w_idft_out[124] = IDFT_OUT124;
    assign w_idft_out[125] = IDFT_OUT125;
    assign w_idft_out[126] = IDFT_OUT126;
    assign w_idft_out[127] = IDFT_OUT127;
    
    assign w_dft_out[0] = DFT_OUT0;
    assign w_dft_out[1] = DFT_OUT1;
    assign w_dft_out[2] = DFT_OUT2;
    assign w_dft_out[3] = DFT_OUT3;
    assign w_dft_out[4] = DFT_OUT4;
    assign w_dft_out[5] = DFT_OUT5;
    assign w_dft_out[6] = DFT_OUT6;
    assign w_dft_out[7] = DFT_OUT7;
    assign w_dft_out[8] = DFT_OUT8;
    assign w_dft_out[9] = DFT_OUT9;
    assign w_dft_out[10] = DFT_OUT10;
    assign w_dft_out[11] = DFT_OUT11;
    assign w_dft_out[12] = DFT_OUT12;
    assign w_dft_out[13] = DFT_OUT13;
    assign w_dft_out[14] = DFT_OUT14;
    assign w_dft_out[15] = DFT_OUT15;
    assign w_dft_out[16] = DFT_OUT16;
    assign w_dft_out[17] = DFT_OUT17;
    assign w_dft_out[18] = DFT_OUT18;
    assign w_dft_out[19] = DFT_OUT19;
    assign w_dft_out[20] = DFT_OUT20;
    assign w_dft_out[21] = DFT_OUT21;
    assign w_dft_out[22] = DFT_OUT22;
    assign w_dft_out[23] = DFT_OUT23;
    assign w_dft_out[24] = DFT_OUT24;
    assign w_dft_out[25] = DFT_OUT25;
    assign w_dft_out[26] = DFT_OUT26;
    assign w_dft_out[27] = DFT_OUT27;
    assign w_dft_out[28] = DFT_OUT28;
    assign w_dft_out[29] = DFT_OUT29;
    assign w_dft_out[30] = DFT_OUT30;
    assign w_dft_out[31] = DFT_OUT31;
    assign w_dft_out[32] = DFT_OUT32;
    assign w_dft_out[33] = DFT_OUT33;
    assign w_dft_out[34] = DFT_OUT34;
    assign w_dft_out[35] = DFT_OUT35;
    assign w_dft_out[36] = DFT_OUT36;
    assign w_dft_out[37] = DFT_OUT37;
    assign w_dft_out[38] = DFT_OUT38;
    assign w_dft_out[39] = DFT_OUT39;
    assign w_dft_out[40] = DFT_OUT40;
    assign w_dft_out[41] = DFT_OUT41;
    assign w_dft_out[42] = DFT_OUT42;
    assign w_dft_out[43] = DFT_OUT43;
    assign w_dft_out[44] = DFT_OUT44;
    assign w_dft_out[45] = DFT_OUT45;
    assign w_dft_out[46] = DFT_OUT46;
    assign w_dft_out[47] = DFT_OUT47;
    assign w_dft_out[48] = DFT_OUT48;
    assign w_dft_out[49] = DFT_OUT49;
    assign w_dft_out[50] = DFT_OUT50;
    assign w_dft_out[51] = DFT_OUT51;
    assign w_dft_out[52] = DFT_OUT52;
    assign w_dft_out[53] = DFT_OUT53;
    assign w_dft_out[54] = DFT_OUT54;
    assign w_dft_out[55] = DFT_OUT55;
    assign w_dft_out[56] = DFT_OUT56;
    assign w_dft_out[57] = DFT_OUT57;
    assign w_dft_out[58] = DFT_OUT58;
    assign w_dft_out[59] = DFT_OUT59;
    assign w_dft_out[60] = DFT_OUT60;
    assign w_dft_out[61] = DFT_OUT61;
    assign w_dft_out[62] = DFT_OUT62;
    assign w_dft_out[63] = DFT_OUT63;
    assign w_dft_out[64] = DFT_OUT64;
    assign w_dft_out[65] = DFT_OUT65;
    assign w_dft_out[66] = DFT_OUT66;
    assign w_dft_out[67] = DFT_OUT67;
    assign w_dft_out[68] = DFT_OUT68;
    assign w_dft_out[69] = DFT_OUT69;
    assign w_dft_out[70] = DFT_OUT70;
    assign w_dft_out[71] = DFT_OUT71;
    assign w_dft_out[72] = DFT_OUT72;
    assign w_dft_out[73] = DFT_OUT73;
    assign w_dft_out[74] = DFT_OUT74;
    assign w_dft_out[75] = DFT_OUT75;
    assign w_dft_out[76] = DFT_OUT76;
    assign w_dft_out[77] = DFT_OUT77;
    assign w_dft_out[78] = DFT_OUT78;
    assign w_dft_out[79] = DFT_OUT79;
    assign w_dft_out[80] = DFT_OUT80;
    assign w_dft_out[81] = DFT_OUT81;
    assign w_dft_out[82] = DFT_OUT82;
    assign w_dft_out[83] = DFT_OUT83;
    assign w_dft_out[84] = DFT_OUT84;
    assign w_dft_out[85] = DFT_OUT85;
    assign w_dft_out[86] = DFT_OUT86;
    assign w_dft_out[87] = DFT_OUT87;
    assign w_dft_out[88] = DFT_OUT88;
    assign w_dft_out[89] = DFT_OUT89;
    assign w_dft_out[90] = DFT_OUT90;
    assign w_dft_out[91] = DFT_OUT91;
    assign w_dft_out[92] = DFT_OUT92;
    assign w_dft_out[93] = DFT_OUT93;
    assign w_dft_out[94] = DFT_OUT94;
    assign w_dft_out[95] = DFT_OUT95;
    assign w_dft_out[96] = DFT_OUT96;
    assign w_dft_out[97] = DFT_OUT97;
    assign w_dft_out[98] = DFT_OUT98;
    assign w_dft_out[99] = DFT_OUT99;
    assign w_dft_out[100] = DFT_OUT100;
    assign w_dft_out[101] = DFT_OUT101;
    assign w_dft_out[102] = DFT_OUT102;
    assign w_dft_out[103] = DFT_OUT103;
    assign w_dft_out[104] = DFT_OUT104;
    assign w_dft_out[105] = DFT_OUT105;
    assign w_dft_out[106] = DFT_OUT106;
    assign w_dft_out[107] = DFT_OUT107;
    assign w_dft_out[108] = DFT_OUT108;
    assign w_dft_out[109] = DFT_OUT109;
    assign w_dft_out[110] = DFT_OUT110;
    assign w_dft_out[111] = DFT_OUT111;
    assign w_dft_out[112] = DFT_OUT112;
    assign w_dft_out[113] = DFT_OUT113;
    assign w_dft_out[114] = DFT_OUT114;
    assign w_dft_out[115] = DFT_OUT115;
    assign w_dft_out[116] = DFT_OUT116;
    assign w_dft_out[117] = DFT_OUT117;
    assign w_dft_out[118] = DFT_OUT118;
    assign w_dft_out[119] = DFT_OUT119;
    assign w_dft_out[120] = DFT_OUT120;
    assign w_dft_out[121] = DFT_OUT121;
    assign w_dft_out[122] = DFT_OUT122;
    assign w_dft_out[123] = DFT_OUT123;
    assign w_dft_out[124] = DFT_OUT124;
    assign w_dft_out[125] = DFT_OUT125;
    assign w_dft_out[126] = DFT_OUT126;
    assign w_dft_out[127] = DFT_OUT127;

    idft_top idft_top_inst (.clk(clk), .reset(reset), .next(r_idft_next), .next_out(w_idft_next_out),
      .X0(IDFT_IN0), .Y0(IDFT_OUT0),
      .X1(IDFT_IN1), .Y1(IDFT_OUT1),
      .X2(IDFT_IN2), .Y2(IDFT_OUT2),
      .X3(IDFT_IN3), .Y3(IDFT_OUT3),
      .X4(IDFT_IN4), .Y4(IDFT_OUT4),
      .X5(IDFT_IN5), .Y5(IDFT_OUT5),
      .X6(IDFT_IN6), .Y6(IDFT_OUT6),
      .X7(IDFT_IN7), .Y7(IDFT_OUT7),
      .X8(IDFT_IN8), .Y8(IDFT_OUT8),
      .X9(IDFT_IN9), .Y9(IDFT_OUT9),
      .X10(IDFT_IN10), .Y10(IDFT_OUT10),
      .X11(IDFT_IN11), .Y11(IDFT_OUT11),
      .X12(IDFT_IN12), .Y12(IDFT_OUT12),
      .X13(IDFT_IN13), .Y13(IDFT_OUT13),
      .X14(IDFT_IN14), .Y14(IDFT_OUT14),
      .X15(IDFT_IN15), .Y15(IDFT_OUT15),
      .X16(IDFT_IN16), .Y16(IDFT_OUT16),
      .X17(IDFT_IN17), .Y17(IDFT_OUT17),
      .X18(IDFT_IN18), .Y18(IDFT_OUT18),
      .X19(IDFT_IN19), .Y19(IDFT_OUT19),
      .X20(IDFT_IN20), .Y20(IDFT_OUT20),
      .X21(IDFT_IN21), .Y21(IDFT_OUT21),
      .X22(IDFT_IN22), .Y22(IDFT_OUT22),
      .X23(IDFT_IN23), .Y23(IDFT_OUT23),
      .X24(IDFT_IN24), .Y24(IDFT_OUT24),
      .X25(IDFT_IN25), .Y25(IDFT_OUT25),
      .X26(IDFT_IN26), .Y26(IDFT_OUT26),
      .X27(IDFT_IN27), .Y27(IDFT_OUT27),
      .X28(IDFT_IN28), .Y28(IDFT_OUT28),
      .X29(IDFT_IN29), .Y29(IDFT_OUT29),
      .X30(IDFT_IN30), .Y30(IDFT_OUT30),
      .X31(IDFT_IN31), .Y31(IDFT_OUT31),
      .X32(IDFT_IN32), .Y32(IDFT_OUT32),
      .X33(IDFT_IN33), .Y33(IDFT_OUT33),
      .X34(IDFT_IN34), .Y34(IDFT_OUT34),
      .X35(IDFT_IN35), .Y35(IDFT_OUT35),
      .X36(IDFT_IN36), .Y36(IDFT_OUT36),
      .X37(IDFT_IN37), .Y37(IDFT_OUT37),
      .X38(IDFT_IN38), .Y38(IDFT_OUT38),
      .X39(IDFT_IN39), .Y39(IDFT_OUT39),
      .X40(IDFT_IN40), .Y40(IDFT_OUT40),
      .X41(IDFT_IN41), .Y41(IDFT_OUT41),
      .X42(IDFT_IN42), .Y42(IDFT_OUT42),
      .X43(IDFT_IN43), .Y43(IDFT_OUT43),
      .X44(IDFT_IN44), .Y44(IDFT_OUT44),
      .X45(IDFT_IN45), .Y45(IDFT_OUT45),
      .X46(IDFT_IN46), .Y46(IDFT_OUT46),
      .X47(IDFT_IN47), .Y47(IDFT_OUT47),
      .X48(IDFT_IN48), .Y48(IDFT_OUT48),
      .X49(IDFT_IN49), .Y49(IDFT_OUT49),
      .X50(IDFT_IN50), .Y50(IDFT_OUT50),
      .X51(IDFT_IN51), .Y51(IDFT_OUT51),
      .X52(IDFT_IN52), .Y52(IDFT_OUT52),
      .X53(IDFT_IN53), .Y53(IDFT_OUT53),
      .X54(IDFT_IN54), .Y54(IDFT_OUT54),
      .X55(IDFT_IN55), .Y55(IDFT_OUT55),
      .X56(IDFT_IN56), .Y56(IDFT_OUT56),
      .X57(IDFT_IN57), .Y57(IDFT_OUT57),
      .X58(IDFT_IN58), .Y58(IDFT_OUT58),
      .X59(IDFT_IN59), .Y59(IDFT_OUT59),
      .X60(IDFT_IN60), .Y60(IDFT_OUT60),
      .X61(IDFT_IN61), .Y61(IDFT_OUT61),
      .X62(IDFT_IN62), .Y62(IDFT_OUT62),
      .X63(IDFT_IN63), .Y63(IDFT_OUT63),
      .X64(IDFT_IN64), .Y64(IDFT_OUT64),
      .X65(IDFT_IN65), .Y65(IDFT_OUT65),
      .X66(IDFT_IN66), .Y66(IDFT_OUT66),
      .X67(IDFT_IN67), .Y67(IDFT_OUT67),
      .X68(IDFT_IN68), .Y68(IDFT_OUT68),
      .X69(IDFT_IN69), .Y69(IDFT_OUT69),
      .X70(IDFT_IN70), .Y70(IDFT_OUT70),
      .X71(IDFT_IN71), .Y71(IDFT_OUT71),
      .X72(IDFT_IN72), .Y72(IDFT_OUT72),
      .X73(IDFT_IN73), .Y73(IDFT_OUT73),
      .X74(IDFT_IN74), .Y74(IDFT_OUT74),
      .X75(IDFT_IN75), .Y75(IDFT_OUT75),
      .X76(IDFT_IN76), .Y76(IDFT_OUT76),
      .X77(IDFT_IN77), .Y77(IDFT_OUT77),
      .X78(IDFT_IN78), .Y78(IDFT_OUT78),
      .X79(IDFT_IN79), .Y79(IDFT_OUT79),
      .X80(IDFT_IN80), .Y80(IDFT_OUT80),
      .X81(IDFT_IN81), .Y81(IDFT_OUT81),
      .X82(IDFT_IN82), .Y82(IDFT_OUT82),
      .X83(IDFT_IN83), .Y83(IDFT_OUT83),
      .X84(IDFT_IN84), .Y84(IDFT_OUT84),
      .X85(IDFT_IN85), .Y85(IDFT_OUT85),
      .X86(IDFT_IN86), .Y86(IDFT_OUT86),
      .X87(IDFT_IN87), .Y87(IDFT_OUT87),
      .X88(IDFT_IN88), .Y88(IDFT_OUT88),
      .X89(IDFT_IN89), .Y89(IDFT_OUT89),
      .X90(IDFT_IN90), .Y90(IDFT_OUT90),
      .X91(IDFT_IN91), .Y91(IDFT_OUT91),
      .X92(IDFT_IN92), .Y92(IDFT_OUT92),
      .X93(IDFT_IN93), .Y93(IDFT_OUT93),
      .X94(IDFT_IN94), .Y94(IDFT_OUT94),
      .X95(IDFT_IN95), .Y95(IDFT_OUT95),
      .X96(IDFT_IN96), .Y96(IDFT_OUT96),
      .X97(IDFT_IN97), .Y97(IDFT_OUT97),
      .X98(IDFT_IN98), .Y98(IDFT_OUT98),
      .X99(IDFT_IN99), .Y99(IDFT_OUT99),
      .X100(IDFT_IN100), .Y100(IDFT_OUT100),
      .X101(IDFT_IN101), .Y101(IDFT_OUT101),
      .X102(IDFT_IN102), .Y102(IDFT_OUT102),
      .X103(IDFT_IN103), .Y103(IDFT_OUT103),
      .X104(IDFT_IN104), .Y104(IDFT_OUT104),
      .X105(IDFT_IN105), .Y105(IDFT_OUT105),
      .X106(IDFT_IN106), .Y106(IDFT_OUT106),
      .X107(IDFT_IN107), .Y107(IDFT_OUT107),
      .X108(IDFT_IN108), .Y108(IDFT_OUT108),
      .X109(IDFT_IN109), .Y109(IDFT_OUT109),
      .X110(IDFT_IN110), .Y110(IDFT_OUT110),
      .X111(IDFT_IN111), .Y111(IDFT_OUT111),
      .X112(IDFT_IN112), .Y112(IDFT_OUT112),
      .X113(IDFT_IN113), .Y113(IDFT_OUT113),
      .X114(IDFT_IN114), .Y114(IDFT_OUT114),
      .X115(IDFT_IN115), .Y115(IDFT_OUT115),
      .X116(IDFT_IN116), .Y116(IDFT_OUT116),
      .X117(IDFT_IN117), .Y117(IDFT_OUT117),
      .X118(IDFT_IN118), .Y118(IDFT_OUT118),
      .X119(IDFT_IN119), .Y119(IDFT_OUT119),
      .X120(IDFT_IN120), .Y120(IDFT_OUT120),
      .X121(IDFT_IN121), .Y121(IDFT_OUT121),
      .X122(IDFT_IN122), .Y122(IDFT_OUT122),
      .X123(IDFT_IN123), .Y123(IDFT_OUT123),
      .X124(IDFT_IN124), .Y124(IDFT_OUT124),
      .X125(IDFT_IN125), .Y125(IDFT_OUT125),
      .X126(IDFT_IN126), .Y126(IDFT_OUT126),
      .X127(IDFT_IN127), .Y127(IDFT_OUT127));
      
      
    dft_top dft_top_inst (.clk(clk), .reset(reset), .next(r_dft_next), .next_out(w_dft_next_out),
      .X0(DFT_IN0), .Y0(DFT_OUT0),
      .X1(DFT_IN1), .Y1(DFT_OUT1),
      .X2(DFT_IN2), .Y2(DFT_OUT2),
      .X3(DFT_IN3), .Y3(DFT_OUT3),
      .X4(DFT_IN4), .Y4(DFT_OUT4),
      .X5(DFT_IN5), .Y5(DFT_OUT5),
      .X6(DFT_IN6), .Y6(DFT_OUT6),
      .X7(DFT_IN7), .Y7(DFT_OUT7),
      .X8(DFT_IN8), .Y8(DFT_OUT8),
      .X9(DFT_IN9), .Y9(DFT_OUT9),
      .X10(DFT_IN10), .Y10(DFT_OUT10),
      .X11(DFT_IN11), .Y11(DFT_OUT11),
      .X12(DFT_IN12), .Y12(DFT_OUT12),
      .X13(DFT_IN13), .Y13(DFT_OUT13),
      .X14(DFT_IN14), .Y14(DFT_OUT14),
      .X15(DFT_IN15), .Y15(DFT_OUT15),
      .X16(DFT_IN16), .Y16(DFT_OUT16),
      .X17(DFT_IN17), .Y17(DFT_OUT17),
      .X18(DFT_IN18), .Y18(DFT_OUT18),
      .X19(DFT_IN19), .Y19(DFT_OUT19),
      .X20(DFT_IN20), .Y20(DFT_OUT20),
      .X21(DFT_IN21), .Y21(DFT_OUT21),
      .X22(DFT_IN22), .Y22(DFT_OUT22),
      .X23(DFT_IN23), .Y23(DFT_OUT23),
      .X24(DFT_IN24), .Y24(DFT_OUT24),
      .X25(DFT_IN25), .Y25(DFT_OUT25),
      .X26(DFT_IN26), .Y26(DFT_OUT26),
      .X27(DFT_IN27), .Y27(DFT_OUT27),
      .X28(DFT_IN28), .Y28(DFT_OUT28),
      .X29(DFT_IN29), .Y29(DFT_OUT29),
      .X30(DFT_IN30), .Y30(DFT_OUT30),
      .X31(DFT_IN31), .Y31(DFT_OUT31),
      .X32(DFT_IN32), .Y32(DFT_OUT32),
      .X33(DFT_IN33), .Y33(DFT_OUT33),
      .X34(DFT_IN34), .Y34(DFT_OUT34),
      .X35(DFT_IN35), .Y35(DFT_OUT35),
      .X36(DFT_IN36), .Y36(DFT_OUT36),
      .X37(DFT_IN37), .Y37(DFT_OUT37),
      .X38(DFT_IN38), .Y38(DFT_OUT38),
      .X39(DFT_IN39), .Y39(DFT_OUT39),
      .X40(DFT_IN40), .Y40(DFT_OUT40),
      .X41(DFT_IN41), .Y41(DFT_OUT41),
      .X42(DFT_IN42), .Y42(DFT_OUT42),
      .X43(DFT_IN43), .Y43(DFT_OUT43),
      .X44(DFT_IN44), .Y44(DFT_OUT44),
      .X45(DFT_IN45), .Y45(DFT_OUT45),
      .X46(DFT_IN46), .Y46(DFT_OUT46),
      .X47(DFT_IN47), .Y47(DFT_OUT47),
      .X48(DFT_IN48), .Y48(DFT_OUT48),
      .X49(DFT_IN49), .Y49(DFT_OUT49),
      .X50(DFT_IN50), .Y50(DFT_OUT50),
      .X51(DFT_IN51), .Y51(DFT_OUT51),
      .X52(DFT_IN52), .Y52(DFT_OUT52),
      .X53(DFT_IN53), .Y53(DFT_OUT53),
      .X54(DFT_IN54), .Y54(DFT_OUT54),
      .X55(DFT_IN55), .Y55(DFT_OUT55),
      .X56(DFT_IN56), .Y56(DFT_OUT56),
      .X57(DFT_IN57), .Y57(DFT_OUT57),
      .X58(DFT_IN58), .Y58(DFT_OUT58),
      .X59(DFT_IN59), .Y59(DFT_OUT59),
      .X60(DFT_IN60), .Y60(DFT_OUT60),
      .X61(DFT_IN61), .Y61(DFT_OUT61),
      .X62(DFT_IN62), .Y62(DFT_OUT62),
      .X63(DFT_IN63), .Y63(DFT_OUT63),
      .X64(DFT_IN64), .Y64(DFT_OUT64),
      .X65(DFT_IN65), .Y65(DFT_OUT65),
      .X66(DFT_IN66), .Y66(DFT_OUT66),
      .X67(DFT_IN67), .Y67(DFT_OUT67),
      .X68(DFT_IN68), .Y68(DFT_OUT68),
      .X69(DFT_IN69), .Y69(DFT_OUT69),
      .X70(DFT_IN70), .Y70(DFT_OUT70),
      .X71(DFT_IN71), .Y71(DFT_OUT71),
      .X72(DFT_IN72), .Y72(DFT_OUT72),
      .X73(DFT_IN73), .Y73(DFT_OUT73),
      .X74(DFT_IN74), .Y74(DFT_OUT74),
      .X75(DFT_IN75), .Y75(DFT_OUT75),
      .X76(DFT_IN76), .Y76(DFT_OUT76),
      .X77(DFT_IN77), .Y77(DFT_OUT77),
      .X78(DFT_IN78), .Y78(DFT_OUT78),
      .X79(DFT_IN79), .Y79(DFT_OUT79),
      .X80(DFT_IN80), .Y80(DFT_OUT80),
      .X81(DFT_IN81), .Y81(DFT_OUT81),
      .X82(DFT_IN82), .Y82(DFT_OUT82),
      .X83(DFT_IN83), .Y83(DFT_OUT83),
      .X84(DFT_IN84), .Y84(DFT_OUT84),
      .X85(DFT_IN85), .Y85(DFT_OUT85),
      .X86(DFT_IN86), .Y86(DFT_OUT86),
      .X87(DFT_IN87), .Y87(DFT_OUT87),
      .X88(DFT_IN88), .Y88(DFT_OUT88),
      .X89(DFT_IN89), .Y89(DFT_OUT89),
      .X90(DFT_IN90), .Y90(DFT_OUT90),
      .X91(DFT_IN91), .Y91(DFT_OUT91),
      .X92(DFT_IN92), .Y92(DFT_OUT92),
      .X93(DFT_IN93), .Y93(DFT_OUT93),
      .X94(DFT_IN94), .Y94(DFT_OUT94),
      .X95(DFT_IN95), .Y95(DFT_OUT95),
      .X96(DFT_IN96), .Y96(DFT_OUT96),
      .X97(DFT_IN97), .Y97(DFT_OUT97),
      .X98(DFT_IN98), .Y98(DFT_OUT98),
      .X99(DFT_IN99), .Y99(DFT_OUT99),
      .X100(DFT_IN100), .Y100(DFT_OUT100),
      .X101(DFT_IN101), .Y101(DFT_OUT101),
      .X102(DFT_IN102), .Y102(DFT_OUT102),
      .X103(DFT_IN103), .Y103(DFT_OUT103),
      .X104(DFT_IN104), .Y104(DFT_OUT104),
      .X105(DFT_IN105), .Y105(DFT_OUT105),
      .X106(DFT_IN106), .Y106(DFT_OUT106),
      .X107(DFT_IN107), .Y107(DFT_OUT107),
      .X108(DFT_IN108), .Y108(DFT_OUT108),
      .X109(DFT_IN109), .Y109(DFT_OUT109),
      .X110(DFT_IN110), .Y110(DFT_OUT110),
      .X111(DFT_IN111), .Y111(DFT_OUT111),
      .X112(DFT_IN112), .Y112(DFT_OUT112),
      .X113(DFT_IN113), .Y113(DFT_OUT113),
      .X114(DFT_IN114), .Y114(DFT_OUT114),
      .X115(DFT_IN115), .Y115(DFT_OUT115),
      .X116(DFT_IN116), .Y116(DFT_OUT116),
      .X117(DFT_IN117), .Y117(DFT_OUT117),
      .X118(DFT_IN118), .Y118(DFT_OUT118),
      .X119(DFT_IN119), .Y119(DFT_OUT119),
      .X120(DFT_IN120), .Y120(DFT_OUT120),
      .X121(DFT_IN121), .Y121(DFT_OUT121),
      .X122(DFT_IN122), .Y122(DFT_OUT122),
      .X123(DFT_IN123), .Y123(DFT_OUT123),
      .X124(DFT_IN124), .Y124(DFT_OUT124),
      .X125(DFT_IN125), .Y125(DFT_OUT125),
      .X126(DFT_IN126), .Y126(DFT_OUT126),
      .X127(DFT_IN127), .Y127(DFT_OUT127));


       initial clk = 0;
       
       always #1 clk = ~clk;
       
       initial begin
       
          $dumpfile("idft_dft_tb.vcd");
          $dumpvars(0, idft_dft_tb);
          
          for (i = 0; i < 128; i = i + 1) begin
              r_idft_in[i] <= 0;
              r_dft_in[i] <= 0;
          end
          
          r_idft_next <= 0;
          r_dft_next <= 0;
          reset <= 0;
          
          // Reset signal 
          @(posedge clk);
          reset <= 1;
          @(posedge clk);
          reset <= 0;
          
          @(posedge clk);
          
          // Assert high to start IDFT
          r_idft_next <= 1;
          @(posedge clk);
          r_idft_next <= 0;
          
          // Start streaming input vector for IDFT
          // Create a Hermitian symmetry
          r_idft_in[20] <= 25;
          
          r_idft_in[108] <= 25;
          
          // Wait until IDFT is done
          @(posedge w_idft_next_out);
          // IDFT module starts streaming output data at the next positive clock edge
          @(posedge clk);
          // We can read IDFT output at the next positive clock edge (registered access)
          @(posedge clk);
          // Print IDFT out
          $display("----------------------------");
          for (i = 0; i < 64; i = i + 1) begin
              $display("IDFT_OUT%03d = %x, %x", i, w_idft_out[i*2], w_idft_out[i*2+1]);
          end
          
          // assert high to start DFT
          r_dft_next <= 1;
          @(posedge clk);
          r_dft_next <= 0;
          
          // Copy the real part of the IDFT output to the DFT input
          for (i = 0; i < 128; i = i + 2) begin
              r_dft_in[i] <= w_idft_out[i];
          end
          
          // Wait until DFT is done
          @(posedge w_dft_next_out);
          // DFT module starts streaming output data at the next positive clock edge
          @(posedge clk);
          // We can read DFT output at the next positive clock edge (registered access)
          @(posedge clk);
          // Print DFT out
          $display("----------------------------");
          for (i = 0; i < 64; i = i + 1) begin
              $display("DFT_OUT%03d = %x, %x", i, w_dft_out[i*2], w_dft_out[i*2+1]);
          end

          
          @(posedge clk);
          @(posedge clk);
          
          $finish;
          
       end

endmodule
