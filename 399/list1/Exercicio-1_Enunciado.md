# CAP-399 / 2019 - Primeira Lista de Exercícios

**Objetivo**: Os principais objetivos desta lista de exercícios são (a) permitir maior familiarização com o sistema Santos Dumont e seu ambiente de programação e execução, e (b) permitir familiarização com o benchmark Stream, através de execuções no sistema Santos Dumont. Antes de fazer os exercícios, leia com atenção a página de instruções da máquina, disponível em <http://sdumont.lncc.br/support_manual.php?pg=support#> .

Em particular, deve ser usados o compilador Intel e a biblioteca MPI da Intel, que podem ser configurados com o comando

    source /scratch/app/modulos/intel-psxe-2019.sh

1. Considere o programa fonte disponível em `~____/MPI/pname.c`. Compile este programa no Santos Dumont, e em seguida execute-o com as configurações abaixo. Entregue o resultado da execução e o script utilizado em cada caso, indicando onde estão os mesmos, no Santos Dumont.
    1. Execução com 16 ranks MPI em um único nó.
    2. Execução com 16 ranks, 2 nós (8 ranks MPI em cada nó)
    3. Execução com 16 ranks, 4 nós (4 ranks MPI em cada nó)
2. Considere o programa fonte disponível em `~____/STREAM/stream.c`. Este programa já está implementado com paralelização via OpenMP.
    1. Compile este programa utilizando o compilador `mpiicc` e o flag `-qopenmp`. Execute-o com um único processador em um nó do Santos Dumont, utilizando apenas um thread (i.e. utilize OMP_NUM_THREADS=1 para a execução). Entregue o resultado da execução e o script utilizado, indicando a localização dos mesmos no S.Dumont.
    2. Para o mesmo progrma do ítem anterior, repita a execução, novamente em um único nó e com um processador, utilizando sucessivamente os seguintes valores de números de threads: 2, 4, 8, 12, 16, 20, 24. Apresente os resultados obtidos em cada caso.
    3. Plote as taxas de desempenho obtidas com a operação TRIAD dos exercícios (2.i.) e (2.ii.), isto é, o valor *Rate* (em MB/s), em função do número de threads utilizados.

