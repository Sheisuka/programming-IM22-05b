program AVLTree;
    type
        NodeP = ^Node;
        Node = record
            val: integer;
            l: NodeP;
            r: NodeP;
            par: NodeP;
            diff: integer;
        end;
    var 
        tree: nodeP;
        action: integer;

    procedure viewTree(root: NodeP; indent: integer);
    begin
        if (root^.r <> nil) then
            viewTree(root^.r, indent + 4);
        writeln(root^.val:(indent));
        if (root^.l <> nil) then
            viewTree(root^.l, indent + 4);
    end;
    
    function get_parent(node: nodeP): nodeP;
    begin
        if (node <> nil) then
           Result := node^.par;
    end;
    
    procedure r_rotate(var node: nodeP);
    var
        l: nodeP := node^.l;
        temp: nodeP^;
    begin
        temp := node^;
        node^ := l^;
        l^ := temp;
        node^.r := l;
        node^.par := node^.par^.par;
        node^.par^.l := node;
        l^.par := node;
    end;
    
    procedure l_rotate(var node: nodeP);
    var
        r: nodeP := node^.r;
        temp: nodeP^;
    begin
        temp := node^;
        node^ := r^;
        r^ := temp;
        node^.l := r;
        node^.par := node^.par^.par;
        node^.par^.r := node;
        r^.par := node;
    end;
    
    procedure check_balance_add(var node: nodeP);
    var
        parent: nodeP;
    begin
        parent := get_parent(node);
        if (parent <> nil) then
        begin
            if (node^.val < node^.par^.val) then
                node^.par^.diff -= 1
            else
                node^.par^.diff += 1;
            node := get_parent(node);
            parent := get_parent(node);
            while (node^.par <> nil) do
            begin
                if ((abs(node^.diff) = 1) and (parent <> nil)) then
                    node^.par^.diff += node^.diff
                else if (node^.diff = 2) then
                    r_rotate(node, node^.l)
                else if (node^.diff = -2) then
                    l_rotate(node, node^.r);
                node := get_parent(node);
                parent := get_parent(node);
            end;
        end;
    end;
    
    
    procedure check_balance_delete(node: nodeP);
    var
        parent: nodeP;
    begin
        parent := get_parent(node);
        if (parent <> nil) then
        begin
            if (node^.val < node^.par^.val) then
                node^.par^.diff -= 1
            else
                node^.par^.diff += 1;
            node := get_parent(node);
            parent := get_parent(node);
            while (node <> nil) do
            begin
                if ((abs(node^.diff) = 1) and (parent <> nil)) then
                    node^.par^.diff += node^.diff
                else if (node^.diff = 2) then
                    r_rotate(node, node^.l)
                else if (node^.diff = -2) then
                    l_rotate(node, node^.r);
                node := get_parent(node);
                parent := get_parent(node);
            end;
        end;
    end;
    
    
    function delete_node(var tree: nodeP; x: integer): nodeP;
    var 
        par, temp: nodeP;
    begin
        if (tree = nil) then
            Result := tree 
        else if (tree^.val = x) then
        begin
            par := get_parent(tree);
            if ((tree^.r = nil) and (tree^.l = nil)) then
            begin
               if (par <> nil) then
                    if (par^.val > x) then
                        par^.diff -= 1
                    else
                        par^.diff += 1;
               Result := nil;
            end
            else if ((tree^.r <> nil) and (tree^.l <> nil)) then
            begin
                temp := tree^.r;
                while (temp^.r <> nil) do
                    temp := temp^.l;
                tree^.val := temp^.val;
                delete_node(tree^.r, temp^.val);
                Result := tree;
            end
            else
            begin
                if (tree^.l = nil) then
                begin
                    if (par <> nil) then
                        par^.diff -= 1;
                    Result := tree^.r;
                end
                else
                begin
                  if (par <> nil) then
                        par^.diff += 1;
                    Result := tree^.l;
                end;
            end;         
        end
        else if (tree^.val > x) then
        begin
            tree^.l := delete_node(tree^.l, x);
            Result := tree;
        end
        else
        begin
            tree^.r := delete(tree^.l, x);
            Result := tree;
        end;
    end;
    
    
    function insert_node(var tree, node, par: nodeP): nodeP;
    begin
        if (tree = nil) then
          begin
            node^.par := par;
            Result := node;
          end
        else
        begin
            if (node^.val > tree^.val) then
                tree^.r := insert_node(tree^.r, node, tree)
            else if (node^.val < tree^.val) then
                tree^.l := insert_node(tree^.l, node, tree);
            Result := tree;
        end;
    end;
    
    procedure create_tree(var root: NodeP);
    var
        new_node: NodeP;
        x: integer;
    begin
        new(root);
        writeln('Enter roots value');
        readln(root^.val);
        writeln('Enter value or 0');
        readln(x);
        while (x <> 0) do
        begin
            new(new_node);
            new_node^.val := x;
            insert_node(root, new_node, nil);
            check_balance_add(new_node);
            viewTree(root, 4);
            writeln('Enter value or 0');
            readln(x);
            writeln;
        end;
    end;
    
  


begin
    writeln('Creating tree...');
    writeln;
    create_tree(tree);
    writeln('1 - View tree, 2 - Delete node');
    while True do
    begin
        readln(action);
        if (action = 1) then
            viewTree(tree, 4)
        else if (action = 2) then
        begin
            writeln('Enter a value of a node that should be deleted');
            readln(val);
            delete_node(tree, val); 
        end;
    end;
end.