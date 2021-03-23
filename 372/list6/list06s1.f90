program list06s

! CAP372 - exercise 06 - serial version - 2019-09-21
! integration of pi : 4.0/(1+x*) dx, interval: 0 to steps
! module load intel_psxe/2019
! ifort -g -check all -fpe0 -warn -traceback -debug extended -qopenmp -o ilist06s list06s.f90
! ./ilist06s
! or if using gnu:
! gfortran -Og -Wall -fcheck=all -fopenmp -o list06s list06s.f90
! ./list06s

  use omp_lib
  implicit none
  
  integer, parameter :: n=2**26     ! 1
!  integer, parameter :: n=2**28    ! 2
!  integer, parameter :: n=2**30    ! 3
  double precision, parameter  :: a=0.0, b=1.0
  double precision :: pi, t1, t2, x, h, integral=0.0
  integer :: i

  call cpu_time(t1)
  integral = ( f(a) + f(b) ) / 2.0
  x = a
  h = ( b - a ) / n
  do i = 1, n -1
    x = a + h * i
    integral = integral + 4.0 / (1.0 + x * x)
  end do
  pi = integral * h
  call cpu_time(t2)
  print*, "Result:", pi, " Error:", dacos(-1.d0) - pi
  print*, "Partitions:", n, "    Elapsed time:", t2 - t1 
  
contains

  function f(x)
    implicit none
    
    double precision :: f
    double precision, intent(in) :: x
   
    f = ( 4.0 / ( 1.0 + x * x ) )
    
  end function f

end program list06s
