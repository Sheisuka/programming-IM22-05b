program chuEdmons;
    type 
        adjacency_matrix = array of array of integer;
        nodes_array = array of integer;
    var 
        matr: adjacency_matrix;
    
    function read_adjacency_matrix: adjacency_matrix;
    var
        file_path, matrix_string: string;
        f: TextFile;
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
            for var i := 1 to Length(matrix_string) do
                if matrix_string[i] = ',' then
                    delimeter_count += 1;
            setLength(res[cur_row_i], delimeter_count);
            
            temp_i := 0;
            for var i := 1 to Length(matrix_string) do
                if (matrix_string[i] <> ',') then
                begin
                    res[cur_row_i, temp_i] := StrToInt(matrix_string[i]);
                    temp_i += 1;
                end;
            
            cur_row_i += 1;
        end;
        close(f);
        Result := res;
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

    function _create_zero_matrix(n: integer): adjacency_matrix;
    var
        zero_matrix: adjacency_matrix;
    begin
        setLength(zero_matrix, n);
        for var i := 0 to n - 1 do
            setLength(zero_matrix[i], n);
        Result := zero_matrix;
    end;
    
    function DFS(matr: adjacency_matrix; root: integer; var visited: nodes_array): nodes_array;
    begin
        for var i := 0 to High(matr) do
            if (matr[root, i] <> 0) and not (i in visited{getPos(visited, i) = -1}) then
                begin
                    setLength(visited, length(visited) + 1);
                    visited[length(visited) - 1] := i;
                    DFS(matr, i, visited);
                end;
        Result := visited;
    end;

    function MST(matr: adjacency_matrix): adjacency_matrix;
    var
        dfs_bool: boolean;
        visited, dfs_res: nodes_array;
        root: integer;
    begin
        writeln('Введите вершину-корень');
        readln(root);
        setLength(visited, 1);
        visited[0] := root;
        dfs_res := DFS(matr, root, visited);
        dfs_bool := (length(dfs_res) = length(matr));
        if (dfs_bool) then
        begin
            delete_incoming(matr, root);
            print_matrix(matr);
            MST(matr, root);
        end
        else
        begin
            writeln('Невозможно составить остовное дерево, так как не все вершины достижимы из такого корня');
            writeln('Попробуйте вершины под следующими номерами:');
            for var i := 0 to High(matr) do
            begin
                setLength(visited, 1);
                visited[0] := i;
                if (length(DFS(matr, i, visited)) = length(matr)) then
                    writeln(i);
            end;
            MST;
        end;
        Result := _MST(root, matr);
    end;

    procedure _delete_incoming_edges(var matr: adjacency_matrix; node: integer);
    begin
        for var i := 0 to High(matr) do
            matr[i, node] := 0;
    end;

    function _MST(var matr: adjacency_matrix; root: integer): adjacency_matrix;
    var
        min_matr: adjacency_matrix;
        min_incoming, visited: nodes_array;
        min_to, min_from: integer;
    begin
        _delete_incoming_edges(matr);

        setLength(min_incoming, length(matrix));
        for var i := 0 to High(matr) do
        begin
            for var j := 0 to High(matr) do
                if (matr[j, i] <> 0) then
                    if (min_incoming[i] < matr[j, i]) then
                    begin
                        min_incoming[i] := matr[j, i];
                        min_to := i;
                        min_from := j;
                    end;
            min_matr[j, i] := min_matr;
        end;

        if (length(DFS(min_matr, root, visited)) = length(matr)) then
            Result := min_matr
        else
        begin
            // Образуется цикл после консендируется и запуск по новой
        end;
    end;

begin
    matr := read_adjacency_matrix;
    print_matrix(matr);
    MST(matr);
end.