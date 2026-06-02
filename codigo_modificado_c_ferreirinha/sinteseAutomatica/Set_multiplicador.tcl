
# GPP & BCS scripts
## rc -files ../scripts/setupe.tcl


if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"
########################################################
## Include TCL utility scripts..
########################################################

include load_etc.tcl

##############################################################################
## Preset global variables and attributes
##############################################################################
# Top module name.

set VCDFILE filtros.vcd
set DESIGN Watermarking









            

    




set clk ap_clk
set per 10000 
#set bib comp_gen

set_attribute information_level 6 

# change switch activity; low use 50%, medium: propagate from other nodes to nodes not declared, high: propagate with more accuracy. default: low{low | medium | high}
set POW_EFF medium
set SYN_EFF medium
set MAP_EFF low     
set DATE [clock format [clock seconds] -format "%b%d-%T"]
set _OUTPUTS_PATH outputs
set _REPORTS_PATH reports
set _LOG_PATH logs
set _RESULTS_PATH results
shell rm -rf logs/ outputs/ rc.* reports/ results/
#shell mkdir outputss_${DATE}
shell mkdir outputs
shell mkdir reports
shell mkdir logs
shell mkdir results
if {![file exists ${_REPORTS_PATH}/${DESIGN}]} {
  file mkdir ${_REPORTS_PATH}/${DESIGN}
}

#65nm
set DK_PATH "/pdk/st/cmos065_421"

set lib_lvt_best_1_35V "${DK_PATH}/CORE65LPLVT_SNPS-AVT-CDS_4.1/libs/CORE65LPLVT_bc_1.35V_125C.lib \
                        ${DK_PATH}/CLOCK65LPLVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPLVT_bc_1.35V_125C.lib"

set lef_lvt_best_1_35V "${DK_PATH}/adv_EncounterTechnoKit_cmos065_7m4x0y2z_4.2/TECH/cmos065_7m4x0y2z_DBLCUT_RULE.lef \
                        ${DK_PATH}/PRHS65_SNPS-AVT-CDS_5.0/CADENCE/LEF/PRHS65_soc.lef \
                        ${DK_PATH}/CORE65LPLVT_SNPS-AVT-CDS_4.1/CADENCE/LEF/CORE65LPLVT.lef \
                        ${DK_PATH}/CLOCK65LPLVT_SNPS-AVT-CDS_2.1/LEF/CLOCK65LPLVT.lef"

set lib_svt_worst_1_25V "${DK_PATH}/CORE65LPSVT_SNPS-AVT-CDS_4.1/libs/CORE65LPSVT_wc_1.25V_125C.lib \
                        ${DK_PATH}/CLOCK65LPSVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPSVT_wc_1.25V_125C.lib"

set lef_svt_worst_1_25V "${DK_PATH}/adv_EncounterTechnoKit_cmos065_7m4x0y2z_4.2/TECH/cmos065_7m4x0y2z_Worst.lef \
                        ${DK_PATH}/PRHS65_SNPS-AVT-CDS_5.0/CADENCE/LEF/PRHS65_soc.lef \
                        ${DK_PATH}/CORE65LPSVT_SNPS-AVT-CDS_4.1/CADENCE/LEF/CORE65LPSVT_soc.lef \
                        ${DK_PATH}/CLOCK65LPSVT_SNPS-AVT-CDS_2.1/CADENCE/LEF/CLOCK65LPSVT_soc.lef"

set lib_svt_worst_1_0V "${DK_PATH}/CORE65LPSVT_SNPS-AVT-CDS_4.1/libs/CORE65LPSVT_wc_1.00V_125C.lib \
                        ${DK_PATH}/CLOCK65LPSVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPSVT_wc_1.00V_125C.lib"

set lib_svt_worst_0_9V "${DK_PATH}/CORE65LPSVT_SNPS-AVT-CDS_4.1/libs/CORE65LPSVT_wc_0.90V_125C.lib \
                        ${DK_PATH}/CLOCK65LPSVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPSVT_wc_0.90V_125C.lib"
                    
set lef_svt_worst_1_0V "${DK_PATH}/adv_EncounterTechnoKit_cmos065_7m4x0y2z_4.2/TECH/cmos065_7m4x0y2z_Worst.lef \
                        ${DK_PATH}/PRHS65_SNPS-AVT-CDS_5.0/CADENCE/LEF/PRHS65_soc.lef \
                        ${DK_PATH}/CORE65LPSVT_SNPS-AVT-CDS_4.1/CADENCE/LEF/CORE65LPSVT_soc.lef \
                        ${DK_PATH}/CLOCK65LPSVT_SNPS-AVT-CDS_2.1/CADENCE/LEF/CLOCK65LPSVT_soc.lef"
                  
set lef_svt_worst_0_9V "${DK_PATH}/adv_EncounterTechnoKit_cmos065_7m4x0y2z_4.2/TECH/cmos065_7m4x0y2z_Worst.lef \
                        ${DK_PATH}/PRHS65_SNPS-AVT-CDS_5.0/CADENCE/LEF/PRHS65_soc.lef \
                        ${DK_PATH}/CORE65LPSVT_SNPS-AVT-CDS_4.1/CADENCE/LEF/CORE65LPSVT_soc.lef \
                        ${DK_PATH}/CLOCK65LPSVT_SNPS-AVT-CDS_2.1/CADENCE/LEF/CLOCK65LPSVT_soc.lef"

set captables "${DK_PATH}/adv_EncounterTechnoKit_cmos065_7m4x0y2z_4.2/TECH/cmos065_7m4x0y2z_Best.captable"
set_attribute library ${lib_svt_worst_1_0V}
set_attribute lef_library ${lef_svt_worst_1_0V}
set_attribute cap_table_file ${captables}
set_attribute script_search_path {. ../../} /
set_attribute hdl_search_path {. .. ../package} /

##Default undriven/unconnected setting is 'none'.  
#set_attribute hdl_unconnected_input_port_value 0 | 1 | x | none /
set_attribute hdl_unconnected_input_port_value 1
##set_attribute hdl_undriven_output_port_value   0 | 1 | x | none /
set_attribute hdl_undriven_output_port_value   1
##set_attribute hdl_undriven_signal_value        0 | 1 | x | none /
set_attribute hdl_undriven_signal_value        1

set_attribute find_takes_multiple_names true

#HDL ERRORS
set_attribute hdl_error_on_blackbox true /
set_attribute hdl_error_on_latch false /
set_attribute hdl_error_on_negedge true /

#TIMING
# retime_effort_level high or low
#set_attribute retime_effort_level high / 
#set_attribute retime_optimize_reset true /

#set_attribute wireload_mode top /
set_attribute information_level 7 /
set_attribute lp_power_unit uW /

#set_attribute avoid true HS65_LS_FA1X4
#set_attribute avoid true HS65_LS_FA1X9
#set_attribute avoid true HS65_LS_FA1X18
#set_attribute avoid true HS65_LS_FA1X27
#set_attribute avoid true HS65_LS_FA1X35
#set_attribute avoid true HS65_LS_HA1X4
#set_attribute avoid true HS65_LS_HA1X9
#set_attribute avoid true HS65_LS_HA1X18
#set_attribute avoid true HS65_LS_HA1X27
#set_attribute avoid true HS65_LS_HA1X35

#set_attribute avoid true HS65_LS_MUX21I1X3
#set_attribute avoid true HS65_LS_MUX21I1X6
#set_attribute avoid true HS65_LS_MUX21I1X12
#set_attribute avoid true HS65_LS_MUX21I1X18
#set_attribute avoid true HS65_LS_MUX21I1X24
#set_attribute avoid true HS65_LS_MUX21X4
#set_attribute avoid true HS65_LS_MUX21X9
#set_attribute avoid true HS65_LS_MUX21X18
#set_attribute avoid true HS65_LS_MUX21X27
#set_attribute avoid true HS65_LS_MUX21X35
#set_attribute avoid true HS65_LSS_XNOR2X3
#set_attribute avoid true HS65_LSS_XNOR2X6
#set_attribute avoid true HS65_LSS_XNOR2X12
#set_attribute avoid true HS65_LSS_XNOR2X18
#set_attribute avoid true HS65_LSS_XNOR2X24
#set_attribute avoid true HS65_LSS_XNOR3X2
#set_attribute avoid true HS65_LSS_XNOR3X4
#set_attribute avoid true HS65_LSS_XNOR3X8
#set_attribute avoid true HS65_LSS_XNOR3X12

###############################################################
## Library setup
###############################################################
set_attr interconnect_mode ple /
set_attribute hdl_track_filename_row_col true /
####################################################################
## Load RTL Design verilog or vhdl, (create a single top file to call all others)
####################################################################
puts "Reading HDLs..."

  	read_hdl -vhdl $DESIGN.vhd

puts "Elaborate Design..."
elaborate $DESIGN
puts "Runtime & Memory after 'read_hdl'"
timestat Elaboration

check_design -unresolved
####################################################################
## Constraints Setup
#################################################################### 5 GHz a 100MHz = 100 iteracoes
read_sdc ../constraints.sdc
   
define_clock -period $per -name clock_name [find [find / -design $DESIGN] -port $clk]

puts "The number of exceptions is [llength [find /designs/$DESIGN -exception *]]"
if {![file exists ${_OUTPUTS_PATH}]} {
  file mkdir ${_OUTPUTS_PATH}
  puts "Creating directory ${_OUTPUTS_PATH}"
}
####################################################################################################
## Synthesizing to gates
####################################################################################################
syn_generic 

puts "Runtime & Memory after 'syn_generic'"
timestat GENERIC

report gates >generic_gates.log
## ungroup -threshold <value>


syn_map 

puts "Runtime & Memory after 'syn_map'"
timestat MAPPED
report datapath > $_REPORTS_PATH/${DESIGN}/${DESIGN}_datapath_map.log
#######################################################################################################
## Incremental Synthesis
#######################################################################################################

check_design -all
#shell ncsdfc barreira.sdf
#shell irun -64bit -top banch banch.v CORE65LPSVT.v martool.v -access +rw -sdf_cmd_file sdf_cmd_file.in
read_vcd $VCDFILE





#############################################################################
## Swicthing Activity (after synthesis to mapped)
#############################################################################
write_sdf  -nosplit_timing_check -edges check_edge  >  barreira.sdf

set_attribute hdl_track_filename_row_col true /

read_tcf $DESIGN

#############################################################################
## Reports & Results
#############################################################################

report_power -by_hierarchy [find / -instance ${DESIGN}] > $_REPORTS_PATH/${DESIGN}/${DESIGN}_${per}_power.rep
report timing > $_REPORTS_PATH/${DESIGN}/${DESIGN}_${per}_timing.rep
report gates  > $_REPORTS_PATH/${DESIGN}/${DESIGN}_${per}_cell.rep
report_area > $_REPORTS_PATH/${DESIGN}/${DESIGN}_${per}_area.rep

write_hdl -generic > martool_generic.v 
write_hdl -mapped  > ${DESIGN}_martool.v


quit

