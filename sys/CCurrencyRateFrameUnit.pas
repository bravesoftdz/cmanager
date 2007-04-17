unit CCurrencyRateFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDataobjectFormUnit,
  CDatabase, CImageListsUnit;

type
  TCCurrencyRateFrame = class(TCDataobjectFrame)
    CDateTimePerStart: TCDateTime;
    Label4: TLabel;
    CDateTimePerEnd: TCDateTime;
    Label5: TLabel;
    Label3: TLabel;
    procedure CStaticFilterChanged(Sender: TObject);
    procedure CDateTimePerStartChanged(Sender: TObject);
    procedure CDateTimePerEndChanged(Sender: TObject);
  protected
    procedure UpdateCustomPeriod;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function GetInitialiFilter: String; override;
  end;

implementation

uses CDataObjects, CCurrencyRateFormUnit, CConsts, DateUtils;

{$R *.dfm}

function TCCurrencyRateFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TCurrencyRate;
end;

function TCCurrencyRateFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCCurrencyRateForm;
end;

function TCCurrencyRateFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := CurrencyRateProxy;
end;

procedure TCCurrencyRateFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
var xId: TDataGid;
begin
  ADateFrom := 0;
  ADateTo := 0;
  xId := CStaticFilter.DataId;
  if xId = CCurrencyRateFilterToday then begin
    ADateFrom := GWorkDate;
    ADateTo := GWorkDate;
  end else if xId = CCurrencyRateFilterYesterday then begin
    ADateFrom := IncDay(GWorkDate, -1);
    ADateTo := IncDay(GWorkDate, -1);
  end else if xId = CCurrencyRateFilterWeek then begin
    ADateFrom := StartOfTheWeek(GWorkDate);
    ADateTo := EndOfTheWeek(GWorkDate);
  end else if xId = CCurrencyRateFilterMonth then begin
    ADateFrom := StartOfTheMonth(GWorkDate);
    ADateTo := EndOfTheMonth(GWorkDate);
  end else if xId = CCurrencyRateFilterOther then begin
    ADateFrom := CDateTimePerStart.Value;
    ADateTo := CDateTimePerEnd.Value;
  end;
end;

function TCCurrencyRateFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CCurrencyRateFilterToday + '=<wa�ne dzi�>');
    Add(CCurrencyRateFilterYesterday + '=<wa�ne wczoraj>');
    Add(CCurrencyRateFilterWeek + '=<wa�ne w tym tygodniu>');
    Add(CCurrencyRateFilterMonth + '=<wa�ne w tym miesi�cu>');
    Add(CCurrencyRateFilterOther + '=<dowolny okres>');
  end;
end;

class function TCCurrencyRateFrame.GetTitle: String;
begin
  Result := 'Kursy walut';
end;

procedure TCCurrencyRateFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck);
  UpdateCustomPeriod;
  CDateTimePerStart.Value := GWorkDate;
  CDateTimePerEnd.Value := GWorkDate;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
end;

function TCCurrencyRateFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xDf, xDt: TDateTime;
begin
  GetFilterDates(xDf, xDt);
  Result := (inherited IsValidFilteredObject(AObject)) or
            (xDf <= TCurrencyRate(AObject).bindingDate) and (TCurrencyRate(AObject).bindingDate <= xDt);
end;

procedure TCCurrencyRateFrame.ReloadDataobjects;
var xCondition: String;
    xDf, xDt: TDateTime;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else begin
    GetFilterDates(xDf, xDt);
    xCondition := Format(' where bindingDate between %s and %s', [DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False)]);
  end;
  Dataobjects := TCurrencyRate.GetList(TCurrencyRate, CurrencyRateProxy, 'select * from currencyRate' + xCondition);
end;

procedure TCCurrencyRateFrame.UpdateCustomPeriod;
var xF, xE: TDateTime;
begin
  CDateTimePerStart.HotTrack := CStaticFilter.DataId = CCurrencyRateFilterOther;
  CDateTimePerEnd.HotTrack := CStaticFilter.DataId = CCurrencyRateFilterOther;
  if CStaticFilter.DataId <> CCurrencyRateFilterOther then begin
    GetFilterDates(xF, xE);
    CDateTimePerStart.Value := xF;
    CDateTimePerEnd.Value := xE;
  end;
end;

procedure TCCurrencyRateFrame.CStaticFilterChanged(Sender: TObject);
begin
  UpdateCustomPeriod;
  inherited;
end;

procedure TCCurrencyRateFrame.CDateTimePerStartChanged(Sender: TObject);
begin
  RefreshData;
end;

procedure TCCurrencyRateFrame.CDateTimePerEndChanged(Sender: TObject);
begin
  RefreshData;
end;

function TCCurrencyRateFrame.GetInitialiFilter: String;
begin
  Result := CCurrencyRateFilterToday;
end;

end.
