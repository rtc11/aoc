        IDENTIFICATION DIVISION.
        program-id. day1.

        ENVIRONMENT DIVISION.
        input-output section.
        file-control.
            select input_file assign to filename
                organization is line sequential
                status is file_status.

        DATA DIVISION.
        file section.
        fd input_file.
        01 input_record.
            05 record_data PIC X(80). *> 80 bytes per line

        working-storage section.
        01 filename PIC X(9) value "input.txt".
        01 eof_flag PIC X value 'N'.
            88 end_of_file value 'Y'.
        01 file_status PIC XX.
        01 record_data_len PIC 99. *> two byte num (00-99)


        01 mass PIC 9(6).
        01 divisor PIC 9 value 3.
        01 subtractor PIC 9 value 2.
        01 fuel PIC 9(5).
        01 total_fuel PIC 9(7) VALUE ZERO.

        PROCEDURE DIVISION.
        main.
           PERFORM read_file
           DISPLAY "Total fuel: " total_fuel.
           STOP run.

        part1.
           DIVIDE mass BY divisor GIVING fuel 
           SUBTRACT subtractor FROM fuel 
           *> display "Mass:" mass " -> Fuel:" fuel.
           ADD fuel TO total_fuel.
           MOVE ZERO TO fuel.

        read_file.
           OPEN INPUT input_file.
           IF file_status NOT = '00'
                   display "failed to read " filename ": " file_status
               EXIT PARAGRAPH
           END-IF.
           PERFORM read_next_record.
           PERFORM UNTIL end_of_file
               MOVE FUNCTION LENGTH(FUNCTION TRIM(record_data)) 
                   TO record_data_len 

               COMPUTE mass = FUNCTION NUMVAL(
                   record_data(1:record_data_len)
               )

               PERFORM part1 

               PERFORM read_next_record
           END-PERFORM.
           CLOSE input_file.

        read_next_record.
           READ input_file
               AT END
                   SET end_of_file TO TRUE
               NOT AT END
                   CONTINUE
           END-READ.
           IF file_status NOT = '00' AND file_status NOT = '10'
               DISPLAY "failed to read record: " file_status
           END-IF.
