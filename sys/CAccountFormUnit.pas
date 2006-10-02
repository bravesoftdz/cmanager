unit CAccountFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ImgList,
  ComCtrls, CComponents, CDatabase, Mask;

type
  TCAccountForm = class(TCDataobjectForm)
    GroupBoxAccountType: TGroupBox;
    ComboBoxType: TComboBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TRichEdit;
    CCurrEditCash: TCCurrEdit;
    LabelCash: TLabel;
    GroupBoxBank: TGroupBox;
    Label3: TLabel;
    EditNumber: TEdit;
    CStaticBank: TCStatic;
    Label4: TLabel;
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CConfigFormUnit, CFrameFormUnit,
  CCashpointsFrameUnit;

{$R *.dfm}

function TCAccountForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa konta nie mo�e by� pusta', '');
    EditName.SetFocus;
  end else if (ComboBoxType.ItemIndex = 1) and (CStaticBank.DataId = CEmptyDataGid) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano banku prowadz�cego konto. Czy wy�wietli� list� teraz ?', '') then begin
      CStaticBank.DoGetDataId;
    end;
  end;
end;

procedure TCAccountForm.ComboBoxTypeChange(Sender: TObject);
begin
  if ComboBoxType.ItemIndex = 0 then begin
    Height := 390;
    GroupBoxBank.Visible := False;
  end else begin
    Height := 516;
    GroupBoxBank.Visible := True;
  end;
end;

procedure TCAccountForm.FillForm;
var xCashPoint: TCashPoint;
begin
  with TAccount(Dataobject) do begin
    EditName.Text := name;
    RichEditDesc.Text := description;
    if accountType = CBankAccount then begin
      ComboBoxType.ItemIndex := 1;
    end else begin
      ComboBoxType.ItemIndex := 0;
    end;
    ComboBoxTypeChange(ComboBoxType);
    CCurrEditCash.Value := cash;
    if Operation = coAdd then begin
      LabelCash.Caption := '�rodki pocz�tkowe';
    end else begin
      LabelCash.Caption := 'Dost�pne �rodki';
      CCurrEditCash.Enabled := False;
    end;
    CStaticBank.DataId := idCashPoint;
    xCashPoint := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, True));
    CStaticBank.Caption := xCashPoint.name;
    xCashPoint.Free;
    EditNumber.Text := accountNumber;
  end;
end;

procedure TCAccountForm.FormCreate(Sender: TObject);
begin
  inherited;
  ComboBoxType.ItemIndex := 0;
  ComboBoxTypeChange(ComboBoxType);
end;

function TCAccountForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TAccount;
end;

procedure TCAccountForm.ReadValues;
begin
  inherited ReadValues;
  with TAccount(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    if ComboBoxType.ItemIndex = 0 then begin
      accountType := CCashAccount;
    end else begin
      accountType := CBankAccount;
    end;
    if Operation = coAdd then begin
      cash := CCurrEditCash.Value;
    end;
    idCashPoint := CStaticBank.DataId;
    accountNumber := EditNumber.Text;
  end;
end;

procedure TCAccountForm.CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

end.
