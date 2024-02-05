program ilist05s512
! CAP372 - exercise 5 - 2019-09-15
! - Each subtask i hold one row of matrix A and one column of matrix B .
! - The result is stored in one element of C .
! - After that, every subtask i, 0≤i<n, transmits its column of matrix B
!   to the subtask with the number (i + 1) mod n .
! - When the number of processors ("p") is less than the number of
!   basic subtasks ("n"), each processor would execute several
!   inner products of matrix A rows and matrix B columns.
! - Each aggregated basic subtask ( = the calculation of one row of C)
!   determines several rows of the result matrix C.
  implicit none
  integer, parameter :: ms = 512      ! matrix size
  integer, parameter :: p = 8         ! emulate the number of processes
  integer :: mi, mj, mk               ! matrix indexes
  double precision :: t1, t2          ! time elapsed
  double precision :: temp1           ! temporary
  integer :: stripe_i, stripe_qtd, stripe_count, stripe_countA   ! stripe
  integer :: interation, subtask      ! looping

  ! C =  A * B, matrix initialization
  double precision, dimension(ms, ms) :: C = 0,       &
    A = reshape([(mi, mi=1, ms*ms)], shape(A)),       &
    B = reshape([(mi, mi=ms*ms+1, ms*ms*2)], shape(A))

  call cpu_time(t1)                   ! elapsed time calculation
  stripe_qtd = ms / p                 ! subtasks per processor
  do interation = 0, ms / stripe_qtd - 1    ! algorithm interation
    do subtask = 0, ms / stripe_qtd - 1     ! each subtask hold one matrix row
      do stripe_countA = 0, stripe_qtd - 1      ! A count for p < n
        do stripe_count = 0,  stripe_qtd - 1    ! count for p < n
          ! stripe column calculation
          stripe_i = stripe_qtd*mod(subtask+p-interation,p)+stripe_count
          ! matrix A line calculation
          mi = subtask * stripe_qtd + 1 + stripe_countA
          temp1 = 0                   ! multiplication: A line x B column 
          do mj = 1, ms               ! count A column
            mk = stripe_i + 1         ! B column index
            temp1 = temp1 + A(mi, mj) * B(mj, mk)  ! C = A x B
          end do
          C(mi, mk) = temp1           ! store C element
        end do
      end do
    end do
  end do
  call cpu_time(t2)                   ! elapsed time calculation
  write(*, "(A, I5, A, I3, A, F8.4)") 'Serial version: matrix size:', ms,  &
        ',  Emulated Processes:', p, ',  Elapsed time [s]:', t2 - t1
end program ilist05s512
