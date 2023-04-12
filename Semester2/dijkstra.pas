program dijkstra;
type
    _2d_int_array_type = array of array of integer;
    _1d_int_array_type = array of integer;
var
    adj_matrix: _2d_int_array_type;
    weights: _1d_int_array_type;

    function read_adjacency_matrix: _2d_int_array_type;
    var
        file_path, f_string: string;
        f: TextFile;
        splitted_string: array of string;
        matrix: _2d_int_array_type;
        ind: integer;
    begin
        writeln('Введите путь к файлу');
        readln(file_path);
        assign(f, file_path);
        reset(f);
        while not EOF(f) do
        begin
            readln(f, f_string);
            splitted_string := f_string.Split(',');
            setLength(matrix, length(splitted_string));
            setLength(matrix[ind], length(splitted_string));
            for var i := 0 to High(splitted_string) do
                matrix[ind, i] := StrToInt(splitted_string[i]);
            ind := ind + 1;
        end;
        close(f);
        Result := matrix;
    end;
    
    function do_dijkstra(matr: _2d_int_array_type): _1d_int_array_type;
    var
        d, used, previous: array of integer;
        s, cur_min, t_value: integer;
    begin
        setLength(d, length(matr));
        setLength(used, length(matr));
        setlength(previous, length(matr));
        
        writeln('Введите номер вершины из которой хотите начать');
        readln(s);
        
        for var i := 0 to High(d) do
            d[i] := 999;
        d[s] := 0;
        while (min(used) <> 1) do
        begin
            cur_min := -1;
            for var node_i := 0 to High(used) do
                if used[node_i] <> 1 then
                begin
                    if (cur_min = -1) then
                        cur_min := node_i
                    else if (d[cur_min] > d[node_i]) then
                        cur_min := node_i;      
                end;
            
            for var neighbour_i := 0 to High(matr[cur_min]) do
                if matr[cur_min, neighbour_i] <> 0 then
                begin
                    t_value := matr[cur_min, neighbour_i] + d[cur_min];
                    if t_value < d[neighbour_i] then
                    begin
                        d[neighbour_i] := t_value;
                        previous[neighbour_i] := cur_min;
                    end;
                end;
            used[cur_min] := 1;
        end;
        Result := d;
    end;
begin
    adj_matrix := read_adjacency_matrix;
    writeln(adj_matrix);
    writeln(do_dijkstra(adj_matrix));
end.