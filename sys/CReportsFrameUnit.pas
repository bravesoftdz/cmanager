unit CReportsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, ExtCtrls, VirtualTrees, Menus,
  VTHeaderPopup, ActnList, CComponents, CDatabase, Contnrs, GraphUtil,
  StdCtrls, CReports, PngImageList, CImageListsUnit;

type
  TReportListElement = class(TCDataListElementObject)
  private
    FisReport: Boolean;
    FisPrivate: Boolean;
    FreportClass: TCReportClass;
    FreportParams: TCReportParams;
    Fname: String;
    Fdesc: String;
    Fimage: Integer;
    Fid: TDataGid;
  public
    constructor CreatePrivate(AName: String; AReportClass: TCReportClass; AReportParams: TCReportParams; ADesc: String; AImage: Integer; AId: TDataGid);
    constructor CreateReport(AName: String; AReportClass: TCReportClass; AReportParams: TCReportParams; ADesc: String; AImage: Integer);
    constructor CreateGroup(AName: String; ADesc: String; AImage: Integer);
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementId: String; override;
    function GetElementType: String; override;
    function GetElementText: String; override;
    procedure GetElementReload; override;
    function GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject): Integer; override;
    destructor Destroy; override;
  published
    property isReport: Boolean read FisReport;
    property reportClass: TCReportClass read FreportClass;
    property reportParams: TCReportParams read FreportParams;
    property isPrivate: Boolean read FisPrivate;
    property id: TDataGid read Fid;
  end;

  TCReportsFrame = class(TCBaseFrame)
    ActionList: TActionList;
    ActionExecute: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    PanelFrameButtons: TPanel;
    CButtonExecute: TCButton;
    List: TCDataList;
    Bevel: TBevel;
    ActionAdd: TAction;
    ActionEdit: TAction;
    ActionDel: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    CButton3: TCButton;
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ListDblClick(Sender: TObject);
    procedure ActionExecuteExecute(Sender: TObject);
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionDelExecute(Sender: TObject);
  private
    FPrivateList: TDataObjectList;
    procedure ReloadPrivate(ARootElement: TCListDataElement);
  public
    function GetList: TCList; override;
    class function GetTitle: String; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    procedure FinalizeFrame; override;
  end;

implementation

uses CDataObjects, CFrameFormUnit, CProductFormUnit, CConfigFormUnit, CInfoFormUnit, CConsts,
  CPlugins, CPluginConsts, CTools, CReportDefFormUnit;

{$R *.dfm}

const CNoImage = -1;
      CHtmlReportImage = 0;
      CChartReportImage = 1;
      CBarReportImage = 2;
      CLineReportImage = 3;
      CPluginReportImage = 4;

procedure TCReportsFrame.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  if Node <> Nil then begin
    CButtonExecute.Enabled := TReportListElement(List.GetTreeElement(Node).Data).isReport;
    CButton2.Enabled := TReportListElement(List.GetTreeElement(Node).Data).isPrivate;
    CButton3.Enabled := TReportListElement(List.GetTreeElement(Node).Data).isPrivate;
  end else begin
    CButtonExecute.Enabled := False;
    CButton2.Enabled := False;
    CButton3.Enabled := False;
  end;
end;

class function TCReportsFrame.GetTitle: String;
begin
  Result := 'Raporty';
end;

procedure TCReportsFrame.ListDblClick(Sender: TObject);
begin
  if List.FocusedNode <> Nil then begin
    if CButtonExecute.Enabled then begin
      ActionExecute.Execute;
    end;
  end;
end;

function TCReportsFrame.GetList: TCList;
begin
  Result := List;
end;

procedure TCReportsFrame.ActionExecuteExecute(Sender: TObject);
var xData: TReportListElement;
    xReport: TCBaseReport;
begin
  xData := TReportListElement(List.SelectedElement.Data);
  if xData.reportClass <> Nil then begin
    xReport := xData.reportClass.CreateReport(xData.reportParams);
    if xReport <> Nil then begin
      xReport.ShowReport;
      xReport.Free;
    end;
  end else begin
    ShowInfo(itError, 'Wybrany raport nie jest jeszcze dost�pny', '')
  end;
end;

constructor TReportListElement.CreateGroup(AName: String; ADesc: String; AImage: Integer);
begin
  inherited Create;
  Fname := AName;
  Fdesc := ADesc;
  FisReport := False;
  Fimage := AImage;
  FreportParams := Nil;
  FreportClass := Nil;
end;

constructor TReportListElement.CreatePrivate(AName: String; AReportClass: TCReportClass; AReportParams: TCReportParams; ADesc: String; AImage: Integer; AId: TDataGid);
begin
  CreateReport(AName, AReportClass, AReportParams, ADesc, AImage);
  FisPrivate := True;
  Fid := AId;
end;

constructor TReportListElement.CreateReport(AName: String; AReportClass: TCReportClass; AReportParams: TCReportParams; ADesc: String; AImage: Integer);
begin
  inherited Create;
  Fname := AName;
  Fdesc := ADesc;
  FisReport := True;
  Fimage := AImage;
  FreportParams := AReportParams;
  FreportClass := AReportClass;
  FisPrivate := False;
  Fid := CEmptyDataGid;
end;

destructor TReportListElement.Destroy;
begin
  if FreportParams <> Nil then begin
    FreportParams.Free;
  end;
  inherited Destroy;
end;

function TReportListElement.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := Fimage;
end;

function TReportListElement.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  Result := Fname;
end;

function TReportListElement.GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject): Integer;
begin
  Result := AnsiCompareStr(GetColumnText(AColumnIndex, False), ACompareWith.GetColumnText(AColumnIndex, False));
end;

function TReportListElement.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdesc;
end;

function TReportListElement.GetElementId: String;
begin
  Result := Fname;
end;

procedure TCReportsFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xBase: TCListDataElement;
    xStats: TCListDataElement;
    xOthers: TCListDataElement;
    xBs, xTm: TCListDataElement;
    xCount: Integer;
    xPlugin: TCPlugin;
begin
  xBase := TCListDataElement.Create(List, TReportListElement.CreateGroup('Podstawowe', '', CNoImage), True);
  ARootElement.Add(xBase);
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Stan kont' , TAccountBalanceOnDayReport, Nil, 'Pokazuje stan wszystkich kont na wybrany dzie�', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Operacje wykonane' , TDoneOperationsListReport, Nil, 'Pokazuje operacje wykonane w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Operacje zaplanowane' , TPlannedOperationsListReport, Nil, 'Pokazuje operacje zaplanowane na wybrany okres', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Przep�yw got�wki' , TCashFlowListReport, Nil, 'Pokazuje przep�yw got�wki mi�dzy kontami/kontrahentami w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Historia konta' , TAccountHistoryReport, Nil, 'Pokazuje histori� wybranego konta w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Historia kontrahenta' , TCPHistoryReport, TCReportParams.CreateAco(CGroupByCashpoint), 'Pokazuje histori� wybranego kontrahenta w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Historia kategorii' , TCPHistoryReport, TCReportParams.CreateAco(CGroupByProduct), 'Pokazuje histori� wybranego kategorii w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres stanu kont' , TAccountBalanceChartReport, Nil, 'Pokazuje wykres stanu kont w wybranym okresie', CLineReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Sumy przychod�w i rozchod�w' , TCashSumReportChart, TCSelectedMovementTypeParams.Create(CInMovement + COutMovement), 'Pokazuje sumy przychod�w\rozchod�w w wybranym okresie', CBarReportImage), True));
  xBs := TCListDataElement.Create(List, TReportListElement.CreateGroup('Rozchody', '', CNoImage), True);
  ARootElement.Add(xBs);
  xBs.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista operacji rozchodowych' , TOperationsListReport, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w wybranym okresie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('w/g kategorii', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres rozchod�w' , TOperationsByCategoryChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista rozchod�w' , TOperationsByCategoryList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('w/g kontrahent�w', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres rozchod�w' , TOperationsByCashpointChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kontrahent�w', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista rozchod�w' , TOperationsByCashpointList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kontrahent�w', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('Sumy', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres sum rozchod�w' , TSumBySomethingChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy rozchod�w w wybranym okresie', CBarReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista sum rozchod�w' , TSumBySomethingList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy rozchod�w w wybranym okresie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Sumy kwotowe rozchod�w dla kont' , TCashSumReportList, TCSelectedMovementTypeParams.CreateAcpType(CGroupByAccount, COutMovement), 'Pokazuje sumy rozchod�w w wybranym okresie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Sumy ilo�ciowe rozchod�w' , TQuantitySumReportList, TCSelectedMovementTypeParams.CreateAcpType(CGroupByProduct, COutMovement), 'Pokazuje sumy ilo�ciowe rozchod�w w wybranym okresie', CHtmlReportImage), True));
  xBs := TCListDataElement.Create(List, TReportListElement.CreateGroup('Przychody', '', CNoImage), True);
  ARootElement.Add(xBs);
  xBs.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista operacji przychodowych' , TOperationsListReport, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w wybranym okresie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('w/g kategorii', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres przychod�w' , TOperationsByCategoryChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista przychod�w' , TOperationsByCategoryList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('w/g kontrahent�w', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres przychod�w' , TOperationsByCashpointChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kontrahent�w', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista przychod�w' , TOperationsByCashpointList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kontrahent�w', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('Sumy', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres sum przychod�w' , TSumBySomethingChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje sumy przychod�w w wybranym okresie', CBarReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista sum przychod�w' , TSumBySomethingList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje sumy przychod�w w wybranym okresie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Sumy kwotowe przychod�w dla kont' , TCashSumReportList, TCSelectedMovementTypeParams.CreateAcpType(CGroupByAccount, CInMovement), 'Pokazuje sumy przychod�w w wybranym okresie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Sumy ilo�ciowe przychod�w' , TQuantitySumReportList, TCSelectedMovementTypeParams.CreateAcpType(CGroupByProduct, CInMovement), 'Pokazuje sumy ilo�ciowe przychod�w w wybranym okresie', CHtmlReportImage), True));
  xStats := TCListDataElement.Create(List, TReportListElement.CreateGroup('Statystyki', '', CNoImage), True);
  ARootElement.Add(xStats);
  xStats.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('�rednie' , TAveragesReport, Nil, 'Pokazuje �rednie rozchody/przychody w wybranym okresie', CHtmlReportImage), True));
  xStats.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Prognozy' , TFuturesReport, Nil,  'Pokazuje prognozy rozchod�w i przychod�w dla wybranego okresu', CHtmlReportImage), True));
  xStats.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Podsumowanie' , TPeriodSumsReport, Nil, 'Pokazuje podsumowanie statystyczne wybranego okresu', CHtmlReportImage), True));
  xOthers := TCListDataElement.Create(List, TReportListElement.CreateGroup('R�ne', '', CNoImage), True);
  ARootElement.Add(xOthers);
  xOthers.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Historia wybranej waluty' , TCurrencyRatesHistoryReport, Nil, 'Pokazuje histori� waluty w/g wybranego kontrahenta w zadanym okresis', CLineReportImage), True));
  for xCount := 0 to GPlugins.Count - 1 do begin
    xPlugin := TCPlugin(GPlugins.Items[xCount]);
    if xPlugin.isTypeof[CPLUGINTYPE_HTMLREPORT] then begin
      xOthers.Add(TCListDataElement.Create(List, TReportListElement.CreateReport(xPlugin.pluginMenu, TPluginHtmlReport, TCPluginReportParams.Create(xPlugin), xPlugin.pluginDescription, CPluginReportImage), True));
    end else if xPlugin.isTypeof[CPLUGINTYPE_CHARTREPORT] then begin
      xOthers.Add(TCListDataElement.Create(List, TReportListElement.CreateReport(xPlugin.pluginMenu, TPluginChartReport, TCPluginReportParams.Create(xPlugin), xPlugin.pluginDescription, CPluginReportImage), True));
    end;
  end;
  ReloadPrivate(ARootElement);
end;

procedure TReportListElement.GetElementReload;
begin
end;

function TReportListElement.GetElementText: String;
begin
end;

function TReportListElement.GetElementType: String;
begin
  Result := ClassName;
end;

procedure TCReportsFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  List.RootElement.FreeDataOnClear := True;
  List.ReloadTree;
  ListFocusChanged(List, List.FocusedNode, 0);  
end;

procedure TCReportsFrame.ReloadPrivate(ARootElement: TCListDataElement);
var xPrivate: TCListDataElement;
begin
  GDataProvider.BeginTransaction;
  FPrivateList := TReportDef.GetAllObjects(ReportDefProxy);
  xPrivate := TCListDataElement.Create(List, TReportListElement.CreateGroup('W�asne', '', CNoImage), True);
  ARootElement.Add(xPrivate);
  GDataProvider.RollbackTransaction;
end;

procedure TCReportsFrame.FinalizeFrame;
begin
  FPrivateList.Free;
  inherited FinalizeFrame;
end;

procedure TCReportsFrame.ActionAddExecute(Sender: TObject);
var xForm: TCReportDefForm;
begin
  xForm := TCReportDefForm.Create(Nil);
  xForm.ShowDataobject(coAdd, ReportDefProxy, Nil, True);
  xForm.Free;
end;

procedure TCReportsFrame.ActionEditExecute(Sender: TObject);
var xForm: TCReportDefForm;
begin
  if List.FocusedNode <> Nil then begin
    xForm := TCReportDefForm.Create(Nil);
    xForm.ShowDataobject(coEdit, ReportDefProxy, FPrivateList.ObjectById[TReportListElement(List.SelectedElement).id], True);
    xForm.Free;
  end;
end;

procedure TCReportsFrame.ActionDelExecute(Sender: TObject);
var xId: TDataGid;
begin
  if List.FocusedNode <> Nil then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun�� wybran� definicj� raportu ?', '') then begin
      xId := TReportListElement(List.SelectedElement).id;
      FPrivateList.ObjectById[xId].DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCReportsFrame, WM_DATAOBJECTDELETED, Integer(@xId), 0);
    end;
  end;
end;

end.
