! Transformee de Fourier en cosinus multiple

program tjmcosfftmlt

  implicit none

  integer, parameter :: m = 4

  integer, parameter :: n = 8
  real(8), dimension(0:(n+2)*m-1) :: x, xx

  integer, parameter :: ntrigs = 4*n
  real(8), dimension(0:ntrigs-1) :: trigs
  integer, parameter :: nfax = 19
  integer, dimension(0:nfax-1) :: ifax

  integer, parameter :: nwork = 2*m*n + m + m*(n+2)
  real(8), dimension(0:nwork-1) :: work

  integer :: inc, jump

  real(8) :: scale

  integer :: i, j, k
  real(8) :: rij
  real(8) :: pi

  ! On genere x
  call random_number(x)
  xx = x

  ! On calcule une fois pour toutes la factorisation
  ! et les tableaux trigonométriques
  call cosfftfax(n,ifax,trigs)

  ! Appel de jmcosfftmlt
  inc = m
  jump = 1
  call cosfftmlt(x,work,trigs,ifax,inc,jump,n,m)

  ! On affiche les resultats
  scale = sqrt( 2._8 / n )

  ! On imprime la sortie dans le fichier temp1
  open( 11, file = 'temp1', form = 'formatted', status = 'unknown' )
  do j = 0, m-1
    do i = 0, n
      write( 11, '(I4, I4, F15.8 )' ) i, j, scale*x(j+i*m)
    end do
  end do

  ! On reinitialise x
  x = xx

  ! Gestion de pi
  pi = acos( -1._8 )

  ! La valeur exacte
  open( 12, file = 'temp2', form = 'formatted', status = 'unknown' )
  do j = 0, m-1
    do i = 0, n
      if ( mod( i, 2 ) == 0 ) then
        rij = 0.5_8 * ( x(j) + x(j+n*m) )
      else
        rij = 0.5_8 * ( x(j) - x(j+n*m) )
      end if
      do k = 1, n-1
        rij = rij + x(j+k*m) * cos( ( k*i*pi ) / n )
      end do
      write( 12, '(I4, I4, F15.8 )' ) i, j, scale*rij
    end do
  end do

end program tjmcosfftmlt
