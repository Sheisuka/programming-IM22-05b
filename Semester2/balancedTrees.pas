program balancedTrees;
    type
        rbNodeP = ^rbNode;
        rbNode = record
            val: integer;
            par: rbNodeP;
            l: rbNodeP;
            r: rbNodeP;
            is_red: boolean;
        end;

        avlNodeP = ^avlNode;
        avlNode = record
            val: integer;
            l: avlNodeP;
            r: avlNodeP;
            par: avlNodeP;
            diff: integer;
        end;

    var
        avlRoot: avlNodeP;
        rbRoot: rbNodeP;


    function insert_avl(node, parent, x: avlNodeP): avlNodeP;
    begin
        if (node = nil) then
        begin
            x^.par := parent;
            if (x^.val < parent^.val) then
                parent^.diff -= 1
            else
                parent^.diff += 1;
            Result := x;
        end
        else
        begin
            if (x^.val < node^.val) then
                node^.l := insert_avl(node^.l, node, x)
            else
                node^.r := insert_avl(node^.r, node, x);
            Result := node;
        end;
    end;


    procedure right_rotate(node_a, node_b: avlNodeP);
    var
        temp: avlNodeP;
    begin
        temp := node_b^.l;
        node_b^.l := node_a;
        node_a^.r := temp;
        temp := node_a^.par;
        node_a^.par := node_b;
        node_b^.par := temp;
    end;


    procedure left_rotate(node_a, node_b: avlNodeP);
    var
        temp: avlNodeP;
    begin
        temp := node_b^.r;
        node_b^.r := node_a;
        node_a^.l := temp;
        temp := node_a^.par;
        node_a^.par := node_b;
        node_b^.par := temp;
    end;


    procedure check_height(node);
    begin
        if (node^.diff = 2) then    
            left_rotate(node, node^.r)
        else if (node^.diff = -2) then
            right_rotate(node, node^.l)
        else if ((node^.diff <> 0) and (node^.par <> nil)) then
        begin
            node^.par^.diff += node^.diff;
            check_height(node^.par);
        end;
    end;


    function create_avl: avlNodeP;
    var
        root, new_node: avlNodeP;
        x: integer;
    begin
        new(root);
        writeln('Введите значения корня');
        readln(root^.val);
        writeln('Введите значение либо 0');
        readln(x);
        while (x <> 0) do
        begin
            new(new_node);
            new_node^.val := x;
            insert_avl(root, root, new_node);
            check_height(new_node^.par);
            writeln('Введите значение либо 0');
            readln(x);
        end;
        Result := root;
    end;


    procedure viewAvlTree(root: avlNodeP; indent: integer);
    begin
        if (root^.l <> nil) then
            view_horizontally(root^.l, indent + 4);
        writeln(root^.val:(indent));
        if (root^.r <> nil) then
            view_horizontally(root^.r, indent + 4);
    end;


begin
    avlRoot := create_avl;
    viewAvlTree(avlRoot, 4);
end.