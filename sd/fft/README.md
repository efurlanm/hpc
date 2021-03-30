# My personal notes on FFT

Some implementations of Fast Fourier Transform, run on SDumont


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
