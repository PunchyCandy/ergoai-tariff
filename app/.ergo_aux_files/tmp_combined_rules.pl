
:-(compiler_options([xpp_on,canonical])).

/********** Tabling and Trailer Control Variables ************/

#define EQUALITYnone
#define INHERITANCEflogic
#define TABLINGreactive
#define TABLINGvariant
#define CUSTOMnone

#define FLORA_INCREMENTAL_TABLING 

/************************************************************************
  file: headerinc/flrheader_inc.flh

  Author(s): Guizhen Yang

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

:-(compiler_options([xpp_on])).
#mode standard Prolog

#include "flrheader.flh"
#include "flora_porting.flh"

/***********************************************************************/

/************************************************************************
  file: headerinc/flrheader_prog_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

:-(compiler_options([xpp_on])).
#mode standard Prolog

#include "flrheader_prog.flh"

/***********************************************************************/

#define FLORA_COMPILATION_ID 1

/************************************************************************
  file: headerinc/flrheader2_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the Flora-2 compiler.
  It has files that must be included in the header and typically
  contain some Prolog statements. Such files cannot appear
  in flrheader.flh because flrheader.flh is included in various restricted
  contexts where Prolog statements are not allowed.

  NOT included in ADDED files (compiled for addition) -- only in LOADED
  ones and in trailers/patch
************************************************************************/

:-(compiler_options([xpp_on])).

#define TABLING_CONNECTIVE  :-

%% flora_tabling_methods is included here to affect preprocessing of
%% flrtable/flrhilogtable.flh dynamically
#include "flora_tabling_methods.flh"

/* note: inside flrtable.flh there are checks for FLORA_NONTABLED_DATA_MODULE
   that exclude tabling non-signature molecules
*/
#ifndef FLORA_NONTABLED_MODULE
#include "flrtable.flh"
#endif

/* if normal tabled module, then table hilog */
#if !defined(FLORA_NONTABLED_DATA_MODULE) && !defined(FLORA_NONTABLED_MODULE)
#include "flrhilogtable.flh"
#endif

#include "flrtable_always.flh"

#include "flrauxtables.flh"

%% include list of tabled predicates
#mode save
#mode nocomment "%"
#if defined(FLORA_FLT_FILENAME)
#include FLORA_FLT_FILENAME
#endif
#mode restore

/***********************************************************************/

/************************************************************************
  file: headerinc/flrdyna_inc.flh

  Author(s): Chang Zhao

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

:-(compiler_options([xpp_on])).

#define TABLING_CONNECTIVE  :-

#include "flrdyndeclare.flh"

/***********************************************************************/

/************************************************************************
  file: headerinc/flrindex_P_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

:-(compiler_options([xpp_on])).

#include "flrindex_P.flh"

/***********************************************************************/

#mode save
#mode nocomment "%"
#define FLORA_THIS_FILENAME  'tmp_combined_rules.ergo'
#mode restore
/************************************************************************
  file: headerinc/flrdefinition_inc.flh

  Author(s): Guizhen Yang

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

#include "flrdefinition.flh"

/***********************************************************************/

/************************************************************************
  file: headerinc/flrtrailerregistry_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

#include "flrtrailerregistry.flh"

/***********************************************************************/

/************************************************************************
  file: headerinc/flrrefreshtable_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

:-(compiler_options([xpp_on])).

#include "flrrefreshtable.flh"

/***********************************************************************/

/************************************************************************
  file: headerinc/flrdynamic_connectors_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

:-(compiler_options([xpp_on])).

#include "flrdynamic_connectors.flh"

/***********************************************************************/

/************************************************************************
  file: syslibinc/flrimportedcalls_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the FLORA-2 compiler.
************************************************************************/

%% Loads the file with all the import statements for predicates
%% that must be known everywhere

:-(compiler_options([xpp_on])).

#mode standard Prolog

#if !defined(FLORA_TERMS_FLH)
#define FLORA_TERMS_FLH
#include "flora_terms.flh"
#endif

?-(:(flrlibman,flora_load_library(FLLIBIMPORTEDCALLS))).

/***********************************************************************/

/************************************************************************
  file: headerinc/flrpatch_inc.flh

  Author(s): Guizhen Yang

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

#include "flrexportcheck.flh"
#include "flrpatch.flh"
/***********************************************************************/

/************************************************************************
  file: headerinc/flropposes_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

#include "flropposes.flh"

/***********************************************************************/

/************************************************************************
  file: headerinc/flrhead_dispatch_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

:-(compiler_options([xpp_on])).

#include "flrhead_dispatch.flh"

/***********************************************************************/

/************************************************************************
  file: syslibinc/flrclause_inc.flh

  Author(s): Chang Zhao

  This file is automatically included by the FLORA-2 compiler.
************************************************************************/

:-(compiler_options([xpp_on])).

#mode standard Prolog

#if !defined(FLORA_TERMS_FLH)
#define FLORA_TERMS_FLH
#include "flora_terms.flh"
#endif

?-(:(flrlibman,flora_load_library(FLLIBCLAUSE))).

/***********************************************************************/

 
#if !defined(FLORA_FDB_FILENAME)
#if !defined(FLORA_LOADDYN_DATA)
#define FLORA_LOADDYN_DATA
#endif
#mode save
#mode nocomment "%"
#define FLORA_FDB_FILENAME  'tmp_combined_rules.fdb'
#mode restore
?-(:(flrutils,flora_loaddyn_data(FLORA_FDB_FILENAME,FLORA_THIS_MODULE_NAME,'fdb'))).
#else
#if !defined(FLORA_READ_CANONICAL_AND_INSERT)
#define FLORA_READ_CANONICAL_AND_INSERT
#endif
?-(:(flrutils,flora_read_canonical_and_insert(FLORA_FDB_FILENAME,FLORA_THIS_FDB_STORAGE))).
#endif

 
#if !defined(FLORA_FLM_FILENAME)
#if !defined(FLORA_LOADDYN_DATA)
#define FLORA_LOADDYN_DATA
#endif
#mode save
#mode nocomment "%"
#define FLORA_FLM_FILENAME  'tmp_combined_rules.flm'
#mode restore
?-(:(flrutils,flora_loaddyn_data(FLORA_FLM_FILENAME,FLORA_THIS_MODULE_NAME,'flm'))).
#else
#if !defined(FLORA_READ_CANONICAL_AND_INSERT)
#define FLORA_READ_CANONICAL_AND_INSERT
#endif
?-(:(flrutils,flora_read_descriptor_metafacts_canonical_and_insert(tmp_combined_rules,_ErrNum))).
#endif

 
#if !defined(FLORA_FLD_FILENAME)
#if !defined(FLORA_LOADDYN_DATA)
#define FLORA_LOADDYN_DATA
#endif
#mode save
#mode nocomment "%"
#define FLORA_FLD_FILENAME  'tmp_combined_rules.fld'
#mode restore
?-(:(flrutils,flora_loaddyn_data(FLORA_FLD_FILENAME,FLORA_THIS_MODULE_NAME,'fld'))).
#else
#if !defined(FLORA_READ_CANONICAL_AND_INSERT)
#define FLORA_READ_CANONICAL_AND_INSERT
#endif
?-(:(flrutils,flora_read_canonical_and_insert(FLORA_FLD_FILENAME,FLORA_THIS_FLD_STORAGE))).
#endif

 
#if !defined(FLORA_FLS_FILENAME)
#if !defined(FLORA_LOADDYN_DATA)
#define FLORA_LOADDYN_DATA
#endif
#mode save
#mode nocomment "%"
#define FLORA_FLS_FILENAME  'tmp_combined_rules.fls'
#mode restore
?-(:(flrutils,flora_loaddyn_data(FLORA_FLS_FILENAME,FLORA_THIS_MODULE_NAME,'fls'))).
#else
#if !defined(FLORA_READ_CANONICAL_AND_INSERT)
#define FLORA_READ_CANONICAL_AND_INSERT
#endif
?-(:(flrutils,flora_read_symbols_canonical_and_insert(FLORA_FLS_FILENAME,FLORA_THIS_FLS_STORAGE,_SymbolErrNum))).
#endif


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rules %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-(FLORA_THIS_WORKSPACE(static^tblflapply)(date_int,flapply(date,__Y,__M,__D),__I,'_$ctxt'(_CallerModuleVar,4,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(4,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',51,[__I,+(+(*(__Y,10000),*(__M,100)),__D)]))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(date_ge,__D1,__D2,'_$ctxt'(_CallerModuleVar,6,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(6,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D1,__I1,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,6)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D2,__I2,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,6)),fllibdelayedliteral(>=,'tmp_combined_rules.ergo',53,[__I1,__I2]))),fllibexecute_delayed_calls([__D1,__D2,__I1,__I2],[__D1,__D2])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(date_le,__D1,__D2,'_$ctxt'(_CallerModuleVar,8,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(8,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D1,__I1,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,8)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D2,__I2,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,8)),fllibdelayedliteral(=<,'tmp_combined_rules.ergo',54,[__I1,__I2]))),fllibexecute_delayed_calls([__D1,__D2,__I1,__I2],[__D1,__D2])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(active_on,__D,__From,__To,'_$ctxt'(_CallerModuleVar,10,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(10,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__From,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,10)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_le,__D,__To,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,10))))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(de_minimis_applies,__S,__Threshold,__Src,'_$ctxt'(_CallerModuleVar,12,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(12,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,___O,__I,___P,__V,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,12)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis,__I,__Threshold,__From,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,12)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__From,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,12)),fllibdelayedliteral(=<,'tmp_combined_rules.ergo',63,[__V,__Threshold])))),fllibexecute_delayed_calls([__D,__From,__I,__S,__Src,__Threshold,__V,___O,___P],[__S,__Src,__Threshold])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(exempt_applies,__S,__RuleId,__Src,'_$ctxt'(_CallerModuleVar,14,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(14,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,__O,__I,__P,___V,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,14)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(product,__P,__H,___Cat,___Desc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,14)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_rule,__RuleId,__O,__I,__H,__From,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,14)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__From,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar5,14))))),fllibexecute_delayed_calls([__D,__From,__H,__I,__O,__P,__RuleId,__S,__Src,___Cat,___Desc,___V],[__RuleId,__S,__Src])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(base_rate,__I,__H,__D,__Rb,__Src,'_$ctxt'(_CallerModuleVar,16,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(16,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(tariff_rate,__I,__H,__Rb,__From,__To,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,16)),FLORA_THIS_WORKSPACE(d^tblflapply)(active_on,__D,__From,__To,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,16))),fllibexecute_delayed_calls([__D,__From,__H,__I,__Rb,__Src,__To],[__D,__H,__I,__Rb,__Src])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(override_delta,__I,__O,__H,__D,__R,__Src,'_$ctxt'(_CallerModuleVar,18,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(18,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(exec_override,___EO,__I,__O,__H,__R,__Eff,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,18)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__Eff,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,18))),fllibexecute_delayed_calls([__D,__Eff,__H,__I,__O,__R,__Src,___EO],[__D,__H,__I,__O,__R,__Src])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(override_exists,__I,__O,__H,__D,'_$ctxt'(_CallerModuleVar,20,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(20,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(exec_override,___EO,__I,__O,__H,___R,__Eff,___Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,20)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__Eff,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,20))),fllibexecute_delayed_calls([__D,__Eff,__H,__I,__O,___EO,___R,___Src],[__D,__H,__I,__O])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(override_delta,__I,__O,__H,__D,0.0,none,'_$ctxt'(_CallerModuleVar,22,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(22,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,___S,__O,__I,__P,___V,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,22)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(product,__P,__H,___Cat,___Desc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,22)),flibnafdelay(flora_naf(FLORA_THIS_WORKSPACE(tabled_naf_call)(','(FLORA_THIS_WORKSPACE(d^tblflapply)(override_exists,__I,__O,__H,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,22)),fllibexecute_delayed_calls([__D,__H,__I,__O],[]))),[__I,__O,__H,__D],89,'tmp_combined_rules.ergo')))),fllibexecute_delayed_calls([__D,__H,__I,__O,__P,___Cat,___Desc,___S,___V],[__D,__H,__I,__O])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(de_minimis_applies_s,__S,'_$ctxt'(_CallerModuleVar,24,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(24,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies,__S,___T,___Sx,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,24)),fllibexecute_delayed_calls([__S,___Sx,___T],[__S])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(exempt_applies_s,__S,'_$ctxt'(_CallerModuleVar,26,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(26,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_applies,__S,___R,___Rx,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,26)),fllibexecute_delayed_calls([__S,___R,___Rx],[__S])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(applicable_rate,__S,0.0,flapply(expl,de_minimis,flapply(detail,flapply(items,[flapply(threshold_usd,__Thr),flapply(source,__Src)]))),'_$ctxt'(_CallerModuleVar,28,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(28,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies,__S,__Thr,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,28)))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(applicable_rate,__S,0.0,flapply(expl,exempt,flapply(detail,flapply(items,[flapply(rule,__R),flapply(source,__Src)]))),'_$ctxt'(_CallerModuleVar,30,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(30,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(flibnafdelay(flora_naf(FLORA_THIS_WORKSPACE(tabled_naf_call)(','(FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies_s,__S,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,30)),fllibexecute_delayed_calls([__S],[]))),[__S],99,'tmp_combined_rules.ergo')),FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_applies,__S,__R,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,30))))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(applicable_rate,__S,__Rtotal,flapply(expl,tariff,flapply(detail,flapply(items,[flapply(hs_code,__H),flapply(label,__HL),flapply(base,__Rb,__Bsrc),flapply(override,__Ro,__Osrc)]))),'_$ctxt'(_CallerModuleVar,32,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(32,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(flibnafdelay(flora_naf(FLORA_THIS_WORKSPACE(tabled_naf_call)(','(FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies_s,__S,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,32)),fllibexecute_delayed_calls([__S],[]))),[__S],104,'tmp_combined_rules.ergo')),','(flibnafdelay(flora_naf(FLORA_THIS_WORKSPACE(tabled_naf_call)(','(FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_applies_s,__S,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,32)),fllibexecute_delayed_calls([__S],[]))),[__S],105,'tmp_combined_rules.ergo')),','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,__O,__I,__P,___V,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,32)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(product,__P,__H,___Cat,___Desc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar5,32)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(hs_label,__H,__HL,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar6,32)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(base_rate,__I,__H,__D,__Rb,__Bsrc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar7,32)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(override_delta,__I,__O,__H,__D,__Ro,__Osrc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar8,32)),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',111,[__Rtotal,+(__Rb,__Ro)])))))))),fllibexecute_delayed_calls([__Bsrc,__D,__H,__HL,__I,__O,__Osrc,__P,__Rb,__Ro,__Rtotal,__S,___Cat,___Desc,___V],[__Bsrc,__H,__HL,__Osrc,__Rb,__Ro,__Rtotal,__S])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(duty,__S,__DutyUSD,__Rate,__Expl,'_$ctxt'(_CallerModuleVar,34,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(34,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,___O,___I,___P,__V,___D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,34)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(applicable_rate,__S,__Rate,__Expl,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,34)),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',116,[__DutyUSD,*(__V,__Rate)]))),fllibexecute_delayed_calls([__DutyUSD,__Expl,__Rate,__S,__V,___D,___I,___O,___P],[__DutyUSD,__Expl,__Rate,__S])))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rule signatures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

?-(fllibinsrulesig(4,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,27,FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,flapply(date,__Y,__M,__D),__I,'_$ctxt'(_CallerModuleVar,4,__newcontextvar1)),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',51,[__I,+(+(*(__Y,10000),*(__M,100)),__D)]),null,'_$_$_ergo''rule_enabled'(4,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),null,true)).
?-(fllibinsrulesig(6,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,28,FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D1,__D2,'_$ctxt'(_CallerModuleVar,6,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D1,__I1,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,6)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D2,__I2,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,6)),fllibdelayedliteral(>=,'tmp_combined_rules.ergo',53,[__I1,__I2]))),null,'_$_$_ergo''rule_enabled'(6,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D1,__D2,__I1,__I2],[__D1,__D2]),true)).
?-(fllibinsrulesig(8,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,29,FLORA_THIS_WORKSPACE(d^tblflapply)(date_le,__D1,__D2,'_$ctxt'(_CallerModuleVar,8,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D1,__I1,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,8)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D2,__I2,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,8)),fllibdelayedliteral(=<,'tmp_combined_rules.ergo',54,[__I1,__I2]))),null,'_$_$_ergo''rule_enabled'(8,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D1,__D2,__I1,__I2],[__D1,__D2]),true)).
?-(fllibinsrulesig(10,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,30,FLORA_THIS_WORKSPACE(d^tblflapply)(active_on,__D,__From,__To,'_$ctxt'(_CallerModuleVar,10,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__From,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,10)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_le,__D,__To,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,10))),null,'_$_$_ergo''rule_enabled'(10,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),null,true)).
?-(fllibinsrulesig(12,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,31,FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies,__S,__Threshold,__Src,'_$ctxt'(_CallerModuleVar,12,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,___O,__I,___P,__V,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,12)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis,__I,__Threshold,__From,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,12)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__From,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,12)),fllibdelayedliteral(=<,'tmp_combined_rules.ergo',63,[__V,__Threshold])))),null,'_$_$_ergo''rule_enabled'(12,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D,__From,__I,__S,__Src,__Threshold,__V,___O,___P],[__S,__Src,__Threshold]),true)).
?-(fllibinsrulesig(14,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,32,FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_applies,__S,__RuleId,__Src,'_$ctxt'(_CallerModuleVar,14,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,__O,__I,__P,___V,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,14)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(product,__P,__H,___Cat,___Desc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,14)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_rule,__RuleId,__O,__I,__H,__From,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,14)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__From,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar5,14))))),null,'_$_$_ergo''rule_enabled'(14,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D,__From,__H,__I,__O,__P,__RuleId,__S,__Src,___Cat,___Desc,___V],[__RuleId,__S,__Src]),true)).
?-(fllibinsrulesig(16,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,33,FLORA_THIS_WORKSPACE(d^tblflapply)(base_rate,__I,__H,__D,__Rb,__Src,'_$ctxt'(_CallerModuleVar,16,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(tariff_rate,__I,__H,__Rb,__From,__To,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,16)),FLORA_THIS_WORKSPACE(d^tblflapply)(active_on,__D,__From,__To,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,16))),null,'_$_$_ergo''rule_enabled'(16,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D,__From,__H,__I,__Rb,__Src,__To],[__D,__H,__I,__Rb,__Src]),true)).
?-(fllibinsrulesig(18,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,34,FLORA_THIS_WORKSPACE(d^tblflapply)(override_delta,__I,__O,__H,__D,__R,__Src,'_$ctxt'(_CallerModuleVar,18,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(exec_override,___EO,__I,__O,__H,__R,__Eff,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,18)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__Eff,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,18))),null,'_$_$_ergo''rule_enabled'(18,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D,__Eff,__H,__I,__O,__R,__Src,___EO],[__D,__H,__I,__O,__R,__Src]),true)).
?-(fllibinsrulesig(20,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,35,FLORA_THIS_WORKSPACE(d^tblflapply)(override_exists,__I,__O,__H,__D,'_$ctxt'(_CallerModuleVar,20,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(exec_override,___EO,__I,__O,__H,___R,__Eff,___Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,20)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__Eff,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,20))),null,'_$_$_ergo''rule_enabled'(20,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D,__Eff,__H,__I,__O,___EO,___R,___Src],[__D,__H,__I,__O]),true)).
?-(fllibinsrulesig(22,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,36,FLORA_THIS_WORKSPACE(d^tblflapply)(override_delta,__I,__O,__H,__D,0.0,none,'_$ctxt'(_CallerModuleVar,22,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,___S,__O,__I,__P,___V,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,22)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(product,__P,__H,___Cat,___Desc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,22)),flibnafdelay(flora_naf(FLORA_THIS_WORKSPACE(tabled_naf_call)(','(FLORA_THIS_WORKSPACE(d^tblflapply)(override_exists,__I,__O,__H,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,22)),fllibexecute_delayed_calls([__D,__H,__I,__O],[]))),[__I,__O,__H,__D],89,'tmp_combined_rules.ergo')))),null,'_$_$_ergo''rule_enabled'(22,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D,__H,__I,__O,__P,___Cat,___Desc,___S,___V],[__D,__H,__I,__O]),true)).
?-(fllibinsrulesig(24,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,37,FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies_s,__S,'_$ctxt'(_CallerModuleVar,24,__newcontextvar1)),FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies,__S,___T,___Sx,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,24)),null,'_$_$_ergo''rule_enabled'(24,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__S,___Sx,___T],[__S]),true)).
?-(fllibinsrulesig(26,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,38,FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_applies_s,__S,'_$ctxt'(_CallerModuleVar,26,__newcontextvar1)),FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_applies,__S,___R,___Rx,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,26)),null,'_$_$_ergo''rule_enabled'(26,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__S,___R,___Rx],[__S]),true)).
?-(fllibinsrulesig(28,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,39,FLORA_THIS_WORKSPACE(d^tblflapply)(applicable_rate,__S,0.0,flapply(expl,de_minimis,flapply(detail,flapply(items,[flapply(threshold_usd,__Thr),flapply(source,__Src)]))),'_$ctxt'(_CallerModuleVar,28,__newcontextvar1)),FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies,__S,__Thr,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,28)),null,'_$_$_ergo''rule_enabled'(28,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),null,true)).
?-(fllibinsrulesig(30,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,40,FLORA_THIS_WORKSPACE(d^tblflapply)(applicable_rate,__S,0.0,flapply(expl,exempt,flapply(detail,flapply(items,[flapply(rule,__R),flapply(source,__Src)]))),'_$ctxt'(_CallerModuleVar,30,__newcontextvar1)),','(flibnafdelay(flora_naf(FLORA_THIS_WORKSPACE(tabled_naf_call)(','(FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies_s,__S,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,30)),fllibexecute_delayed_calls([__S],[]))),[__S],99,'tmp_combined_rules.ergo')),FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_applies,__S,__R,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,30))),null,'_$_$_ergo''rule_enabled'(30,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),null,true)).
?-(fllibinsrulesig(32,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,41,FLORA_THIS_WORKSPACE(d^tblflapply)(applicable_rate,__S,__Rtotal,flapply(expl,tariff,flapply(detail,flapply(items,[flapply(hs_code,__H),flapply(label,__HL),flapply(base,__Rb,__Bsrc),flapply(override,__Ro,__Osrc)]))),'_$ctxt'(_CallerModuleVar,32,__newcontextvar1)),','(flibnafdelay(flora_naf(FLORA_THIS_WORKSPACE(tabled_naf_call)(','(FLORA_THIS_WORKSPACE(d^tblflapply)(de_minimis_applies_s,__S,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,32)),fllibexecute_delayed_calls([__S],[]))),[__S],104,'tmp_combined_rules.ergo')),','(flibnafdelay(flora_naf(FLORA_THIS_WORKSPACE(tabled_naf_call)(','(FLORA_THIS_WORKSPACE(d^tblflapply)(exempt_applies_s,__S,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,32)),fllibexecute_delayed_calls([__S],[]))),[__S],105,'tmp_combined_rules.ergo')),','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,__O,__I,__P,___V,__D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,32)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(product,__P,__H,___Cat,___Desc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar5,32)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(hs_label,__H,__HL,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar6,32)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(base_rate,__I,__H,__D,__Rb,__Bsrc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar7,32)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(override_delta,__I,__O,__H,__D,__Ro,__Osrc,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar8,32)),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',111,[__Rtotal,+(__Rb,__Ro)])))))))),null,'_$_$_ergo''rule_enabled'(32,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__Bsrc,__D,__H,__HL,__I,__O,__Osrc,__P,__Rb,__Ro,__Rtotal,__S,___Cat,___Desc,___V],[__Bsrc,__H,__HL,__Osrc,__Rb,__Ro,__Rtotal,__S]),true)).
?-(fllibinsrulesig(34,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,42,FLORA_THIS_WORKSPACE(d^tblflapply)(duty,__S,__DutyUSD,__Rate,__Expl,'_$ctxt'(_CallerModuleVar,34,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,___O,___I,___P,__V,___D,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,34)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(applicable_rate,__S,__Rate,__Expl,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,34)),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',116,[__DutyUSD,*(__V,__Rate)]))),null,'_$_$_ergo''rule_enabled'(34,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__DutyUSD,__Expl,__Rate,__S,__V,___D,___I,___O,___P],[__DutyUSD,__Expl,__Rate,__S]),true)).


%%%%%%%%%%%%%%%%%%%%%%%%% Signatures for latent queries %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%% Queries found in the source file %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 
#if !defined(FLORA_FLS2_FILENAME)
#if !defined(FLORA_LOADDYN_DATA)
#define FLORA_LOADDYN_DATA
#endif
#mode save
#mode nocomment "%"
#define FLORA_FLS2_FILENAME  'tmp_combined_rules.fls2'
#mode restore
?-(:(flrutils,flora_loaddyn_data(FLORA_FLS2_FILENAME,FLORA_THIS_MODULE_NAME,'fls2'))).
#else
#if !defined(FLORA_READ_CANONICAL_AND_INSERT)
#define FLORA_READ_CANONICAL_AND_INSERT
#endif
?-(:(flrutils,flora_read_symbols_canonical_and_insert(FLORA_FLS2_FILENAME,FLORA_THIS_FLS_STORAGE,_SymbolErrNum))).
#endif

?-(:(flrutils,util_load_structdb('tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME))).

/************************************************************************
  file: headerinc/flrtrailer_inc.flh

  Author(s): Michael Kifer

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

#include "flrtrailer.flh"

/***********************************************************************/

/************************************************************************
  file: headerinc/flrpreddef_inc.flh

  Author(s): Chang Zhao

  This file is automatically included by the Flora-2 compiler.
************************************************************************/

:-(compiler_options([xpp_on])).

#include "flrpreddef.flh"

/***********************************************************************/

