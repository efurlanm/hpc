! Real-complex Fourier transform 1D

program tjmscfft
    implicit none
    
    ! n - INTEGER type scalar. (input)
    integer, parameter :: n = 6
    ! SCFFT calculates the FFT of the real vector x (input)
    real, dimension(0:n-1) :: x, xx
    ! returns the result in the complex vector y
    complex, dimension(0:n/2) :: y
    ! to store cosines and sines
    integer, parameter :: ntable = 100+2*n
    real, dimension(0:ntable-1) :: table
    ! actually jm routines only need 2 * n
    integer, parameter :: nwork = 4+4*n
    real, dimension(nwork) :: work
    ! isign - initialize coefficient table, or apply FFT
    integer :: isign
    ! scale - each element of the vector y is multiplied
    real :: scale
    integer :: isys    ! not used
    integer :: i, j
    real :: twopi
    complex :: s

    ! prepare the input table
    call random_number( x )
    write(*,'(10e10.2)') x
    xx = x
    print*

    scale = 1.
    isys = 0

    ! 0 : initializes the array table and returns its value,
    !     only isign, n and table are checked and used
    isign = 0
    call scfft(isign, n, scale, x, y, table, work, isys)
    write(*,'(10e10.2)') table
    print*
    
    ! 1 : apply an FFT
    isign = 1
    print*, 'jmscfft ', n, isign, scale
    print*
    call scfft(isign,n,scale,x,y,table,work,isys)

    ! print the output table
    ! open(10, file='temp1', status='unknown', form='formatted')
    write(*, "(*('('spe0.2xspe0.2'j)':x))") y
    print*

    ! what to find
    ! open(11, file='temp2', status='unknown', form='formatted')
    twopi = 2 * acos(real(-1))
    ! repair the input table
    x = xx
    ! and calculate
    do i = 0, n/2
        s = 0
        do j = 0, n-1
            s = s + cmplx(cos(twopi*i*j/real(n)), &
                          isign*sin(twopi*i*j/real(n)))*x(j)
        end do
        write(*,"(*('('spe0.2xspe0.2'j) ':x))", advance='no') s*scale
    end do

end program tjmscfft
