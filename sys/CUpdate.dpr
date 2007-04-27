program CUpdate;

{$R 'cupdateicons.res' 'cupdateicons.rc'}

uses
  Forms,
  Windows,
  CUpdateMainFormUnit in 'CUpdateMainFormUnit.pas' {CUpdateMainForm},
  CComponents in 'CComponents.pas',
  MemCheck in 'MemCheck.pas',
  CRichtext in '.\Shared\CRichtext.pas',
  CXml in '.\Shared\CXml.pas',
  CTools in '.\Shared\CTools.pas',
  CHttpRequest in '.\Shared\CHttpRequest.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  Application.Initialize;
  Application.Icon.Handle := LoadIcon(HInstance, 'BASEICON');
  UpdateSystem;
end.
