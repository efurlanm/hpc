#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>

int main(argc,argv)
int argc;
char *argv[];
{
    int myid, numprocs, other, i, j, size, num_sizes;
    int  namelen;
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    char name[MPI_MAX_PROCESSOR_NAME];

    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD,&myid);
    MPI_Get_processor_name(processor_name,&namelen);
    gethostname(name,MPI_MAX_PROCESSOR_NAME);

    fprintf(stdout,"Process %d of %d on %s (hostname %s) \n",
            myid, numprocs, processor_name, name);

    MPI_Barrier(MPI_COMM_WORLD);

    MPI_Finalize();
    return 0;
}

