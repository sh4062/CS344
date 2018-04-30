#include<stdio.h>


__global__ void square(float *d_out,float * d_in){
    int idx = nv.x;
    float f = d_in[idx];
    d_out[idx]= f*f;
}
int main(int argc,char** argv){
    printf("CS344\n");
    const int ARRAY_SIZE = 10;
    const int ARRAY_BYTES = ARRAY_SIZE*sizeof(float);

    //generate the input array on the host
    float h_in[ARRAY_SIZE];
    for(int i = 0;i<ARRAY_SIZE;i++){
        h_in[i]=(float)(i);
    }
    float h_out[ARRAY_SIZE];

    //declare GPU memory pointers
    float * d_in;
    float * d_out;
    //allocate GPU memoryy
    cudaMalloc((void**)&d_in,ARRAY_BYTES);
    cudaMalloc((void**)&d_out,ARRAY_BYTES);
    //transfer to GPU
    printf("transfer to GPU\n");
    for(int i = 0;i<ARRAY_SIZE;i++){
        printf("%f",h_in[i]);
        printf(((i%4)!=3)?"\t":"\n");
    }
    cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);
    //launch kernal
    square<<<1,ARRAY_SIZE>>>(d_out,d_in);
    //copy back
	cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);
    //print out results
    for(int i = 0;i<ARRAY_SIZE;i++){
        printf("%f",h_out[i]);
        printf(((i%4)!=3)?"\t":"\n");
    }
    //free cudamem
    cudaFree(d_in);
    cudaFree(d_out);
    return 0;
    
}
