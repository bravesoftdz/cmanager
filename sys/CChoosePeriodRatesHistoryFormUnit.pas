unit CChoosePeriodRatesHistoryFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFormUnit, StdCtrls, Buttons, CComponents, ExtCtrls,
  CDatabase;

type
  TCChoosePeriodRatesHistoryForm = class(TCChoosePeriodForm)
    GroupBox2: TGroupBox;
    Label14: TLabel;
    CStaticSource: TCStatic;
    Label3: TLabel;
    CStaticTarget: TCStatic;
    Label4: TLabel;
    CStaticCashpoint: TCStatic;
    procedure CStaticSourceGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTargetGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    function CanAccept: Boolean; override;
  end;

function ChoosePeriodRatesHistory(var AStartDate, AEndDate: TDateTime; var ASourceId, ATargetId, ACashpointId: TDataGid): Boolean;

implementation

uses CConfigFormUnit, CFrameFormUnit, CCurrencydefFrameUnit,
  CCashpointsFrameUnit, CConsts, CInfoFormUnit, CDataObjects;

{$R *.dfm}

function ChoosePeriodRatesHistory(var AStartDate, AEndDate: TDateTime; var ASourceId, ATargetId, ACashpointId: TDataGid): Boolean;
var xForm: TCChoosePeriodRatesHistoryForm;
begin
  xForm := TCChoosePeriodRatesHistoryForm.Create(Nil);
  GDataProvider.BeginTransaction;
  if ASourceId <> CEmptyDataGid then begin
    xForm.CStaticSource.DataId := ASourceId;
    xForm.CStaticSource.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, ASourceId, False)).GetElementText;
  end;
  if ATargetId <> CEmptyDataGid then begin
    xForm.CStaticTarget.DataId := ATargetId;
    xForm.CStaticTarget.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, ATargetId, False)).GetElementText;
  end else begin
    xForm.CStaticTarget.DataId := CCurrencyDefGid_PLN;
    xForm.CStaticTarget.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CCurrencyDefGid_PLN, False)).GetElementText;
  end;
  if ACashpointId <> CEmptyDataGid then begin
    xForm.CStaticTarget.DataId := ACashpointId;
    xForm.CStaticTarget.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, ACashpointId, False)).GetElementText;
  end;
  GDataProvider.RollbackTransaction;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    ASourceId := xForm.CStaticSource.DataId;
    ATargetId := xForm.CStaticTarget.DataId;
    ACashpointId := xForm.CStaticCashpoint.DataId;
  end;
  xForm.Free;
end;

procedure TCChoosePeriodRatesHistoryForm.CStaticSourceGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCChoosePeriodRatesHistoryForm.CStaticTargetGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCChoosePeriodRatesHistoryForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

function TCChoosePeriodRatesHistoryForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticCashpoint.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano dostawcy kursu waluty. Czy wy�wietli� list� teraz ?', '') then begin
      CStaticCashpoint.DoGetDataId;
    end;
  end else if (CStaticSource.DataId = CEmptyDataGid) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano waluty bazowej. Czy wy�wietli� list� teraz ?', '') then begin
      CStaticSource.DoGetDataId;
    end;
  end else if (CStaticTarget.DataId = CEmptyDataGid) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano waluty docelowej. Czy wy�wietli� list� teraz ?', '') then begin
      CStaticTarget.DoGetDataId;
    end;
  end;
end;

end.
 