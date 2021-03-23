# My notes about FFT

The goal here is to explore the Python and Jupyter Notebook (JN) interactive development environment on the Santos Dumont (SD) supercomputer, not as a replacement for the F90 or C, but as a way to make more resources available, to help those starting out, and even attract new HPC users.

The intention is not to make any kind of comparison between languages, each has its application, and together they form a powerful environment. Another point to note is that existing libraries written in F90 or C are usually encapsulated by an API and become Python libraries, while maintaining processing power. In this way, all languages ​​remain important, each with its potentials, used together forming a single JN interactive environment. A case study, FFT, was selected as a way to explore the JN environment on the SD. When processing power is needed, the F90 is used, taking advantage of Python's ease of interface, adding clean syntax, rapid prototyping, modularization, flexibility, and together with JN, facilitating documentation, simulation, data analysis and visualization. Python can also be used in large-scale scientific applications to integrate multiple programs in a single, rapidly developing interactive environment, thereby facilitating scientific computing that is inherently experimental and exploratory. Used in this way, Python can be thought of as a "glue" used to write and manage programs and code, which connects different parts and components. For HPC you don't write or optimize libraries in pure Python for performance, think of it as a Bash shell, you don't write high-performance programs using Bash shell, you use the Bash shell for other purposes that are complementary things. Note that this repository is a work in progress, under continuous construction, and several things are missing. I use it for my personal notes. Most of the JNs in this repository were executed in SD, and in these links are some instructions on how to use it (in Portuguese):

* https://sites.usp.br/cadase/recursos-computacionais/tutoriais-sdumont/
- https://sdumont.lncc.br/support_manual.php



## pyFFTW

pyFFTW is a pythonic wrapper around FFTW, the speedy FFT library. The ultimate aim is to present a unified interface for all the possible transforms that FFTW can perform
- https://pypi.org/project/pyFFTW/

pyFFTW settin up on C2PAP (Computational Center for Particle And Astrophysics)
- https://wiki.tum.de/display/c2pap2018/pyfftw




## FFTW

FFTW, the Fastest Fourier Transform in the West, is a comprehensive collection of fast C routines for computing the discrete Fourier Transform (DFT), wich includes an F90 interface and MPI interface
- http://www.fftw.org

My FFTW notes (the JN run on the SD)
- http://github.com/efurlanm/fft/blob/master/FFTW/




## JMFFT

FFT library, written in F90 by Jean-Marie Teuler, that emulates most of the Cray-SCILIB library
* https://efurlanm.github.io/web/2006/www.idris.fr/data/publications/JMFFT/

English translation using Google Translate
* https://efurlanm.github.io/web/2006en/www.idris.fr/data/publications/JMFFT/

JMFFT-8.2 (2007-07-04)
* https://efurlanm.github.io/web/2019/www.idris.fr/data/publications/JMFFT/

The links above were mirrored from
* https://web.archive.org/web/20061124071657/http://www.idris.fr/data/publications/JMFFT/
* https://web.archive.org/web/20190327122921/http://www.idris.fr/data/publications/JMFFT/

JMFFT is used in numerical simulation that integrates the incompressible Navier-Stokes Three-Dimensional (NS3D) equations
* http://yakari.polytechnique.fr/people/deloncle/ns3d.html

The JMFFT-8.0 is part of the package NS3D
* http://forge.ipsl.jussieu.fr/model_iw/browser/trunk/NS3D/SRC/JMFFT-8.0?rev=8

My JMFFT notes
* http://github.com/efurlanm/fft/blob/master/JMFFT/



## REFERENCES

* [Understanding the FFT Algorithm, by Jake VanderPlas](https://jakevdp.github.io/blog/2013/08/28/understanding-the-fft/). How to compute the discrete Fourier transform, with Python examples.
* [FFT code and related material, by Jörg Arndt](https://www.jjj.de/fft/). Many links and references.
* [FFT on a Beowulf - a Case Study, by Martin Siegert](http://www.sfu.ca/~siegert/fft-timings.html). Uses FFTW and MPI_Alltoall.
* [Parallel FFT Package, by Steve Plimpton](https://www.sandia.gov/~sjplimp/docs/fft/README.html). Routines to perform 2d and 3d complex-to-complex Fast Fourier Transforms on parallel computers.
* [FFT Software](http://www.fftw.org/benchmark/fft-software.html). Many links and references used in FFTW benchmarks.
* [Discrete Fourier Transform (numpy.fft)](https://numpy.org/doc/stable/reference/routines.fft.html). NumPy function to compute the discrete Fourier Transform (DFT).
