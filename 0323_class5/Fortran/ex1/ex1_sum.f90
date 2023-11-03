!******************************************************
     subroutine ex1_sum(a,b)
!    Return the summation from 1 to a 


!===Variables===========================
! Input
     real, dimension(2,5):: a
! Output
     real, dimension(2):: b
! Local
     integer:: i, j
!******************************************************
     b = 0
     do i = 1, 2
     do j = 1, 5
        b(i) = b(i) + a(i, j)
     end do
     end do

     end 


