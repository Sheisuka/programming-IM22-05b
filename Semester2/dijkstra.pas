program dijkstra;
type
    2d_int_array_type = array of array of integer;
    1d_int_array_type = array of integer;
var
    adj_matr: 2d_int_array_type;
    weights: 1d_int_array_type;

    function read_adjacency_matrix: 2d_int_array_type;
    var
        file_path, f_string: string;
        f: TextFile;
        splitted_string: TStringArray;
        matrix: 2d_int_array_type;
        ind: integer;
    begin
        writeln('Введите путь к файлу');
        readln(file_path);
        assign(f, file_path);
        reset(f);
        while not EOF(f) do
        begin
            readln(f, f_string);
            splitted_string := f_string.Split(', ')
            setLength(matrix, length(splitted_string), length(splitted_string));
            for var i := 0 to High(splitted_string) do
                matrix[ind, i] := splitted_string[i];
            ind := ind + 1;
        end;
        close(f);
    end;
begin
    
end.