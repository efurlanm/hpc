# My personal notes on SDumont

Repository of some implementations of case studies, run on SDumont


## Useful links (most in Portuguese)

LNCC Santos Dumont supercomputer (SDumont)

https://sdumont.lncc.br/

SD Manual

* https://sdumont.lncc.br/support_manual.php

SDumont access tutorial with screenshots

* https://sites.usp.br/cadase/recursos-computacionais/tutoriais-sdumont/

The above tutorial is part of the Cadase project, which aims to perform numerical modeling and simulations, using HPC techniques, of applications belonging to the energy sector

* https://sites.usp.br/cadase

Using SDumont

* https://www.linea.gov.br/wp-content/uploads/lineadbfiles/apresentacao/17%20-%20Usando%20o%20santos%20dumont%20(16_9).pdf


## Thoughts

The goal is to explore the Python and Jupyter Notebook (JN) interactive development environment on the Santos Dumont (SDumont) supercomputer, not as a replacement for the F90 or C, but as a way to explore the resources available, to help those starting out, and even attract new HPC users. The intention is not to make any kind of comparison between languages, each has its application, and together they form a powerful environment. Another point to note is that existing libraries written in F90 or C are usually encapsulated by an API and become Python libraries, while maintaining processing power. In this way, all languages ​​remain important, each with its potentials, used together forming a single JN interactive environment, taking advantage of Python's ease of interface, adding clean syntax, rapid prototyping, modularization, flexibility, and together with JN, facilitating documentation, simulation, data analysis and visualization. Python can also be used in large-scale scientific applications to integrate multiple programs in a single, rapidly developing interactive environment, thereby facilitating scientific computing that is inherently experimental and exploratory. Used in this way, Python can be thought of as a "glue", used to write and manage programs and code, which connects different parts and components. For HPC you don't write or optimize libraries in pure Python for performance, think of it as a kind of Bash shell, you don't write high-performance programs using Bash shell, you use for other purposes that are complementary things. Note that this repository is a work in progress, under continuous construction, and several things are missing. I use it for my personal notes only.


## Acknowledgments

Most of the information about SDumont contained in this repository was obtained during INPE's graduate program and in the project approved by the LNCC, with resources from the government of Brazil, without which this work would not be possible.
