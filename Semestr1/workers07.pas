program workers07;

{$APPTYPE CONSOLE}

type
   TWorker = record
       Name: string[15];
       surname: string[20];
       lastName: string[20];
       gender: string[6];
       birth: string[10];
       starWorkingDate: string[10];
       post: string[30];
       grade: string[15];
   end;
   
TWorkerFile = file of TWorker;

procedure addElement(fileName:string);
var s:string;
    worker: TWorker;
    f: TWorkerFile;
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
      writeln('Input name:');
      readln(worker.name);
      writeln('Input surname:');
      readln(worker.surname);
      writeln('Input lastName:');
      readln(worker.lastName);
      writeln('Input gender:');
      readln(worker.gender);
      writeln('Input birth date (dd.mm.yyyy) :');
      readln(worker.birth);
      writeln('Input start working date (dd.mm.yyyy):');
      readln(worker.starWorkingDate);
      writeln('Input post:');
      readln(worker.post);
      writeln('Input grade:');
      readln(worker.grade);
      write(f, worker);
    end
    else
      break;
  end;
  closeFile(f);
end;


procedure listWorkersByPost(fileName, post: string);
var f:TWorkerFile;
  worker:TWorker;
begin
  if FileExists(fileName) then
  begin
    assignFile(f, fileName);
    reset(f);
    writeln;
    writeln('Workers list:');
    writeln('Name Surname LastName Post');
    while not Eof(f) do
    begin
      read(f, worker);
      if (worker.post = post) then
        writeln(worker.name:4, ' ', worker.surname:8, ' ', worker.lastName:10, ' ', worker.post:4);
    end;
    closeFile(f);
  end;
end;

procedure findWorkerByName(fileName, name, surname, lastName: string);
var f:TWorkerFile;
  worker:TWorker;
begin
  if FileExists(fileName) then
  begin
    assignFile(f, fileName);
    reset(f);
    writeln;
    writeln('Workers list:');
    writeln('Name Surname LastName Post Birth StartWorkingDate');
    while not Eof(f) do
    begin
      read(f, worker);
      if ((worker.name = name) and (worker.surname = surname) and (worker.lastName = lastName)) then
        writeln(worker.name, ' ', worker.surname, ' ', worker.lastName, ' ', worker.post, ' ', worker.grade, ' ', worker.birth, ' ', worker.starWorkingDate);
    end;
    closeFile(f);
  end;
end;

procedure getListOfPensioners(fileName: string);
var f:TWorkerFile;
  worker:TWorker;
  age: integer;
  ageString: string;
begin
  if FileExists(fileName) then
  begin
    assignFile(f, fileName);
    reset(f);
    writeln;
    writeln('Pensioners list:');
    writeln('Name Surname LastName Birth');
    while not Eof(f) do
    begin
      read(f, worker);
      ageString := copy(worker.birth, 7, 4);
      integer.TryParse(ageString, age);
      if (2022 - age >= 65) then
        writeln(worker.name:4, ' ', worker.surname:8, ' ', worker.lastName:10, ' ', worker.birth:10);
    end;
    closeFile(f);
  end;
end;


procedure listWorkersByExperience(fileName: string; experience: integer);
var f:TWorkerFile;
  worker:TWorker;
  age: integer;
  ageString: string;
begin
  if FileExists(fileName) then
  begin
    assignFile(f, fileName);
    reset(f);
    writeln;
    writeln('Pensioners list:');
    writeln('Name Surname LastName StartWorkingDate');
    while not Eof(f) do
    begin
      read(f, worker);
      ageString := copy(worker.starWorkingDate, 7, 4);
      integer.TryParse(ageString, age);
      if (2022 - age >= experience) then
        writeln(worker.name:4, ' ', worker.surname:8, ' ', worker.lastName:10, ' ', worker.starWorkingDate:10);
    end;
    closeFile(f);
  end;
end;

var
  element: TWorker;
  fileName: string;
  flag: string;
  name, surname, lastname, post: string;
  age: integer;
begin
  fileName:='C:\Users\sheisuka\Desktop\workers.dat';

  addElement(fileName);
  writeln();
  writeln('Enter 0 to stop');
  writeln('Enter 1 to find worker by post');
  writeln('Enter 2 to find worker by name surname lastName');
  writeln('Enter 3 to find pensioners');
  writeln('Enter 4 to find workers with experince greather than number');
  repeat
  begin
      readln(flag);
      if (flag = '1') then
        begin
        writeln('Enter post');
        readln(post);
        listWorkersByPost(filename, post);
        end
      else if (flag = '2') then
      begin
          writeln('Enter name');
          readln(name);
          writeln('Enter surname');
          readln(surname);
          writeln('Enter lastname');
          readln(lastname);
          findWorkerByName(fileName, name, surname, lastname);
      end
      else if (flag = '3') then
          getListOfPensioners(fileName)
      else if (flag = '4') then
      begin
          writeln('Enter experience in years');
          readln(age);
          listWorkersByExperience(filename, age);
      end;
        
       
  end;
  until (flag = '0');  
end.