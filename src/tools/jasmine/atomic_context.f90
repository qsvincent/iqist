
!!!-------------------------------------------------------------------------
!!! project : jasmine
!!! program : m_sector  module
!!!           m_sector@nullify_one_fmat
!!!           m_sector@alloc_one_fmat
!!!           m_sector@dealloc_one_fmat
!!!           m_sector@nullify_one_sector
!!!           m_sector@alloc_one_sector
!!!           m_sector@dealloc_one_sector
!!! source  : mod_control.f90
!!! type    : module
!!! authors : yilin wang (email: qhwyl2006@126.com)
!!! history : 07/09/2014 by yilin wang
!!!           08/22/2014 by yilin wang
!!! purpose : define data structure for good quantum numbers (GQNs) algorithm
!!! status  : unstable
!!! comment :
!!!-------------------------------------------------------------------------

!!!-------------------------------------------------------------------------
!!! project : jasmine
!!! program : m_basis_fullspace  module
!!!           m_spmat            module
!!!           m_glob_fullspace   module
!!!           m_glob_sectors     module
!!!           m_basis_fullspace@alloc_m_basis_fullspace
!!!           m_basis_fullspace@dealloc_m_basis_fullspace
!!!           m_spmat@alloc_m_spmat
!!!           m_spmat@dealloc_m_spmat
!!!           m_glob_fullspace@alloc_m_glob_fullspace
!!!           m_glob_fullspace@dealloc_m_glob_fullspace
!!!           m_glob_sectors@alloc_m_glob_sectors
!!!           m_glob_sectors@dealloc_m_glob_sectors
!!! source  : mod_global.f90
!!! type    : modules 
!!! authors : yilin wang (email: qhwyl2006@126.com)
!!! history : 07/09/2014 by yilin wang
!!!           08/22/2014 by yilin wang
!!! purpose : global variables
!!! status  : unstable
!!! comment :
!!!-------------------------------------------------------------------------

!!>>> data structure for good quantum numbers (GQNs) algorithm
  module m_sector
     use constants, only : dp, zero, czero
  
     implicit none
  
! the fmat between any two sectors, it is just a matrix
     type t_fmat
! the dimension
         integer :: n, m

! the items of the matrix
         real(dp), pointer :: item(:,:)
     end type t_fmat
  
! one sector
     type :: t_sector 
! the dimension of this sector
         integer :: ndim

! total number of electrons n
         integer :: nelectron 

! number of fermion operators
         integer :: nops

! the start index of this sector
         integer :: istart

! the Fock basis index of this sector
         integer, pointer :: mybasis(:)

! the Hamiltonian of this sector
         complex(dp), pointer :: myham(:,:)

! the eigenvalues
         real(dp), pointer :: myeigval(:) 

! the eigenvectors, Hamiltonian must be real
         real(dp), pointer :: myeigvec(:,:) 

! the next sector it points to when a fermion operator acts on this sector
! -1: outside of the Hilbert space, otherwise, it is the index of next sector
! next_sector(nops,0:1), 0 for annihilation and 1 for creation operators, respectively
         integer, pointer :: next_sector(:,:)

! the fmat between this sector and all other sectors
! if this sector doesn't point to some other sectors, the pointer is null
! mymfat(nops, 0:1), 0 for annihilation and 1 for creation operators, respectively
         type(t_fmat), pointer :: myfmat(:,:)
     end type t_sector
     
! status of allocating memory
     integer, private :: istat

!!========================================================================
!!>>> declare accessibility for module routines                        <<<
!!========================================================================

     public :: nullify_one_fmat
     public :: alloc_one_fmat
     public :: dealloc_one_fmat
     public :: nullify_one_sector
     public :: alloc_one_sector
     public :: dealloc_one_sector

  contains
  
!!>>> nullify_one_fmat: nullify one fmat
  subroutine nullify_one_fmat(one_fmat)
     implicit none
  
! external variables
     type(t_fmat), intent(inout) :: one_fmat
  
     nullify(one_fmat%item)
  
     return
  end subroutine nullify_one_fmat
  
!!>>> alloc_one_fmat: allocate one fmat
  subroutine alloc_one_fmat(one_fmat)
     implicit none
  
! external variables
     type(t_fmat), intent(inout) :: one_fmat
  
     allocate( one_fmat%item(one_fmat%n, one_fmat%m),  stat=istat )
  
! check status
     if ( istat /= 0 ) then
         call s_print_error('alloc_one_fmat', 'can not allocate enough memory')
     endif
! initialize it
     one_fmat%item = zero
  
     return
  end subroutine alloc_one_fmat
  
!>>> dealloc_one_fmat: deallocate one fmat
  subroutine dealloc_one_fmat(one_fmat)
     implicit none
  
! external variables
     type(t_fmat), intent(inout) :: one_fmat
  
     if ( associated(one_fmat%item) ) deallocate(one_fmat%item)
  
     return
  end subroutine dealloc_one_fmat
  
!!>>> nullify_one_sector: nullify one sector
  subroutine nullify_one_sector(one_sector)
     implicit none
  
! external variables
     type(t_sector), intent(inout) :: one_sector
  
     nullify( one_sector%mybasis )
     nullify( one_sector%myham )
     nullify( one_sector%myeigval )
     nullify( one_sector%myeigvec )
     nullify( one_sector%next_sector )
     nullify( one_sector%myfmat )
  
     return
  end subroutine nullify_one_sector
  
!>>> alloc_one_sector: allocate memory for one sector
  subroutine alloc_one_sector(one_sector)
     implicit none
  
! external variables
     type(t_sector), intent(inout) :: one_sector
  
! local variables
     integer :: i, j
  
     allocate( one_sector%mybasis(one_sector%ndim),                   stat=istat ) 
     allocate( one_sector%myham(one_sector%ndim, one_sector%ndim),    stat=istat ) 
     allocate( one_sector%myeigval(one_sector%ndim),                  stat=istat )
     allocate( one_sector%myeigvec(one_sector%ndim, one_sector%ndim), stat=istat ) 
     allocate( one_sector%next_sector(one_sector%nops,0:1),           stat=istat )
     allocate( one_sector%myfmat(one_sector%nops,0:1),                stat=istat )
  
! check status
     if ( istat /= 0 ) then
         call s_print_error('alloc_one_sector', 'can not allocate enough memory')
     endif

! initialize them
     one_sector%mybasis = 0
     one_sector%myham = czero
     one_sector%myeigval = zero
     one_sector%myeigvec = zero
     one_sector%next_sector = 0
  
! initialize myfmat one by one
     do i=1, one_sector%nops 
        do j=0, 1
            one_sector%myfmat(i,j)%n = 0
            one_sector%myfmat(i,j)%m = 0
            call nullify_one_fmat(one_sector%myfmat(i,j))
        enddo
     enddo
  
     return
  end subroutine alloc_one_sector
  
!!>>> dealloc_one_sector: deallocate memory for one sector
  subroutine dealloc_one_sector(one_sector)
     implicit none
  
! external variables
     type(t_sector), intent(inout) :: one_sector 
  
! local variables  
     integer :: i, j
  
     if (associated(one_sector%mybasis))      deallocate(one_sector%mybasis)
     if (associated(one_sector%myham))        deallocate(one_sector%myham)
     if (associated(one_sector%myeigval))     deallocate(one_sector%myeigval)
     if (associated(one_sector%myeigvec))     deallocate(one_sector%myeigvec)
     if (associated(one_sector%next_sector))  deallocate(one_sector%next_sector)
  
! deallocate myfmat one by one
     do i=1, one_sector%nops
         do j=0,1
             call dealloc_one_fmat(one_sector%myfmat(i,j))
         enddo
     enddo 
  
     return
  end subroutine dealloc_one_sector

  end module m_sector





!!>>> Fock basis of full Hilbert space
  module m_basis_fullspace
     use control, only : norbs, ncfgs
  
     implicit none
  
! dimension of subspace of total electron N
     integer, public, allocatable, save :: dim_sub_n(:)
  
! binary form of Fock basis
     integer, public, allocatable, save :: bin_basis(:,:)
  
! decimal form of Fock basis
     integer, public, allocatable, save :: dec_basis(:)
  
! index of Fock basis, given their decimal number
     integer, public, allocatable, save :: index_basis(:)

! status flag
     integer, private :: istat

!!========================================================================
!!>>> declare accessibility for module routines                        <<<
!!========================================================================

     public :: alloc_m_basis_fullspace
     public :: dealloc_m_basis_fullspace

  contains
  
!!>>> alloc_m_basis_fullspace: allocate memory for these matrices
  subroutine alloc_m_basis_fullspace()
     implicit none
  
! allocate them
     allocate( dim_sub_n(0:norbs),        stat=istat )
     allocate( bin_basis(norbs, ncfgs),   stat=istat )
     allocate( dec_basis(ncfgs),          stat=istat )
     allocate( index_basis(0:ncfgs-1),    stat=istat )
  
! check the status 
     if ( istat /= 0 ) then
         call s_print_error('alloc_m_basis_fullspace', &
                            'can not allocate enough memory')
     endif

! initialize them
     dim_sub_n = 0
     bin_basis = 0
     dec_basis = 0
     index_basis = 0
  
     return
  end subroutine alloc_m_basis_fullspace
  
!!>>> dealloc_m_basis_fullspace: deallocate memory for these matrices
  subroutine dealloc_m_basis_fullspace()
     implicit none
  
! deallocate them
     if (allocated(dim_sub_n))   deallocate(dim_sub_n)
     if (allocated(bin_basis))   deallocate(bin_basis)
     if (allocated(dec_basis))   deallocate(dec_basis) 
     if (allocated(index_basis)) deallocate(index_basis) 
  
     return
  end subroutine dealloc_m_basis_fullspace
  
  end module m_basis_fullspace

!!>>> single particle related matrices, including: 
!!>>> crystal field, spin-orbital coupling, Coulomb interaction U tensor
  module m_spmat
     use constants, only : dp, czero
     use control, only : norbs

     implicit none
  
! crystal field (CF)
     complex(dp), public, allocatable, save :: cfmat(:,:) 
  
! spin-orbital coupling (SOC)
     complex(dp), public, allocatable, save :: socmat(:,:)
  
! on-site energy (CF+SOC) of impurity
     complex(dp), public, allocatable, save :: eimpmat(:,:)
  
! Coulomb interaction U tensor
     complex(dp), public, allocatable, save :: cumat(:,:,:,:)
  
! the transformation matrix from origional basis to natural basis 
     complex(dp), public, allocatable, save :: tran_umat(:,:)
  
! the status flag
     integer, private :: istat

!!========================================================================
!!>>> declare accessibility for module routines                        <<<
!!========================================================================

     public :: alloc_m_spmat
     public :: dealloc_m_spmat

  contains
  
!!>>> alloc_m_spmat: allocate memory for these matrix
  subroutine alloc_m_spmat()
     implicit none
  
! allocate them
     allocate( cfmat(norbs, norbs),               stat=istat )
     allocate( socmat(norbs, norbs),              stat=istat )
     allocate( eimpmat(norbs, norbs),             stat=istat )
     allocate( cumat(norbs, norbs, norbs, norbs), stat=istat )
     allocate( tran_umat(norbs, norbs),           stat=istat )
  
! check the status
     if ( istat /= 0 ) then
         call s_print_error('alloc_m_spmat', 'can not allocate enough memory')
     endif

! initialize them
     cfmat    = czero
     socmat   = czero
     eimpmat  = czero
     cumat    = czero
     tran_umat= czero
  
     return
  end subroutine alloc_m_spmat
  
!!>>> dealloc_m_spmat: deallocate memory for these matrix
  subroutine dealloc_m_spmat()
     implicit none
  
! deallocate them
     if (allocated(cfmat))      deallocate(cfmat)
     if (allocated(socmat))     deallocate(socmat)
     if (allocated(eimpmat))    deallocate(eimpmat)
     if (allocated(cumat))      deallocate(cumat)
     if (allocated(tran_umat))  deallocate(tran_umat)
  
     return
  end subroutine dealloc_m_spmat
  
  end module m_spmat

!!>>> global variables for full space algorithm case
  module m_glob_fullspace
     use constants, only : dp, zero, czero
     use control, only : norbs, ncfgs
  
     implicit none
  
! atomic Hamiltonian (CF + SOC + CU)
     complex(dp), public, allocatable, save :: hmat(:,:)
  
! eigenvalues of hmat
     real(dp), public, allocatable, save :: hmat_eigval(:)
  
! eigenvectors of hmat
     real(dp), public, allocatable, save :: hmat_eigvec(:, :)
  
! fmat for annihilation fermion operators
     real(dp), public, allocatable, save :: anni_fmat(:,:,:)
  
! occupany number for atomic eigenstates
     real(dp), public, allocatable, save :: occu_mat(:,:)

! the status flag
     integer, private :: istat

!!========================================================================
!!>>> declare accessibility for module routines                        <<<
!!========================================================================
   
     public :: alloc_m_glob_fullspace 
     public :: dealloc_m_glob_fullspace 
     
  contains
  
!!>>> alloc_m_glob_fullspace: allocate memory for m_glob_fullspace module
  subroutine alloc_m_glob_fullspace()
     implicit none

     allocate( hmat(ncfgs, ncfgs),              stat=istat )
     allocate( hmat_eigval(ncfgs),              stat=istat )
     allocate( hmat_eigvec(ncfgs, ncfgs),       stat=istat )
     allocate( anni_fmat(ncfgs, ncfgs, norbs),  stat=istat )
     allocate( occu_mat(ncfgs, ncfgs),          stat=istat )
  
! check status
     if ( istat /= 0 ) then
         call s_print_error('alloc_m_glob_fullspace', 'can not allocate enough memory')
     endif

! init them
     hmat = czero
     hmat_eigval = zero
     hmat_eigvec = zero
     anni_fmat = zero
     occu_mat = zero
  
     return
  end subroutine alloc_m_glob_fullspace
  
!!>>> dealloc_m_glob_fullspace: deallocate memory for m_glob_fullspace module
  subroutine dealloc_m_glob_fullspace()
     implicit none
  
     if(allocated(hmat))        deallocate(hmat)
     if(allocated(hmat_eigval)) deallocate(hmat_eigval)
     if(allocated(hmat_eigvec)) deallocate(hmat_eigvec)
     if(allocated(anni_fmat))   deallocate(anni_fmat)
     if(allocated(occu_mat))    deallocate(occu_mat)
  
     return
  end subroutine dealloc_m_glob_fullspace
  
  end module m_glob_fullspace

!!>>> global variables for sectors algorithm case
  module m_glob_sectors
     use constants, only : dp
     use m_sector, only : t_sector, nullify_one_sector, dealloc_one_sector
  
     implicit none
  
! number of sectors
     integer, public, save :: nsectors
  
! maximum dimension of sectors
     integer, public, save :: max_dim_sect
  
! average dimension of sectors
     real(dp), public, save :: ave_dim_sect
  
! all the sectors
     type(t_sector), public, allocatable, save :: sectors(:)
  
! the status flag
     integer, private :: istat

!!========================================================================
!!>>> declare accessibility for module routines                        <<<
!!========================================================================
   
     public :: alloc_m_glob_sectors
     public :: dealloc_m_glob_sectors
     
  contains
 
!!>>> alloc_m_glob_sectors: allocate memory for sectors
  subroutine alloc_m_glob_sectors()
     implicit none
  
! local variables
! loop index
     integer :: i
  
     allocate( sectors(nsectors),   stat=istat ) 
  
! check status
     if ( istat /= 0 ) then
         call s_print_error('alloc_m_glob_sectors', &
                            'can not allocate enough memory')
     endif
 
! nullify each sector one by one
     do i=1, nsectors
         call nullify_one_sector(sectors(i))
     enddo          
  
     return
  end subroutine alloc_m_glob_sectors
  
!!>>> dealloc_m_glob_sectors: deallocate memory of sectors
  subroutine dealloc_m_glob_sectors()
     implicit none
     
     integer :: i

! deallocate memory for pointers in t_sectors
! before deallocating sectors to avoid memory leak 
     do i=1, nsectors
         call dealloc_one_sector(sectors(i)) 
     enddo 
  
     if (allocated(sectors))  deallocate(sectors) 
     
     return
  end subroutine dealloc_m_glob_sectors
  
  end module m_glob_sectors
