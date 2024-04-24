C=============================================================================C
! This program convert the fort.8 of OCCAM into GROMACS trajectory file.      !
! To converter the fort.8 need to add additional information. see the example !
! at the bottom of the file.                                                  !
!                                                                             !
! Written by: Antonio De Nicola                                               !
! Version 1.1                                                                 !
! 05.08.2011                                                                  !
!                                                                             !
! Contacts: adenicola@unisa.it                                                !
C=============================================================================C

C Change Log:
C 12/10/2011 aggiunto indice riscalato anche alla molecola A, dalla riga 126-128 


      Program xyz2gro
      implicit none
      
      integer i, j, k, l, natom, tp, ncpu, ios, istop
      integer NatomA, NatomB, NatomC, NatomD, frame, molid, ind
      integer indres1, indres2
      real*8 bx, by, bz, tstep, x, y, z        
      integer, allocatable :: Nmol(:), NmolA(:), NmolB(:), NmolC(:), 
     + NmolD(:) 
      character*5 labResA, labResB, labResC, LabresD, LabelAtom


      istop = 0 ! check on I/O Files

      open (unit = 8, file = 'fort.8', status = 'OLD',
     $     iostat = ios, access='SEQUENTIAL', form = 'FORMATTED')
      if (ios.ne.0) then
         write(6,*) '*** FATAL fort.8 input file does not exist ***'
         istop = 1
         go to 90
      endif


      open (unit = 7, file = 'trj.gro', status = 'UNKNOWN',
     $      form = 'FORMATTED')
 
      ncpu = 1 ! default value



      write(6,*) '============================='
      write(6,*) '*           xyz2gro         *'
      write(6,*) '* ver. 1.2                  *'
      write(6,*) '============================='
      write(6,*) 
      write(6,*) 
      write(6,*) 'Usage:'
      write(6,*) 'This code convert a file xyz into gro file.'
      write(6,*) 'You can convert a serial or parralel trajectory'
      write(6,*) 'of OCCAM. For the parallel output you need also'
      write(6,*) 'of file fort.15, generated by IOPC.'
      write(6,*) 'For the serial output you need of simple info'  
      write(6,*) 'of your system.'  
      write(6,*) 'Follow the informations on screen !'  
      write(6,*)      
      write(6,*)      
10    write(6,*)'[1] Serial, [2] Parallel, [3] Exit'
      read(5,*) tp

      if(tp.gt.3)then
         write(6,*) 'Your choice is not accepted, please try again'
         go to 10
      endif

      if(tp.eq.3) then
         go to 90
      endif

      if(tp.eq.2) then
         write(6,*)'Insert Nr. of CPU'
         read(5,*) ncpu
      endif

      allocate(Nmol(ncpu))
      allocate(NmolA(ncpu))
      allocate(NmolB(ncpu))
      allocate(NmolC(ncpu))
      allocate(NmolD(ncpu))

      if(tp.eq.2) then

      open (unit = 15, file = 'fort.15', status = 'OLD',
     $     iostat = ios, access='SEQUENTIAL', form = 'FORMATTED')
        if (ios.ne.0) then
          write(6,*) '*** FATAL fort.15 input file does not exist ***'
          istop = 1
          go to 90
        endif

         do i = 1, ncpu
            read(15,*) Nmol(i), NmolA(i), NmolB(i), NmolC(i), NmolD(i)
         enddo
       endif

      if(tp.eq.1) then
         write(6,*)'Insert Nmol, NmolA, NmolB, NmolC, NmolD:'
         read(5,*) Nmol(:), NmolA(:), NmolB(:), NmolC(:), NmolD(:)
      endif

      write(6,*)'Insert NatomA, NatomB, NatomC, NatomD:'
      read(5,*) NatomA, NatomB, NatomC, NatomD
      write(6,*)'Insert Lab_A, Lab_B, Lab_C, Lab_D, N_frames:'
      read(5,*) labResA, labResB, labResC, labResD, frame
      write(6,*)'     * * * PLASE WAIT * * *          '


      do k = 1, frame
       read(8,*) natom     
       read(8,*) tstep, bx, by, bz
       write(7,103) 't=', tstep
       write(7,102) natom
       molid = 0                 ! counter of molres
       ind = 0
 
       do l = 1, ncpu
          do i = 1, NmolA(l)
             molid = molid + 1
             do j = 1, NatomA
                ind = ind + 1

                if (ind.gt.99999) then                     ! serve per rimettere a 1 l'indice
                   ind = ind - 99999                       ! altrimenti il formato gro non è valido
                endif

                read(8,*) LabelAtom, x, y, z
                write(7,99) i, labResA, labelAtom, 
     $          ind, x/10, y/10, z/10
             enddo
          enddo 
      
          do i = 1, NmolB(l)
              
             do j = 1, NatomB
                ind = ind + 1

                if (ind.gt.99999) then                     ! serve per rimettere a 1 l'indice
                   ind = ind - 99999                       ! altrimenti il formato gro non è valido
                endif

                read(8,*) LabelAtom, x, y, z

                indres1 = i + NmolA(l)
                if (indres1.gt.99999) then
                   indres1 = indres1 - 99999
                endif

                write(7,99) indres1, labResB, labelAtom, !ho aggiunto nmolA
     $          ind, x/10, y/10, z/10
             enddo
          enddo 

          do i = 1, NmolC(l)
             do j = 1, NatomC
                ind = ind + 1

                if (ind.gt.99999) then                     ! serve per rimettere a 1 l'indice
                   ind = ind - 99999                       ! altrimenti il formato gro non è valido
                endif

                read(8,*) LabelAtom, x, y, z

                indres2 = i + NmolA(l) + NmolB(l)
                if (indres2.gt.99999) then
                   indres2 = indres2 - 99999
                endif

                write(7,99) indres2, labResC, labelAtom, !ho aggiunto nmolA + nmolB
     $          ind, x/10, y/10, z/10
             enddo
          enddo

          do i = 1, NmolD(l)
             do j = 1, NatomD
                ind = ind + 1

                if (ind.gt.99999) then                     ! serve per rimettere a 1 l'indice
                   ind = ind - 99999                       ! altrimenti il formato gro non è valido
                endif

                read(8,*) LabelAtom, x, y, z

                indres2 = i + NmolA(l) + NmolB(l) + NmolC(l)
                if (indres2.gt.99999) then
                   indres2 = indres2 - 99999
                endif

                write(7,99) indres2, labResD, labelAtom, !ho aggiunto nmolA + nmolB
     $          ind, x/10, y/10, z/10
             enddo
          enddo

       enddo 
       write(7,101) bx, by, bz
      enddo
      write(6,*)'        + + + END + + +              '


99    format(i5, 2a5, i5, 3f8.3, 3f8.4)   
101   format(3f10.5) 
102   format(i6) 
103   format(1a5, 1f12.4)    

90    end program
