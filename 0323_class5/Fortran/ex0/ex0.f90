!********************************************************
      subroutine ex0(a,b)
!       Return the summation(b) from 1 to a

!=== Variables ==========================================
! Input 
      integer:: a

! Output
      integer:: b

! Local 
      integer:: i
!********************************************************
        b = 0
        do i = 1, a
            b = b + i
        end do

        end







