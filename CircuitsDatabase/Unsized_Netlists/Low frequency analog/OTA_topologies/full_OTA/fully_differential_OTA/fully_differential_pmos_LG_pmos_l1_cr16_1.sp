************************************************************************
* auCdl Netlist:
* 
* Library Name:  OTA_class
* Top Cell Name: fully_differential_pmos
* View Name:     schematic
* Netlisted on:  Sep 11 21:06:01 2019
************************************************************************

*.BIPOLAR
*.RESI = 2000 
*.RESVAL
*.CAPVAL
*.DIOPERI
*.DIOAREA
*.EQUATION
*.SCALE METER
*.MEGA
.PARAM

*.GLOBAL gnd!
+        vdd!

*.PIN gnd!
*+    vdd!

************************************************************************
* Library Name: OTA_class
* Cell Name:    fully_differential_pmos
* View Name:    schematic
************************************************************************

.SUBCKT fully_differential_pmos Vbiasn Vbiasp Vinn Vinp Voutn Voutp
*.PININFO Vbiasp:I Vinn:I Vinp:I Vbiasn:O Voutn:O Voutp:O
MM7 Voutp Vinn net12 net16 pmos w=WA l=LA nfin=nA
MM6 Voutn Vinp net12 net16 pmos w=WA l=LA nfin=nA
MM5 net12 Vbiasp vdd! vdd! pmos w=WA l=LA nfin=nA
MM9 Voutp Vbiasn gnd! gnd! nmos w=WA l=LA nfin=nA
MM8 Voutn Vbiasn gnd! gnd! nmos w=WA l=LA nfin=nA
.ENDS


.SUBCKT LG_pmos_l1 Biasp Vbiasn Vbiasp
*.PININFO Biasp:I Vbiasn:O Vbiasp:O
MM0 Vbiasp Vbiasn gnd! gnd! nmos w=WA l=LA nfin=nA
MM8 Vbiasn Vbiasn gnd! gnd! nmos w=WA l=LA nfin=nA
MM3 Vbiasp Vbiasp vdd! vdd! pmos w=WA l=LA nfin=nA
MM10 Vbiasn Biasp vdd! vdd! pmos w=WA l=LA nfin=nA
.ENDS

.SUBCKT CR16_1 Vbiasp
*.PININFO Vbiasp:O
RR0 vdd! net6 res=rK
RR1 Vbiasp gnd! res=rK
MM2 Vbiasp Vbiasp net6 vdd! pmos w=WA l=LA nfin=nA
.ENDS


xiota LG_Vbiasn LG_Vbiasp Vinn Vinp Voutn Voutp fully_differential_pmos
xiLG_pmos_l1 Biasp LG_Vbiasn LG_Vbiasp LG_pmos_l1
xibCR16_1 Biasp CR16_1
.END