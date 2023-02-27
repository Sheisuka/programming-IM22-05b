program chuEdmons;
    type 
        adjacency_matrix = array of array of integer;
        nodes_array = array of integer;
    var 
        matr: adjacency_matrix;
        root: integer;
        visited, dfs_res: nodes_array;
        dfs_bool: boolean;
    
    function getPos(arr: nodes_array; node: integer): integer;
    var ans: integer := -1;
    begin
        for var i := 0 to High(arr) do
        begin
            if (node = arr[i]) then
                ans := i;
        end;
        Result := ans;
    end;
    
    procedure delete_incoming(var matr: adjacency_matrix; node: integer);
    begin
        for var i := 0 to High(matr) do
            matr[i, node] := 0;
    end;
    
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
    
    function DFS(matr: adjacency_matrix; root: integer; var visited: nodes_array): nodes_array;
    begin
        for var i := 0 to High(matr) do
        begin
            if (matr[root, i] <> 0) then
            begin
                if (getPos(visited, i) = -1) then
                begin
                    setLength(visited, length(visited) + 1);
                    visited[length(visited) - 1] := i;
                    DFS(matr, i, visited);
                end;
            end;
        end;
        Result := visited;
    end;
    
    function create_zero_matrix(n: integer): adjacency_matrix;
    var 
        ans: adjacency_matrix;
    begin
        setLength(ans, n);
        for var i := 0 to n - 1 do
        begin
            setLength(ans[i], n);
            for var j := 0 to n - 1 do
                ans[i, j] := 0;
        end;
        Result := ans;
    end;
    
    function get_difference(arr1, arr2: nodes_array): nodes_array;
    var
        ans: nodes_array;
    begin
        for var i := 0 to High(arr1) do
        begin
            if (getPos(arr2, arr1[i]) = -1) then
            begin
                setLength(ans, length(ans) + 1);
                ans[i] := arr1[i];
            end;
        end;
        Result := ans;
    end;
    
    function __MST__(var matr: adjacency_matrix; root: integer; var ans: integer): integer;
    var
        min_weight, min_i, min_j: integer;
        new_matr: adjacency_matrix;
    begin
        new_matr := create_zero_matrix(length(matr));;
        for var i := 0 to High(matr) do
        begin
            if (i <> root) then
            begin
                min_weight := 999;
                for var j := 0 to High(matr) do
                begin
                    if ((matr[j, i] <> 0) and (matr[j, i] < min_weight)) then 
                    begin
                        min_weight := matr[j, i];
                        min_i := i;
                        min_j := j;
                    end;
                end;
                ans += min_weight;
                new_matr[min_j, min_i] := min_weight;
                for var j := 0 to High(matr) do
                begin
                    if (matr[j, i] <> 0) then 
                    begin
                        matr[j, i] -= min_weight;  
                    end;
                end;
            end;
        end;
        print_matrix(new_matr);
        Result := ans;
    end;
    
    function MST(var matr: adjacency_matrix; root: integer): integer;
    var 
        ans := 0;
    begin
        Result := __MST__(matr, root, ans);
    end;
    
begin
    matr := read_adjacency_matrix;
    print_matrix(matr);
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
    end;
    
end.