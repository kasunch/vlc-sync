
module dft_tb();

    reg clk, reset;
    
    integer i;
    
    reg [15:0] counter;
        
    reg r_dft_next;
    wire w_dft_next_out;
    reg signed [9:0] r_dft_in [127:0];
    wire signed [9:0] w_dft_out [127:0];
    
    // We load 128 samples to mem
    reg [9:0] mem [127:0];
    
    wire signed [9:0] DFT_IN0;
    wire signed [9:0] DFT_IN1;
    wire signed [9:0] DFT_IN2;
    wire signed [9:0] DFT_IN3;
    wire signed [9:0] DFT_IN4;
    wire signed [9:0] DFT_IN5;
    wire signed [9:0] DFT_IN6;
    wire signed [9:0] DFT_IN7;
    wire signed [9:0] DFT_IN8;
    wire signed [9:0] DFT_IN9;
    wire signed [9:0] DFT_IN10;
    wire signed [9:0] DFT_IN11;
    wire signed [9:0] DFT_IN12;
    wire signed [9:0] DFT_IN13;
    wire signed [9:0] DFT_IN14;
    wire signed [9:0] DFT_IN15;
    wire signed [9:0] DFT_IN16;
    wire signed [9:0] DFT_IN17;
    wire signed [9:0] DFT_IN18;
    wire signed [9:0] DFT_IN19;
    wire signed [9:0] DFT_IN20;
    wire signed [9:0] DFT_IN21;
    wire signed [9:0] DFT_IN22;
    wire signed [9:0] DFT_IN23;
    wire signed [9:0] DFT_IN24;
    wire signed [9:0] DFT_IN25;
    wire signed [9:0] DFT_IN26;
    wire signed [9:0] DFT_IN27;
    wire signed [9:0] DFT_IN28;
    wire signed [9:0] DFT_IN29;
    wire signed [9:0] DFT_IN30;
    wire signed [9:0] DFT_IN31;
    wire signed [9:0] DFT_IN32;
    wire signed [9:0] DFT_IN33;
    wire signed [9:0] DFT_IN34;
    wire signed [9:0] DFT_IN35;
    wire signed [9:0] DFT_IN36;
    wire signed [9:0] DFT_IN37;
    wire signed [9:0] DFT_IN38;
    wire signed [9:0] DFT_IN39;
    wire signed [9:0] DFT_IN40;
    wire signed [9:0] DFT_IN41;
    wire signed [9:0] DFT_IN42;
    wire signed [9:0] DFT_IN43;
    wire signed [9:0] DFT_IN44;
    wire signed [9:0] DFT_IN45;
    wire signed [9:0] DFT_IN46;
    wire signed [9:0] DFT_IN47;
    wire signed [9:0] DFT_IN48;
    wire signed [9:0] DFT_IN49;
    wire signed [9:0] DFT_IN50;
    wire signed [9:0] DFT_IN51;
    wire signed [9:0] DFT_IN52;
    wire signed [9:0] DFT_IN53;
    wire signed [9:0] DFT_IN54;
    wire signed [9:0] DFT_IN55;
    wire signed [9:0] DFT_IN56;
    wire signed [9:0] DFT_IN57;
    wire signed [9:0] DFT_IN58;
    wire signed [9:0] DFT_IN59;
    wire signed [9:0] DFT_IN60;
    wire signed [9:0] DFT_IN61;
    wire signed [9:0] DFT_IN62;
    wire signed [9:0] DFT_IN63;
    wire signed [9:0] DFT_IN64;
    wire signed [9:0] DFT_IN65;
    wire signed [9:0] DFT_IN66;
    wire signed [9:0] DFT_IN67;
    wire signed [9:0] DFT_IN68;
    wire signed [9:0] DFT_IN69;
    wire signed [9:0] DFT_IN70;
    wire signed [9:0] DFT_IN71;
    wire signed [9:0] DFT_IN72;
    wire signed [9:0] DFT_IN73;
    wire signed [9:0] DFT_IN74;
    wire signed [9:0] DFT_IN75;
    wire signed [9:0] DFT_IN76;
    wire signed [9:0] DFT_IN77;
    wire signed [9:0] DFT_IN78;
    wire signed [9:0] DFT_IN79;
    wire signed [9:0] DFT_IN80;
    wire signed [9:0] DFT_IN81;
    wire signed [9:0] DFT_IN82;
    wire signed [9:0] DFT_IN83;
    wire signed [9:0] DFT_IN84;
    wire signed [9:0] DFT_IN85;
    wire signed [9:0] DFT_IN86;
    wire signed [9:0] DFT_IN87;
    wire signed [9:0] DFT_IN88;
    wire signed [9:0] DFT_IN89;
    wire signed [9:0] DFT_IN90;
    wire signed [9:0] DFT_IN91;
    wire signed [9:0] DFT_IN92;
    wire signed [9:0] DFT_IN93;
    wire signed [9:0] DFT_IN94;
    wire signed [9:0] DFT_IN95;
    wire signed [9:0] DFT_IN96;
    wire signed [9:0] DFT_IN97;
    wire signed [9:0] DFT_IN98;
    wire signed [9:0] DFT_IN99;
    wire signed [9:0] DFT_IN100;
    wire signed [9:0] DFT_IN101;
    wire signed [9:0] DFT_IN102;
    wire signed [9:0] DFT_IN103;
    wire signed [9:0] DFT_IN104;
    wire signed [9:0] DFT_IN105;
    wire signed [9:0] DFT_IN106;
    wire signed [9:0] DFT_IN107;
    wire signed [9:0] DFT_IN108;
    wire signed [9:0] DFT_IN109;
    wire signed [9:0] DFT_IN110;
    wire signed [9:0] DFT_IN111;
    wire signed [9:0] DFT_IN112;
    wire signed [9:0] DFT_IN113;
    wire signed [9:0] DFT_IN114;
    wire signed [9:0] DFT_IN115;
    wire signed [9:0] DFT_IN116;
    wire signed [9:0] DFT_IN117;
    wire signed [9:0] DFT_IN118;
    wire signed [9:0] DFT_IN119;
    wire signed [9:0] DFT_IN120;
    wire signed [9:0] DFT_IN121;
    wire signed [9:0] DFT_IN122;
    wire signed [9:0] DFT_IN123;
    wire signed [9:0] DFT_IN124;
    wire signed [9:0] DFT_IN125;
    wire signed [9:0] DFT_IN126;
    wire signed [9:0] DFT_IN127;
         
    wire signed [9:0] DFT_OUT0;
    wire signed [9:0] DFT_OUT1;
    wire signed [9:0] DFT_OUT2;
    wire signed [9:0] DFT_OUT3;
    wire signed [9:0] DFT_OUT4;
    wire signed [9:0] DFT_OUT5;
    wire signed [9:0] DFT_OUT6;
    wire signed [9:0] DFT_OUT7;
    wire signed [9:0] DFT_OUT8;
    wire signed [9:0] DFT_OUT9;
    wire signed [9:0] DFT_OUT10;
    wire signed [9:0] DFT_OUT11;
    wire signed [9:0] DFT_OUT12;
    wire signed [9:0] DFT_OUT13;
    wire signed [9:0] DFT_OUT14;
    wire signed [9:0] DFT_OUT15;
    wire signed [9:0] DFT_OUT16;
    wire signed [9:0] DFT_OUT17;
    wire signed [9:0] DFT_OUT18;
    wire signed [9:0] DFT_OUT19;
    wire signed [9:0] DFT_OUT20;
    wire signed [9:0] DFT_OUT21;
    wire signed [9:0] DFT_OUT22;
    wire signed [9:0] DFT_OUT23;
    wire signed [9:0] DFT_OUT24;
    wire signed [9:0] DFT_OUT25;
    wire signed [9:0] DFT_OUT26;
    wire signed [9:0] DFT_OUT27;
    wire signed [9:0] DFT_OUT28;
    wire signed [9:0] DFT_OUT29;
    wire signed [9:0] DFT_OUT30;
    wire signed [9:0] DFT_OUT31;
    wire signed [9:0] DFT_OUT32;
    wire signed [9:0] DFT_OUT33;
    wire signed [9:0] DFT_OUT34;
    wire signed [9:0] DFT_OUT35;
    wire signed [9:0] DFT_OUT36;
    wire signed [9:0] DFT_OUT37;
    wire signed [9:0] DFT_OUT38;
    wire signed [9:0] DFT_OUT39;
    wire signed [9:0] DFT_OUT40;
    wire signed [9:0] DFT_OUT41;
    wire signed [9:0] DFT_OUT42;
    wire signed [9:0] DFT_OUT43;
    wire signed [9:0] DFT_OUT44;
    wire signed [9:0] DFT_OUT45;
    wire signed [9:0] DFT_OUT46;
    wire signed [9:0] DFT_OUT47;
    wire signed [9:0] DFT_OUT48;
    wire signed [9:0] DFT_OUT49;
    wire signed [9:0] DFT_OUT50;
    wire signed [9:0] DFT_OUT51;
    wire signed [9:0] DFT_OUT52;
    wire signed [9:0] DFT_OUT53;
    wire signed [9:0] DFT_OUT54;
    wire signed [9:0] DFT_OUT55;
    wire signed [9:0] DFT_OUT56;
    wire signed [9:0] DFT_OUT57;
    wire signed [9:0] DFT_OUT58;
    wire signed [9:0] DFT_OUT59;
    wire signed [9:0] DFT_OUT60;
    wire signed [9:0] DFT_OUT61;
    wire signed [9:0] DFT_OUT62;
    wire signed [9:0] DFT_OUT63;
    wire signed [9:0] DFT_OUT64;
    wire signed [9:0] DFT_OUT65;
    wire signed [9:0] DFT_OUT66;
    wire signed [9:0] DFT_OUT67;
    wire signed [9:0] DFT_OUT68;
    wire signed [9:0] DFT_OUT69;
    wire signed [9:0] DFT_OUT70;
    wire signed [9:0] DFT_OUT71;
    wire signed [9:0] DFT_OUT72;
    wire signed [9:0] DFT_OUT73;
    wire signed [9:0] DFT_OUT74;
    wire signed [9:0] DFT_OUT75;
    wire signed [9:0] DFT_OUT76;
    wire signed [9:0] DFT_OUT77;
    wire signed [9:0] DFT_OUT78;
    wire signed [9:0] DFT_OUT79;
    wire signed [9:0] DFT_OUT80;
    wire signed [9:0] DFT_OUT81;
    wire signed [9:0] DFT_OUT82;
    wire signed [9:0] DFT_OUT83;
    wire signed [9:0] DFT_OUT84;
    wire signed [9:0] DFT_OUT85;
    wire signed [9:0] DFT_OUT86;
    wire signed [9:0] DFT_OUT87;
    wire signed [9:0] DFT_OUT88;
    wire signed [9:0] DFT_OUT89;
    wire signed [9:0] DFT_OUT90;
    wire signed [9:0] DFT_OUT91;
    wire signed [9:0] DFT_OUT92;
    wire signed [9:0] DFT_OUT93;
    wire signed [9:0] DFT_OUT94;
    wire signed [9:0] DFT_OUT95;
    wire signed [9:0] DFT_OUT96;
    wire signed [9:0] DFT_OUT97;
    wire signed [9:0] DFT_OUT98;
    wire signed [9:0] DFT_OUT99;
    wire signed [9:0] DFT_OUT100;
    wire signed [9:0] DFT_OUT101;
    wire signed [9:0] DFT_OUT102;
    wire signed [9:0] DFT_OUT103;
    wire signed [9:0] DFT_OUT104;
    wire signed [9:0] DFT_OUT105;
    wire signed [9:0] DFT_OUT106;
    wire signed [9:0] DFT_OUT107;
    wire signed [9:0] DFT_OUT108;
    wire signed [9:0] DFT_OUT109;
    wire signed [9:0] DFT_OUT110;
    wire signed [9:0] DFT_OUT111;
    wire signed [9:0] DFT_OUT112;
    wire signed [9:0] DFT_OUT113;
    wire signed [9:0] DFT_OUT114;
    wire signed [9:0] DFT_OUT115;
    wire signed [9:0] DFT_OUT116;
    wire signed [9:0] DFT_OUT117;
    wire signed [9:0] DFT_OUT118;
    wire signed [9:0] DFT_OUT119;
    wire signed [9:0] DFT_OUT120;
    wire signed [9:0] DFT_OUT121;
    wire signed [9:0] DFT_OUT122;
    wire signed [9:0] DFT_OUT123;
    wire signed [9:0] DFT_OUT124;
    wire signed [9:0] DFT_OUT125;
    wire signed [9:0] DFT_OUT126;
    wire signed [9:0] DFT_OUT127;
    
    wire [9:0] DFT_OUT_MAG0;
    wire [9:0] DFT_OUT_MAG1;
    wire [9:0] DFT_OUT_MAG2;
    wire [9:0] DFT_OUT_MAG3;
    wire [9:0] DFT_OUT_MAG4;
    wire [9:0] DFT_OUT_MAG5;
    wire [9:0] DFT_OUT_MAG6;
    wire [9:0] DFT_OUT_MAG7;
    wire [9:0] DFT_OUT_MAG8;
    wire [9:0] DFT_OUT_MAG9;
    wire [9:0] DFT_OUT_MAG10;
    wire [9:0] DFT_OUT_MAG11;
    wire [9:0] DFT_OUT_MAG12;
    wire [9:0] DFT_OUT_MAG13;
    wire [9:0] DFT_OUT_MAG14;
    wire [9:0] DFT_OUT_MAG15;
    wire [9:0] DFT_OUT_MAG16;
    wire [9:0] DFT_OUT_MAG17;
    wire [9:0] DFT_OUT_MAG18;
    wire [9:0] DFT_OUT_MAG19;
    wire [9:0] DFT_OUT_MAG20;
    wire [9:0] DFT_OUT_MAG21;
    wire [9:0] DFT_OUT_MAG22;
    wire [9:0] DFT_OUT_MAG23;
    wire [9:0] DFT_OUT_MAG24;
    wire [9:0] DFT_OUT_MAG25;
    wire [9:0] DFT_OUT_MAG26;
    wire [9:0] DFT_OUT_MAG27;
    wire [9:0] DFT_OUT_MAG28;
    wire [9:0] DFT_OUT_MAG29;
    wire [9:0] DFT_OUT_MAG30;
    wire [9:0] DFT_OUT_MAG31;
    wire [9:0] DFT_OUT_MAG32;
    wire [9:0] DFT_OUT_MAG33;
    wire [9:0] DFT_OUT_MAG34;
    wire [9:0] DFT_OUT_MAG35;
    wire [9:0] DFT_OUT_MAG36;
    wire [9:0] DFT_OUT_MAG37;
    wire [9:0] DFT_OUT_MAG38;
    wire [9:0] DFT_OUT_MAG39;
    wire [9:0] DFT_OUT_MAG40;
    wire [9:0] DFT_OUT_MAG41;
    wire [9:0] DFT_OUT_MAG42;
    wire [9:0] DFT_OUT_MAG43;
    wire [9:0] DFT_OUT_MAG44;
    wire [9:0] DFT_OUT_MAG45;
    wire [9:0] DFT_OUT_MAG46;
    wire [9:0] DFT_OUT_MAG47;
    wire [9:0] DFT_OUT_MAG48;
    wire [9:0] DFT_OUT_MAG49;
    wire [9:0] DFT_OUT_MAG50;
    wire [9:0] DFT_OUT_MAG51;
    wire [9:0] DFT_OUT_MAG52;
    wire [9:0] DFT_OUT_MAG53;
    wire [9:0] DFT_OUT_MAG54;
    wire [9:0] DFT_OUT_MAG55;
    wire [9:0] DFT_OUT_MAG56;
    wire [9:0] DFT_OUT_MAG57;
    wire [9:0] DFT_OUT_MAG58;
    wire [9:0] DFT_OUT_MAG59;
    wire [9:0] DFT_OUT_MAG60;
    wire [9:0] DFT_OUT_MAG61;
    wire [9:0] DFT_OUT_MAG62;
    wire [9:0] DFT_OUT_MAG63;

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

    cmplx_to_mag cmpx_mag_inst0 (.i_i(DFT_OUT0), .i_q(DFT_OUT1), .o_mag(DFT_OUT_MAG0));
    cmplx_to_mag cmpx_mag_inst1 (.i_i(DFT_OUT2), .i_q(DFT_OUT3), .o_mag(DFT_OUT_MAG1));
    cmplx_to_mag cmpx_mag_inst2 (.i_i(DFT_OUT4), .i_q(DFT_OUT5), .o_mag(DFT_OUT_MAG2));
    cmplx_to_mag cmpx_mag_inst3 (.i_i(DFT_OUT6), .i_q(DFT_OUT7), .o_mag(DFT_OUT_MAG3));
    cmplx_to_mag cmpx_mag_inst4 (.i_i(DFT_OUT8), .i_q(DFT_OUT9), .o_mag(DFT_OUT_MAG4));
    cmplx_to_mag cmpx_mag_inst5 (.i_i(DFT_OUT10), .i_q(DFT_OUT11), .o_mag(DFT_OUT_MAG5));
    cmplx_to_mag cmpx_mag_inst6 (.i_i(DFT_OUT12), .i_q(DFT_OUT13), .o_mag(DFT_OUT_MAG6));
    cmplx_to_mag cmpx_mag_inst7 (.i_i(DFT_OUT14), .i_q(DFT_OUT15), .o_mag(DFT_OUT_MAG7));
    cmplx_to_mag cmpx_mag_inst8 (.i_i(DFT_OUT16), .i_q(DFT_OUT17), .o_mag(DFT_OUT_MAG8));
    cmplx_to_mag cmpx_mag_inst9 (.i_i(DFT_OUT18), .i_q(DFT_OUT19), .o_mag(DFT_OUT_MAG9));
    cmplx_to_mag cmpx_mag_inst10 (.i_i(DFT_OUT20), .i_q(DFT_OUT21), .o_mag(DFT_OUT_MAG10));
    cmplx_to_mag cmpx_mag_inst11 (.i_i(DFT_OUT22), .i_q(DFT_OUT23), .o_mag(DFT_OUT_MAG11));
    cmplx_to_mag cmpx_mag_inst12 (.i_i(DFT_OUT24), .i_q(DFT_OUT25), .o_mag(DFT_OUT_MAG12));
    cmplx_to_mag cmpx_mag_inst13 (.i_i(DFT_OUT26), .i_q(DFT_OUT27), .o_mag(DFT_OUT_MAG13));
    cmplx_to_mag cmpx_mag_inst14 (.i_i(DFT_OUT28), .i_q(DFT_OUT29), .o_mag(DFT_OUT_MAG14));
    cmplx_to_mag cmpx_mag_inst15 (.i_i(DFT_OUT30), .i_q(DFT_OUT31), .o_mag(DFT_OUT_MAG15));
    cmplx_to_mag cmpx_mag_inst16 (.i_i(DFT_OUT32), .i_q(DFT_OUT33), .o_mag(DFT_OUT_MAG16));
    cmplx_to_mag cmpx_mag_inst17 (.i_i(DFT_OUT34), .i_q(DFT_OUT35), .o_mag(DFT_OUT_MAG17));
    cmplx_to_mag cmpx_mag_inst18 (.i_i(DFT_OUT36), .i_q(DFT_OUT37), .o_mag(DFT_OUT_MAG18));
    cmplx_to_mag cmpx_mag_inst19 (.i_i(DFT_OUT38), .i_q(DFT_OUT39), .o_mag(DFT_OUT_MAG19));
    cmplx_to_mag cmpx_mag_inst20 (.i_i(DFT_OUT40), .i_q(DFT_OUT41), .o_mag(DFT_OUT_MAG20));
    cmplx_to_mag cmpx_mag_inst21 (.i_i(DFT_OUT42), .i_q(DFT_OUT43), .o_mag(DFT_OUT_MAG21));
    cmplx_to_mag cmpx_mag_inst22 (.i_i(DFT_OUT44), .i_q(DFT_OUT45), .o_mag(DFT_OUT_MAG22));
    cmplx_to_mag cmpx_mag_inst23 (.i_i(DFT_OUT46), .i_q(DFT_OUT47), .o_mag(DFT_OUT_MAG23));
    cmplx_to_mag cmpx_mag_inst24 (.i_i(DFT_OUT48), .i_q(DFT_OUT49), .o_mag(DFT_OUT_MAG24));
    cmplx_to_mag cmpx_mag_inst25 (.i_i(DFT_OUT50), .i_q(DFT_OUT51), .o_mag(DFT_OUT_MAG25));
    cmplx_to_mag cmpx_mag_inst26 (.i_i(DFT_OUT52), .i_q(DFT_OUT53), .o_mag(DFT_OUT_MAG26));
    cmplx_to_mag cmpx_mag_inst27 (.i_i(DFT_OUT54), .i_q(DFT_OUT55), .o_mag(DFT_OUT_MAG27));
    cmplx_to_mag cmpx_mag_inst28 (.i_i(DFT_OUT56), .i_q(DFT_OUT57), .o_mag(DFT_OUT_MAG28));
    cmplx_to_mag cmpx_mag_inst29 (.i_i(DFT_OUT58), .i_q(DFT_OUT59), .o_mag(DFT_OUT_MAG29));
    cmplx_to_mag cmpx_mag_inst30 (.i_i(DFT_OUT60), .i_q(DFT_OUT61), .o_mag(DFT_OUT_MAG30));
    cmplx_to_mag cmpx_mag_inst31 (.i_i(DFT_OUT62), .i_q(DFT_OUT63), .o_mag(DFT_OUT_MAG31));
    cmplx_to_mag cmpx_mag_inst32 (.i_i(DFT_OUT64), .i_q(DFT_OUT65), .o_mag(DFT_OUT_MAG32));
    cmplx_to_mag cmpx_mag_inst33 (.i_i(DFT_OUT66), .i_q(DFT_OUT67), .o_mag(DFT_OUT_MAG33));
    cmplx_to_mag cmpx_mag_inst34 (.i_i(DFT_OUT68), .i_q(DFT_OUT69), .o_mag(DFT_OUT_MAG34));
    cmplx_to_mag cmpx_mag_inst35 (.i_i(DFT_OUT70), .i_q(DFT_OUT71), .o_mag(DFT_OUT_MAG35));
    cmplx_to_mag cmpx_mag_inst36 (.i_i(DFT_OUT72), .i_q(DFT_OUT73), .o_mag(DFT_OUT_MAG36));
    cmplx_to_mag cmpx_mag_inst37 (.i_i(DFT_OUT74), .i_q(DFT_OUT75), .o_mag(DFT_OUT_MAG37));
    cmplx_to_mag cmpx_mag_inst38 (.i_i(DFT_OUT76), .i_q(DFT_OUT77), .o_mag(DFT_OUT_MAG38));
    cmplx_to_mag cmpx_mag_inst39 (.i_i(DFT_OUT78), .i_q(DFT_OUT79), .o_mag(DFT_OUT_MAG39));
    cmplx_to_mag cmpx_mag_inst40 (.i_i(DFT_OUT80), .i_q(DFT_OUT81), .o_mag(DFT_OUT_MAG40));
    cmplx_to_mag cmpx_mag_inst41 (.i_i(DFT_OUT82), .i_q(DFT_OUT83), .o_mag(DFT_OUT_MAG41));
    cmplx_to_mag cmpx_mag_inst42 (.i_i(DFT_OUT84), .i_q(DFT_OUT85), .o_mag(DFT_OUT_MAG42));
    cmplx_to_mag cmpx_mag_inst43 (.i_i(DFT_OUT86), .i_q(DFT_OUT87), .o_mag(DFT_OUT_MAG43));
    cmplx_to_mag cmpx_mag_inst44 (.i_i(DFT_OUT88), .i_q(DFT_OUT89), .o_mag(DFT_OUT_MAG44));
    cmplx_to_mag cmpx_mag_inst45 (.i_i(DFT_OUT90), .i_q(DFT_OUT91), .o_mag(DFT_OUT_MAG45));
    cmplx_to_mag cmpx_mag_inst46 (.i_i(DFT_OUT92), .i_q(DFT_OUT93), .o_mag(DFT_OUT_MAG46));
    cmplx_to_mag cmpx_mag_inst47 (.i_i(DFT_OUT94), .i_q(DFT_OUT95), .o_mag(DFT_OUT_MAG47));
    cmplx_to_mag cmpx_mag_inst48 (.i_i(DFT_OUT96), .i_q(DFT_OUT97), .o_mag(DFT_OUT_MAG48));
    cmplx_to_mag cmpx_mag_inst49 (.i_i(DFT_OUT98), .i_q(DFT_OUT99), .o_mag(DFT_OUT_MAG49));
    cmplx_to_mag cmpx_mag_inst50 (.i_i(DFT_OUT100), .i_q(DFT_OUT101), .o_mag(DFT_OUT_MAG50));
    cmplx_to_mag cmpx_mag_inst51 (.i_i(DFT_OUT102), .i_q(DFT_OUT103), .o_mag(DFT_OUT_MAG51));
    cmplx_to_mag cmpx_mag_inst52 (.i_i(DFT_OUT104), .i_q(DFT_OUT105), .o_mag(DFT_OUT_MAG52));
    cmplx_to_mag cmpx_mag_inst53 (.i_i(DFT_OUT106), .i_q(DFT_OUT107), .o_mag(DFT_OUT_MAG53));
    cmplx_to_mag cmpx_mag_inst54 (.i_i(DFT_OUT108), .i_q(DFT_OUT109), .o_mag(DFT_OUT_MAG54));
    cmplx_to_mag cmpx_mag_inst55 (.i_i(DFT_OUT110), .i_q(DFT_OUT111), .o_mag(DFT_OUT_MAG55));
    cmplx_to_mag cmpx_mag_inst56 (.i_i(DFT_OUT112), .i_q(DFT_OUT113), .o_mag(DFT_OUT_MAG56));
    cmplx_to_mag cmpx_mag_inst57 (.i_i(DFT_OUT114), .i_q(DFT_OUT115), .o_mag(DFT_OUT_MAG57));
    cmplx_to_mag cmpx_mag_inst58 (.i_i(DFT_OUT116), .i_q(DFT_OUT117), .o_mag(DFT_OUT_MAG58));
    cmplx_to_mag cmpx_mag_inst59 (.i_i(DFT_OUT118), .i_q(DFT_OUT119), .o_mag(DFT_OUT_MAG59));
    cmplx_to_mag cmpx_mag_inst60 (.i_i(DFT_OUT120), .i_q(DFT_OUT121), .o_mag(DFT_OUT_MAG60));
    cmplx_to_mag cmpx_mag_inst61 (.i_i(DFT_OUT122), .i_q(DFT_OUT123), .o_mag(DFT_OUT_MAG61));
    cmplx_to_mag cmpx_mag_inst62 (.i_i(DFT_OUT124), .i_q(DFT_OUT125), .o_mag(DFT_OUT_MAG62));
    cmplx_to_mag cmpx_mag_inst63 (.i_i(DFT_OUT126), .i_q(DFT_OUT127), .o_mag(DFT_OUT_MAG63));

       initial clk = 0;
       
       always #1 clk = ~clk;
       
       initial begin
       
          $dumpfile("dft_tb.vcd");
          $dumpvars(0, dft_tb);
          
          // The input_dft_tb.hex file has 128 samples (10-bit) captured from an ADC
          $readmemh("input_dft_tb.hex", mem);
          
          for (i = 0; i < 128; i = i + 1) begin
              r_dft_in[i] <= 0;
          end
          
          r_dft_next <= 0;
          reset <= 0;
          
          // Reset signal 
          @(posedge clk);
          reset <= 1;
          @(posedge clk);
          reset <= 0;
          
          @(posedge clk);
                    
          // assert high to start DFT
          r_dft_next <= 1;
          @(posedge clk);
          r_dft_next <= 0;
          
          // Copy first 64 samples to the real input of the DFT
          for (i = 0; i < 64; i = i + 1) begin
              // We have to convet the unsigned samples to signed values
              r_dft_in[i*2] <= mem[i] ^ 10'h200;
          end
          
          // Wait until DFT is done
          @(posedge w_dft_next_out);
          // DFT module starts streaming output data at the next positive clock edge
          @(posedge clk);
          // We can read DFT output at the next positive clock edge (registered access)
          @(posedge clk);
          for (i = 0; i < 64; i = i + 1) begin
              $display("%d, %d", w_dft_out[i*2], w_dft_out[i*2+1]);
          end

          // Wait two more clock cycles so, we can see the output in the simulator
          @(posedge clk);
          @(posedge clk);
          
          $finish;
          
       end

endmodule
