program trees;
type
    ptr =  ^Node;
    Node = record
        val: integer;
        l: ptr;
        r: ptr;
    end;

var 
    root: ptr;
    c: integer;
     

    procedure add_element(root, x: ptr);
    begin
        if (x^.val > root^.val) then
            if root^.r = nil then
                root^.r := x
            else
                add_element(root^.r, x)
        else if (x^.val < root^.val) then
            if root^.l = nil then
                root^.l := x
            else
                add_element(root^.l, x);
    end;

    function init_node: ptr;
    var
        node: ptr;
    begin
        new(node);
        writeln('¬ведите значени€ узла ');
        readln(node^.val);
        Result := node;
    end;

    function create_tree: ptr;
    var
        count: integer;
        cur_node, dummy: ptr;
    begin
        new(dummy);
        dummy^.val := -999;
        writeln('Cколько узлов будет в дереве?');
        readln(count);
        for var i := 1 to count do
        begin
            cur_node := init_node;
            add_element(dummy, cur_node);
        end;
        Result := dummy^.r;
    end;

    function get_height(tree: ptr; count: integer): integer;
    begin
        if ((tree^.r = nil) and (tree^.l = nil)) then
            Result := count
        else
            if (tree^.r <> nil) then
                Result := get_height(tree^.r, count + 1)
            else if (tree^.l <> nil) then
                Result := get_height(tree^.l, count + 1);
    end;


    procedure view_horizontally(tree: ptr; indent, a_indent: integer);
    begin
        if (tree^.l <> nil) then
            view_horizontally(tree^.l, indent + 4, a_indent);
        writeln('  ', tree^.val:(a_indent - indent));
        if (tree^.r <> nil) then
            view_horizontally(tree^.r, indent + 4, a_indent);
    end;
    
    procedure delete_tree(var tree_root: ptr);
    begin
        if (tree_root <> nil) then
        begin
            delete_tree(tree_root^.l);
            delete_tree(tree_root^.r);
            writeln('Delete ', tree_root^.val, ' ', tree_root);
            dispose(tree_root);
        end;
    end;
    
    procedure count_leafes(tree_root: ptr; var c: integer);
    begin
        if (tree_root <> nil) then
        begin
        if ((tree_root^.l = nil) and (tree_root^.r = nil)) then
            c += 1;
        count_leafes(tree_root^.l, c);
        count_leafes(tree_root^.r, c);
        end;
    end;
    
    procedure delete_element(var root: ptr; x: integer);
    begin
        if (root <> nil) then
        begin
            if (x > root^.val) then
                delete_element(root^.r, x)
            else if (x < root^.val) then
                delete_element(root^.l, x)
            else if (x = root^.val) then
            begin
                writeln(root^.val, ' ', root^.l, root^.r);
                if (root^.r = nil) then
                    root := root^.l
                else if (root^.l = nil) then
                    root := root^.r
                else
                    root := nil;
            end;
        end;
    end;
    
begin
    root := create_tree;
    writeln;
    view_horizontally(root, 0, get_height(root, 0) * 4);
    {delete_tree(root);
    writeln(root);}
    count_leafes(root, c);
    writeln(c);
    delete_element(root, 1);
    view_horizontally(root, 0, get_height(root, 0) * 4);
    writeln(root^.l);
end.