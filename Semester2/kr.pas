program KR;
type
    _2d_int_array_type = array of array of integer;
    _1d_int_array_type = array of integer;

    ptr = ^stackElement;
    stackElement = record
        prev: ptr;
        val: integer;
    end;

var
    adj_matrix, kirchhoff_matrix: _2d_int_array_type;
    f: TextFile;
    f_path: string;
    head, new_head, graph_head: ptr;

    procedure view_matrix(matrix: _2d_int_array_type);
    begin
        for var i := 0 to High(matrix) do
        begin
            for var j := 0 to High(matrix[i]) do
                write(matrix[i, j]:2);
            writeln;
        end;
        writeln;
    end;

    function get_random_adjacency_matrix(): _2d_int_array_type; // Задание 1 создаем матрицу
    var
        adj_matrix: _2d_int_array_type;
        n, val, matrix_size: integer;
    begin
        writeln('Введите верхнюю грань случайного числа int');
        readln(matrix_size);
        n := Random(1, matrix_size);
        setLength(adj_matrix, n);
        writeln('Размерность - ', n);
        for var i := 0 to High(adj_matrix) do
            setLength(adj_matrix[i], n);
        for var i := 0 to High(adj_matrix) do
        begin
            for var j := i to High(adj_matrix[i]) do
            begin
                val := Random(0, 9);
                adj_matrix[i, j] := val;
                adj_matrix[j, i] := val;
            end;
        end;
        Result := adj_matrix;
    end;

    procedure save_matrix(f_path: string; adj_matrix: _2d_int_array_type); // Задание 2 сохраняем матрицу
    var
        cur_string: string;
        f: TextFile;
    const delimeter = ',';
    begin
        assign(f, f_path);
        rewrite(f);
        for var i := 0 to High(adj_matrix) do
        begin
            for var j := 0 to High(adj_matrix[i]) do
                cur_string += IntToStr(adj_matrix[i, j]) + delimeter;
            writeln(f, cur_string);
            cur_string := '';
        end;
        close(f);
    end;

    function get_node_power(adj_matrix: _2d_int_array_type; node: integer): integer; //Задание 2
    var
        count: integer;
    begin
        for var i := 0 to High(adj_matrix[node]) do
            if (adj_matrix[node, i] <> 0) then
                count += 1;
        Result := count;
    end;

    function read_adjacency_matrix(f_path: string): _2d_int_array_type; // Задание 2
    var
        matrix: _2d_int_array_type;
    begin

    end;

    function get_kirchhoff_matrix(adj_matrix: _2d_int_array_type): _2d_int_array_type; // Задание 2
    var
        kirchhoff: _2d_int_array_type;
    begin
        setLength(kirchhoff, length(adj_matrix));
        for var i := 0 to High(kirchhoff) do
            setLength(kirchhoff[i], length(adj_matrix[i]));
        for var i := 0 to High(adj_matrix) do
            for var j := i to High(adj_matrix[i]) do
            begin
                if (i = j) then
                begin
                    kirchhoff[i, j] := get_node_power(adj_matrix, i);
                    kirchhoff[j, i] := get_node_power(adj_matrix, i);
                end
                else if (i <> j) then
                    if (adj_matrix[i, j]) <> 0 then
                    begin
                        kirchhoff[i, j] := -1;
                        kirchhoff[j, i] := -1;
                    end;
            end;
        Result := kirchhoff;
    end;

    procedure viewStack(head: ptr); // Задание 5
    begin
        while (head <> nil) do
        begin
            writeln('Блок с адресом ', head, ' и значением ', head^.val);
            head := head^.prev;
        end;
        writeln;
    end;

    function create_stack: ptr; // Задание 5
    var
        n: integer;
        head, prev: ptr;
    begin
        writeln('Введит колво элементов в стеке');
        readln(n);
        for var i := 1 to n do 
        begin
            new(head);
            head^.prev := prev;
            writeln('Введите значение элемента №', i);
            readln(head^.val);
            prev := head;
        end;
        Result := head;
    end;

    procedure reverse_stack(head, prev: ptr; var new_head: ptr); // Задание 5
    begin
        if (head <> nil) then
        begin
            new(new_head);
            new_head^.prev := prev;
            new_head^.val := head^.val;
            prev := new_head;
            head := head^.prev;
            reverse_stack(head, prev, new_head);
        end;
    end;

    //function add_stack
    
    function dfs(adj_matrix: _2d_int_array_type; var visited: _1d_int_array_type; root: integer): _1d_int_array_type;
    begin
        for var i := 0 to High(adj_matrix[root]) do
        begin
            if ((adj_matrix[i, root] <> 0) and not (i in visited)) then
            begin
               setLength(visited, length(visited) + 1);
               visited[length(visited) - 1] := i;
               dfs(adj_matrix, visited, i);
           end;
        end;
        Result := visited;
    end;

    function search_stack_graph(adj_matrix: _2d_int_array_type): ptr; // Задание 4
    var 
        head, prev: ptr;
        nodes: _1d_int_array_type;
    begin
        setLength(nodes, 1);
        writeln('Введите вершину с которой хотите начать');
        readln(nodes[0]);
        nodes := dfs(adj_matrix, nodes, nodes[0]);
        for var i := 0 to High(nodes) do
        begin
            new(head);
            head^.prev := prev;
            head^.val := nodes[i];
            prev := head;
        end;
        Result := head;
    end;

begin
    writeln('Задание 1');
    adj_matrix := get_random_adjacency_matrix; 
    view_matrix(adj_matrix);
    writeln('Введите путь по которому хотите сохранить матрицу');
    readln(f_path);
    save_matrix(f_path, adj_matrix); 
    
    writeln('Задание 2');
    kirchhoff_matrix := get_kirchhoff_matrix(adj_matrix); 
    view_matrix(kirchhoff_matrix); 
    
    writeln('Задание 4');
    graph_head := search_stack_graph(adj_matrix); 
    viewStack(graph_head);

    writeln('Задание 5');
    head := create_stack; 
    reverse_stack(head, nil, new_head);
    viewStack(head);
    viewStack(new_head); 
end.