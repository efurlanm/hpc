/* mpi2.c
 * Para compilar:
 *      module load papi
 *      module load papi-devel
 *      module load intel_psxe/2019
 *      mpiicc -o mpi2 $PAPI_INC mpi2.c $PAPI_LIB -lpapi -lm        # Intel
 *      mpicc -o mpi2 $PAPI_INC mpi2.c $PAPI_LIB -lpapi -lm         # GNU
 * Rodar:
 *      mpirun -n 8 ./mpi2
 */

#include "mpi.h"
#include <papi.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>

#define NUM_EVENTS 3
#define SIZE 1000000

int m;
void exit(int), do_flops(double *,int);

int main(int argc, char *argv[])
{
    int Events[NUM_EVENTS] = {PAPI_L2_TCM, PAPI_L3_TCM, PAPI_BR_MSP};
    long_long avalues[NUM_EVENTS], bvalues[NUM_EVENTS];
    int nc = PAPI_num_counters();
    printf("Num.Counters=%d\n",nc);
    printf("PAPI_L2_TCM, PAPI_L3_TCM, PAPI_BR_MSP\n");

    int myid, numprocs;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &myid);
    m = myid + 1 ;

    /* Initializations */
    double x = 0.5;

    /* Warmup */                /* primeira chamada */
    do_flops(&x, 4*SIZE);

    /* Start counting events */
    if (PAPI_start_counters(Events, NUM_EVENTS) != PAPI_OK) exit(-1);

    /* Do flops */              /* segunda chamada <-- instrumentar */
    do_flops(&x, SIZE);

    /* Read the counters */
    if (PAPI_read_counters(avalues, NUM_EVENTS) != PAPI_OK) exit(-1);
    
    /* Do many more flops */    /* terceira chamada <-- instrumentar */
    do_flops(&x, 4*SIZE);

    /* Read the counters again */
    if (PAPI_read_counters(bvalues, NUM_EVENTS) != PAPI_OK) exit(-1);

    /* Print counters */
    printf("[%d] Apos primeira leitura dos counters: %lld, %lld, %lld, x=%lf\n",            
		myid, avalues[0], avalues[1], avalues[2], x);
    printf("[%d] Apos segunda leitura dos counters: %lld, %lld, %lld, x=%lf\n", 
		myid, bvalues[0], bvalues[1], bvalues[2], x);
    
    printf("[%d] All done: x=%lf\n", myid, x);
    MPI_Finalize();
}

void do_flops(double *x, int k)
{
    int i, passes;

    for (passes=0; passes<m; passes++)
        for (i=0; i<k; i++) *x = sin(*x);
}
