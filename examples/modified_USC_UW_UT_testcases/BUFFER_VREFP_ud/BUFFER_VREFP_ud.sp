.subckt BUFFER_VREFP_ud gnd ibias1 ibias2 vdd vref vrefp
xm60 vrefp vrefp vrefp vdd pfet_lvt w=w0 l=l0
xm37 vdd net057 vdd vdd pfet_lvt w=w1 l=l1
xm29 net052 net057 vrefp vdd pfet_lvt w=w2 l=l0
xm27 net057 net057 net050 vdd pfet_lvt w=w3 l=l0
xm28 vrefp net052 vdd vdd pfet_lvt w=w4 l=l0
xm15 net050 net036 vdd vdd pfet_lvt w=w5 l=l0
xm59 net057 net057 net057 vdd pfet_lvt w=w6 l=l0
xm57 vdd vdd vdd vdd pfet_lvt w=w7 l=l0
xm58 net050 net050 net050 vdd pfet_lvt w=w6 l=l0
xm55 vdd vdd vdd vdd pfet_lvt w=w8 l=l0
xm54 net050 net050 net050 vdd pfet_lvt w=w8 l=l0
xm38 vdd net036 vdd vdd pfet_lvt w=w6 l=l2
xm65 ibias2 ibias2 ibias2 gnd nfet w=w9 l=l0
xm64 ibias2 ibias2 gnd gnd nfet w=w10 l=l0
xm63 gnd gnd gnd gnd nfet w=w11 l=l0
xm62 gnd gnd gnd gnd nfet w=w11 l=l0
xm61 gnd gnd gnd gnd nfet w=w9 l=l0
xm56 net057 net057 net057 gnd nfet w=w9 l=l0
xm30 net052 ibias2 gnd gnd nfet w=w12 l=l0
xm21 net057 ibias2 gnd gnd nfet w=w10 l=l0
xm12 net051 vref net212 gnd nfet w=w13 l=l0
xm11 net211 vref net212 gnd nfet w=w13 l=l0
xm10 net054 net050 net212 gnd nfet w=w13 l=l0
xm8 net215 net050 net212 gnd nfet w=w13 l=l0
xm5 net204 ibias1 gnd gnd nfet w=w10 l=l0
xm4 ibias1 ibias1 gnd gnd nfet w=w10 l=l0
xm3 net212 ibias1 gnd gnd nfet w=w11 l=l0
xm1 net207 net207 gnd gnd nfet w=w10 l=l3
xm6 net036 net207 gnd gnd nfet w=w10 l=l3
xm43 net211 net211 net211 gnd nfet w=w14 l=l0
xm53 gnd gnd gnd gnd nfet w=w10 l=l3
xm52 net036 net036 net036 gnd nfet w=w10 l=l3
xm51 gnd gnd gnd gnd nfet w=w10 l=l3
xm47 net212 net212 net212 gnd nfet w=w14 l=l0
xm50 net207 net207 net207 gnd nfet w=w10 l=l3
xm45 net051 net051 net051 gnd nfet w=w14 l=l0
xm49 gnd gnd gnd gnd nfet w=w11 l=l0
xm48 net212 net212 net212 gnd nfet w=w14 l=l0
xm40 net204 net204 net204 gnd nfet w=w9 l=l0
xm46 net054 net054 net054 gnd nfet w=w14 l=l0
xm44 net215 net215 net215 gnd nfet w=w14 l=l0
xm39 ibias1 ibias1 ibias1 gnd nfet w=w9 l=l0
xm42 net051 net051 net051 vdd pfet w=w15 l=l0
xm35 net211 net211 net211 vdd pfet w=w16 l=l0
xm33 vdd vdd vdd vdd pfet w=w17 l=l0
xm26 net054 net211 vdd vdd pfet w=w17 l=l0
xm25 net211 net211 vdd vdd pfet w=w14 l=l0
xm24 net051 net215 vdd vdd pfet w=w17 l=l0
xm23 net215 net215 vdd vdd pfet w=w14 l=l0
xm22 net204 net204 vdd vdd pfet w=w18 l=l4
xm41 net054 net054 net054 vdd pfet w=w15 l=l0
xm32 vdd vdd vdd vdd pfet w=w18 l=l4
xm14 net207 net204 net054 vdd pfet w=w11 l=l0
xm13 net036 net204 net051 vdd pfet w=w11 l=l0
xm34 vdd vdd vdd vdd pfet w=w17 l=l0
xm36 net215 net215 net215 vdd pfet w=w16 l=l0
xm31 net204 net204 net204 vdd pfet w=w18 l=l4
.ends BUFFER_VREFP_ud

