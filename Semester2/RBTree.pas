program RBTrees;
uses CRT;
type
    RBNodeP = ^RBNode;
    RBNode = record
        val: integer;
        l: RBNodeP;
        r: RBNodeP;
        parent: RBNodeP;
        color: integer;
    end;

const 
    RED = 4;
    BLACK = 15;
var
    TreeRoot, newNode, fictNode: RBNodeP;
    flag, value: integer;
    
    function IsFict(node: RBNodeP): boolean;
    begin
        Result := ((node^.r = nil) and (node^.l = nil))
    end;
    
    function GetBH(root: RBNodeP; count: integer): integer;
    begin
        if (root^.color = BLACK) then   
            count += 1;
        if (root^.parent <> nil) then
            Result := GetBH(root^.parent, count)
        else
            Result := count;
    end;

    function getMax(root: RBNodeP): RBNodeP;
    begin
        if ((root^.r^.r = nil) and (root^.r^.l = nil)) then
            Result := root
        else
            Result := getMax(root^.r);
    end;

    procedure viewTree(root: RBNodeP; indent: integer);
    begin
        if (root^.r <> nil) then
            viewTree(root^.r, indent + 4);
        if ((root^.l <> nil) and (root^.r <> nil)) then
        begin
            textcolor(root^.color);
            write(root^.val:indent);
            writeln('(', GetBh(root, 0), ')');
        end;
        if (root^.l <> nil) then
            viewTree(root^.l, indent + 4);
    end;

    function GetUncle(root: RBNodeP): RBNodeP;
    begin
        if (root^.val > root^.parent^.parent^.val) then
            Result := root^.parent^.parent^.l
        else
            Result := root^.parent^.parent^.r;
    end;

    procedure _LeftRotateInsert(root: RBNodeP);
    var
        temp: RBNode;
        temp2: RBNodeP;
        l := root^.l;
    begin
        temp := l^;
        l^ := root^;
        root^ := temp;
        temp2 := root^.r;
        l^.l := temp2;
        l^.l^.parent := l;
        l^.r^.parent := l;
        root^.parent := l^.parent;
        l^.parent := root;
        root^.r := l;
        root^.l^.parent := root;
    end;

    procedure _RightRotateInsert(root: RBNodeP);
    var
        temp: RBNode;
        temp2: RBNodeP;
        r := root^.r;
    begin
        temp := r^;
        r^ := root^;
        root^ := temp;
        temp2 := root^.l;
        r^.r := temp2;
        r^.r^.parent := r;
        r^.l^.parent := r;
        root^.parent := r^.parent;
        r^.parent := root;
        root^.l := r;
        root^.r^.parent := root;
    end;

    procedure FixAfterInsert(var root: RBNodeP);
    var
        uncle, parent: RBNodeP;
    begin
        if ((root^.color = RED) and (root^.parent = nil)) then
            root^.color := BLACK
        else if ((root^.color = RED) and (root^.parent^.color = RED)) then
        begin
            if (root^.parent^.parent = nil) then
                root^.parent^.color := BLACK
            else
            begin
                uncle := GetUncle(root);
                if (uncle^.color = RED) then
                begin
                    uncle^.color := BLACK;
                    root^.parent^.color := BLACK;
                    uncle^.parent^.color := RED;
                end
                else
                begin
                    if (root^.val > root^.parent^.parent^.val) then
                    // правое поддерево
                        if (root^.val > root^.parent^.val) then
                        begin
                            _RightRotateInsert(root^.parent^.parent);
                            root^.parent^.color := BLACK;
                            uncle^.parent^.color := RED;
                        end
                        else
                        begin
                            _LeftRotateInsert(root^.parent);
                            FixAfterInsert(root);
                        end
                    // Левое поддерево
                    else
                    if (root^.val < root^.parent^.val) then
                    begin
                        _LeftRotateInsert(root^.parent^.parent);
                        root^.parent^.color := BLACK;
                        uncle^.parent^.color := RED;
                    end
                    else
                    begin
                        _RightRotateInsert(root^.parent);
                        FixAfterInsert(root);
                    end;
                end;
            end;
            if (root^.parent <> nil) then
                FixAfterInsert(root^.parent);
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
        Result := FictNode;
    end;

    function Search(root: RBNodeP; val: integer): RBNodeP;
    begin
        if ((root^.r = nil) and (root^.l = nil)) then
            Result := nil
        else 
            if (val > root^.val) then
                Result := Search(root^.r, val)
            else if (val < root^.val) then
                Result := Search(root^.l, val)
            else
                Result := root;
    end;

    function InsertNode(var root, node, parent: RBNodeP): RBNodeP;
    begin
        if (root = nil) then
            root := node
        else if ((root^.r = nil) and (root^.l = nil)) then
        begin
            if (root <> parent) then
                node^.parent := parent;
            Result := node;
        end 
        else
        begin
            if (root^.val > node^.val) then
                root^.l := InsertNode(root^.l, node, root)
            else if (root^.val < node^.val) then
                root^.r := InsertNode(root^.r, node, root);
            Result := root
        end;
    end;
    
    


    function CreateRBTree(): RBNodeP;
    var
        RBTree, NewNode: RBNodeP;
        fictNode := GetFictNode();
        value: integer;
    begin
        writeln('Создадим дерево случайно');
        while (value <> -1) do
        begin
            write('---> ');
            readln(value);
            if (value = -1) then break;
            InitNode(NewNode, FictNode, Random(0, 100));
            InsertNode(RBTree, NewNode, RBTree);
            FixAfterInsert(NewNode);
            viewTree(RBTree, 0);
        end;
        Result := RBTree;
    end;
    
    procedure ReduceBH(node: RBNodeP);
    var
        parent, bro: RBNodeP;
    begin
        if ((node^.color = BLACK) and not IsFict(node)) then
        begin
            node^.color := RED;
            FixAfterInsert(node^.l);
            FixAfterInsert(node^.r);
            FixAfterInsert(node);
        end
        else
        begin
            if not IsFict(node^.l) then
                ReduceBH(node^.l);
            if not IsFict(node^.r) then
                ReduceBH(node^.r);
        end;
    end;
    
    procedure CheckAfterDelete(node: RBNodeP);
    var
        bro, grandpa: RBNodeP;
    begin
        if (node^.val > node^.parent^.val) then
            bro := node^.parent^.l
        else
            bro := node^.parent^.r;
        ReduceBH(bro);
        grandpa := node^.parent^.parent;
        if (grandpa <> nil) then
            if (not IsFict(grandpa)) then
                if (node^.parent^.val < grandpa^.val) then
                    CheckAfterDelete(grandpa^.r)
                else
                    CheckAfterDelete(grandpa^.l);
    end;
    
    procedure DeleteNode(root, fictNode: RBNodeP; val: integer);
    var
        node, child, parent, brother, lilbro, subMax: RBNodeP;
    begin
        node := Search(root, val);
        if (node <> nil) then
        if (IsFict(node^.r) and IsFict(node^.l) and (node^.color = RED)) then // Случай 1| Дети фиктивные, x - красный
        begin
            if (node^.parent <> nil) then
                if (node^.val > node^.parent^.val) then
                    node^.parent^.r := fictNode
                else
                    node^.parent^.l := fictNode;
            dispose(node);
        end
        else if (IsFict(node^.r) and IsFict(node^.l) and (node^.color = BLACK)) then // Случай 2|  Дети фиктивные, x - черный
        begin
            parent := node^.parent;
            if (parent^.val < node^.val) then
            begin
            brother := parent^.l;
            parent^.r := fictNode;
            dispose(node);
            if (parent^.color = RED) then // Случай 2.1| Родитель красный
            begin
                if ((brother^.r^.color = RED) or (brother^.l^.color = RED)) then //Случай 2.1.1| Есть хотя бы один красный сын у брата
                begin
                    if (brother^.r^.color = RED) then // ПРОВЕРИТЬ
                        _RightRotateInsert(brother)
                    else
                        _LeftRotateInsert(brother);
                    _LeftRotateInsert(parent);
                    parent^.color := BLACK;
                end
                else //Случай 2.1.2| Нет красного брата
                begin
                    parent^.color := BLACK;
                    brother^.color := RED;
                end;
            end
            else // Случай 2.2| Родитель черный
            begin
                if (brother^.color = RED) then // Случай 2.2.1| Брат красный
                begin
                    lilbro := brother^.r;
                    if ((lilbro^.r^.color = RED) or (lilbro^.l^.color = RED)) then // Случай 2.2.1.1| Есть красный сын у младшего брата
                    begin
                        _RightRotateInsert(brother);
                        _LeftRotateInsert(parent);
                        if (lilbro^.l^.color = RED) then
                            lilbro^.l^.color := BLACK
                        else 
                            lilbro^.r^.color := RED;
                    end
                    else // Случай 2.2.1.2| Нет красного сына у младшего брата
                    begin
                        _LeftRotateInsert(parent);
                        brother^.color := BLACK;
                        lilbro^.color := RED;
                    end;
                end
                else // Случай 2.2.2| Брат черный
                begin
                    if ((brother^.r^.color = RED) or (brother^.l^.color = RED)) then //Случай 2.2.2.1| Есть хотя бы один красный сын у брата
                    begin
                        if (node^.val < parent^.val) then
                            _LeftRotateInsert(brother)
                        else
                            _RightRotateInsert(brother);
                        if (brother^.val > parent^.val) then
                            _RightRotateInsert(parent)
                        else
                            _LeftRotateInsert(brother);
                        if (brother^.r^.color = RED) then
                            brother^.r^.color := BLACK
                        else
                            brother^.l^.color := BLACK;
                    end
                    else // Случай 2.2.2.2| Нет красных детей у брата
                    begin
                        brother^.color := RED;
                        writeln(brother^.val, ' ', brother^.parent);
                        CheckAfterDelete(brother^.parent);
                    end;
                end;
            end;
        end
        else
        begin
          brother := parent^.r;
            parent^.l := fictNode;
            if (parent^.color = RED) then // Случай 2.1| Родитель красный
            begin
                if ((brother^.l^.color = RED) or (brother^.r^.color = RED)) then //Случай 2.1.1| Есть хотя бы один красный сын у брата
                begin
                    if (brother^.l^.color = RED) then
                        _RightRotateInsert(brother)
                    else
                        _LeftRotateInsert(brother);
                    _LeftRotateInsert(parent);
                    parent^.color := BLACK;
                end
                else //Случай 2.1.2| Нет красного брата
                begin
                    parent^.color := BLACK;
                    brother^.color := RED;
                end;
            end
            else // Случай 2.2| Родитель черный
            begin
                if (brother^.color = RED) then // Случай 2.2.1| Брат красный
                begin
                    lilbro := brother^.l;
                    if ((lilbro^.l^.color = RED) or (lilbro^.r^.color = RED)) then // Случай 2.2.1.1| Есть красный сын у младшего брата
                    begin
                        _RightRotateInsert(brother);
                        _LeftRotateInsert(parent);
                        if (lilbro^.r^.color = RED) then
                            lilbro^.r^.color := BLACK
                        else 
                            lilbro^.l^.color := RED;
                    end
                    else // Случай 2.2.1.2| Нет красного сына у младшего брата
                    begin
                        _LeftRotateInsert(parent);
                        brother^.color := BLACK;
                        lilbro^.color := RED;
                    end;
                end
                else // Случай 2.2.2| Брат черный
                begin
                    if ((brother^.l^.color = RED) or (brother^.r^.color = RED)) then //Случай 2.2.2.1| Есть хотя бы один красный сын у брата
                    begin
                        if (node^.val < parent^.val) then
                            _LeftRotateInsert(brother)
                        else
                            _RightRotateInsert(brother);
                        if (brother^.val > parent^.val) then
                            _RightRotateInsert(parent)
                        else
                            _LeftRotateInsert(brother);
                        if (brother^.l^.color = RED) then
                            brother^.l^.color := BLACK
                        else
                            brother^.r^.color := BLACK;
                    end
                    else // Случай 2.2.2.2| Нет красных детей у брата
                    begin
                        brother^.color := RED;
                        CheckAfterDelete(brother^.parent);
                    end;
                end;
            end;
        dispose(node);
        end;
        end
        else if (not IsFict(node^.r) and IsFict(node^.l)) or 
                (IsFict(node^.r) and not IsFict(node^.l)) then // Случай 3| 1 дитё фиктивное другое - поддерево. Поддерево - обязательно красная вершина
        begin
            if (IsFict(node^.r)) then
                child := node^.l
            else
                child := node^.r;
            child^.color := BLACK;
            if (node^.val > node^.parent^.val) then
                node^.parent^.r := child
            else
                node^.parent^.l := child;
            dispose(node);
        end
        else if not ((IsFict(node^.r)) and (IsFict(node^.l))) then // Случай 4| Оба ребенка не фиктивные
        begin
            subMax := getMax(node^.l);
            node^.val := subMax^.val;
            DeleteNode(node^.l, fictNode, node^.val);
        end;
    end;

begin
    TreeRoot := CreateRBTree();
    fictNode := GetFictNode();
    writeln('1 - добавить элемент, 2 - удалить элемент, 3 - вывести дерево, -1 - закончить');
    while (flag <> -1) do
    begin
        readln(flag);
        case flag of
            -1: 
                break;
            1:
                begin
                    writeln('Введите значение добавляемого узла');
                    readln(value);
                    InitNode(NewNode, FictNode, value);
                    InsertNode(TreeRoot, NewNode, TreeRoot);
                    FixAfterInsert(NewNode);
                end;
            2:
                begin
                    writeln('Введите значение удаляемого узла');
                    readln(value);
                    DeleteNode(TreeRoot, FictNode, value);
                end;
            3:
                begin
                    writeln('------------------');
                    viewTree(TreeRoot, 0);
                    writeln('------------------');
                    writeln;
                end;
        end;
    end;
end.