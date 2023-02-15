program graph;
    type 
        adjacency_matrix = array of array of integer;
    var 
        matr: adjacency_matrix;
    
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
        Result := res;
    end;
    
    function Clone(matrix: adjacency_matrix): adjacency_matrix;
    var ans: adjacency_matrix;
    begin
        setLength(ans, length(matrix));
        for var i := 0 to High(matrix) do
            ans[i] := Copy(matrix[i]);
        Result := ans;
    end;
    
    procedure print_matrix(matrix: adjacency_matrix);
    begin
        writeln;
        for var i := 0 to High(matrix) do
        begin
            for var j := 0 to High(matrix[i]) do 
            begin
                write(matrix[i, j]:2);
            end;
            writeln;
        end;
        writeln;
    end;
    
    function graph_node_even(matrix: adjacency_matrix; n: integer): boolean;
    var temp_sum: integer;
    begin
        for var i := 0 to High(matrix) do
        begin
            temp_sum += matrix[i, n];
        end;
        Result := (temp_sum mod 2) = 0;
    end;
    
    procedure check_node_even;
    var n: integer;
    begin
        writeln('Введите номер вершины >=1');
        readln(n);
        writeln(graph_node_even(matr, n - 1));
    end;
       
    function dfs(matr: adjacency_matrix; node_i: integer; path: string): string;
    var 
        node_i_str: string;
        adj_matr: adjacency_matrix;
    begin
        adj_matr := Clone(matr);
        for var i := 0 to High(matr) do
        begin
            str(i, node_i_str);
            if ((adj_matr[i, node_i] = 1) and (path[1] <> node_i_str) and (pos(node_i_str, path) =0)) then
            begin
                adj_matr[i, node_i] := 0; // В силу неориентированности графа
                adj_matr[node_i, i] := 0;
                Result := dfs(adj_matr, i, path + node_i_str);
            end
            else if ((adj_matr[i, node_i] = 1) and (path[1] = node_i_str)) then
            begin
                adj_matr[i, node_i] := 0; // В силу неориентированности графа
                adj_matr[node_i, i] := 0;
                writeln(path + node_i_str);
                Result := path + node_i_str;
            end;
        end;
    end;
    
    procedure get_graph_cicles(matr: adjacency_matrix);
    var 
        node_stack: array of integer;
        temp_i: integer;
        node_i_str: string;
        adj_matr: adjacency_matrix;
    begin
        adj_matr := Clone(matr);
        setLength(node_stack, length(matr));
        for var i := 0 to High(node_stack) do
            node_stack[i] := i;
        temp_i := High(node_stack);
        while (length(node_stack) <> 0) do
        begin
            str(temp_i, node_i_str);
            writeln('Из вершины ', node_i_str);
            dfs(adj_matr, temp_i, node_i_str);
            temp_i -= 1;
            setLength(node_stack, temp_i);
            writeln;
        end;
    end;
    
begin
    matr := read_adjacency_matrix;
    print_matrix(matr);
    //check_node_even;
    get_graph_cicles(matr);
end.