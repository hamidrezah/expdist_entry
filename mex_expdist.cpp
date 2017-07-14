/*%%=====================================================================
%% Entry function for evaluating bhatt cost
%% Author: Hamidreza Heydarian
%%=====================================================================*/
#include <stdio.h>
#include "mex.h"

double expdist(const double* A, const double* B,  int m, int n, int dim, const double* scale_A, const double* scale_B);

void mexFunction(int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
    /* Declare variables */ 
    int m, n, dim; 
    double *A, *B, *result, *scale_A, *scale_B;
    
    /* Check for proper number of input and output arguments */    
    if (nrhs != 4) {
	mexErrMsgTxt("Seven input arguments required.");
    } 
    if (nlhs > 2){
	mexErrMsgTxt("Too many output arguments.");
    }
    
    /* Check data type of input argument */
    if (!(mxIsDouble(prhs[0]))) {
      mexErrMsgTxt("Input array must be of type double.");
    }
    if (!(mxIsDouble(prhs[1]))) {
      mexErrMsgTxt("Input array must be of type double.");
    }
    if (!(mxIsDouble(prhs[2]))) {
      mexErrMsgTxt("Input array must be of type double.");
    }
    if (!(mxIsDouble(prhs[3]))) {
      mexErrMsgTxt("Input array must be of type double.");
    }    
    
    /* Get the number of elements in the input argument */
    /* elements=mxGetNumberOfElements(prhs[0]); */
    /* Get the data */
    A = (double *)mxGetPr(prhs[0]);
    B = (double *)mxGetPr(prhs[1]);
    scale_A = (double *)mxGetPr(prhs[2]);
    scale_B = (double *)mxGetPr(prhs[3]);
  	/* Get the dimensions of the matrix input A&B. */
  	m = mxGetM(prhs[0]);
  	n = mxGetM(prhs[1]);
  	dim = mxGetN(prhs[0]);
  	if (mxGetN(prhs[1])!=dim)
  	{
  		mexErrMsgTxt("The two input point sets should have same dimension.");
  	}
    /* Allocate the space for the return argument */
    plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    result = mxGetPr(plhs[0]);
    *result = expdist(A, B, m, n, dim, scale_A, scale_B);
    
}
