program graph;
    type adjacency_matrix = array of array of integer;
    var matr: adjacency_matrix;
    
    function read_adjacency_matrix: adjacency_matrix;
    var
        file_path: string;
        f: TextFile;
        
        matrix_string: string;
        temp_i, cur_row_i, delimeter_count: integer;
        
        res: adjacency_matrix;
    begin
        writeln('Введите название файла/путь к нему');
        readln(file_path);
        assign(f, file_path);
        reset(f);
        while not Eof(f) do
        begin
            readln(f, matrix_string);
            setLength(res, cur_row_i + 1);
            
            if (delimeter_count = 0) then
            begin
                for var i := 1 to Length(matrix_string) do
                begin
                    if matrix_string[i] = ',' then
                      delimeter_count += 1;
                end;
            end;
            setLength(res[cur_row_i], delimeter_count);
            
            temp_i := 0;
            for var i := 1 to Length(matrix_string) do
            begin
                if matrix_string[i] <> ',' then
                begin
                    res[cur_row_i, temp_i] := StrToInt(matrix_string[i]);
                    temp_i += 1;
                end;
            end;
            cur_row_i += 1;
        end;
        close(f);
    end;
    
    procedure print_matrix(matrix: adjacency_matrix);
    begin
        for var i := 0 to High(matrix) do
        begin
            for var j := 0 to High(matrix[i]) do 
            begin
                write(matrix[i, j]:2);
            end;
            writeln;
        end;
    end;
    
begin
    matr := read_adjacency_matrix();
    print_matrix(matr);
end.