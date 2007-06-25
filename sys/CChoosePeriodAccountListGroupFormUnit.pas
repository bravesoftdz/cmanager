unit CChoosePeriodAccountListGroupFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodAccountListFormUnit, StdCtrls, Buttons,
  CComponents, ExtCtrls;

type
  TCChoosePeriodAccountListGroupForm = class(TCChoosePeriodAccountListForm)
    GroupBox3: TGroupBox;
    Label3: TLabel;
    ComboBoxSums: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ChoosePeriodAccountListGroupByForm(var AStartDate, AEndDate: TDateTime; var AIdAccounts: TStringList; var AGroupBy: String; ACurrencyView: PChar): Boolean;

implementation

uses CConsts, CConfigFormUnit, CDatabase;

{$R *.dfm}

function ChoosePeriodAccountListGroupByForm(var AStartDate, AEndDate: TDateTime; var AIdAccounts: TStringList; var AGroupBy: String; ACurrencyView: PChar): Boolean;
var xForm: TCChoosePeriodAccountListGroupForm;
    xList: TList;
    xData: String;
begin
  xForm := TCChoosePeriodAccountListGroupForm.Create(Nil);
  if ACurrencyView = Nil then begin
    xForm.GroupBoxView.Visible := False;
    xForm.Height := xForm.Height - xForm.GroupBoxView.Height - 15;
    xList := TList.Create;
    xForm.GetTabOrderList(xList);
    xForm.GroupBoxView.TabOrder := xList.Count;
    xList.Free;
  end;
  if (AStartDate = GWorkDate) and (AEndDate = GWorkDate) then begin
    xForm.ComboBoxPredefined.ItemIndex := 1;
    xForm.ComboBoxPredefinedChange(xForm.ComboBoxPredefined);
  end;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    AIdAccounts.Text := xForm.CStaticAccount.DataId;
    if xForm.ComboBoxSums.ItemIndex = 0 then begin
      AGroupBy := CGroupByDay;
    end else if xForm.ComboBoxSums.ItemIndex = 1 then begin
      AGroupBy := CGroupByWeek;
    end else begin
      AGroupBy := CGroupByMonth;
    end;
    if ACurrencyView <> Nil then begin
      xData := xForm.CStaticCurrencyView.DataId[1];
      CopyMemory(ACurrencyView, @xData[1], 1);
    end;
  end;
  xForm.Free;
end;

end.
