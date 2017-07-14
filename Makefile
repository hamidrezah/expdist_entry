# comments start with a #
# $< first dependency in the list
# $@ name of the target
# $^ all dependencies of this target

#Hamid's settings
HOME = /home/hheydarian
#VXL_INC = -I$(HOME)/vxl/core/ -I$(HOME)/bin/core -I$(HOME)/vxl/vcl/ -I$(HOME)/bin/vcl 
GPU_EXPDIST_DIR = /home/hheydarian/expdist-master/
#GPU_GAUSSTRANSFORM_DIR = /home/hheydarian/gmmreg-master/MATLAB/GaussTransform/GPUGaussTransform/
#GMMREG_DIR = /home/hheydarian/gmmreg-master/C++/

#Ben's settings
#VXL_DIR = /home/tnw-g434/vxl
#VXL_INC = -I$(VXL_DIR)/core -I$(VXL_DIR)/vcl
#GPU_EXPDIST_DIR = /home/tnw-g434/GPUGaussTransform
#GMMREG_DIR = /home/tnw-g434/gmmreg-master/C++/


#don't change the following
GPUEXPDIST_INC = -I$(GPU_EXPDIST_DIR)/src
GPUEXPDIST_LIB = $(GPU_EXPDIST_DIR)/bin/
#GPUGT_INC = -I$(GPU_GAUSSTRANSFORM_DIR)/src
#GPUGT_LIB = $(GPU_GAUSSTRANSFORM_DIR)/bin/

all: expdist_mex_cuda.mexa64 mex_expdist.mexa64

mex_expdist.mexa64: mex_expdist.cpp expdist.cpp
	mex $^

expdist_mex_cuda.mexa64: expdist_mex_cuda.cpp expdist_cuda.o
	mex $^ $(GPUEXPDIST_LIB)expdist.so -L/opt/ud/cuda-8.0/lib64 -lcudart -I/opt/ud/Matlab-R2016b/extern/include/

expdist_cuda.o: expdist_cuda.cpp
	g++ -fPIC $(GPUEXPDIST_INC) -c $< -o $@ -I/opt/ud/cuda-8.0/include/

clean:
	rm -rf *.mexa64 *.o
