unit CReportsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, ExtCtrls, VirtualTrees, Menus,
  VTHeaderPopup, ActnList, CComponents, CDatabase, Contnrs, GraphUtil,
  StdCtrls, CReports, PngImageList;

type
  THelperElement = class(TObjectList)
  private
    FisReport: Boolean;
    Fid: TDataGid;
    Fname: String;
    Fdesc: String;
    Fimage: Integer;
  public
    constructor Create(AIsReport: Boolean; AName: String; AId: TDataGid; ADesc: String; AImage: Integer);
  published
    property isReport: Boolean read FisReport;
    property id: TDataGid read Fid;
    property name: String read Fname;
    property desc: String read Fdesc;
    property image: Integer read Fimage;
  end;

  TCReportsFrame = class(TCBaseFrame)
    ReportList: TVirtualStringTree;
    ActionList: TActionList;
    ActionExecute: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    PanelFrameButtons: TPanel;
    CButtonExecute: TCButton;
    procedure ReportListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ReportListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ReportListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure ReportListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure ReportListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ReportListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure ReportListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure ReportListDblClick(Sender: TObject);
    procedure ActionExecuteExecute(Sender: TObject);
  private
    FTreeHelper: THelperElement;
    procedure RecreateTreeHelper;
    procedure ReloadReports;
  protected
    function GetSelectedId: TDataGid; override;
    function GetSelectedText: String; override;
    function GetList: TVirtualStringTree; override;
    function GetInstanceOfReport(AGid: TDataGid): TCBaseReport;
  public
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
  end;

implementation

uses CDataObjects, CFrameFormUnit, CProductFormUnit, CConfigFormUnit,
     CInfoFormUnit;

{$R *.dfm}

const CNoImage = -1;

procedure TCReportsFrame.ReloadReports;
begin
  ReportList.BeginUpdate;
  ReportList.Clear;
  RecreateTreeHelper;
  ReportList.RootNodeCount := FTreeHelper.Count;
  ReportListFocusChanged(ReportList, ReportList.FocusedNode, 0);
  ReportList.EndUpdate;
end;

procedure TCReportsFrame.ReportListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var xData: THelperElement;
begin
  if Node <> Nil then begin
    xData := THelperElement(ReportList.GetNodeData(Node)^);
    CButtonExecute.Enabled := xData.isReport;
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOk.Enabled := xData.isReport;
    end;
  end else begin
    CButtonExecute.Enabled := False;
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOk.Enabled := False;
    end;
  end;
end;

procedure TCReportsFrame.RecreateTreeHelper;
var xBase: THelperElement;
    xIncomes: THelperElement;
    xExpenses: THelperElement;
    xStats: THelperElement;
begin
  xBase := THelperElement.Create(False, 'Podstawowe', '1', '', CNoImage);
  FTreeHelper.Add(xBase);
  xBase.Add(THelperElement.Create(True, 'Stan kont' , '1_01', 'Pokazuje stan wszystkich kont na wybrany dzie�', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Operacje wykonane' , '1_02', 'Pokazuje operacje wykonane w wybranym okresie', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Operacje zaplanowane' , '1_03', 'Pokazuje operacje zaplanowane na wybrany okres', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Przep�yw got�wki' , '1_04', 'Pokazuje przep�yw got�wki mi�dzy kontami/kontrahentami w wybranym okresie', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Historia konta' , '1_05', 'Pokazuje histori� wybranego konta w wybranym okresie', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Wykres stanu kont' , '1_06', 'Pokazuje wykres stanu kont w wybranym okresie', CNoImage));

  xExpenses := THelperElement.Create(False, 'Rozchody', '2', '', CNoImage);
  FTreeHelper.Add(xExpenses);
  xExpenses.Add(THelperElement.Create(True, 'Lista operacji rozchodowych' , '2_01', 'Pokazuje operacje rozchodowe w wybranym okresie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Wykres rozchod�w wed�ug kategorii' , '2_02', 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Wykres rozchod�w wed�ug kontrahent�w' , '2_03', 'Pokazuje operacje rozchodowe w rozbiciu na kontrahent�w', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Lista rozchod�w wed�ug kategorii' , '2_04', 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Lista rozchod�w wed�ug kontrahent�w' , '2_05', 'Pokazuje operacje rozchodowe w rozbiciu na kontrahent�w', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Wykres sum dziennych rozchod�w' , '2_06', 'Pokazuje sumy dzienne dla rozchod�w w wybranym okresie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Wykres sum tygodniowych rozchod�w' , '2_07', 'Pokazuje sumy tygodniowe dla rozchod�w w wybranym okresie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Wykres sum miesi�cznych rozchod�w' , '2_08', 'Pokazuje sumy miesi�czne dla rozchod�w w wybranym okresie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Lista sum dziennych rozchod�w' , '2_09', 'Pokazuje sumy dzienne dla rozchod�w w wybranym okresie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Lista sum tygodniowych rozchod�w' , '2_10', 'Pokazuje sumy tygodniowe dla rozchod�w w wybranym okresie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Lista sum miesi�cznych rozchod�w' , '2_11', 'Pokazuje sumy miesi�czne dla rozchod�w w wybranym okresie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Podsumowanie rozchod�w' , '4_05', 'Pokazuje podsumowanie wybranego okresu', CNoImage));

  xIncomes := THelperElement.Create(False, 'Przychody', '3', '', CNoImage);
  FTreeHelper.Add(xIncomes);
  xIncomes.Add(THelperElement.Create(True, 'Lista operacji przychodowych' , '3_01', 'Pokazuje operacje przychodowe w wybranym okresie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Wykres przychod�w wed�ug kategorii' , '3_02', 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Wykres przychod�w wed�ug kontrahent�w' , '3_03', 'Pokazuje operacje przychodowe w rozbiciu na kontrahent�w', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Lista przychod�w wed�ug kategorii' , '3_04', 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Lista przychod�w wed�ug kontrahent�w' , '3_05', 'Pokazuje operacje przychodowe w rozbiciu na kontrahent�w', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Wykres sum dziennych przychod�w' , '3_06', 'Pokazuje sumy dzienne dla przychod�w w wybranym okresie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Wykres sum tygodniowych przychod�w' , '3_07', 'Pokazuje sumy tygodniowe dla przychod�w w wybranym okresie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Wykres sum miesi�cznych przychod�w' , '3_08', 'Pokazuje sumy miesi�czne dla przychod�w w wybranym okresie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Lista sum dziennych przychod�w' , '3_10', 'Pokazuje sumy dzienne dla przychod�w w wybranym okresie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Lista sum tygodniowych przychod�w' , '3_11', 'Pokazuje sumy tygodniowe dla przychod�w w wybranym okresie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Lista sum miesi�cznych przychod�w' , '3_12', 'Pokazuje sumy miesi�czne dla przychod�w w wybranym okresie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Podsumowanie przychod�w' , '4_05', 'Pokazuje podsumowanie wybranego okresu', CNoImage));


  xStats := THelperElement.Create(False, 'Statystyki', '4', '', CNoImage);
  FTreeHelper.Add(xStats);
  xStats.Add(THelperElement.Create(True, '�rednie dzienne' , '4_01', 'Pokazuje �rednie dzienne rozchody/przychody w wybranym okresie', CNoImage));
  xStats.Add(THelperElement.Create(True, '�rednie tygodniowe' , '4_02', 'Pokazuje �rednie tygodniowe rozchody/przychody w wybranym okresie', CNoImage));
  xStats.Add(THelperElement.Create(True, '�rednie miesi�czne' , '4_03', 'Pokazuje �rednie tygodniowe rozchody/przychody w wybranym okresie', CNoImage));
  xStats.Add(THelperElement.Create(True, 'Trendy' , '4_04', 'Pokazuje trendy rozchod�w i przychod�w dla wybranego okresu', CNoImage));
  xStats.Add(THelperElement.Create(True, 'Podsumowanie' , '4_05', 'Pokazuje podsumowanie statystyczne wybranego okresu', CNoImage));
end;

destructor TCReportsFrame.Destroy;
begin
  FTreeHelper.Free;
  inherited Destroy;
end;

class function TCReportsFrame.GetTitle: String;
begin
  Result := 'Raporty';
end;

procedure TCReportsFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AAdditionalData, AOutputData, AMultipleCheck);
  FTreeHelper := THelperElement.Create(False, '', '', '', CNoImage);
  ReloadReports;
end;

procedure TCReportsFrame.ReportListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var xTreeList: THelperElement;
    xTreeObject: THelperElement;
begin
  if ParentNode = Nil then begin
    xTreeList := FTreeHelper;
  end else begin
    xTreeList := THelperElement(ReportList.GetNodeData(ParentNode)^);
  end;
  xTreeObject := THelperElement(xTreeList.Items[Node.Index]);
  THelperElement(ReportList.GetNodeData(Node)^) := xTreeObject;
  if xTreeObject.Count > 0 then begin
    InitialStates := InitialStates + [ivsHasChildren, ivsExpanded];
  end;
end;

procedure TCReportsFrame.ReportListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(THelperElement);
end;

procedure TCReportsFrame.ReportListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var xData: THelperElement;
begin
  xData := THelperElement(ReportList.GetNodeData(Node)^);
  ChildCount := xData.Count;
end;

procedure TCReportsFrame.ReportListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: THelperElement;
begin
  xData := THelperElement(ReportList.GetNodeData(Node)^);
  CellText := xData.name;
end;

procedure TCReportsFrame.ReportListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: THelperElement;
begin
  xData := THelperElement(ReportList.GetNodeData(Node)^);
  HintText := xData.desc;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCReportsFrame.ReportListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  with TargetCanvas do begin
    if not Odd(Sender.AbsoluteIndex(Node)) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    EraseAction := eaColor;
  end;
end;

procedure TCReportsFrame.ReportListDblClick(Sender: TObject);
begin
  if ReportList.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end else begin
      if CButtonExecute.Enabled then begin
        ActionExecute.Execute;
      end;
    end;
  end;
end;

function TCReportsFrame.GetList: TVirtualStringTree;
begin
  Result := ReportList;
end;

function TCReportsFrame.GetSelectedId: TDataGid;
begin
  Result := '';
  if ReportList.FocusedNode <> Nil then begin
    Result := THelperElement(ReportList.GetNodeData(ReportList.FocusedNode)^).id;
  end;
end;

function TCReportsFrame.GetSelectedText: String;
begin
  Result := '';
  if ReportList.FocusedNode <> Nil then begin
    Result := THelperElement(ReportList.GetNodeData(ReportList.FocusedNode)^).name;
  end;
end;

constructor THelperElement.Create(AIsReport: Boolean; AName: String; AId: TDataGid; ADesc: String; AImage: Integer);
begin
  inherited Create(True);
  FisReport := AIsReport;
  Fid := AId;
  Fname := AName;
  Fdesc := ADesc;
  Fimage := AImage;
end;

procedure TCReportsFrame.ActionExecuteExecute(Sender: TObject);
var xReport: TCBaseReport;
    xGid: TDataGid;
begin
  xGid := GetSelectedId;
  if xGid <> CEmptyDataGid then begin
    xReport := GetInstanceOfReport(xGid);
    if xReport <> Nil then begin
      xReport.ShowReport;
      xReport.Free;
    end else begin
      ShowInfo(itError, 'Wybrany raport nie jest jeszcze dost�pny', '')
    end;
  end;
end;

function TCReportsFrame.GetInstanceOfReport(AGid: TDataGid): TCBaseReport;
begin
  if AGid = '1_01' then begin
    Result := TAccountBalanceOnDayReport.CreateReport(Nil);
  end else if AGid = '1_02' then begin
    Result := TDoneOperationsListReport.CreateReport(Nil);
  end else if AGid = '1_03' then begin
    Result := TPlannedOperationsListReport.CreateReport(Nil);
  end else if AGid = '1_04' then begin
    Result := TCashFlowListReport.CreateReport(Nil);
  end else if AGid = '1_05' then begin
    Result := TAccountHistoryReport.CreateReport(Nil);
  end else if AGid = '1_06' then begin
    Result := TAccountBalanceChartReport.CreateReport(Nil);
  end else if AGid = '2_01' then begin
    Result := TOperationsListReport.CreateReport(TCSelectedMovementTypeParams.Create(COutMovement));
  end else if AGid = '2_02' then begin
    Result := TOperationsByCategoryChart.CreateReport(TCSelectedMovementTypeParams.Create(COutMovement));
  end else if AGid = '2_03' then begin
    Result := TOperationsByCashpointChart.CreateReport(TCSelectedMovementTypeParams.Create(COutMovement));
  end else if AGid = '2_04' then begin
    Result := TOperationsByCategoryList.CreateReport(TCSelectedMovementTypeParams.Create(COutMovement));
  end else if AGid = '2_05' then begin
    Result := TOperationsByCashpointList.CreateReport(TCSelectedMovementTypeParams.Create(COutMovement));
  end else if AGid = '3_01' then begin
    Result := TOperationsListReport.CreateReport(TCSelectedMovementTypeParams.Create(CInMovement));
  end else if AGid = '3_02' then begin
    Result := TOperationsByCategoryChart.CreateReport(TCSelectedMovementTypeParams.Create(CInMovement));
  end else if AGid = '3_03' then begin
    Result := TOperationsByCashpointChart.CreateReport(TCSelectedMovementTypeParams.Create(CInMovement));
  end else if AGid = '3_04' then begin
    Result := TOperationsByCategoryList.CreateReport(TCSelectedMovementTypeParams.Create(CInMovement));
  end else if AGid = '3_05' then begin
    Result := TOperationsByCashpointList.CreateReport(TCSelectedMovementTypeParams.Create(CInMovement));
  end else begin
    Result := Nil;
  end;
end;

end.
