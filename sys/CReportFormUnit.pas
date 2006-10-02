unit CReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, OleCtrls, SHDocVw, CComponents, ExtCtrls,
  ActnList, ImgList;

type
  TCReportForm = class(TCBaseForm)
    Panel1: TPanel;
    Panel2: TPanel;
    CBrowser: TCBrowser;
    CButtonAddCategory: TCButton;
    CButtonAddSubcategory: TCButton;
    CButtonEditCategory: TCButton;
    ImageList: TImageList;
    ActionList: TActionList;
    ActionPreview: TAction;
    ActionPrint: TAction;
    ActionSave: TAction;
    procedure ActionPrintExecute(Sender: TObject);
    procedure ActionPreviewExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
  end;

implementation

uses CReports;

{$R *.dfm}

procedure TCReportForm.ActionPrintExecute(Sender: TObject);
begin
  CBrowser.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER);
end;

procedure TCReportForm.ActionPreviewExecute(Sender: TObject);
begin
  CBrowser.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_PROMPTUSER);
end;

procedure TCReportForm.ActionSaveExecute(Sender: TObject);
begin
//
end;

end.
