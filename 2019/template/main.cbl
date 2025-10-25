        IDENTIFICATION DIVISION.
        program-id. file-reader.

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
        01 actual_record_data_len PIC 99. *> two byte num (00-99)

        PROCEDURE DIVISION.
        main.
           perform read_file
           stop run.

        read_file.
           open input input_file.
           if file_status not = '00'
               evaluate file_status
                   when "35"
                       display "[INFO] file not found: '" filename "'"
                   when "37" display "[INFO] access denied"
                   when other
                       display "[INFO] unexpected error: " file_status
               end-evaluate
               exit paragraph
           end-if.
           perform read_next_record.
           perform until end_of_file
               move function length(function trim(record_data)) to
               actual_record_data_len 
               display record_data(1:actual_record_data_len)
               perform read_next_record
           end-perform.
           close input_file.
           if file_status not = '00'
               display "[ERROR] failed to close file: " file_status
           end-if.

        read_next_record.
           read input_file
               at end
                   set end_of_file to true
               not at end
                   continue
           end-read.
           if file_status not = '00' and file_status not = '10'
               display "[ERROR] failed to read record: " file_status
           end-if.

