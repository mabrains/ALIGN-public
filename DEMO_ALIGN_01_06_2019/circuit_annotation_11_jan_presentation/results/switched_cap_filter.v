//Verilog block level netlist file for switched_cap_filter
//Generated by UMN for ALIGN project 


module top (  ); 
Cap_60f_2x3 c10 ( .MINUS(net1), .PLUS(net3) ); 
Cap_60f_2x3 c11 ( .MINUS(net13), .PLUS(net11) ); 
Cap_60f_2x3 c4 ( .MINUS(net14), .PLUS(net12) ); 
Cap_60f_2x3 c5 ( .MINUS(vinp), .PLUS(net08) ); 
Cap_60f_2x3 c6 ( .MINUS(net2), .PLUS(net4) ); 
Cap_60f_2x3 c7 ( .MINUS(voutp), .PLUS(net08) ); 
Cap_60f_2x3 c8 ( .MINUS(vinn), .PLUS(net09) ); 
Cap_60f_2x3 c9 ( .MINUS(voutn), .PLUS(net09) ); 
DC_converter_2018_11_09_ASAP7_current_mirror_ota_schematic i0 ( .vg(id), .net08(net08), .net09(net09), .voutn(vg), .voutp(voutn), .id(voutp) ); 
DC_converter_2018_11_09_ASAP7_cmfb_schematic i13 ( .voutn(id), .voutp(phi1), .id(phi2), .vcm(vcm), .vg(vg), .phi1(voutn), .phi2(voutp) ); 
DC_converter_2018_11_09_ASAP7_non_overlapping_clock_generator_schematic i3 ( .clk(0), .vdd!(clk), .0(phi1), .phi1(phi2), .phi2(vdd!) ); 
Switch_NMOS_10_1x1 m11 ( .D(agnd), .G(phi2), .S(net13) ); 
Switch_NMOS_10_1x1 m3 ( .D(agnd), .G(phi2), .S(net14) ); 
Switch_NMOS_10_1x1 m5 ( .D(agnd), .G(phi2), .S(net4) ); 
Switch_NMOS_10_1x1 m9 ( .D(agnd), .G(phi2), .S(net3) ); 
SCM_NMOS_50_1x12 m8_m4 ( .D1(net1), .D2(net2), .S(agnd) ); 
SCM_NMOS_50_1x12 m10_m2 ( .D1(net11), .D2(net12), .S(agnd) ); 
CMC_NMOS_25_1x10 m7_m14 ( .D1(net08), .G(phi1), .D2(voutn), .S1(net4), .S2(net13) ); 
CMC_NMOS_25_1x10 m13_m0 ( .D1(net09), .G(phi1), .D2(voutp), .S1(net3), .S2(net14) ); 
CMC_NMOS_25_1x10 m12_m6 ( .D1(net1), .G(phi1), .D2(net2), .S1(vinp), .S2(vinn) ); 
CMC_NMOS_25_1x10 m15_m1 ( .D1(net11), .G(phi1), .D2(net12), .S1(net09), .S2(net08) ); 

endmodule

module DC_converter_2018_11_09_ASAP7_current_mirror_ota_schematic ( vg, net08, net09, voutn, voutp, id ); 
inout vg, net08, net09, voutn, voutp, id;

Cap_60f_2x3 c2 ( .MINUS(0), .PLUS(voutp) ); 
Cap_60f_2x3 c3 ( .MINUS(0), .PLUS(voutn) ); 
Switch_PMOS_10_1x1 m1 ( .D(net06), .G(vbiasp1), .S(vdd!) ); 
DiodeConnected_PMOS_5_1x1 m1pdown ( .D(vbiasp), .S(net8_bias) ); 
DiodeConnected_PMOS_5_1x1 m1pup ( .D(net8_bias), .S(vdd!) ); 
DiodeConnected_PMOS_5_1x1 m2p ( .D(vbiasp1), .S(vdd!) ); 
DiodeConnected_NMOS_5_1x1 m3nbias ( .D(vbiasn), .S(net10) ); 
Switch_NMOS_10_1x1 m4 ( .D(net10), .G(vbiasnd), .S(0) ); 
DiodeConnected_NMOS_5_1x1 m5 ( .D(id), .S(0) ); 
CMC_PMOS_10_1x4 m2_m3pbias ( .D1(net012), .G(vbiasp1), .D2(vbiasn), .S(vdd!) ); 
SCM_NMOS_50_1x12 m1n_m2n ( .D1(vbiasp), .D2(vbiasp1), .S(0) ); 
CMC_NMOS_25_1x10 m9_m8 ( .D1(voutn), .G(vbiasn), .D2(voutp), .S1(net8), .S2(net014) ); 
CMC_PMOS_15_1x6 m6_m7 ( .D1(voutn), .G(vbiasp), .D2(voutp), .S1(net06), .S2(net012) ); 
DP_NMOS_75_3x10 m3_m0 ( .D1(net014), .G1(vinn), .S(net10), .D2(net8), .G2(vinp) ); 

endmodule

module DC_converter_2018_11_09_ASAP7_cmfb_schematic ( voutn, voutp, id, vcm, vg, phi1, phi2 ); 
inout voutn, voutp, id, vcm, vg, phi1, phi2;

Cap_60f_2x3 c2 ( .MINUS(net8), .PLUS(vg) ); 
Cap_60f_2x3 c3 ( .MINUS(vg), .PLUS(net10) ); 
Switch_NMOS_10_1x1 m3 ( .D(vcm), .G(phi2), .S(net10) ); 
CMC_NMOS_25_1x10 m1_m4 ( .D1(net8), .G(phi2), .D2(vbias), .S1(vcm), .S2(vg) ); 
CMC_NMOS_25_1x10 m0_m2 ( .D1(net8), .G(phi1), .D2(vb), .S1(va), .S2(net10) ); 

endmodule

module DC_converter_2018_11_09_ASAP7_non_overlapping_clock_generator_schematic ( clk, vdd!, 0, phi1, phi2 ); 
inout clk, vdd!, 0, phi1, phi2;

INVx1_ASAP7_75t_R i0 ( .net18(d_gnd), .net17(d_vdd), .d_vdd(net17), .d_gnd(net18) ); 
INVx1_ASAP7_75t_R i1 ( .net16(d_gnd), .net15(d_vdd), .d_vdd(net15), .d_gnd(net16) ); 
INVx1_ASAP7_75t_R i2 ( .net15(d_gnd), .net8(d_vdd), .d_vdd(net15), .d_gnd(net8) ); 
INVx1_ASAP7_75t_R_21 i3 ( .net8(d_gnd), .phi1(d_vdd), .d_vdd(net8), .d_gnd(phi1) ); 
INVx1_ASAP7_75t_R i4 ( .net17(d_gnd), .net12(d_vdd), .d_vdd(net12), .d_gnd(net17) ); 
INVx1_ASAP7_75t_R_21 i5 ( .net12(d_gnd), .phi2(d_vdd), .d_vdd(net12), .d_gnd(phi2) ); 
INVx1_ASAP7_75t_R i6 ( .clk(clk), .net9(d_gnd), .d_vdd(d_vdd), .d_gnd(net9) ); 
DC_converter_2018_12_03_ASAP7_transmission_gate i6_tg ( .clk(clk), .net9_tg(d_dd), .d_dd(d_gnd), .d_gnd(net9_tg) ); 
DC_converter_2018_11_09_ASAP7_NAND_gate_schematic i7 ( .net12(d_gnd), .net9_tg(d_vdd), .net16(net12), .d_vdd(net16), .d_gnd(net9_tg) ); 
DC_converter_2018_11_09_ASAP7_NAND_gate_schematic i8 ( .net9(d_gnd), .net8(d_vdd), .net18(net18), .d_vdd(net8), .d_gnd(net9) ); 

endmodule

module INVx1_ASAP7_75t_R ( clk, net9, d_vdd, d_gnd ); 
inout clk, net9, d_vdd, d_gnd;

Switch_NMOS_10_1x1 m0 ( .D(y), .G(a), .S(vss) ); 
Switch_PMOS_10_1x1 m1 ( .D(y), .G(a), .S(vdd) ); 

endmodule

module INVx1_ASAP7_75t_R_21 ( net12, phi2, d_vdd, d_gnd ); 
inout net12, phi2, d_vdd, d_gnd;

Switch_NMOS_10_1x1 m0 ( .D(y), .G(a), .S(vss) ); 
Switch_PMOS_10_1x1 m1 ( .D(y), .G(a), .S(vdd) ); 

endmodule

module DC_converter_2018_12_03_ASAP7_transmission_gate ( clk, net9_tg, d_dd, d_gnd ); 
inout clk, net9_tg, d_dd, d_gnd;

Switch_NMOS_10_1x1 m0 ( .D(y), .G(vdd), .S(a) ); 
Switch_PMOS_10_1x1 m1 ( .D(y), .G(vss), .S(a) ); 

endmodule

module DC_converter_2018_11_09_ASAP7_NAND_gate_schematic ( net9, net8, net18, d_vdd, d_gnd ); 
inout net9, net8, net18, d_vdd, d_gnd;

Switch_PMOS_10_1x1 m0 ( .D(out), .G(a), .S(vdd) ); 
Switch_PMOS_10_1x1 m1 ( .D(out), .G(b), .S(vdd) ); 
Switch_NMOS_10_1x1 m2 ( .D(out), .G(a), .S(net22) ); 
Switch_NMOS_10_1x1 m3 ( .D(net22), .G(b), .S(vss) ); 

endmodule


// End HDL models
// Global nets module
`celldefine
module cds_globals;

supply0 VDD;
supply1 VSS;

endmodule
`endcelldefine