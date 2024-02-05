# Python + MPI 
*Última atualização: 2019-11-18*

Instalar OpenMPI no nó de login

```console
x@master:/scratch$ sudo apt install -y openmpi-bin openmpi-common libopenmpi2 libopenmpi-dev
```

Instalar OpenMPI nos demais 6 nós, em paralelo

```console
x@master:~$ sudo su -
root@node05:~# srun --nodes=6 apt install -y openmpi-bin openmpi-common libopenmpi2 libopenmpi-dev
```
Testando com `/scratch/hello_mpi.c`

```c
#include <stdio.h>
#include <mpi.h>

int main(int argc, char** argv){
    int node;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &node);

    printf("Hello World from Node %d!\n", node);

    MPI_Finalize();
}
```
Compilar

```console
x@master:/scratch$ mpicc -O0 hello_mpi.c -o hello_mpi
```
Script de submissão `/scratch/sub_mpi.sh`

```bash
#!/bin/bash

cd $SLURM_SUBMIT_DIR

# Print the node that starts the process
echo "Master node: $(hostname)"

# Run our program using OpenMPI.
# OpenMPI will automatically discover resources from SLURM.
mpirun hello_mpi
```
Rodar

```console
x@master:/scratch$ sbatch --nodes=7 --ntasks-per-node=1 sub_mpi.sh
Submitted batch job 160
```
slurm-160.out

```
Master node: node01
Hello World from Node 0!
Hello World from Node 3!
Hello World from Node 6!
Hello World from Node 4!
Hello World from Node 5!
Hello World from Node 1!
Hello World from Node 2!
```

# PYTHON

Instalar pip nos 7 nós, em paralelo

```console
x@master:/scratch$ srun --nodes=7 sudo apt install -y python3-pip

```
Instalar as bibliotecas numpy e mpi4py

```console
x@master:/scratch$ srun --nodes=7 sudo -H pip3 install numpy mpi4py
```

Testando

```console
x@master:/scratch$ srun --nodes=7 python3 -c "print('Hello')"
Hello
Hello
Hello
Hello
Hello
Hello
Hello
```


```console
x@master:/scratch$ srun --ntasks=30 python3 -c "print('Hello')"
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
```


```console
x@master:/scratch$ srun --nodelist=node02,node03 --ntasks=16 python3 -c "print('Hello')"
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
```


# Python MPI

Exemplo cálculo PI `/scratch/calc-pi.py` (baseado no código existente no repositório `mpi4py`)

```python
from mpi4py import MPI
from math   import pi as PI
from numpy  import array
import time

def comp_pi(n, myrank=0, nprocs=1):
    h = 1.0 / n
    s = 0.0
    for i in range(myrank + 1, n + 1, nprocs):
        x = h * (i - 0.5)
        s += 4.0 / (1.0 + x**2)
    return s * h

def prn_pi(pi, PI):
    message = "pi is approximately %.16f, error is %.16f"
    print  (message % (pi, abs(pi - PI)))

comm = MPI.COMM_WORLD
nprocs = comm.Get_size()
myrank = comm.Get_rank()

n    = array(0, dtype=int)
pi   = array(0, dtype=float)
mypi = array(0, dtype=float)

if myrank == 0:
    _n = 1000  # Enter the number of intervals
    n.fill(_n)
    print('--- Printing from Rank 0 ---')
    print('Number of intervals = ', _n)
    print('Processes comm.Get_size() = ', nprocs)
    print('Rank 0 MPI.Get_processor_name() = ', MPI.Get_processor_name())
    print('--- from Processes ---------')

comm.Bcast([n, MPI.INT], root=0)
time1 = time.time()
wt = MPI.Wtime()
_mypi = comp_pi(n, myrank, nprocs)
wt = MPI.Wtime() - wt
time2 = time.time() - time1
print('Running Rank = ', myrank, '  time.time() = ', time2, '  Wtime() = ', wt)
mypi.fill(_mypi)
comm.Reduce([mypi, MPI.DOUBLE], [pi, MPI.DOUBLE], op=MPI.SUM, root=0)

if myrank == 0:
    prn_pi(pi, PI)
```

Script de submissão `/scratch/sub_calc_pi.sh` com 30 processos

```bash
#!/bin/bash
#SBATCH --ntasks=30

cd $SLURM_SUBMIT_DIR

mpiexec -n $SLURM_NTASKS python3 calc-pi.py
```

Rodando o cálculo com 1000 intervalos

```console
x@master:/scratch$ sbatch sub_calc_pi.sh
Submitted batch job 166

```

slurm-166.out

```
--- Printing from Rank 0 ---
Number of intervals =  1000
Processes comm.Get_size() =  30
Rank 0 MPI.Get_processor_name() =  node01
--- from Processes ---------
Running Rank =  27   time.time() =  9.608268737792969e-05   Wtime() =  8.821599476505071e-05
Running Rank =  11   time.time() =  0.0001761913299560547   Wtime() =  0.0001629960024729371
Running Rank =  23   time.time() =  0.00015282630920410156   Wtime() =  0.0001459560007788241
Running Rank =  26   time.time() =  0.00011587142944335938   Wtime() =  0.0001111230012611486
Running Rank =  10   time.time() =  0.0001895427703857422   Wtime() =  0.00017130805645138025
Running Rank =  22   time.time() =  0.00038170814514160156   Wtime() =  0.0003614960005506873
Running Rank =  20   time.time() =  0.00014591217041015625   Wtime() =  0.0001399520260747522
Running Rank =  21   time.time() =  0.0001621246337890625   Wtime() =  0.00015257601626217365
Running Rank =  9   time.time() =  0.000179290771484375   Wtime() =  0.00017114309594035149
Running Rank =  8   time.time() =  0.00012946128845214844   Wtime() =  0.00012361095286905766
Running Rank =  24   time.time() =  0.018949508666992188   Wtime() =  0.01893674700113479
Running Rank =  25   time.time() =  0.019182443618774414   Wtime() =  0.019168964001437416
Running Rank =  3   time.time() =  0.00010800361633300781   Wtime() =  0.00010345797636546195
Running Rank =  4   time.time() =  0.0001316070556640625   Wtime() =  0.000124647980555892
Running Rank =  2   time.time() =  7.915496826171875e-05   Wtime() =  7.492199074476957e-05
Running Rank =  7   time.time() =  0.00011229515075683594   Wtime() =  0.00010660302359610796
Running Rank =  5   time.time() =  0.0001583099365234375   Wtime() =  0.00015073898248374462
Running Rank =  0   time.time() =  0.00011539459228515625   Wtime() =  0.00011255498975515366
Running Rank =  6   time.time() =  0.00016236305236816406   Wtime() =  0.0001544909318909049
Running Rank =  28   time.time() =  9.393692016601562e-05   Wtime() =  8.16650062915869e-05
Running Rank =  29   time.time() =  9.1552734375e-05   Wtime() =  8.835500193526968e-05
Running Rank =  1   time.time() =  9.775161743164062e-05   Wtime() =  9.155602310784161e-05
Running Rank =  12   time.time() =  0.014123678207397461   Wtime() =  0.014117746999545489
Running Rank =  13   time.time() =  0.014143943786621094   Wtime() =  0.014137095997284632
Running Rank =  14   time.time() =  0.020174503326416016   Wtime() =  0.020163690998742823
Running Rank =  15   time.time() =  0.020157814025878906   Wtime() =  0.020146622002357617
Running Rank =  16   time.time() =  0.019798994064331055   Wtime() =  0.01979123400087701
Running Rank =  17   time.time() =  0.01237344741821289   Wtime() =  0.012366331997327507
Running Rank =  18   time.time() =  0.019823312759399414   Wtime() =  0.01981667899963213
Running Rank =  19   time.time() =  0.02013564109802246   Wtime() =  0.02012383499823045
pi is approximately 3.1415927369231267, error is 0.0000000833333336
```

Agora rodando o cálculo com 1000000000 intervalos

```console
x@master:/scratch$ sbatch sub_calc_pi.sh
Submitted batch job 167
x@master:/scratch$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
               167 mycluster sub_calc        x  R       0:04      7 node[01-07]
x@master:/scratch$ scontrol show node | grep Load
   CPUAlloc=0 CPUErr=0 CPUTot=2 CPULoad=0.06
   CPUAlloc=4 CPUErr=0 CPUTot=4 CPULoad=1.04
   CPUAlloc=8 CPUErr=0 CPUTot=8 CPULoad=0.00
   CPUAlloc=8 CPUErr=0 CPUTot=8 CPULoad=0.00
   CPUAlloc=2 CPUErr=0 CPUTot=2 CPULoad=0.01
   CPUAlloc=2 CPUErr=0 CPUTot=2 CPULoad=0.00
   CPUAlloc=2 CPUErr=0 CPUTot=2 CPULoad=0.04
   CPUAlloc=4 CPUErr=0 CPUTot=4 CPULoad=0.01
```

sinfo

```console
x@master:/scratch$ sinfo  
PARTITION  AVAIL  TIMELIMIT  NODES  STATE NODELIST
mycluster*    up   infinite      7  alloc node[01-07]
```

top

```console
x@node01:~$ top
Tasks: 254 total,   7 running, 184 sleeping,   0 stopped,   0 zombie
%Cpu(s): 87.6 us, 11.8 sy,  0.0 ni,  0.5 id,  0.0 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem : 16288556 total, 13402360 free,   658440 used,  2227756 buff/cache
KiB Swap:  2097148 total,  2096368 free,      780 used. 15269808 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                  
 8891 x         20   0  715664  40428  21932 R 103.6  0.2   1439:25 python3                  
13097 x         20   0  715664  39852  21432 R  86.4  0.2   0:24.72 python3                  
13096 x         20   0  715664  40096  21708 R  78.8  0.2   0:21.18 python3                  
13098 x         20   0  715664  39780  21360 R  67.2  0.2   0:22.24 python3                  
13099 x         20   0  715664  40236  21820 R  53.3  0.2   0:21.02 python3                  
 8892 x         20   0  714388  39560  22156 R   7.6  0.2  85:08.23 python3                  
13120 x         20   0   53008   4156   3376 R   0.3  0.0   0:00.03 top  
```

Cancelando o job. Observar que não é instantâneo, no exemplo abaixo dois nós aguardam em "CG" ("Completing") antes de terminar.

```console
x@master:/scratch$ scancel 167
x@master:/scratch$ squeue    
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
               167 mycluster sub_calc        x CG       2:44      2 node[02-03]
x@master:/scratch$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
```

os códigos que aparecem em squeue estão em https://slurm.schedmd.com/squeue.html

rodando apenas em node02

```bash
#!/bin/bash
#SBATCH --ntasks=8
#SBATCH --nodelist=node02

cd $SLURM_SUBMIT_DIR

mpiexec -n $SLURM_NTASKS python3 calc-pi.py

```

```console
x@master:/scratch$ sbatch sub_calc_pi.sh
Submitted batch job 151
```

slurm-151.out

```
--- Printing from Rank 0 ---
Number of intervals =  1000
Processes comm.Get_size() =  8
Rank 0 MPI.Get_processor_name() =  node02
--- from Processes ---------
Running Rank =  0   time.time() =  0.0004057884216308594   Wtime() =  0.0004029989941045642
Running Rank =  1   time.time() =  0.0003402233123779297   Wtime() =  0.0003352019703015685
Running Rank =  3   time.time() =  0.00038361549377441406   Wtime() =  0.0003773680655285716
Running Rank =  5   time.time() =  0.00035691261291503906   Wtime() =  0.00034958391916006804
Running Rank =  7   time.time() =  0.0003273487091064453   Wtime() =  0.0003221730003133416
Running Rank =  2   time.time() =  0.00036454200744628906   Wtime() =  0.00035880901850759983
Running Rank =  6   time.time() =  0.0003533363342285156   Wtime() =  0.0003446540795266628
Running Rank =  4   time.time() =  0.0003407001495361328   Wtime() =  0.0003334229113534093
pi is approximately 3.1415927369231262, error is 0.0000000833333331
```

# REFERÊNCIAS

* https://medium.com/@glmdev/building-a-raspberry-pi-cluster-784f0df9afbd
* https://www.linuxwave.info/2019/10/installing-slurm-workload-manager-job.html
* https://slurm.schedmd.com/

