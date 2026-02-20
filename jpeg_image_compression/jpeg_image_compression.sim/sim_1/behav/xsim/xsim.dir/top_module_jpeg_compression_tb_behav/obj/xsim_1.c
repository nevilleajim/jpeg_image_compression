/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_119(char*, char *);
extern void execute_120(char*, char *);
extern void execute_121(char*, char *);
extern void execute_44(char*, char *);
extern void execute_79(char*, char *);
extern void execute_80(char*, char *);
extern void execute_81(char*, char *);
extern void execute_99(char*, char *);
extern void execute_100(char*, char *);
extern void execute_101(char*, char *);
extern void execute_102(char*, char *);
extern void execute_83(char*, char *);
extern void execute_85(char*, char *);
extern void execute_87(char*, char *);
extern void execute_89(char*, char *);
extern void execute_91(char*, char *);
extern void execute_93(char*, char *);
extern void execute_95(char*, char *);
extern void execute_97(char*, char *);
extern void execute_48(char*, char *);
extern void execute_49(char*, char *);
extern void execute_104(char*, char *);
extern void execute_108(char*, char *);
extern void execute_109(char*, char *);
extern void execute_110(char*, char *);
extern void execute_107(char*, char *);
extern void execute_113(char*, char *);
extern void execute_115(char*, char *);
extern void execute_116(char*, char *);
extern void execute_118(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[32] = {(funcp)execute_119, (funcp)execute_120, (funcp)execute_121, (funcp)execute_44, (funcp)execute_79, (funcp)execute_80, (funcp)execute_81, (funcp)execute_99, (funcp)execute_100, (funcp)execute_101, (funcp)execute_102, (funcp)execute_83, (funcp)execute_85, (funcp)execute_87, (funcp)execute_89, (funcp)execute_91, (funcp)execute_93, (funcp)execute_95, (funcp)execute_97, (funcp)execute_48, (funcp)execute_49, (funcp)execute_104, (funcp)execute_108, (funcp)execute_109, (funcp)execute_110, (funcp)execute_107, (funcp)execute_113, (funcp)execute_115, (funcp)execute_116, (funcp)execute_118, (funcp)transaction_0, (funcp)vhdl_transfunc_eventcallback};
const int NumRelocateId= 32;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/top_module_jpeg_compression_tb_behav/xsim.reloc",  (void **)funcTab, 32);
	iki_vhdl_file_variable_register(dp + 67000);
	iki_vhdl_file_variable_register(dp + 67056);
	iki_vhdl_file_variable_register(dp + 72560);
	iki_vhdl_file_variable_register(dp + 72680);
	iki_vhdl_file_variable_register(dp + 72800);
	iki_vhdl_file_variable_register(dp + 72920);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/top_module_jpeg_compression_tb_behav/xsim.reloc");
}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/top_module_jpeg_compression_tb_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/top_module_jpeg_compression_tb_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/top_module_jpeg_compression_tb_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/top_module_jpeg_compression_tb_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
