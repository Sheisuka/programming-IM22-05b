program ChuLiEdmons;
    type 
        edge_tuple = (integer, integer, integer);
        array_edges = array of edge_tuple;
        array_2d = array of array of integer;
        array_1d = array of integer;
    var
        root, n: integer;
        edges: array_edges;
        adjacency_matrix: array_2d;
        visited, dfs_res: array_1d;
    
    function getPos(arr: array_1d; node: integer): integer;
    var ans: integer := -1;
    begin
        for var i := 0 to High(arr) do
        begin
            if (node = arr[i]) then
                ans := i;
        end;
        Result := ans;
    end;
    
    function count_components(edges: array_edges): array_1d;
    var
        uni: array_1d;
    begin
        for var i := 0 to High(edges) do
            begin
                if (getPos(uni, edges[i][0]) = -1) then
                begin
                    setLength(uni, length(uni) + 1);
                    uni[length(uni) - 1] := edges[i][0];
                end
                else if (getPos(uni, edges[i][1]) = -1) then
                begin
                    setLength(uni, length(uni) + 1);
                    uni[length(uni) - 1] := edges[i][1];
                end;
            end;
        Result := uni;
    end;
    
    function read_adjacency_matrix: array_2d;
    var
        file_path: string;
        f: TextFile;
        
        matrix_string: string;
        temp_i, cur_row_i, delimeter_count: integer;
        
        res: array_2d;
    begin
        write('Введите название файла/путь к нему - ');
        readln(file_path);
        writeln;
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
    
    function get_adjacency_array(matr: array_2d): array_edges;
    var
        adj_array: array_edges;
        edge: edge_tuple;
        
    begin
        for var i := 0 to High(matr) do
        begin
            for var j := 0 to High(matr) do
            begin
                if ((matr[i, j] <> 0) and (i <> j)) then
                begin
                    edge := (i, j, matr[i, j]);
                    setLength(adj_array, length(adj_array) + 1);
                    adj_array[length(adj_array) - 1] := edge;
                end;
            end;
        end;
        Result := adj_array;
    end;
    
    procedure print_matrix(matrix: array_2d);
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
    
    function DFS(edges: array_edges; root: integer; var visited: array_1d): array_1d;
    var
        root_path: array_edges;
    begin
        setLength(visited, length(visited) + 1);
        visited[length(visited) - 1] := root;
        for var i := 0 to High(edges) do 
            if (edges[i][0] = root) then
            begin
                setLength(root_path, length(root_path) + 1);
                root_path[length(root_path) - 1] := edges[i];
            end;
        for var i := 0 to High(root_path) do
        begin
            if (getPos(visited, root_path[i][1]) = -1) then
            begin
                DFS(edges, root_path[i][1], visited);
            end;
        end;
        Result := visited;
    end;
    
    function array_difference(arr1, arr2: array_1d): array_1d;
    var
        diff: array_1d;
    begin
        if (length(arr1) > length(arr2)) then
        begin
            for var i := 0 to High(arr1) do
            begin
                if (getPos(arr2, arr1[i]) = -1) then
                begin
                    setLength(diff, length(diff) + 1);
                    diff[length(diff) - 1] := arr1[i];
                end;
            end;
        end
        else
        begin
            for var i := 0 to High(arr2) do
            begin
                if (getPos(arr1, arr2[i]) = -1) then
                begin
                    setLength(diff, length(diff) + 1);
                    diff[length(diff) - 1] := arr2[i];
                end;
            end;
        end;
        if (length(diff) = 0) then setLength(diff, 1);
        Result := diff;
    end;
    
    function Condensate(zeroEdges, edges: array_edges): array_edges;
    var
        all_nodes, first_comp, second_comp, visited1, visited2: array_1d;
        first_edge, second_edge, first_to, second_to, newfrom, newto: integer;
        newEdges: array_edges;
    begin
        all_nodes := count_components(zeroedges);
        first_edge := zeroEdges[1][0];
        first_comp := DFS(zeroEdges, first_edge, visited1);
        first_to := first_comp.Min;
        for var i := 0 to High(edges) do
        begin
            newfrom := edges[i][0];
            newto := edges[i][1];
            if not ((getPos(first_comp, edges[i][0]) >= 0) and (getPos(first_comp, edges[i][1]) >= 0)) then
            begin
                if (getPos(first_comp, edges[i][0]) >= 0) then newfrom := first_to;
                if (getPos(first_comp, edges[i][1]) >= 0) then newto := first_to;
                setLength(newEdges, length(newEdges) + 1);
                newEdges[length(newEdges) - 1] := (newfrom, newto, edges[i][2]);
            end;
        end;
        Result := newEdges;
    end;
    
    function MST(edges: array_edges; comp_count, root, n: integer): integer;
    var
        res: integer := 0;
        visited_dfs, minEdge: array_1d;
        zeroEdges, newEdges: array_edges;
        edge: edge_tuple;
    begin
        setLength(minEdge, comp_count);
        for var i := 0 to High(minEdge) do
            minEdge[i] := 99;
        for var i := 0 to High(edges) do
            minEdge[edges[i][1]] := min(minEdge[edges[i][1]], edges[i][2]);
        for var i := 0 to High(edges) do
        begin
            if (edges[i][1] <> root) then
                res += minEdge[edges[i][1]];
        end;
        for var i := 0 to High(edges) do begin
            if edges[i][2] = minEdge[edges[i][1]] then
            begin
                setLength(zeroEdges, length(zeroEdges) + 1);
                edge := (edges[i][0], edges[i][1], edges[i][2] - minEdge[edges[i][1]]);
                zeroEdges[length(zeroEdges) - 1] := edge;
            end;
        end;
        {for var i := 0 to High(edges) do
          begin
            edge := (edges[i][0], edges[i][1], edges[i][2] - minEdge[edges[i][1]]);
            edges[i] := edge;
            if ((edges[i][2] = minEdge[edges[i][1]]) and (edges[i][1] <> root)) then
            begin
                setLength(zeroEdges, length(zeroEdges) + 1);
                res += minEdge[edges[i][1]];
                edge := (edges[i][0], edges[i][1], edges[i][2] - minEdge[edges[i][1]]);
                edges[i] := edge;
                zeroEdges[length(zeroEdges) - 1] := edge}
        writeln(zeroEdges);
        setLength(visited, 0);
        writeln(res);
        if (length(DFS(zeroEdges, root, visited)) = comp_count) then
            Result := res
        else 
        begin
            newEdges := Condensate(zeroEdges, edges);
            res += MST(newEdges, length(count_components(newEdges)), root, n);
        end;
        Result := res;
    end;
    
    
begin
    adjacency_matrix := read_adjacency_matrix;
    n := length(adjacency_matrix);
    edges := get_adjacency_array(adjacency_matrix);
    write('Ребра графа - ');
    writeln(edges);
    writeln;
    write('Введите вершину-корень - ');
    readln(root);
    writeln;
    dfs_res := DFS(edges, root, visited);
    writeln(dfs_res);
    if (length(dfs_res) = n) then
    begin
        writeln(MST(edges, n, root, n));
    end;
    {else
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
    }
end.