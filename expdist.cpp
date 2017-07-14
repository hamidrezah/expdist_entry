/*%%=====================================================================
%% Computes the bhattacharya cost function for two given point set
%% Author:    Hamidreza Heydarian
%%=====================================================================*/

#define SQR(X)  ((X)*(X))

#include <stdio.h> 
#include <math.h>

#ifdef WIN32
__declspec( dllexport )
#endif
double expdist(const double* A, const double* B,  int m, int n, int dim, const double* scale_A, const double* scale_B)
{
	int i,j,d; 
    int id, jd;
	double dist_ij, cross_term = 0;
	
	for (i=0;i<m;++i)
	{
		for (j=0;j<n;++j)
		{
			dist_ij = 0;
			for (d=0;d<dim;++d)
			{
                id = i + d * m;
                jd = j + d * n;                
				dist_ij = dist_ij + SQR( A[id] - B[jd]);
			}
            cross_term += exp(-dist_ij/(scale_A[i] + scale_B[j]));			
		}
	}
    
	return cross_term;
}
