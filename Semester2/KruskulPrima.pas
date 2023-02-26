program KruskulPrima;
    type 
        adjacency_matrix = array of array of integer;
        nodes_array = array of integer;
    var 
        matr, new_matr: adjacency_matrix;

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
    
    function _get_pos(arr: nodes_array; item: integer): integer;
    var
        ans: integer := -1;
    begin
        for var i := 0 to High(arr) do
        begin
            if (arr[i] = item) then
            begin
                ans := i;
                break;
            end;
        end;
        Result := ans;
    end;
    
    function _kruskul(var matr, new_matr: adjacency_matrix; var nodes: nodes_array): adjacency_matrix;
    var 
        min_weight: integer := 999;
        min_node_to, min_node_from, node: integer;
    begin
        if (length(matr) <> length(nodes)) then
            begin
            for var node_i := 0 to High(nodes) do
            begin
                node := nodes[node_i];
                for var path_i := 0 to High(matr) do
                begin
                    if ((node_i <> path_i) and (matr[node, path_i] > 0) and (matr[node, path_i] < min_weight) and (_get_pos(nodes, path_i) = -1)) then
                    begin
                        min_node_from := node;
                        min_node_to := path_i;
                        min_weight := matr[node, path_i];
                    end;
                end;
            end;
            new_matr[min_node_from, min_node_to] := min_weight;
            new_matr[min_node_to, min_node_from] := min_weight;
            setLength(nodes, length(nodes) + 1);
            nodes[length(nodes) - 1] := min_node_to;
            Result := _kruskul(matr, new_matr, nodes);
            end
        else
            Result := new_matr;
        
    end;
    
    function _create_zero_matrix(n: integer): adjacency_matrix;
    var
        ans: adjacency_matrix;
    begin
        setLength(ans, n);
        for var i := 0 to High(ans) do
        begin
            setLength(ans[i], n);
            for var j := 0 to High(ans) do
                ans[i, j] := 0;
        end;
        Result := ans;
    end;
    
    function kruskul(matr: adjacency_matrix): adjacency_matrix;
    var 
        new_matr: adjacency_matrix;
        nodes: nodes_array;
        n: integer := length(matr);
    begin
        new_matr := _create_zero_matrix(n);
        setLength(nodes, 1);
        nodes[0] := 0;
        Result := _kruskul(matr, new_matr, nodes);
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

begin
    matr := read_adjacency_matrix;
    print_matrix(matr);
    new_matr := kruskul(matr);
    print_matrix(new_matr);
end.