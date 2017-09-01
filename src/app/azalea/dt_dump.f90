!!!-----------------------------------------------------------------------
!!! project : azalea
!!! program : dt_dump_grnf
!!!           dt_dump_sigf
!!!           dt_dump_hybf <<<---
!!!           dt_dump_grnd
!!!           dt_dump_sigd
!!!           dt_dump_wssd <<<---
!!!           dt_dump_grnk
!!!           dt_dump_sigk <<<---
!!!           dt_dump_v4_d
!!!           dt_dump_v4_m
!!!           dt_dump_v4_f <<<---
!!!           dt_dump_schi
!!!           dt_dump_cchi <<<---
!!! source  : dt_dump.f90
!!! type    : subroutines
!!! author  : li huang (email:lihuang.dmft@gmail.com)
!!! history : 09/16/2009 by li huang (created)
!!!           09/02/2017 by li huang (last modified)
!!! purpose : dump key observables produced by the diagrammatic framework
!!!           for dynamical mean field theory to external files.
!!! status  : unstable
!!! comment :
!!!-----------------------------------------------------------------------

!!
!! @sub dt_dump_grnf
!!
!! write out impurity green's function in matsubara frequency space
!!
  subroutine dt_dump_grnf(rmesh, grnf)
     use constants, only : dp
     use constants, only : czero
     use constants, only : mytmp

     use control, only : norbs
     use control, only : nffrq

     implicit none

! external arguments
! matsubara frequency mesh
     real(dp), intent(in)    :: rmesh(nffrq)

! impurity green's function
     complex(dp), intent(in) :: grnf(nffrq,norbs)

! local variables
! loop index
     integer :: i
     integer :: j

! open data file: dt.dmft_g.dat
     open(mytmp, file='dt.dmft_g.dat', form='formatted', status='unknown')

! write it
     do i=1,norbs
         do j=1,nffrq
             write(mytmp,'(i6,5f16.8)') i, rmesh(j), grnf(j,i), czero
         enddo ! over j={1,nffrq} loop
         write(mytmp,*) ! write empty lines
         write(mytmp,*)
     enddo ! over i={1,norbs} loop

! close data file
     close(mytmp)

     return
  end subroutine dt_dump_grnf

!!
!! @sub dt_dump_sigf
!!
!! write out impurity self-energy function in matsubara frequency space
!!
  subroutine dt_dump_sigf(rmesh, sigf)
     use constants, only : dp
     use constants, only : czero
     use constants, only : mytmp

     use control, only : norbs
     use control, only : nffrq

     implicit none

! external arguments
! matsubara frequency mesh
     real(dp), intent(in)    :: rmesh(nffrq)

! impurity self-energy function
     complex(dp), intent(in) :: sigf(nffrq,norbs)

! local variables
! loop index
     integer :: i
     integer :: j

! open data file: dt.dmft_s.dat
     open(mytmp, file='dt.dmft_s.dat', form='formatted', status='unknown')

! write it
     do i=1,norbs
         do j=1,nffrq
             write(mytmp,'(i6,5f16.8)') i, rmesh(j), sigf(j,i), czero
         enddo ! over j={1,nffrq} loop
         write(mytmp,*) ! write empty lines
         write(mytmp,*)
     enddo ! over i={1,norbs} loop

! close data file
     close(mytmp)

     return
  end subroutine dt_dump_sigf

!!
!! @sub dt_dump_hybf
!!
!! write out impurity hybridization function in matsubara frequency space
!!
  subroutine dt_dump_hybf(rmesh, hybf)
     use constants, only : dp
     use constants, only : czero
     use constants, only : mytmp

     use control, only : norbs
     use control, only : nffrq

     implicit none

! external arguments
! matsubara frequency mesh
     real(dp), intent(in)    :: rmesh(nffrq)

! impurity hybridization function
     complex(dp), intent(in) :: hybf(nffrq,norbs)

! local variables
! loop index
     integer :: i
     integer :: j

! open data file: dt.dmft_h.dat
     open(mytmp, file='dt.dmft_h.dat', form='formatted', status='unknown')

! write it
     do i=1,norbs
         do j=1,nffrq
             write(mytmp,'(i6,5f16.8)') i, rmesh(j), hybf(j,i), czero
         enddo ! over j={1,nffrq} loop
         write(mytmp,*) ! write empty lines
         write(mytmp,*)
     enddo ! over i={1,norbs} loop

! close data file
     close(mytmp)

     return
  end subroutine dt_dump_hybf

!!
!! @sub dt_dump_grnd
!!
!! write out dual green's function in matsubara frequency space
!!
  subroutine dt_dump_grnd(rmesh, grnd)
     use constants, only : dp
     use constants, only : czero
     use constants, only : mytmp

     use control, only : norbs
     use control, only : nffrq
     use control, only : nkpts

     implicit none

! external arguments
! matsubara frequency mesh
     real(dp), intent(in)    :: rmesh(nffrq)

! dual green's function
     complex(dp), intent(in) :: grnd(nffrq,norbs,nkpts)

! local variables
! loop index
     integer :: i
     integer :: j
     integer :: k

! open data file: dt.dual_g.dat
     open(mytmp, file='dt.dual_g.dat', form='formatted', status='unknown')

! write it
     do k=1,nkpts
         do j=1,norbs
             write(mytmp,'(2(a8,i6))') '# kpt:', k, 'orb:', j
             do i=1,nffrq
                 write(mytmp,'(i6,5f16.8)') j, rmesh(i), grnd(i,j,k), czero
             enddo ! over i={1,nffrq} loop
             write(mytmp,*) ! write empty lines
             write(mytmp,*)
         enddo ! over j={1,norbs} loop
     enddo ! over k={1,nkpts} loop

! close data file
     close(mytmp)

     return
  end subroutine dt_dump_grnd

!!
!! @sub dt_dump_sigd
!!
!! write out dual self-energy function in matsubara frequency space
!!
  subroutine dt_dump_sigd()
     implicit none

     return
  end subroutine dt_dump_sigd

!!
!! @sub dt_dump_grnd
!!
!! write out lattice green's function in matsubara frequency space
!!
  subroutine dt_dump_grnk()
     implicit none

     return
  end subroutine dt_dump_grnk

!!
!! @sub dt_dump_sigk
!!
!! write out lattice self-energy function in matsubara frequency space
!!
  subroutine dt_dump_sigk()
     implicit none

     return
  end subroutine dt_dump_sigk

!!
!! @sub dt_dump_v4_d
!!
!! write out vertex function (density channel) 
!!
  subroutine dt_dump_v4_d()
     implicit none

     return
  end subroutine dt_dump_v4_d

!!
!! @sub dt_dump_v4_m
!!
!! write out vertex function (magnetic channel)
!!
  subroutine dt_dump_v4_m()
     implicit none

     return
  end subroutine dt_dump_v4_m

!!
!! @sub dt_dump_v4_f
!!
!! write out vertex function (full vertex)
!!
  subroutine dt_dump_v4_f()
     implicit none

     return
  end subroutine dt_dump_v4_f

!!
!! @sub dt_dump_schi
!!
!! write out spin susceptibility
!!
  subroutine dt_dump_schi()
     implicit none

     return
  end subroutine dt_dump_schi

!!
!! @sub dt_dump_cchi
!!
!! write out charge susceptibility
!!
  subroutine dt_dump_cchi()
     implicit none

     return
  end subroutine dt_dump_cchi
