
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

#define FLORA_COMPILATION_ID 2

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

:-(FLORA_THIS_WORKSPACE(static^tblflapply)(date_int,flapply(date,__Y,__M,__D),__I,'_$ctxt'(_CallerModuleVar,4,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(4,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',29,[__I,+(+(*(__Y,10000),*(__M,100)),__D)]))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(date_ge,__D1,__D2,'_$ctxt'(_CallerModuleVar,6,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(6,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D1,__I1,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,6)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D2,__I2,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,6)),fllibdelayedliteral(>=,'tmp_combined_rules.ergo',31,[__I1,__I2]))),fllibexecute_delayed_calls([__D1,__D2,__I1,__I2],[__D1,__D2])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(date_le,__D1,__D2,'_$ctxt'(_CallerModuleVar,8,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(8,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D1,__I1,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,8)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D2,__I2,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,8)),fllibdelayedliteral(=<,'tmp_combined_rules.ergo',32,[__I1,__I2]))),fllibexecute_delayed_calls([__D1,__D2,__I1,__I2],[__D1,__D2])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(active_on,__D,__From,__To,'_$ctxt'(_CallerModuleVar,10,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(10,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__From,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,10)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_le,__D,__To,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,10))))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(base_rate,__I,__H,__D,__Rate,__Src,'_$ctxt'(_CallerModuleVar,12,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(12,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(tariff_rate,__I,__H,__Rate,__From,__To,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,12)),FLORA_THIS_WORKSPACE(d^tblflapply)(active_on,__D,__From,__To,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,12))),fllibexecute_delayed_calls([__D,__From,__H,__I,__Rate,__Src,__To],[__D,__H,__I,__Rate,__Src])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(applicable_rate,__S,__Rate,flapply(expl,tariff,flapply(detail,flapply(items,[flapply(hs_code,__H),flapply(label,__HL),flapply(base,__Rate,__Src)]))),'_$ctxt'(_CallerModuleVar,14,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(14,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,___Origin,__ImportCountry,__Product,___Value,__Date,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,14)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(product,__Product,__H,___Category,___Description,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,14)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(hs_label,__H,__HL,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,14)),FLORA_THIS_WORKSPACE(d^tblflapply)(base_rate,__ImportCountry,__H,__Date,__Rate,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar5,14))))),fllibexecute_delayed_calls([__Date,__H,__HL,__ImportCountry,__Product,__Rate,__S,__Src,___Category,___Description,___Origin,___Value],[__H,__HL,__Rate,__S,__Src])))).
:-(FLORA_THIS_WORKSPACE(static^tblflapply)(duty,__S,__DutyUSD,__Rate,__Expl,'_$ctxt'(_CallerModuleVar,16,__newcontextvar1)),','('_$_$_ergo''rule_enabled'(16,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),','(','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,___Origin,___ImportCountry,___Product,__Value,___Date,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,16)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(applicable_rate,__S,__Rate,__Expl,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,16)),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',51,[__DutyUSD,*(__Value,__Rate)]))),fllibexecute_delayed_calls([__DutyUSD,__Expl,__Rate,__S,__Value,___Date,___ImportCountry,___Origin,___Product],[__DutyUSD,__Expl,__Rate,__S])))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rule signatures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

?-(fllibinsrulesig(4,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,18,FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,flapply(date,__Y,__M,__D),__I,'_$ctxt'(_CallerModuleVar,4,__newcontextvar1)),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',29,[__I,+(+(*(__Y,10000),*(__M,100)),__D)]),null,'_$_$_ergo''rule_enabled'(4,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),null,true)).
?-(fllibinsrulesig(6,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,19,FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D1,__D2,'_$ctxt'(_CallerModuleVar,6,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D1,__I1,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,6)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D2,__I2,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,6)),fllibdelayedliteral(>=,'tmp_combined_rules.ergo',31,[__I1,__I2]))),null,'_$_$_ergo''rule_enabled'(6,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D1,__D2,__I1,__I2],[__D1,__D2]),true)).
?-(fllibinsrulesig(8,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,20,FLORA_THIS_WORKSPACE(d^tblflapply)(date_le,__D1,__D2,'_$ctxt'(_CallerModuleVar,8,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D1,__I1,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,8)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_int,__D2,__I2,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,8)),fllibdelayedliteral(=<,'tmp_combined_rules.ergo',32,[__I1,__I2]))),null,'_$_$_ergo''rule_enabled'(8,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D1,__D2,__I1,__I2],[__D1,__D2]),true)).
?-(fllibinsrulesig(10,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,21,FLORA_THIS_WORKSPACE(d^tblflapply)(active_on,__D,__From,__To,'_$ctxt'(_CallerModuleVar,10,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(date_ge,__D,__From,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,10)),FLORA_THIS_WORKSPACE(d^tblflapply)(date_le,__D,__To,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,10))),null,'_$_$_ergo''rule_enabled'(10,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),null,true)).
?-(fllibinsrulesig(12,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,22,FLORA_THIS_WORKSPACE(d^tblflapply)(base_rate,__I,__H,__D,__Rate,__Src,'_$ctxt'(_CallerModuleVar,12,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(tariff_rate,__I,__H,__Rate,__From,__To,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,12)),FLORA_THIS_WORKSPACE(d^tblflapply)(active_on,__D,__From,__To,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,12))),null,'_$_$_ergo''rule_enabled'(12,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__D,__From,__H,__I,__Rate,__Src,__To],[__D,__H,__I,__Rate,__Src]),true)).
?-(fllibinsrulesig(14,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,23,FLORA_THIS_WORKSPACE(d^tblflapply)(applicable_rate,__S,__Rate,flapply(expl,tariff,flapply(detail,flapply(items,[flapply(hs_code,__H),flapply(label,__HL),flapply(base,__Rate,__Src)]))),'_$ctxt'(_CallerModuleVar,14,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,___Origin,__ImportCountry,__Product,___Value,__Date,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,14)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(product,__Product,__H,___Category,___Description,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,14)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(hs_label,__H,__HL,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar4,14)),FLORA_THIS_WORKSPACE(d^tblflapply)(base_rate,__ImportCountry,__H,__Date,__Rate,__Src,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar5,14))))),null,'_$_$_ergo''rule_enabled'(14,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__Date,__H,__HL,__ImportCountry,__Product,__Rate,__S,__Src,___Category,___Description,___Origin,___Value],[__H,__HL,__Rate,__S,__Src]),true)).
?-(fllibinsrulesig(16,'tmp_combined_rules.ergo','_$_$_ergo''descr_vars',FLORA_THIS_MODULE_NAME,24,FLORA_THIS_WORKSPACE(d^tblflapply)(duty,__S,__DutyUSD,__Rate,__Expl,'_$ctxt'(_CallerModuleVar,16,__newcontextvar1)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(shipment,__S,___Origin,___ImportCountry,___Product,__Value,___Date,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar2,16)),','(FLORA_THIS_WORKSPACE(d^tblflapply)(applicable_rate,__S,__Rate,__Expl,'_$ctxt'(FLORA_THIS_MODULE_NAME,__newcontextvar3,16)),fllibdelayedliteral('\\is','tmp_combined_rules.ergo',51,[__DutyUSD,*(__Value,__Rate)]))),null,'_$_$_ergo''rule_enabled'(16,'tmp_combined_rules.ergo',FLORA_THIS_MODULE_NAME),fllibexecute_delayed_calls([__DutyUSD,__Expl,__Rate,__S,__Value,___Date,___ImportCountry,___Origin,___Product],[__DutyUSD,__Expl,__Rate,__S]),true)).


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

