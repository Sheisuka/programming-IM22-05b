program ChuLiEdmons;
    type 
        edge = (integer, integer);
        edges_array = array of array of edge;
        adjacency_matrix = array of array of integer;
        nodes_array = array of integer;
        cicles_array = array of nodes_array;
    var 
        matr: adjacency_matrix;
        edges: edges_array;
    
    function read_adjacency_matrix: edges_array;
    var
        file_path, matrix_string: string;
        f: TextFile;
        temp_i, cur_row_i, delimeter_count: integer;
        matr: adjacency_matrix;
        res: edges_array;
        edge: edge;

    begin
        write('Введите название файла/путь к нему - ');
        readln(file_path);
        writeln;
        assign(f, file_path);
        reset(f);
        while not Eof(f) do
        begin
            readln(f, matrix_string);
            setLength(matr, cur_row_i + 1);
            for var i := 1 to Length(matrix_string) do
                if matrix_string[i] = ',' then
                    delimeter_count += 1;
            setLength(matr[cur_row_i], delimeter_count);
            
            temp_i := 0;
            for var i := 1 to Length(matrix_string) do
                if (matrix_string[i] <> ',') then
                begin
                    matr[cur_row_i, temp_i] := StrToInt(matrix_string[i]);
                    temp_i += 1;
                end;
            
            cur_row_i += 1;
        end;
        close(f);
        
        setLength(res, length(matr));
        for var i := 0 to High(matr) do
            for var j := 0 to High(matr[i]) do
                if (matr[i, j] <> 0) then
                begin
                    edge := (j, matr[i, j]);
                    setLength(res[i], length(res[i]) + 1);
                    res[i, length(res[i]) - 1] := edge;
                end;
        
        
        Result := res;

    end;

    function _condensate_edges(edges: edges_array; cicle: nodes_array): edges_array;
    var
        condensated_edges: edges_array;
        new_node, cel: integer;
        new_edge: edge;
    begin
        new_node := min(cicle);
        setLength(condensated_edges, length(edges));
        for var i := 0 to High(edges) do
            setLength(condensated_edges[i], 0);
        for var i := 0 to High(edges) do
            for var j := 0 to High(edges[i]) do 
                if ((i in cicle) and not (edges[i, j].item1 in cicle)) then
                begin
                    cel := length(condensated_edges[new_node]);
                    setLength(condensated_edges[new_node], cel + 1);
                    condensated_edges[new_node, cel] := edges[i, j]
                end
                else if (not (i in cicle) and (edges[i, j].item1 in cicle)) then
                    begin
                        cel := length(condensated_edges[i]);
                        setLength(condensated_edges[i], cel + 1);
                        new_edge := (new_node, edges[i, j].item2);
                        condensated_edges[i, cel] := new_edge;
                    end
                else if (not (i in cicle) and not (edges[i, j].item1 in cicle)) then
                begin
                    cel := length(condensated_edges[i]);
                    setLength(condensated_edges[i], cel + 1);
                    condensated_edges[i, cel] := edges[i, j];
               end;
        Result := condensated_edges;
    end; 

    function _get_pos(element: integer; arr: nodes_array): integer;
    var
        ans: integer := -1;
    begin
        for var i := 0 to High(arr) do 
            if (arr[i] = element) then
            begin
               ans := i;
               break;
            end;
        Result := ans;
    end;
    
    function slice(arr: nodes_array; from_, to_: integer): nodes_array;
    var
        ans: nodes_array;
    begin
        setLength(ans, to_ - from_ + 1);
        for var i := from_ to to_ do
            ans[i] := arr[i];
        Result := ans;
    end;

    
    function _find_cicle(edges: edges_array; root: integer; var visited: nodes_array): nodes_array;
    var 
        cicle: nodes_array;
        p: integer;
    begin
        for var i := 0 to High(edges[root]) do
            if not (edges[root, i].item1 in visited) then
                begin
                    setLength(visited, length(visited) + 1);
                    visited[length(visited) - 1] := edges[root, i].item1;
                    cicle := _find_cicle(edges, edges[root, i].item1, visited);
                end
            else 
                begin
                    p := _get_pos(edges[root, i].item1, visited);
                    if (p <> length(visited) - 1) and (length(visited) >= 2) then
                    begin
                        setLength(cicle, length(visited) - p);
                        cicle := slice(visited, p, length(visited) - 1); // От P до конца
                        Result := cicle;
                        break
                    end;
                end;
        Result := cicle;
    end;
 
    
    function DFS(edges: edges_array; root: integer; var visited: nodes_array): nodes_array;
    begin
        for var i := 0 to High(edges[root]) do
            if (_get_pos(edges[root, i].item1, visited) = -1) then
                begin
                    setLength(visited, length(visited) + 1);
                    visited[length(visited) - 1] := edges[root, i].item1;
                    DFS(edges, edges[root, i].item1, visited);
                end;
        Result := visited;
    end;
    
    function count_nodes(edges: edges_array): integer;
    var
        ans: integer;
        visited: nodes_array;
    begin
        setLength(visited, 0);
        for var i := 0 to High(edges) do 
            for var j := 0 to High(edges[i]) do
            begin
                if (not (edges[i, j].item1 in visited) and not (i in visited)) then
                begin
                    setLength(visited, length(visited) + 2);
                    visited[length(visited) - 2] := i;
                    visited[length(visited) - 1] := edges[i, j].item1;
                end
                else if (not (i in visited)) then
                begin
                    setLength(visited, length(visited) + 1);
                    visited[length(visited) - 1] := i;
                end 
                else if (not (edges[i, j].item1 in visited)) then
                begin
                    setLength(visited, length(visited) + 1);
                    visited[length(visited) - 1] := edges[i, j].item1;
                end;
            end;
        Result := length(visited);
    end;
    
    function not_contains(arr: cicles_array; node: integer): boolean;
    var
        ans := True;
    begin
        for var i := 0 to High(arr) do
            if (node in arr[i]) then
            begin
                ans := False;
                break;
            end;
        Result := ans;
    end;

    function _MST(var edges: edges_array; root: integer): integer;
    var
        min_incoming, visited, dfs_res, cicle: nodes_array;
        min_edges, new_edges, condensated_edges: edges_array;
        cicles: cicles_array;
        new_edge: edge;
        res: integer;
    begin
        //_delete_incoming_edges(matr);

        setLength(min_incoming, length(edges));
        for var i := 0 to High(edges) do
            for var j := 0 to High(edges[i]) do
                if (min_incoming[edges[i, j].item1] = 0) then
                    min_incoming[edges[i, j].item1] := edges[i, j].item2
                else
                    min_incoming[edges[i, j].item1] := min(min_incoming[edges[i, j].item1], edges[i, j].item2);

        setLength(min_edges, length(edges));
        setLength(new_edges, length(edges));
        for var i := 0 to High(min_edges) do
            setLength(min_edges[i], 0);
        for var i := 0 to High(edges) do
            for var j := 0 to High(edges[i]) do
            begin
                begin
                    new_edge := (edges[i, j].item1, edges[i, j].item2 - min_incoming[edges[i, j].item1]);
                    setLength(new_edges[i], length(new_edges[i]) + 1);
                    new_edges[i, length(new_edges[i]) - 1] := new_edge;
                end;
                if (edges[i, j].item2 = min_incoming[edges[i, j].item1]) then
                begin
                    res += edges[i, j].item2;
                    setLength(min_edges[i], length(min_edges[i]) + 1);
                    min_edges[i, length(min_edges[i]) - 1] := (edges[i, j].item1, 0);
                    min_incoming[edges[i, j].item1] := 0;
                end;
            end;

        setLength(visited, 1);
        visited[0] := root;
        dfs_res := DFS(min_edges, root, visited);
        if (length(dfs_res) = count_nodes(edges)) then
            Result := res
        else
        begin
            // Образуется цикл после консендируется и запуск по новой
            setLength(cicles, 0);
            for var i := 0 to High(edges) do
            begin
                if (not_contains(cicles, i)) then
                begin
                    setLength(visited, 1);
                    visited[0] := i;
                    cicle := _find_cicle(min_edges, i, visited);
                    if (length(cicle) >= 2) then
                    begin
                        setLength(cicles, length(cicles) + 1);
                        cicles[length(cicles) - 1] := cicle;
                    end;
                end;
            end;
            
            for var i := 0 to High(cicles) do     
                new_edges := _condensate_edges(new_edges, cicles[i]);
            res += _MST(new_edges, root);
        end;
        Result := res;
    end;

    function MST(edges: edges_array): integer;
    var
        dfs_bool: boolean;
        visited, dfs_res: nodes_array;
        root: integer;
    begin
        writeln('Введите вершину-корень');
        readln(root);
        setLength(visited, 1);
        visited[0] := root;
        dfs_res := DFS(edges, root, visited);
        dfs_bool := (length(dfs_res) = length(edges));
        if (dfs_bool) then
        begin
            Result := _MST(edges, root);
        end
        else
        begin
            writeln('Невозможно составить остовное дерево, так как не все вершины достижимы из такого корня');
            writeln('Попробуйте вершины под следующими номерами:');
            for var i := 0 to High(matr) do
            begin
                setLength(visited, 1);
                visited[0] := i;
                if (length(DFS(edges, i, visited)) = length(edges)) then
                    writeln(i);
            end;
            MST(edges);
        end;
    end;
    
begin
    edges := read_adjacency_matrix;
    writeln(edges);
    writeln(MST(edges));
end.