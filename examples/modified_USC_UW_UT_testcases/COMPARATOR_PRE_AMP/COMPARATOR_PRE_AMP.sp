* label = Comparator
.subckt COMPARATOR_PRE_AMP clk crossn crossp gnd intern interp outm outp vdd _net0 _net1
m0 gnd intern gnd gnd lvtnfet w=w0 l=l0
m22 gnd interp gnd gnd lvtnfet w=w0 l=l0
m16 outm crossp gnd gnd lvtnfet w=w1 l=l1
m17 outp crossn gnd gnd lvtnfet w=w1 l=l1
m4 crossn crossp intern gnd lvtnfet w=w2 l=l1
m3 crossp crossn interp gnd lvtnfet w=w2 l=l1
m7 net050 clk gnd gnd lvtnfet w=w3 l=l1
m5 intern _net0 net050 gnd lvtnfet w=w4 l=l1
m6 interp _net1 net050 gnd lvtnfet w=w4 l=l1
m8 outm crossp vdd vdd lvtpfet w=w5 l=l1
m18 intern clk vdd vdd lvtpfet w=w2 l=l1
m15 outp crossn vdd vdd lvtpfet w=w5 l=l1
m19 interp clk vdd vdd lvtpfet w=w2 l=l1
m10 crossn clk vdd vdd lvtpfet w=w2 l=l1
m12 crossp clk vdd vdd lvtpfet w=w2 l=l1
m14 crossn crossp vdd vdd lvtpfet w=w6 l=l1
m13 crossp crossn vdd vdd lvtpfet w=w6 l=l1
.ends COMPARATOR_PRE_AMP

