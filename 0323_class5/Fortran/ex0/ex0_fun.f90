!********************************************************
      function ex0_fun(a)

!=== Variables ===========================================
! Input 
      integer:: a

! Local
      integer:: i
!********************************************************
        do i = 1, a
            ex0_fun = ex0_fun + i
!print*,ex0_fun
        end do

        return
        end
