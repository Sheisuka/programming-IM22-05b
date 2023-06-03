program RBTrees;
uses CRT;
type
    RBNode = record
        val: integer;
        l: RBNodeP;
        r: RBNodeP;
        parent: RBNodeP;
        color: integer;
    end;

const 
    RED = 4;
    BLACK = 0;
var
    TreeRoot: RBNodeP;

    procedure viewTree(root: RBNodeP; indent: integer);
    begin
        if (root^.r <> nil) then
            viewTree(root^.r, indent + 4);
        textcolor(root^.color);
        writeln(root^.r:indent);
        if (root^.l <> nil) then
            viewTree(root^.l, indent + 4);
    end;

    function GetUncle(root: RBNodeP);
    begin
        if (root^.val > root^.parent^.val) then
            Result := root^.parent^.l
        else
            Result := root^.parent^.r;
    end;

    procedure _LeftRotateInsert(var root, parent: RBNodeP);
    begin
        root^.parent := parent^.parent;
        parent^.parent := root;
        parent^.l := root^.r;
        root^.r := parent;
        parent^.l^.parent := parent;
    end;

    procedure _RightRotateInsert(var root, parent: RBNodeP);
    begin
        root^.parent := parent^.parent;
        parent^.parent := root;
        parent^.r := root^.l;
        root^.l := parent;
        parent^.r^.parent := parent;
    end;

    procedure RotateInsert(var root, parent: RBNodeP);
    begin
        if (root^.val < parent^.val) then
            _LeftRotateInsert(root, parent)
        else
            _RightRotateInsert(root, parent);
    end;

    procedure FixAfterInsert(var root: RBNodeP);
    var
        uncle, parent: RBNodeP;
    begin
        if ((root^.color = RED) and (root^.parent = RED)) then
        begin
            if (root^.parent^.parent = nil) then
                root^.parent^.color := BLACK
            else
            begin
                uncle := GetUncle();
                if (uncle^.color := RED) then
                begin
                    uncle^.color := BLACK;
                    root^.parent := BLACK;
                end
                else
                    RotateInsert(root, parent);
            end;
        end;
    end;

    procedure InitNode(var root, fict: RBNodeP; value: integer);
    begin
        new(root);
        root^.r := fict;
        root^.l := fict;
        root^.val := value;
        root^.color := RED;
    end;

    function GetFictNode(): RBNodeP;
    var
        FictNode: RBNodeP;
    begin
        new(FictNode);
        FictNode^.r := nil;
        FictNode^.l := nil;
    end;

    function Search(root: RBNodeP; val: integer): RBNodeP;
    begin
        if (root = nil) then
            Result := nil
        else 
            if (val > root^.val) then
                Result := Search(root^.r, val)
            else if (val < root^.val) then
                Result := Search(root^.l, val)
            else
                Result := root;
    end;

    function InsertNode(var root, node, parent: RBNodeP);
    begin
        if (root = nil) then
        begin
            node^.parent := parent;
            Result := node;
        end; 
        else
        begin
            if (root^.val > node^.val) then
                root^.l := InsertNode(root^.l, node, root)
            else if (root^.val < node^.val) then
                root^.r := InsertNode(root^.r, node, root);
            Result := root
        end;
    end;


    function CreateRBTree();
    const
        fictNode := GetFictNode();
    var
        RBTree, NewNode: RBNodeP;
        value: integer;
    begin
        writeln('Введите значение, либо -1, чтобы закончить');
        write('---> ');
        readln(value)
        if (value <> -1) then
        begin
            InitNode(RBTree, value);
        end;
        while (value <> 0) do
        begin
            write('---> ');
            readln(value);
            InitNode(NewNode, FictNode, value);
            InsertNode(RBTree, NewNode, RBTree);
            FixAfterInsert(NewNode);
        end;
        Result := RBTree;
    end;

begin
    TreeRoot := CreateRBTree();
end.