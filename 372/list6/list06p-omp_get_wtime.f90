program list06p
! CAP372 - exercise 06 - parallel version - 2019-09-21
! integration of pi : 4.0/(1+x*) dx, interval: 0 to hs
! gfortran -Og -Wall -fcheck=all -fopenmp -o list06p list06p.f90
! gfortran -fopenmp -o list06p list06p.f90
! ./list06p
  use omp_lib
  implicit none
  integer :: n, t
  n=2**26
  t=2
  call calc(n, t)
  t=3
  call calc(n, t)
  t=4
  call calc(n, t)
  n=2**28
  t=2
  call calc(n, t)
  t=3
  call calc(n, t)
  t=4
  call calc(n, t)
  n=2**30
  t=2
  call calc(n, t)
  t=3
  call calc(n, t)
  t=4
  call calc(n, t)
contains
  subroutine calc(n, t)
    integer, intent(in) :: n, t
    double precision, parameter  :: a=0.0, b=1.0
    double precision :: pi, t1, t2, x, h, integral=0.0
    integer :: i
    t1 = omp_get_wtime()
    integral = ( ( 4.0 / ( 1.0 + a * a ) ) +  &
                 ( 4.0 / ( 1.0 + b * b ) ) ) / 2.0
    x = a
    h = ( b - a ) / n
!$omp parallel do private(x) reduction(+:integral) num_threads(t)
    do i = 1, n - 1
      x = a + h * i
      integral = integral + 4.0 / (1.0 + x * x)
    end do
!$omp end parallel do
    pi = integral * h
    t2 = omp_get_wtime()
    print*, "Partitions:", n,"    Threads:", t
    print*, "Result:", pi, "    Error:", dacos(-1.d0) - pi
    print*, "Elapsed time:", t2 - t1
    print*, ""
  end subroutine
end program list06p
