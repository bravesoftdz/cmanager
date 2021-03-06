unit CChoosePeriodAcpListGroupFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodAcpListFormUnit, StdCtrls, Buttons,
  CComponents, ExtCtrls, CDatabase;

type
  TCChoosePeriodAcpListGroupForm = class(TCChoosePeriodAcpListForm)
    GroupBox3: TGroupBox;
    Label3: TLabel;
    ComboBoxSums: TComboBox;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    CStaticFilter: TCStatic;
    procedure CStaticFilterGetDataId(var ADataGid, AText: String;
      var AAccepted: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ChoosePeriodAcpListGroupByForm(AAcp: String; var AStartDate, AEndDate: TDateTime; var AIdAcps: TStringList; var AIdFilter: TDataGid; var AGroupBy: String; ACurrencyView: PChar): Boolean;

implementation

uses CConsts, CConfigFormUnit, CFilterDetailFrameUnit;

{$R *.dfm}

function ChoosePeriodAcpListGroupByForm(AAcp: String; var AStartDate, AEndDate: TDateTime; var AIdAcps: TStringList; var AIdFilter: TDataGid; var AGroupBy: String; ACurrencyView: PChar): Boolean;
var xForm: TCChoosePeriodAcpListGroupForm;
    xList: TList;
    xData: String;
begin
  xForm := TCChoosePeriodAcpListGroupForm.Create(Nil);
  xForm.Acp := AAcp;
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
    AIdAcps.Text := xForm.CStatic.DataId;
    AIdFilter := xForm.CStaticFilter.DataId;
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

procedure TCChoosePeriodAcpListGroupForm.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := DoTemporaryMovementFilter(ADataGid, AText);
end;

end.
