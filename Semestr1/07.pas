program work07;

{$APPTYPE CONSOLE}

type
   TElement = record
   Group : integer;
   SubGroup : 0..2;
   Subject : string[8];
   Day : 1..7;
   ClassNumber : 1..6;
end;
TElementFile = file of TElement;
TElementArray = array of TElement;

procedure addElement(fileName:string);
var s:string;
    element: TElement;
    f: TElementFile;
begin
  assignFile(f, fileName);
  if not FileExists(fileName) then
    rewrite(f)
  else
    reset(f);
  seek(f, fileSize(f));
  while true do
  begin
    writeln('Add new record? Y/N');
    readln(s);
    if s = 'Y' then
    begin
      writeln('Input group:');
      readln(element.group);
      writeln('Input subgroup:');
      readln(element.subGroup);
      writeln('Input subject:');
      readln(element.subject);
      writeln('Input day:');
      readln(element.day);
      writeln('Input class number:');
      readln(element.classNumber);
      write(f, element);
    end
    else
      break;
  end;
  closeFile(f);
end;

procedure removeElement(fileName: string; Group, subGroup, Day, classNumber: integer);
var 
    arrayelement: TElementArray;
    element: TElement;
    f: TElementFile;
    var i: integer;
begin
    assignFile(f, fileName);
    if not fileExists(fileName) then
        writeln('Файла не существует')
    else
    begin
        reset(f);
        while not EOF(f) do
        begin
          read(f, element);
          i += 1;
          if (element.Group = Group) and (element.SubGroup = subGroup) and
              (element.Day = Day) and (element.ClassNumber = classNumber) then
              break
        end;
        seek(f, i - 1);
        for var n := i - 1 to filesize(f) - 2 do begin
            seek(f, i + 1);
            read(f, element);
            seek(f, i);
            write(f, element);
        end;
        seek(f, filesize(f) - 1);
        truncate(f);
        
        closeFile(f);
    end;
    
end;


function findSubject(fileName: string; group: integer; subgroup: 0..2; classNumber: integer; day: integer): string;
var f: TElementFile;
    element: TElement;
begin
  if FileExists(fileName) then
  begin
    assignFile(f, fileName);
    reset(f);
    while not Eof(f) do
    begin
      read(f, element);
      if (element.Group = group) and (element.SubGroup = subGroup)
        and (element.ClassNumber = classNumber) and (element.Day = day) then
      begin
        result := element.Subject;
        break;
      end;
    end;
    closeFile(f);
  end;
end;

procedure listElements(fileName: string);
var f:TElementFile;
  element:TElement;
begin
  if FileExists(fileName) then
  begin
    assignFile(f, fileName);
    reset(f);
    writeln;
    writeln('Element list:');
    writeln('Group, subGroup, Day, Subject, ClassNumber');
    while not Eof(f) do
    begin
      read(f, element);
      writeln(element.Group:5, ' ', element.subGroup:8, ' ', element.Day:3, ' ', element.Subject:7, ' ', element.ClassNumber:11);
    end;
    closeFile(f);
  end;
end;

var
  element: TElement;
  fileName: string;
  flag: string;
  group, subgroup, classNumber, day: integer;
begin
  fileName:='C:\Users\sheisuka\Desktop\repos\programming-IM22-05b\Semestr1\elements.dat';

  addElement(fileName);
  writeln();
  writeln('Enter 0 to stop');
  writeln('Enter 1 to find subject');
  writeln('Enter 2 to delete element');
  writeln('Enter 3 to view elements');
  repeat
  begin
      readln(flag);
      if (flag = '1') then
        begin
        writeln('Enter group subgroup classNumber day');
        readln(group, subgroup, classnumber, day);
        writeln(findSubject(filename, group, subgroup, classnumber, day));
        end
      else if (flag = '2') then
      begin
          writeln('Enter Group, subGroup, Day, classNumber');
          removeElement(fileName, Group, subGroup, Day, ClassNumber);
      end
      else if (flag = '3') then
        listElements(fileName);
       
  end;
  until (flag = '0');  
end.