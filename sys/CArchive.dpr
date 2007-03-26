program CArchive;

{$R 'carchiveicons.res' 'carchiveicons.rc'}

uses
  Forms,
  Windows,
  SysUtils,
  CTools in 'CTools.pas',
  CBackups in 'CBackups.pas',
  MemCheck in 'MemCheck.pas';

{$R *.res}

var xAction: Integer;
    xExitCode: Integer;
    xOverride: Boolean;
    xText: String;
    xFile, xBackup: String;
begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  Application.Initialize;
  Application.Icon.Handle := LoadIcon(HInstance, 'BASEICON');
  xExitCode := $FF;
  if GetSwitch('-h') then begin
    xExitCode := $00;
    xText := 'CArchive -[a|x|h] [-o] -b [nazwa kopii pliku danych] -u [nazwa pliku danych]' + sLineBreak +
             '  -a wykonaj kopi� pliku danych [nazwa pliku danych] i zapisz jako [nazwa kopii pliku danych]' + sLineBreak +
             '  -x odtw�rz kopi� pliku danych [nazwa kopii pliku danych] do pliku o nazwie [nazwa pliku danych]' + sLineBreak +
             '  -o zezwala na nadpisywanie plik�w' + sLineBreak +
             '  -h wy�wietla ten ekran';
    MessageBox(0, PChar(xText), 'Informacja', MB_OK + MB_ICONINFORMATION);
  end else begin
    xAction := 0;
    if GetSwitch('-a') then begin
      xAction := xAction or $01;
    end;
    if GetSwitch('-x') then begin
      xAction := xAction or $02;
    end;
    if (xAction <= 0) or (xAction >= 3) then begin
      MessageBox(0, 'Niepoprawne parametry wywo�ania. Spr�buj "CArchive -h"', 'B��d', MB_OK + MB_ICONERROR);
    end else begin
      xOverride := GetSwitch('-o');
      xFile := GetParamValue('-u');
      xBackup := GetParamValue('-b');
      if xFile = '' then begin
        MessageBox(0, 'Nie podano nazwy pliku danych', 'B��d', MB_OK + MB_ICONERROR);
      end else if xBackup = '' then begin
        MessageBox(0, 'Nie podano nazwy kopii pliku danych', 'B��d', MB_OK + MB_ICONERROR);
      end else begin
        //todo
      end;
    end;
  end;
  Halt(xExitCode);
end.
