program list06s
! CAP372 - exercise 06 - serial version - 2019-09-21
! integration of pi : 4.0/(1+x*) dx, interval: 0 to hs
! gfortran -Og -Wall -fcheck=all -fopenmp -o list06p list06p.f90
! gfortran -fopenmp -o list06s list06s.f90
! ./list06s
  use omp_lib
  implicit none
  integer :: n
  n=2**26
  call calc(n)
  n=2**28
  call calc(n)
  n=2**30
  call calc(n)
contains
  subroutine calc(n)
    integer, intent(in) :: n
    double precision, parameter  :: a=0.0, b=1.0
    double precision :: pi, t1, t2, x, h, integral=0.0
    integer :: i
    t1 = omp_get_wtime()
    integral = ( ( 4.0 / ( 1.0 + a * a ) ) +  &
                 ( 4.0 / ( 1.0 + b * b ) ) ) / 2.0
    x = a
    h = ( b - a ) / n
    do i = 1, n - 1
      x = a + h * i
      integral = integral + 4.0 / (1.0 + x * x)
    end do
    pi = integral * h
    t2 = omp_get_wtime()
    print*, "Partitions:", n
    print*, "Result:", pi, "    Error:", dacos(-1.d0) - pi
    print*, "Elapsed time:", t2 - t1
    print*, ""
  end subroutine
end program list06s
