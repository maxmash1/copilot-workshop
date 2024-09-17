       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYCHECKS.
       AUTHOR. CHARLES R. MARTIN.
       DATE-WRITTEN. 2020-APR-15.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TIMECARDS
               ASSIGN TO "TIMECARDS.DAT"
                   ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
           FD TIMECARDS.
           01 TIMECARD.
               02 EMPLOYEE-NAME.
                   03 EMP-FIRSTNAME PIC X(10).
                   03 EMP-SURNAME   PIC X(15).
               02 HOURS-WORKED PIC 99V9.
               02 PAY-RATE     PIC 99.
       WORKING-STORAGE SECTION.
      * temporary variables in computational usage.
      *    intermediate values for computing paycheck with overtime
           01 REGULAR-HOURS    PIC 9(4)V99 USAGE COMP.
           01 OVERTIME-HOURS   PIC 9(4)V99 USAGE COMP.
           01 OVERTIME-RATE    PIC 9(4)V99 USAGE COMP.
           01 REGULAR-PAY      PIC 9(4)V99 USAGE COMP.
           01 OVERTIME-PAY     PIC 9(4)V99 USAGE COMP.
      *    computed parts of the paycheck
           01 GROSS-PAY        PIC 9(4)V99 USAGE COMP.
           01 FED-TAX          PIC 9(4)V99 USAGE COMP.
           01 STATE-TAX        PIC 9(4)V99 USAGE COMP.
           01 FICA-TAX         PIC 9(4)V99 USAGE COMP.
           01 NET-PAY          PIC 9(4)V99 USAGE COMP.
      * print format of the check
           01 PAYCHECK.
               02 PRT-EMPLOYEE-NAME    PIC X(25).
               02 FILLER               PIC X.
               02 PRT-HOURS-WORKED     PIC 99.9.
               02 FILLER               PIC X.
               02 PRT-PAY-RATE         PIC 99.9.
               02 PRT-GROSS-PAY        PIC $,$$9.99.
               02 PRT-FED-TAX          PIC $,$$9.99.
               02 PRT-STATE-TAX        PIC $,$$9.99.
               02 PRT-FICA-TAX         PIC $,$$9.99.
               02 FILLER               PIC X(5).
               02 PRT-NET-PAY          PIC $*,**9.99.
      * Tax rates -- 77 level aha！
           77 Fed-tax-rate     Pic V999 Value Is .164 .
           77 State-tax-rate   Pic V999 Value Is .070 .
           77 Fica-tax-rate    Pic V999 Value Is .062 .
      * 88 Level is for conditions.
           01 END-FILE             PIC X.
               88  EOF VALUE "T".
       PROCEDURE DIVISION.
       BEGIN.
           PERFORM INITIALIZE-PROGRAM.
           PERFORM PROCESS-LINE WITH TEST BEFORE UNTIL EOF
           PERFORM CLEAN-UP.
           STOP RUN.
       INITIALIZE-PROGRAM.
           OPEN INPUT TIMECARDS.
       PROCESS-LINE.
           READ TIMECARDS INTO TIMECARD
               AT END MOVE "T" TO END-FILE.
           IF NOT EOF THEN
               PERFORM COMPUTE-GROSS-PAY
               PERFORM COMPUTE-FED-TAX
               PERFORM COMPUTE-STATE-TAX
               PERFORM COMPUTE-FICA
               PERFORM COMPUTE-NET-PAY
               PERFORM PRINT-CHECK
            END-IF.
       COMPUTE-GROSS-PAY.
           IF HOURS-WORKED > 40 THEN
               MULTIPLY PAY-RATE BY 1.5 GIVING OVERTIME-RATE
               MOVE 40 TO REGULAR-HOURS
               SUBTRACT 40 FROM HOURS-WORKED GIVING OVERTIME-HOURS
               MULTIPLY REGULAR-HOURS BY PAY-RATE GIVING REGULAR-PAY
               MULTIPLY OVERTIME-HOURS BY OVERTIME-RATE
                   GIVING OVERTIME-PAY
               ADD REGULAR-PAY TO OVERTIME-PAY GIVING GROSS-PAY
           ELSE
               MULTIPLY HOURS-WORKED BY PAY-RATE GIVING GROSS-PAY
           END-IF
           .
       COMPUTE-FED-TAX.
           MULTIPLY GROSS-PAY BY FED-TAX-RATE GIVING FED-TAX
           .
       COMPUTE-STATE-TAX.
      * Compute lets us use a more familiar syntax
           COMPUTE STATE-TAX = GROSS-PAY * STATE-TAX-RATE
           .
       COMPUTE-FICA.
           MULTIPLY GROSS-PAY BY FICA-TAX-RATE GIVING FICA-TAX
           .
       COMPUTE-NET-PAY.
           SUBTRACT FED-TAX STATE-TAX FICA-TAX FROM GROSS-PAY
               GIVING NET-PAY
           PRINT-CHECK.
               MOVE EMPLOYEE-NAME  TO PRT-EMPLOYEE-NAME
               MOVE HOURS-WORKED   TO PRT-HOURS-WORKED
               MOVE PAY-RATE       TO PRT-PAY-RATE
               MOVE GROSS-PAY      TO PRT-GROSS-PAY
               MOVE FED-TAX        TO PRT-FED-TAX
               MOVE STATE-TAX      TO PRT-STATE-TAX
               MOVE FICA-TAX       TO PRT-FICA-TAX
               MOVE NET-PAY        TO PRT-NET-PAY
               DISPLAY PAYCHECK
            CLEAN-UP.
           CLOSE TIMECARDS.
        END PROGRAM PAYCHECKS.
