#include "stdio.h"
#include "stdlib.h"
#include "time.h"
#define idx threadIdx.x
#define COM_COST 20

__global__ void init(bool* prime, int n, int step) {
    int start = step * idx; // including start
    int end = ((start + step) < n) ? (start + step) : n; // excluding end
 
    for(int i = start; i < end; i++) {
        prime[i] = true;
    }
}

__global__ void sieve(bool* prime, int num, int n, int step, int c) {
    // To simulate linear architecture
    for(int i = 0, tmp = 0; i < c * idx * COM_COST; i++) tmp++;

    int start = step * idx; // including start
    int end = ((start + step) < n) ? (start + step) : n; // excluding end
 
    int loc = (start % num) ? start - start % num + num : start; 
    while(loc < end) {
        prime[loc] = false;
        loc += num;
    }
}

// print the maximum prime, for testing
void print_max_prime(bool* prime, int n) {
    for(int i = n - 1; i > n - 100; i--)
        if(prime[i]) {
            printf("The maximum prime less than %d is %d\n", n, i);
            break;
        }
}

int main(int argc, char** argv) {
    int n, p, c;
    if(argc != 4) {
        printf("Usage: ./seive <n> <p> <c> (n > 0,  p > 0 and c >= 0)\n");
        return 1;
    }
    else {
        n = atoi(argv[1]);
        p = atoi(argv[2]);
        c = atoi(argv[3]);
        if(n <= 0 || p <= 0 || c < 0) {
            printf("Usage: ./seive <n> <p> <c> (n > 0,  p > 0 and c >= 0)\n");
            return 1;
        }
    }

    int start_time = clock(); // Start timing

    bool *prime, *d_prime;
    prime = (bool*)malloc(n * sizeof(bool));
    cudaMalloc(&d_prime, n * sizeof(bool));

    // Initialize the array in parallel
    int step = (n + p - 1) / p;
    init<<<1, p>>>(d_prime, n, step); // Since my GPU has only one SM

    int sqrt_n = sqrt(n); 
    for(int i = 2; i <= sqrt_n; i++) {
        cudaMemcpy(prime + i*sizeof(bool), d_prime + i*sizeof(bool), sizeof(bool), cudaMemcpyDeviceToHost);
        if(prime[i])
            sieve<<<1, p>>>(d_prime, i, n, step, c);
    }
    
    cudaMemcpy(prime, d_prime, n * sizeof(bool), cudaMemcpyDeviceToHost);
    // print_max_prime(prime, n);
    int end_time = clock(); // End timing
    printf("%d\n", (end_time - start_time) / ((int)CLOCKS_PER_SEC / 1000));
    return 0;
}
