#include <stdio.h>
#include "expdist.h"

double expdist_cuda(const double* A, const double* B,
                            int m, int n, int dim, 
                            const double* scale_A,
                            const double* scale_B)
{

    GPUExpDist *gpu_expdist = (GPUExpDist *)NULL;

    if (gpu_expdist == (GPUExpDist *)NULL) {
        gpu_expdist = new GPUExpDist(1000000);
    }  

    double energy = gpu_expdist->compute(A, B, m, n, scale_A, scale_B);  
    delete gpu_expdist;

    return energy;
}
