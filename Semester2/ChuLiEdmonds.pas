program chuEdmons;
    type 
        edge = (integer, integer);
        edges_array = array of array of edge;
        adjacency_matrix = array of array of integer;
        nodes_array = array of integer;
    var 
        matr: adjacency_matrix;
        edges: edges_array;
    
    function read_adjacency_matrix: edges_array;
    var
        file_path, matrix_string: string;
        f: TextFile;
        temp_i, cur_row_i, delimeter_count: integer;
        res: adjacency_matrix;
        true_res: edges_array;
        edge: edge;

    begin
        writeln('Введите название файла/путь к нему');
        readln(file_path);
        assign(f, file_path);
        reset(f);
        readln(f, matrix_string);
        setLength(res, cur_row_i + 1);
        for var i := 1 to Length(matrix_string) do
            if matrix_string[i] = ',' then
                delimeter_count += 1;
        while not Eof(f) do
        begin  
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

        setLength(true_res, length(res));
        for var i := 0 to High(res) do
        begin
            for var j := 0 to High(res) do 
                if (res[i, j] <> 0) then
                begin
                    setLength(true_res[i], length(true_res) + 1);
                    edge := (j, res[i, j]);
                    true_res[i, length(true_res[i]) - 1] := edge;
                end;
        end;
        Result := true_res;
    end;

    function _condensate_edges(edges: edges_array; cicle: nodes_array): edges_array;
    var
        condensated_edges: edges_array;
        new_node, cel: integer;
        new_edge: edge;
    begin
        new_node := min(cicle);
        setLength(condensated_edges, length(edges) - length(cicle) + 1);
        for var i := 0 to High(edges) do
            for var j := 0 to High(edges) do 
                if ((i in cicle) and not (edges[i, j].item1 in cicle)) then
                begin
                    cel := length(condensated_edges[new_node]);
                    setLength(condensated_edges[new_node], cel + 1);
                    condensated_edges[new_node, cel - 1] := edges[i, j]
                end
                else if (not (i in cicle) and (edges[i, j].item1 in cicle)) then
                    begin
                        cel := length(condensated_edges[new_node]);
                        setLength(condensated_edges[new_node], cel + 1);
                        new_edge := (new_node, edges[i, j].item2);
                        condensated_edges[i, cel - 1] := new_edge;
                    end
                else if (not (i in cicle) and not (edges[i, j].item1 in cicle)) then
                begin
                    cel := length(condensated_edges[new_node]);
                    setLength(condensated_edges[new_node], cel + 1);
                    condensated_edges[i, cel - 1] := edges[i, j];
               end;
        Result := condensated_edges;
    end; 

    function _get_pos(element: integer; arr: nodes_array): integer;
    var 
        ans: integer := -1;
        p: integer;
    begin
        for var i := 0 to High(arr) do 
            if (arr[i] = element) then
                Result := i;
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
        for var i := 0 to High(edges) do
            if not (edges[root, i].item1 in visited) then
                begin
                    setLength(visited, length(visited) + 1);
                    visited[length(visited) - 1] := i;
                    _find_cicle(edges, i, visited);
                end
            else 
                begin
                    p := _get_pos(edges[root, i].item1, visited);
                    if (p <> length(visited) - 1) and (length(visited) >= 2) then
                    begin
                        setLength(cicle, length(visited) - p);
                        cicle := slice(visited, p, length(visited) - 1); // От P до конца
                        break
                    end;
                end;
        Result := cicle;
    end;
 
    
    function DFS(edges: edges_array; root: integer; var visited: nodes_array): nodes_array;
    begin
        for var i := 0 to High(edges) do
            if (_get_pos(edges[root, i].item1, visited) = -1) then
                begin
                    setLength(visited, length(visited) + 1);
                    visited[length(visited) - 1] := i;
                    DFS(edges, i, visited);
                end;
        Result := visited;
    end;

    function _MST(var edges: edges_array; root: integer): integer;
    var
        min_incoming, visited, dfs_res, cicle: nodes_array;
        min_edges, new_edges, condensated_edges: edges_array;
        new_edge: edge;
        res: integer;
    begin
        //_delete_incoming_edges(matr);

        setLength(min_incoming, length(edges));
        for var i := 0 to High(edges) do
            for var j := 0 to High(edges[i]) do
                if (i = edges[i, j].item1) then
                    min_incoming[i] := min(min_incoming[i], edges[i, j].item2);

        setLength(min_edges, length(edges));
        setLength(new_edges, length(edges));
        for var i := 0 to High(edges) do
            for var j := 0 to High(edges) do
            begin
                if (edges[i, j].item2 <> min_incoming[j]) then
                begin
                    new_edge := (edges[i, j].item1, edges[i, j].item2 - min_incoming[j]);
                    setLength(new_edges[i], length(new_edges[i]) + 1);
                    new_edges[i, length(new_edges[i]) - 1] := new_edge;
                end
                else
                begin
                    res += edges[i, j].item2;
                    setLength(new_edges[i], length(new_edges[i]) + 1);
                    new_edges[i, length(new_edges[i]) - 1] := (edges[i, j].item1, 0);
                end;
            end;

        setLength(visited, 0);
        dfs_res := DFS(min_edges, root, visited);
        if (length(dfs_res) = length(edges)) then
            Result := res
        else
        begin
            // Образуется цикл после консендируется и запуск по новой
            for var i := 0 to High(edges) do
            begin
                setLength(visited, 0);
                cicle := _find_cicle(edges, root, visited);
                if (length(cicle) >= 3) then
                    break;
            end;

            condensated_edges := _condensate_edges(new_edges, cicle);
            res += _MST(condensated_edges, root);
        end;
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
            _MST(edges, root);
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
        Result := _MST(edges, root);
    end;
    
begin
    edges := read_adjacency_matrix;
    writeln(edges);
    MST(edges);
end.