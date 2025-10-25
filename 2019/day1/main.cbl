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


        01 mass PIC S9(6).
        01 temp_mass PIC S9(6).
        01 divisor PIC 9 value 3.
        01 subtractor PIC 9 value 2.
        01 fuel PIC S9(5).
        01 temp_fuel PIC S9(7).
        01 total_fuel_p1 PIC 9(7) VALUE ZERO.
        01 total_fuel_p2 PIC 9(7) VALUE ZERO.

        PROCEDURE DIVISION.
        main.
           PERFORM read_file
           DISPLAY "Part 1: " total_fuel_p1.
           DISPLAY "Part 2: " total_fuel_p2.
           STOP run.

        part1.
           MOVE MASS TO temp_mass.
           PERFORM calculate_fuel
           ADD fuel TO total_fuel_p1.
           MOVE ZERO TO fuel.

        part2.
           MOVE MASS TO temp_mass.
           PERFORM UNTIL temp_mass IS NOT POSITIVE
               PERFORM calculate_fuel
               IF fuel IS NOT POSITIVE
                   EXIT PERFORM
               END-IF
               ADD fuel TO temp_fuel
               MOVE fuel to temp_mass
           END-PERFORM.
           ADD temp_fuel to total_fuel_p2.
           MOVE ZERO TO fuel.
           MOVE ZERO TO temp_fuel.

        calculate_fuel.
           DIVIDE temp_mass BY divisor GIVING fuel
           SUBTRACT subtractor FROM fuel.

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
               PERFORM part2 

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
