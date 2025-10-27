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
            05 record_data pic x(80). *> 80 bytes per line

        working-storage section.
        01 filename pic x(9) value "input.txt".
        01 eof_flag pic x value 'n'.
            88 end_of_file value 'y'.
        01 file_status pic xx.
        01 record_data_len pic 99. *> two byte num (00-99)


        01 mass pic s9(6).
        01 temp_mass pic s9(6).
        01 divisor pic 9 value 3.
        01 subtractor pic 9 value 2.
        01 fuel pic s9(5).
        01 temp_fuel pic s9(7).
        01 total_fuel_p1 pic 9(7) value zero.
        01 total_fuel_p2 pic 9(7) value zero.

        PROCEDURE DIVISION.
        main.
           perform read_file
           display "part 1: " total_fuel_p1.
           display "part 2: " total_fuel_p2.
           stop run.

        part1.
           move mass to temp_mass.
           perform calculate_fuel
           add fuel to total_fuel_p1.
           move zero to fuel.

        part2.
           move mass to temp_mass.
           perform until temp_mass is not positive
               perform calculate_fuel
               if fuel is not positive
                   exit perform
               end-if
               add fuel to temp_fuel
               move fuel to temp_mass
           end-perform.
           add temp_fuel to total_fuel_p2.
           move zero to fuel.
           move zero to temp_fuel.

        calculate_fuel.
           divide temp_mass by divisor giving fuel
           subtract subtractor from fuel.

        read_file.
           open input input_file.
           if file_status not = '00'
                   display "failed to read " filename ": " file_status
               exit paragraph
           end-if.
           perform read_next_record.
           perform until end_of_file
               move function length(function trim(record_data)) 
                   to record_data_len 

               compute mass = function numval(
                   record_data(1:record_data_len)
               )

               perform part1 
               perform part2 

               perform read_next_record
           end-perform.
           close input_file.

        read_next_record.
           read input_file
               at end
                   set end_of_file to true
               not at end
                   continue
           end-read.
           if file_status not = '00' and file_status not = '10'
               display "failed to read record: " file_status
           end-if.
