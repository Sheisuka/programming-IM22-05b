program RandomGraph;
const
  MaxVertices = 10; // Максимальное количество вершин в графе
var
  IncMatrix: array[1..MaxVertices, 1..MaxVertices] of Integer; // Матрица инцидентности
  N: Integer; // Количество вершин в графе
  
function myPower(x, y: integer): integer;
var
    res: integer;
begin
    res := x;
    
    while y - 1 <> 0 do
    begin
        res *= x;
        y -= 1;
    end;
    Result := res;
end;

procedure GenerateIncMatrix;
var
  i, j: Integer;
begin
  Randomize;
  for i := 1 to N do
  begin
    for j := i + 1 to N do
    begin
      if i <> j then
      begin
        if Random(2) = 0 then // Генерируем случайное значение 0 или 1
          IncMatrix[i, j] := 0
        else
          IncMatrix[i, j] := Random(10) + 1; // Генерируем случайный вес ребра от 1 до 10
        IncMatrix[j, i] := IncMatrix[i, j]; // Граф неориентированный, поэтому значение симметрично
      end;
    end;
  end;
end;

function CountSpanningTrees: Integer;
var
  AdjMatrix: array[1..MaxVertices, 1..MaxVertices] of Boolean; // Матрица смежности
  Degree: array[1..MaxVertices] of Integer; // Степени вершин
  i, j, k: Integer;
begin
  // Преобразуем матрицу инцидентности в матрицу смежности
  for i := 1 to N do
  begin
    for j := 1 to N do
      AdjMatrix[i, j] := False; // Инициализируем все значения как False
  end;

  for i := 1 to N do
  begin
    for j := 1 to N do
    begin
      if (IncMatrix[i, j] <> 0) then
      begin
        AdjMatrix[i, j] := True;
        Inc(Degree[i]);
        Inc(Degree[j]);
      end;
    end;
  end;

  // Подсчитываем количество остовных деревьев с помощью формулы Кирхгофа
  Result := 1;
  for i := 2 to N do
  begin
    k := 0;
    for j := 1 to i - 1 do
      if AdjMatrix[i, j] then
        Inc(k);
    Result := Result * k;
  end;
  Result := Result * MyPower(N, N - 2);
end;

procedure PrintMatrix;
var
  i, j: Integer;
begin
  for i := 1 to N do
  begin
    for j := 1 to N do
      Write(IncMatrix[i, j], ' ');
    Writeln;
  end;
end;

procedure FindAndPrintSpanningTree;
var
  TreeEdges: array[1..MaxVertices] of Boolean; // Флаги для ребер, входящих в остовное дерево
  Visited: array[1..MaxVertices] of Boolean; // Посещенные вершины
  i, j, EdgeCount: Integer;
begin
  for i := 1 to N do
    Visited[i] := False;
  Visited[1] := True; // Начинаем обход с первой вершины

  EdgeCount := 0;
  while EdgeCount < N - 1 do
  begin
    // Ищем непосещенную вершину, инцидентную посещенной
    for i := 1 to N do
    begin
      if Visited[i] then
      begin
        for j := 1 to N do
        begin
          if (IncMatrix[i, j] <> 0) and (not Visited[j]) then
          begin
            Writeln('Ребро: ', i, ' - ', j);
            Inc(EdgeCount);
            TreeEdges[i] := True;
            TreeEdges[j] := True;
            Visited[j] := True;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

begin
  N := 5; // Количество вершин в графе
  GenerateIncMatrix;
  
  Writeln('Матрица инцидентности:');
  PrintMatrix;
  
  Writeln('Количество остовных деревьев: ', CountSpanningTrees);
  
  Writeln('Одно из остовных деревьев:');
  FindAndPrintSpanningTree; 
  
  // Короче тут ищет по матрице смежности, подсчет не работает хуй знает почему
end.
