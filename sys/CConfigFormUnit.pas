unit CConfigFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, ComCtrls, StdCtrls, ExtCtrls, Buttons, Themes,
  ImgList;

type
  TConfigOperation = (coNone, coAdd, coEdit);
  TCConfigForm = class(TCBaseForm)
    PanelConfig: TPanel;
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
  private
    FAccepted: Boolean;
    FOperation: TConfigOperation;
  protected
    function CanAccept: Boolean; virtual;
    procedure FillForm; virtual;
    procedure ReadValues; virtual;
  public
    function ShowConfig(AOperation: TConfigOperation): Boolean; virtual;
  published
    property Operation: TConfigOperation read FOperation write FOperation;
    property Accepted: Boolean read FAccepted write FAccepted;
  end;

implementation

uses Math;

{$R *.dfm}

procedure TCConfigForm.BitBtnOkClick(Sender: TObject);
begin
  if CanAccept then begin
    FAccepted := True;
    Close;
  end;
end;

function TCConfigForm.CanAccept: Boolean;
begin
  Result := True;
end;

function TCConfigForm.ShowConfig(AOperation: TConfigOperation): Boolean;
begin
  FAccepted := False;
  FOperation := AOperation;
  if FOperation = coNone then begin
    BitBtnOk.Visible := False;
    BitBtnCancel.Default := True;
    BitBtnCancel.Caption := '&Wyj�cie';
  end;
  FillForm;
  ShowModal;
  if FAccepted then begin
    ReadValues;
  end;
  Result := FAccepted;
end;

procedure TCConfigForm.BitBtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TCConfigForm.FillForm;
begin
end;

procedure TCConfigForm.ReadValues;
begin
end;

end.
