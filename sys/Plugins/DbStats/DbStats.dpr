library DBStats;

{$R *.res}

uses
  Windows,
  Dialogs,
  Variants,
  Forms,
  AdoInt,
  Messages,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  DBStatsFormUnit in 'DBStatsFormUnit.pas' {DBStatsForm},
  CRichtext in '..\..\Shared\CRichtext.pas',
  CTools in '..\..\Shared\CTools.pas';

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  CManInterface := ACManagerInterface;
  with CManInterface do begin
    Application.Handle := GetAppHandle;
    SetType(CPLUGINTYPE_JUSTEXECUTE);
    SetCaption('Poka� informacje o pliku danych');
    SetDescription('Informacje o pliku danych');
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
var xObject: IInterface;
    xForm: TDBStatsForm;
begin
  VarClear(Result);
  xObject := CManInterface.GetConnection;
  if xObject <> Nil then begin
    xForm := TDBStatsForm.Create(Application);
    xForm.Icon.Handle := SendMessage(CManInterface.GetAppHandle, WM_GETICON, ICON_BIG, 0);
    xForm.Intf := xObject as _Connection;
    xForm.PrepareInfo;
    xForm.ShowModal;
    xForm.Free;
  end;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
