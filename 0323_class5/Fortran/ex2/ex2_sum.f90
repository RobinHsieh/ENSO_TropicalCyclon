!******************************************************
     subroutine ex2_sum(a,b, c, d)
!    Return the summation from 1 to a 


!===Variables===========================
! Input
     integer:: c, d
     real, dimension(c,d):: a
! Output
     real, dimension(c):: b
! Local
     integer:: i, j
!******************************************************
     b = 1
     do j = 1, d
     do i = 1, c
        b(i) = b(i) + a(i, j)
     end do
     end do

     end 


