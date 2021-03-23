
#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>

#define SIZE 1000000
int m;

void exit(int), do_flops(double *,int);

int main(argc,argv)
int argc;
char *argv[];
{
int myid, numprocs;

    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD,&myid);
    m = myid+1 ;

/* Initializations */
double x=0.5;

/* Warmup */
do_flops(&x,4*SIZE);

/* Do flops */
do_flops(&x,SIZE);

/* Do many more flops */
do_flops(&x,4*SIZE);

printf("[%d] All done: x=%lf\n",myid,x);
MPI_Finalize();
}

void do_flops(x,k)
double *x;
int k;
{
        int i;

int passes;

  for (passes=0; passes<m; passes++) {
        for (i=0; i<k; i++) *x=sin(*x);
  }
}
