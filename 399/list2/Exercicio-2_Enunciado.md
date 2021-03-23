# CAP-399 / 2019 - Segunda Lista de Exercícios

**Objetivo**: O principal objetivo desta lista de exercícios é oferecer uma familiarização com o uso de PAPI no sistema Santos Dumont. Esta ferramenta (PAPI) deverá ser utilizada também em outras fases do curso futuramente. Antes de fazer os exercícios, leia com atenção a página de instruções da máquina, disponível em http://sdumont.lncc.br/support_manual.php?pg=support#

Deve ser usado o compilador Intel, que pode ser configurado com um destes comandos:

    source /scratch/app/modulos/intel-psxe-2019.sh
    module load intel_psxe

Para utilizar PAPI, devem ser previamente carregados os módulos `papi` e `papi-devel`

1. Considere o programa fonte disponível em `~____/PAPI/papiex.c`:
    1. Compile o programa (conforme indicado em aula) e execute-o em um processador de um nó do Santos Dumont, apresentando os resultados obtidos na execução.
    2. Modifique o código fonte do programa, de modo a capturar quatro eventos pré-definidos em PAPI, diferentes daqueles eventos colhidos no ítem anterior. Apresente o resultado da execução e o novo código fonte.

> Para auxiliar na escolha dos novos eventos do item 1.ii., podem ser executados os utilitários `papi_avail` e `papi_command_line`, conforme visto em aula.

2. Considere o programa fonte em MPI disponível em `~____/PAPI/mpi.c`:
    1. Compile o programa, utilizando MPI-Intel, e execute-o em oito processadores de um mesmo nó do Santos Dumont. Apresente os resultados obtidos nesta execução.
    2. Modifique este programa, de modo a instrumentar a *segunda* e a *terceira* chamadas à função `do_flops()` no programa principal, para capturar com PAPI os mesmos três eventos obtidos no item 1.i. e reportar os resultados obtidos em cada processador, identificando corretamente tal processador. Compile este novo programa e execute-o também com 8 processadores em um nó do Santos Dumont. Apresente o resultado da execução, o novo código fonte, e o script utilizado.

> Note que, neste programa `mpi.c`, cada rank MPI executa, na rotina `do_flops()`, uma quantidade de trabalho proporcional a “rank+1”.
