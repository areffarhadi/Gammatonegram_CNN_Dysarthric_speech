/*=================================================================
 * mxcreatestructarray.c
 *
 * mxcreatestructarray illustrates how to create a MATLAB structure
 * from a corresponding C structure.  It creates a 1-by-4 structure mxArray,
 * which contains two fields, name and phone number where name is store as a
 * string and phone number is stored as a double.  The structure that is
 * passed back to MATLAB could be used as input to the phonebook.c example
 * in $MATLAB/extern/examples/refbook.
 *
 * This is a MEX-file for MATLAB.  
 * Copyright 1984-2006 The MathWorks, Inc.
 * All rights reserved.
 *=================================================================*/

/* $Revision: 1.2 $ */
#include "mex.h"
#include "matrix.h"
#include "getf0.h"
#include <string.h>

#define NUMBER_OF_STRUCTS (sizeof(friends)/sizeof(struct phonebook))
#define NUMBER_OF_FIELDS (sizeof(field_names)/sizeof(*field_names))

void
mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    mwSize dims[2] = {1, 1 };
    mxArray *field_value;
    const char *field_names[] = 
     {/*float*/
      "cand_thresh",	/* only correlation peaks above this are considered */
      "lag_weight",	/* degree to which shorter lags are weighted */
      "freq_weight",	/* weighting given to F0 trajectory smoothness */
      "trans_cost",	/* fixed cost for a voicing-state transition */
      "trans_amp",	/* amplitude-change-modulated VUV trans. cost */
      "trans_spec",	/* spectral-change-modulated VUV trans. cost */
      "voice_bias",	/* fixed bias towards the voiced hypothesis */
      "double_cost",	/* cost for octave F0 jumps */
      "mean_f0",		/* talker-specific mean F0 (Hz) */
      "mean_f0_weight",	/* weight to be given to deviations from mean F0 */
      "min_f0",		/* min. F0 to search for (Hz) */
      "max_f0",		/* max. F0 to search for (Hz) */
      "frame_step",	/* inter-frame-interval (sec) */
      "wind_dur",		/* duration of correlation window (sec) */
      /*int*/
      "n_cands",		/* max. # of F0 cands. to consider at each frame */
      "conditioning" /* Specify optional signal pre-conditioning. */
      };
    
    
    /* Check for proper number of input and  output arguments */    
    if (nrhs !=0) {
        mexErrMsgTxt("No input argument required.");
    } 
    if(nlhs < 1){
        mexErrMsgTxt("Please give the name of the structure to be filled with the default parameters as an output argument.");
    }
    if(nlhs > 1){
        mexErrMsgTxt("Only one output argument, please.");
    }
    
    /* Create struct */ 
    plhs[0] = mxCreateStructArray(2, dims, NUMBER_OF_FIELDS, field_names);
    
    /* Populate the structure with default values */
    field_value = mxCreateDoubleScalar(0.3f);
    mxSetField(plhs[0],0,"cand_thresh",field_value); 

    field_value = mxCreateDoubleScalar(0.3f);
    mxSetField(plhs[0],0,"lag_weight",field_value); 

    field_value = mxCreateDoubleScalar(0.02f);
    mxSetField(plhs[0],0,"freq_weight",field_value); 
    
    field_value = mxCreateDoubleScalar(0.005f);
    mxSetField(plhs[0],0,"trans_cost",field_value); 
    
    field_value = mxCreateDoubleScalar(0.5f);
    mxSetField(plhs[0],0,"trans_amp",field_value); 
    
    field_value = mxCreateDoubleScalar(0.5f);
    mxSetField(plhs[0],0,"trans_spec",field_value); 
    
    field_value = mxCreateDoubleScalar(0.0f);
    mxSetField(plhs[0],0,"voice_bias",field_value); 
    
    field_value = mxCreateDoubleScalar(0.35f);
    mxSetField(plhs[0],0,"double_cost",field_value); 
    
    field_value = mxCreateDoubleScalar( 50);
    mxSetField(plhs[0],0,"min_f0",field_value); 
    
    field_value = mxCreateDoubleScalar(550);
    mxSetField(plhs[0],0,"max_f0",field_value); 
    
    field_value = mxCreateDoubleScalar(0.01f);
    mxSetField(plhs[0],0,"frame_step",field_value); 
    
    field_value = mxCreateDoubleScalar(0.0075f);
    mxSetField(plhs[0],0,"wind_dur",field_value); 
    
    field_value = mxCreateDoubleScalar(20);
    mxSetField(plhs[0],0,"n_cands",field_value); 
   
   /* unused */
    field_value = mxCreateDoubleScalar(200);
    mxSetField(plhs[0],0,"mean_f0",field_value); 
    
   /* unused */
    field_value = mxCreateDoubleScalar(0.0f);
    mxSetField(plhs[0],0,"mean_f0_weight",field_value); 
 
   /*unused */
    field_value = mxCreateDoubleScalar(0);
    mxSetField(plhs[0],0,"conditioning",field_value); 

}

