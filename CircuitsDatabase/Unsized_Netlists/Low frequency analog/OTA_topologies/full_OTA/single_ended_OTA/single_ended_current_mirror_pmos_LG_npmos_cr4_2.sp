************************************************************************
* auCdl Netlist:
* 
* Library Name:  OTA_class
* Top Cell Name: single_ended_current_mirror_pmos
* View Name:     schematic
* Netlisted on:  Sep 11 21:07:49 2019
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

*.GLOBAL vdd!
+        gnd!

*.PIN vdd!
*+    gnd!

************************************************************************
* Library Name: OTA_class
* Cell Name:    single_ended_current_mirror_pmos
* View Name:    schematic
************************************************************************

.SUBCKT single_ended_current_mirror_pmos Vbiasp Vinn Vinp Voutp
*.PININFO Vbiasp:I Vinn:I Vinp:I Voutp:O
MM3 Voutp net17 vdd! vdd! pmos w=WA l=LA nfin=nA
MM2 net17 net17 vdd! vdd! pmos w=WA l=LA nfin=nA
MM7 net9 Vinn net13 net22 pmos w=WA l=LA nfin=nA
MM6 net15 Vinp net13 net22 pmos w=WA l=LA nfin=nA
MM5 net13 Vbiasp vdd! vdd! pmos w=WA l=LA nfin=nA
MM1 Voutp net9 gnd! gnd! nmos w=WA l=LA nfin=nA
MM0 net17 net15 gnd! gnd! nmos w=WA l=LA nfin=nA
MM9 net9 net9 gnd! gnd! nmos w=WA l=LA nfin=nA
MM8 net15 net15 gnd! gnd! nmos w=WA l=LA nfin=nA
.ENDS


.SUBCKT LG_npmos Biasn Vbiasn Vbiasp
*.PININFO Biasn:I Vbiasn:O Vbiasp:O
MM4 Vbiasp Vbiasn gnd! gnd! nmos w=WA l=LA nfin=nA
MM2 Vbiasn Vbiasn gnd! gnd! nmos w=WA l=LA nfin=nA
MM10 neta Biasn gnd! gnd! nmos w=WA l=LA nfin=nA
MM3 Vbiasp Vbiasp vdd! vdd! pmos w=WA l=LA nfin=nA
MM1 Vbiasn neta vdd! vdd! pmos w=WA l=LA nfin=nA
MM0 neta neta vdd! vdd! pmos w=WA l=LA nfin=nA
.ENDS

.SUBCKT CR4_2 Vbiasn Vbiasp
*.PININFO Vbiasn:O Vbiasp:O
MM11 net023 net024 Vbiasn gnd! nmos w=27.0n l=LA nfin=nA
MM8 net025 net010 net023 gnd! nmos w=27.0n l=LA nfin=nA
MM9 net024 net024 net023 gnd! nmos w=27.0n l=LA nfin=nA
MM7 net010 net010 net025 gnd! nmos w=WA l=LA nfin=nA
MM2 Vbiasn Vbiasn gnd! gnd! nmos w=WA l=LA nfin=nA
MM0 Vbiasp net025 gnd! gnd! nmos w=WA l=LA nfin=nA
MM10 net024 Vbiasp vdd! vdd! pmos w=WA l=LA nfin=nA
MM4 net010 Vbiasp vdd! vdd! pmos w=WA l=LA nfin=nA
MM3 Vbiasn Vbiasp vdd! vdd! pmos w=WA l=LA nfin=nA
MM1 Vbiasp Vbiasp vdd! vdd! pmos w=WA l=LA nfin=nA
.ENDS


xiota LG_Vbiasp Vinn Vinp Voutp single_ended_current_mirror_pmos
xiLG_npmos Biasn LG_Vbiasn LG_Vbiasp LG_npmos
xibCR4_2 Biasn Vbiasp CR4_2
.END