      SUBROUTINE DATIN
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INCLUDE 'SIZES'
C* SHIHAO'S MODIFICATION START *************************************
C* Added:
      PARAMETER(NPARTYP=37,IFNSTART=27,IPWSTART=35,IPWEND=37)
      CHARACTER NUMBRS(0:9)*1, PARTYP(NPARTYP)*5, FILES*64, DUMMY*50,
C* Removed:
C     CHARACTER NUMBRS(0:9)*1, PARTYP(25)*5, FILES*64, DUMMY*50,
C* SHIHAO'S MODIFICATION END ***************************************
     1          KEYWRD*241, TEXT*50, TXTNEW*50, ELEMNT(107)*2,
     2          GETNAM*80
      COMMON /ATHEAT/ ATHEAT
     1       /MOLKST/ NUMAT,NAT(NUMATM),NFIRST(NUMATM),NMIDLE(NUMATM),
     2                NLAST(NUMATM), NORBS, NELECS,NALPHA,NBETA,
     3                NCLOSE,NOPEN,NDUMY,FRACT
      COMMON /ATOMIC/ EISOL(107),EHEAT(107)
      COMMON /KEYWRD/ KEYWRD
C* SHIHAO'S MODIFICATION START *************************************
C* Added:
      COMMON /MOLMEC/ HTYPE(4),NHCO(4,20),NNHCO,ITYPE

C* TEMP
      COMMON /ONELEC/ USS(107),UPP(107),UDD(107)
     2       /ALPHA / ALP(107)
     3       /EXPONT/ ZS(107),ZP(107),ZD(107)
     4       /GAUSS / FN1(107),FN2(107)
     5       /BETAS / BETAS(107),BETAP(107),BETAD(107)
     6       /TWOELE/ GSS(107),GSP(107),GPP(107),GP2(107),HSP(107),
     7                GSD(107),GPD(107),GDD(107)
     8       /IDEAS / GUESS1(107,10), GUESS2(107,10), GUESS3(107,10)
      COMMON/MULTIP/ DD(107),QQ(107),AM(107),AD(107),AQ(107)
      COMMON /PDDG/  PGF1(107,10), PGF2(107,10),PGF3(107,10)
      COMMON /PWGFP/ PWGF1(10,2), PWGF2(10,2),PWGF3(10,2),
     1               PWGFIJ(10)

C* SHIHAO'S MODIFICATION END ***************************************
      DIMENSION  IJPARS(5,1000), PARSIJ(1000)
      SAVE NUMBRS, PARTYP, ELEMNT
      DATA NUMBRS/' ','1','2','3','4','5','6','7','8','9'/
      DATA PARTYP/'USS  ','UPP  ','UDD  ','ZS   ','ZP   ','ZD   ',
     1    'BETAS','BETAP','BETAD','GSS  ','GSP  ','GPP  ','GP2  ',
     2    'HSP  ','AM1  ','EXPC ','GAUSS','ALP  ','GSD  ','GPD  ',
C* SHIHAO'S MODIFICATION START *************************************
C* Added:
     3    'GDD  ','EISOL','DD   ','QQ   ','RHO0 ','RHO1 ','RHO2 ',
     4    'FN1  ','FN2  ','FN3  ',
     5    'ORB  ','PGF1 ','PGF2 ','PGF3 ','PWGF1 ','PWGF2 ','PWGF3 '/
C* Removed:
C*     3    'GDD  ','FN1  ','FN2  ','FN3  ','ORB  '/
C* SHIHAO'S MODIFICATION END ***************************************
      DATA (ELEMNT(I),I=1,107)/'H ','HE',
     1 'LI','BE','B ','C ','N ','O ','F ','NE',
     2 'NA','MG','AL','SI','P ','S ','CL','AR',
     3 'K ','CA','SC','TI','V ','CR','MN','FE','CO','NI','CU',
     4 'ZN','GA','GE','AS','SE','BR','KR',
     5 'RB','SR','Y ','ZR','NB','MO','TC','RU','RH','PD','AG',
     6 'CD','IN','SN','SB','TE','I ','XE',
     7 'CS','BA','LA','CE','PR','ND','PM','SM','EU','GD','TB','DY',
     8 'HO','ER','TM','YB','LU','HF','TA','W ','RE','OS','IR','PT',
     9 'AU','HG','TL','PB','BI','PO','AT','RN',
     1 'FR','RA','AC','TH','PA','U ','NP','PU','AM','CM','BK','CF','XX',
     2 'FM','MD','CB','++','+','--','-','TV'/
      I=INDEX(KEYWRD,'EXTERNAL=')+9
      J=INDEX(KEYWRD(I:),' ')+I-1
      FILES=GETNAM(KEYWRD(I:J))
      WRITE(6,'(//5X,'' PARAMETER TYPE      ELEMENT    PARAMETER'')')
      OPEN(14,STATUS='UNKNOWN',FILE=FILES)
      I=0
      NPARAS=0
   10 READ(14,'(A40)',ERR=90,END=90)TEXT
      NPARAS=NPARAS+1
      IF(TEXT.EQ.' ')GOTO 90
      IF(INDEX(TEXT,'END').NE.0)GOTO 90
      ILOWA = ICHAR('a')
      ILOWZ = ICHAR('z')
      ICAPA = ICHAR('A')
************************************************************************
      DO 20 I=1,50
         ILINE=ICHAR(TEXT(I:I))
         IF(ILINE.GE.ILOWA.AND.ILINE.LE.ILOWZ) THEN
            TEXT(I:I)=CHAR(ILINE+ICAPA-ILOWA)
         ENDIF
   20 CONTINUE
************************************************************************
      IF(INDEX(TEXT,'END') .NE. 0) GOTO 90
C* SHIHAO'S MODIFICATION START *************************************
C* Added:
      DO 30 J=1,NPARTYP
        IF(J.GT.IFNSTART) THEN
C* Removed:
C    DO 30 J=1,25
C        IF(J.GT.21) THEN
C* SHIHAO'S MODIFICATION END ***************************************
            IT=INDEX(TEXT,'FN')
            TXTNEW = TEXT(1:IT+2)
            IF(INDEX(TXTNEW,PARTYP(J)) .NE. 0) GOTO 40

C* SHIHAO'S MODIFICATION START *************************************
C* Added:
            IT=INDEX(TEXT,'PGF')
            TXTNEW = TEXT(1:IT+3)
            IF(INDEX(TXTNEW,PARTYP(J)) .NE. 0) GOTO 40
C* SHIHAO'S MODIFICATION END ***************************************

         ENDIF
         IF(INDEX(TEXT,PARTYP(J)) .NE. 0) GOTO 40
   30 CONTINUE
      WRITE(6,'(''  FAULTY LINE:'',A)')TXTNEW
      WRITE(6,'(''  FAULTY LINE:'',A)')TEXT
      WRITE(6,'(''   NAME NOT FOUND'')')
      STOP
   40 IPARAM=J

C* SHIHAO'S MODIFICATION START *************************************
C* Added:
      IF(IPARAM.GT.IFNSTART) THEN
C* Removed:
C      IF(IPARAM.GT.21) THEN
C* SHIHAO'S MODIFICATION END ***************************************
         I=INDEX(TEXT,'FN')
         KFN=READA(TEXT,I+3)
C* SHIHAO'S MODIFICATION START *************************************
C* Added:
         IF(I.EQ.0) THEN
           I=INDEX(TEXT,'PGF')
           KFN=READA(TEXT,I+4)
         ENDIF

C*  For Pairwise gaussian functions
         IF(I.EQ.0) THEN
           I=INDEX(TEXT,'PWGF')
           KFN=READA(TEXT,I+5)
         ENDIF      
C* SHIHAO'S MODIFICATION END ***************************************
      ELSE
         KFN=0
         I=INDEX(TEXT,PARTYP(J))
      ENDIF
      K=INDEX(TEXT(I:),' ')+1
      DUMMY=TEXT(K:)
      TEXT=DUMMY
C* SHIHAO'S MODIFICATION START *************************************
C* Added:
      IF(IPARAM.GE.IPWSTART.AND.IPARAM.LE.IPWEND) THEN
      DO 55 JI=1,107
        DO 55 JJ=JI,107
   55 IF(INDEX(TEXT,' '//TRIM(ELEMNT(JI))//'_'//TRIM(ELEMNT(JJ)))
     1   .NE. 0 . OR. INDEX(TEXT,' '//TRIM(ELEMNT(JJ))//'_'//
     1   TRIM(ELEMNT(JI))) .NE. 0) GOTO 59      
      ENDIF
C* SHIHAO'S MODIFICATION END ***************************************
      DO 50 J=1,107
   50 IF(INDEX(TEXT,' '//ELEMNT(J)) .NE. 0) GOTO 60
      WRITE(6,'('' ELEMENT NOT FOUND '')')
      WRITE(6,*)' FAULTY LINE: "'//TEXT//'"'
      STOP
   59 J=1000*JI+JJ
   60 IELMNT=J
C* SHIHAO'S MODIFICATION START *************************************
C* Removed:
C*      PARAM=READA(TEXT,INDEX(TEXT,ELEMNT(J)))
C* Added:
      IF(IPARAM.GE.IPWSTART.AND.IPARAM.LE.IPWEND) THEN
         PARAM=READA(TEXT,INDEX(TEXT,'_'))
      ELSE
         PARAM=READA(TEXT,INDEX(TEXT,ELEMNT(J)))
      ENDIF
C* SHIHAO'S MODIFICATION END ***************************************
      DO 70 I=1,LPARS
         IF(IJPARS(1,I).EQ.KFN.AND.IJPARS(2,I).EQ.IELMNT.AND.
     1IJPARS(3,I).EQ.IPARAM) GOTO 80
   70 CONTINUE
      LPARS=LPARS+1
      I=LPARS
   80 IJPARS(1,I)=KFN
      IJPARS(2,I)=IELMNT
      IJPARS(3,I)=IPARAM
      PARSIJ(I)=PARAM
      GOTO 10
   90 CONTINUE
      IF(NPARAS.EQ.0)THEN
         WRITE(6,'(//10X,A)')' EXTERNAL PARAMETERS FILE MISSING OR EMPTY
     1'
         STOP
      ENDIF
      CLOSE(14)
      DO 120 J=1,107
C* SHIHAO'S MODIFICATION START *************************************
C* Added:
         DO 110 K=1,NPARTYP
C* Removed:
C*       DO 110 K=1,25
C* SHIHAO'S MODIFICATION END ***************************************
            DO 100 I=1,LPARS
               IPARAM=IJPARS(3,I)
               KFN=IJPARS(1,I)
               IELMNT=IJPARS(2,I)
               IF(IPARAM.NE.K) GOTO 100
               IF(IELMNT.NE.J) GOTO 100
               PARAM=PARSIJ(I)
               IF(KFN.NE.0)THEN
C* SHIHAO'S MODIFICATION START *************************************
C* Added:
                 IF(IPARAM.GT.IFNSTART+4) THEN
                  WRITE(6,'(10X,A6,11X,A2,F17.6)')
     1PARTYP(IPARAM)(:4)//NUMBRS(KFN)//'  ',
     2ELEMNT(IELMNT),PARAM
                 ELSE
                  WRITE(6,'(10X,A6,11X,A2,F17.6)')
     1PARTYP(IPARAM)(:3)//NUMBRS(KFN)//'  ',
     2ELEMNT(IELMNT),PARAM
                 ENDIF
C* Removed:
C                  WRITE(6,'(10X,A6,11X,A2,F17.6)')
C     1PARTYP(IPARAM)(:3)//NUMBRS(KFN)//'  ',
C     2ELEMNT(IELMNT),PARAM
C* SHIHAO'S MODIFICATION END ***************************************
               ELSE
                  WRITE(6,'(10X,A6,11X,A2,F17.6)')
     1PARTYP(IPARAM)//NUMBRS(KFN),
     2ELEMNT(IELMNT),PARAM
               ENDIF
               CALL UPDATE(IPARAM,IELMNT,PARAM,KFN)
  100       CONTINUE
  110    CONTINUE
  120 CONTINUE
C* SHIHAO'S MODIFICATION START *************************************
C* Deal with the pairwise gaussian functions
C* Added:
      DO 150 I=1,LPARS
         IPARAM=IJPARS(3,I)
         KFN=IJPARS(1,I)
         IELMNT=IJPARS(2,I)
         IELMNT1=IELMNT/1000
         IELMNT2=MOD(IELMNT,1000)
         IF(IPARAM.LT.IPWSTART.OR.IPARAM.GT.IPWEND) GOTO 150
         PARAM=PARSIJ(I)
         WRITE(6,'(10X,A6,11X,A2,A2,F17.6)')
     1PARTYP(IPARAM)(:5)//NUMBRS(KFN)//'  ',
     2ELEMNT(IELMNT1),ELEMNT(IELMNT2),PARAM
         CALL UPDATE(IPARAM,IELMNT,PARAM,KFN)
  150 CONTINUE
C* SHIHAO'S MODIFICATION END ***************************************
      CALL MOLDAT(1)
      CALL CALPAR
      ATHEAT=0.D0
      ETH=0.D0
      DO 130 I=1,NUMAT
         NI=NAT(I)
         ATHEAT=ATHEAT+EHEAT(NI)
  130 ETH=ETH+EISOL(NI)
      ATHEAT=ATHEAT-ETH*23.061D0
      RETURN
      END
