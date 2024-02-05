program list06p

! CAP372 - exercise 06 - parallel version - 2019-09-21
! integration of pi : 4.0/(1+x*) dx, interval: 0 to hs
! module load intel_psxe/2019
! ifort -g -check all -fpe0 -warn -traceback -debug extended -qopenmp &
!       -o ilist06p list06p.f90
! ./ilist06s
! or if using gnu:
! gfortran -Og -Wall -fcheck=all -fopenmp -o list06p list06p.f90
! ./list06s

  use omp_lib
  implicit none
  

  integer, parameter :: n=2**26, t=2   ! 1
!  integer, parameter :: n=2**26, t=12  ! 2
!  integer, parameter :: n=2**26, t=24  ! 3
!  integer, parameter :: n=2**28, t=2   ! 4
!  integer, parameter :: n=2**28, t=12  ! 5
!  integer, parameter :: n=2**28, t=24  ! 6
!  integer, parameter :: n=2**30, t=2   ! 7
!  integer, parameter :: n=2**30, t=12  ! 8
!  integer, parameter :: n=2**30, t=24  ! 9
  double precision, parameter  :: a=0.0, b=1.0
  double precision :: pi, t1, t2, x, h, integral=0.0
  integer :: i

  call cpu_time(t1)
  integral = ( f(a) + f(b) ) / 2.0
  x = a
  h = ( b - a ) / n

  !$omp parallel do private(x) reduction(+:integral) num_threads(t)
  do i = 1, n -1
    x = a + h * i
    integral = integral + 4.0 / (1.0 + x * x)
  end do
  !$omp end parallel do
  
  pi = integral * h
  call cpu_time(t2)
  print*, "Result:", pi, " Error:", dacos(-1.d0) - pi
  print*, "Partitions:", n,"    Threads:", t, "    Elapsed time:", t2 - t1 

contains

  function f(x)
    implicit none
    
    double precision :: f
    double precision, intent(in) :: x
   
    f = ( 4.0 / ( 1.0 + x * x ) )
    
  end function f

end program list06p
