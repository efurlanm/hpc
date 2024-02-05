program list05p
! CAP372 - exercise 5 - 2019-09-15 - Parallel version
! Based on "Introduction to Parallel Programming: Matrix Multiplication"
! by  Gergel V.P. :
! <http://www.lac.inpe.br/~stephan/CAP-372/matrixmult_microsoft.pdf>
! - Each subtask i hold one row of matrix A and one column of matrix B .
! - The result is stored in one element of C .
! - After that, every subtask i, 0≤i<n, transmits its column of matrix B
!   to the subtask with the number (i + 1) mod n .
! - When the number of processors ("p") is less than the number of
!   basic subtasks ("n"), each processor would execute several
!   inner products of matrix A rows and matrix B columns.
! - Each aggregated basic subtask ( = the calculation of one row of C)
!   determines several rows of the result matrix C.
! module load intel_psxe/2019
! mpiifort -g -check all -fpe0 -warn -traceback -debug extended  &
!           -o ilist05p ilist05p.f90
! mpirun -n 2 ./ilist05p
! or if using gnu: mpif90 -Og -fcheck=all list05p.f90

  use MPI
  implicit none

  integer, parameter :: ms=512                        ! matrix size ms x ms
  integer, parameter :: ps=2                          ! expected processes
  integer, parameter :: st=ms/ps                      ! # of stripes   
  double precision, dimension(ms, ms) :: A, B, C=0    ! matrix definition
  double precision, dimension(st, ms) :: AR=0         ! stripes: A Rows
  double precision, dimension(ms, st) :: BC=0         ! stripes: B Cols
  double precision, dimension(st, st) :: CS=0         ! stripes: C Stripe
  double precision, dimension(ms)     :: AT=0, BT=0   ! temporary
  integer :: stripe_i, stripe_countA, stripe_countB   ! counters
  integer :: mi, mj, mk, source, dest, i              ! indexes
  integer :: interation, subtask                      ! looping
  double precision :: t1, t2, ttot, tcal=0, tcom=0    ! time elapsed
  double precision :: temp1                           ! temporary value

  ! MPI Initialization
  integer :: my_rank, sender, p, ierr                 ! mpi variables
  integer :: tagC=0                                   ! variable tag
  integer, parameter ::  &
    tag=0,  &                         ! general use tag
    tagB=99999,  &                    ! tag for B matrix send
    tagTcom=99998,  &                 ! tag for communication time elapsed
    tagTcal=99997                     ! tag for calculation time elapsed
  integer, dimension(MPI_STATUS_SIZE) :: status       ! mpi status
  call MPI_Init(ierr)                                 ! mpi initialize
  call MPI_Comm_rank(MPI_COMM_WORLD, my_rank, ierr)   ! mpi processor's id
  call MPI_Comm_size(MPI_COMM_WORLD, p, ierr)         ! mpi # of processors
  if (p .ne. ps) then                                 ! abort if ps <> p
    if (my_rank .eq. 0) then
      print*, "Error: # of mpi processes is", p, " and the expected is", ps
    endif
    stop
  end if
  if (my_rank .eq. 0) then
    ttot = MPI_Wtime()                ! Elapsed time calculation.
    ! *** Each subtask hold one row|colomn of matrix A|B and return C ***
    ! The rank 0 has the entire matrix A|B .
    A = reshape([(mi, mi=1, ms*ms)], shape(A))
    B = reshape([(mi, mi=ms*ms+1, ms*ms*2)], shape(B))
  end if

  !########## BEGIN SEND DATA TO THE FIRST INTERATION #########################
  ! Each subtask is one processor.
  ! Row A # is the same for the same subtask #, and then it is only
  ! necessary send|recv one time.
  if (my_rank .eq. 0) then            ! Rank 0 has the entire matrix.
    t1 = MPI_Wtime()                  ! Start elapsed time calculation.
    do dest = 1, ms / st -1           ! Send to the subtask.
      do stripe_countA = 1, st        ! Send the stripe.
        mi = dest * st + stripe_countA  ! calculate stripe line
        ! Send row by row. Can be optimized to send a block.
        AT = A(mi, :)
        call MPI_Send(AT, ms, MPI_DOUBLE_PRECISION,   &
                      dest, tag, MPI_COMM_WORLD, ierr)
      end do  ! stripe_countA
    end do  ! dest
    do mi = 1, st                     ! Rank 0: copy A stripe to AR
        AR(mi, :) = A(mi, :)
    end do ! mi
  end if
  ! And then each subtask i, 0<i<n,receives. The i=0 is not necessary.
  if (my_rank .ne. 0) then            ! Rank > 0 receive the stripe.
    do stripe_countA = 1, st          ! Recv the A stripe.
      ! For sure it can be optimized, instead of receiving line by line.
      call MPI_Recv(AT, ms, MPI_DOUBLE_PRECISION, MPI_ANY_SOURCE,   &
                    MPI_ANY_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
      AR(stripe_countA, :) = AT
    end do  ! stripe_countA
    t2 = MPI_Wtime() - t1       ! Elapsed time to send initial data
    tcom = tcom + t2
  end if  ! my_rank .ne. 0

  ! In the first interaction, the subtasks should receive initial B row.
  ! In the next interations, each substask send to another.
  ! First time B row send:
  if (my_rank .eq. 0) then            ! Rank 0 has the entire matrix.
    interation = 0                    ! Interation of the algorithm.
    do subtask = 0, ms / st - 1       ! Each subtask hold one matrix row.
      do stripe_countB = 0,  st - 1   ! Count for p < n .
        ! stripe column calculation
        stripe_i = st * mod(subtask + p - interation, p) + stripe_countB
        mk = stripe_i + 1             ! Matrix B column index
        if (subtask .eq. 0) then
          BC(:, mk) = B(:, mk)        ! Rank 0 only copy
        else
          BT = B(:, mk)               ! Send to rank > 0
          dest = subtask
          call MPI_Send(BT, ms, MPI_DOUBLE_PRECISION,   &
                        dest, tag, MPI_COMM_WORLD, ierr)
        endif  ! subtask
      end do  ! stripe_countB
    end do  ! subtask
  end if  ! my_rank

  ! Recv B row that was sent
  if (my_rank .ne. 0) then
    do stripe_countB = 0,  st - 1       ! Count for p < n
      call MPI_Recv(BT, ms, MPI_DOUBLE_PRECISION, MPI_ANY_SOURCE,   &
          MPI_ANY_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
      BC(:, stripe_countB + 1) = BT
    end do  ! stripe_countB
  end if  ! my_rank

  !++++++++++ START INTERATION ALGORITHM ++++++++++++++++++++++++++++++++++++++
  do interation = 0, ms / st - 1      ! Algorithm interation.
    t1 = MPI_Wtime()                  ! Start elapsed time calculation.
    ! Every subtask receives its row|col of matrix A|B
    subtask = my_rank                 ! Each subtask hold one matrix A|B row|col
    ! >>>>>>>>>> START STRIPE <<<<<<<<<<
    do stripe_countA = 0, st - 1      ! A count for p < n
      do stripe_countB = 0,  st - 1   ! count for p < n
        ! stripe column calculation
        stripe_i = st * mod(subtask+p-interation,p) + stripe_countB
        ! matrix A line calculation
        mi = st * subtask + stripe_countA + 1
        temp1 = 0                     ! multiplication: A line x B column 
        do mj = 1, ms                 ! count A column
          mk = stripe_i + 1           ! B column index
          ! C = A x B. Can be optimized using intrinsic functions
          temp1 = temp1 + AR(stripe_countA+1, mj) * BC(mj, stripe_countB+1)
        end do
        CS(stripe_countA+1, stripe_countB+1) = temp1  ! store C element
      end do
    end do   ! >>>>>>>>>> END STRIPE <<<<<<<<<<
    ! Each rank has their partial time and must send to the rank 0
    t2 = MPI_Wtime() - t1
    if (my_rank .ne. 0) then          ! rank 0 accumulate
      call MPI_Send(t2, 1, MPI_DOUBLE_PRECISION, 0,  &
                    tagTcal, MPI_COMM_WORLD, ierr)
    else
      tcal = tcal + t2             ! rank 0 own time
      call MPI_Recv(t2, 1, MPI_DOUBLE_PRECISION, MPI_ANY_SOURCE,  &
                    tagTcal, MPI_COMM_WORLD, status, ierr)
      tcal = tcal + t2             ! other rank time
    endif  ! End calculation elapsed time calculation
    
    ! $$$$$$$$$$ send C stripe to rank 0 $$$$$$$$$$
    ! Each subtask should return the calculated C to rank 0
    t1 = MPI_Wtime()                  ! Start elapsed time calculation.
    if (my_rank .ne. 0) then          ! Rank 0 does not need to send
      tagC = interation
      do mj = 1,  st                    ! Send one stripe.
        call MPI_Send(CS(:,mj), st, MPI_DOUBLE_PRECISION, 0, tagC, &
                      MPI_COMM_WORLD, ierr)
      end do
    end if
    ! Rank 0 is responsible for completing the matrix C
    if (my_rank .eq. 0) then
      ! For sure there is a whay to optimize this part of code
      ! SEND C stripe
      do stripe_countA = 0, st - 1
        do stripe_countB = 0, st - 1
          stripe_i = st * mod(0 + p - interation, p) + stripe_countB + 1
          mi = stripe_countA + 1
          C(mi, stripe_i) = CS(stripe_countA + 1, stripe_countB + 1)
        end do
      end do  
      ! RECV C stripe
      do source = 1,  ps - 1          ! recv from ranks > 0 and store in C
        ! Receive the corresponding C
        do mj = 1,  st                ! Recv one stripe.
          call MPI_Recv(CS(:, mj), st * st, MPI_DOUBLE_PRECISION, source, &
                        MPI_ANY_TAG, MPI_COMM_WORLD, status, ierr)
        end do
        sender  = status(MPI_SOURCE)
        i       = status(MPI_TAG)
        ! For sure there is a whay to optimize this part of code
        do stripe_countA = 0, st - 1
          do stripe_countB = 0,  st - 1
            mi = st * sender + stripe_countA + 1      ! Calculate C line index
            stripe_i = st * mod(sender + p - i, p) + stripe_countB
            mk = stripe_i + 1         ! B column index
            C(mi , mk) = CS(stripe_countA + 1, stripe_countB + 1)
          end do  ! stripe_countA
        end do  ! stripe_countB
      end do  ! source
    end if  ! $$$$$$$$$$ END OF SEND C $$$$$$$$$$

    ! @@@@@@@@@@ send and recv B @@@@@@@@@@
    ! At the end of one interation, every subtask transmits its column
    ! of matrix B to the subtask with the number (i + 1) mod n .
    ! NOTE: the count index in Intel MPI implementation is a 4-byte integer,
    ! so the maximum allowed value is 2^31-1 : 2.147.483.647 .
    ! I had a lot o trouble with this...........
    if (interation .lt. (ms / st - 1)) then   ! Not need in the last interation.
      dest = mod(my_rank + 1, ps)
      do mj = 1,  st                  ! Send one stripe.
        ! tagAB ensures no confusion with matrix C
        call MPI_Send(BC(:,mj), ms, MPI_DOUBLE_PRECISION, dest,  &
                      tagB, MPI_COMM_WORLD, ierr)
      end do
      ! Each subtask recv
      do mj = 1,  st                  ! Recv one stripe.
        ! tagAB ensures no confusion with matrix C
        call MPI_Recv(BC(:,mj), ms, MPI_DOUBLE_PRECISION, MPI_ANY_SOURCE,  &
                      tagB, MPI_COMM_WORLD, status, ierr)
      end do    
    end if

    ! Each rank has their partial time and must send to the rank 0
    t2 = MPI_Wtime() - t1
    if (my_rank .ne. 0) then          ! rank 0 accumulate
      call MPI_Send(t2, 1, MPI_DOUBLE_PRECISION, 0,  &
                    tagTcom, MPI_COMM_WORLD, ierr)
    else
      tcom = tcom + t2             ! rank 0 own time
      call MPI_Recv(t2, 1, MPI_DOUBLE_PRECISION, MPI_ANY_SOURCE,  &
                    tagTcom, MPI_COMM_WORLD, status, ierr)
      tcom = tcom + t2             ! other rank time
    endif  ! End communication elapsed time calculation

  end do  ! ++++++++++ END INTERATION ++++++++++

  
  !%%%%%%%%%% SHOW THE RESULT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if (my_rank .eq. 0) then
    ttot = MPI_Wtime() - ttot         ! Elapsed time calculation.
    write(*, '(a, i5, 3x, a, i2, 3x, a, f7.4, 3x, a, f7.4, 3x, a, f7.4)')   &
      'Matrix size:', ms,  &
      'Processors:', p,  &
      'Total time:', ttot,  &
      'Comm time:', tcom, &
      'Calc time:', tcal
  end if

  call MPI_Finalize(ierr)             ! mpi finalize
end program list05p
