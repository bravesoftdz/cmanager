unit CDoneFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, StdCtrls, ExtCtrls, VirtualTrees,
  ActnList, CComponents, CDatabase, Menus, VTHeaderPopup, GraphUtil, AdoDb,
  Contnrs, CDataObjects;

type
  TDoneFrameAdditionalData = class
  private
    FmovementType: TBaseEnumeration;
  public
    constructor Create(AMovementType: TBaseEnumeration);
  published
    property movementType: TBaseEnumeration read FmovementType;
  end;

  TCDoneFrame = class(TCBaseFrame)
    PanelFrameButtons: TPanel;
    DoneList: TVirtualStringTree;
    ActionList: TActionList;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    Panel: TPanel;
    CStaticFilter: TCStatic;
    Panel2: TPanel;
    Splitter1: TSplitter;
    SumList: TVirtualStringTree;
    Label2: TLabel;
    Label1: TLabel;
    CStaticPeriod: TCStatic;
    Label3: TLabel;
    CDateTimePerStart: TCDateTime;
    Label4: TLabel;
    CDateTimePerEnd: TCDateTime;
    Label5: TLabel;
    procedure DoneListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure DoneListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure DoneListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure DoneListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DoneListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure DoneListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure DoneListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticFilterChanged(Sender: TObject);
    procedure SumListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure SumListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure SumListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure SumListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CDateTimePerStartChanged(Sender: TObject);
    procedure DoneListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  private
    FPlannedObjects: TDataObjectList;
    FDoneObjects: TDataObjectList;
    FSumObjects: TSumList;
    FTreeObjects: TObjectList;
    procedure UpdateCustomPeriod;
    function FindPlannedDone(APlannedMovement: TPlannedMovement; ATriggerDate: TDateTime): TPlannedDone;
  protected
    procedure WndProc(var Message: TMessage); override;
    function GetList: TVirtualStringTree; override;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
    procedure RecreatePlannedMovements(AMovement: TPlannedMovement; AFromDate, AToDate: TDateTime);
    function GetSelectedId: ShortString; override;
    function GetSelectedText: String; override;
  public
    procedure ReloadDone;
    procedure RecreateTreeHelper;
    constructor Create(AOwner: TComponent); override;
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function FindNode(ADataId: ShortString; AList: TVirtualStringTree): PVirtualNode; override;
  end;

implementation

uses CFrameFormUnit, CInfoFormUnit, CConfigFormUnit, CDataobjectFormUnit,
  CAccountsFrameUnit, DateUtils, CListFrameUnit, DB, CMovementFormUnit,
  Math;

{$R *.dfm}

type
  TPlannedTreeItem = class(TObject)
  private
    FPlanned: TPlannedMovement;
    FDone: TPlannedDone;
    FtriggerDate: TDateTime;
  public
    constructor Create(APlanned: TPlannedMovement; ADone: TPlannedDone; ATriggerDate: TDateTime);
  published
    property planned: TPlannedMovement read FPlanned write FPlanned;
    property done: TPlannedDone read FDone write FDone;
    property triggerDate: TDateTime read FtriggerDate write FtriggerDate;
  end;


constructor TCDoneFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPlannedObjects := Nil;
  FDoneObjects := Nil;
  FSumObjects := TSumList.Create(True);
  FTreeObjects := TObjectList.Create(True);
end;

procedure TCDoneFrame.ReloadDone;
var xSqlPlanned, xSqlDone: String;
    xDf, xDt: TDateTime;
    xOvr: TSumElement;
begin
  xSqlPlanned := 'select plannedMovement.*, (select count(*) from plannedDone where plannedDone.idplannedMovement = plannedMovement.idplannedMovement) as doneCount from plannedMovement where isActive = true ';
  if CStaticFilter.DataId = '2' then begin
    xSqlPlanned := xSqlPlanned + Format(' and movementType = ''%s''', [COutMovement]);
  end else if CStaticFilter.DataId = '3' then begin
    xSqlPlanned := xSqlPlanned + Format(' and movementType = ''%s''', [CInMovement]);
  end;
  GetFilterDates(xDf, xDt);
  xSqlPlanned := xSqlPlanned + Format(' and (' +
                        '  (scheduleType = ''O'' and scheduleDate between %s and %s and (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement) = 0) or ' +
                        '  (scheduleType = ''C'' and scheduleDate <= %s)' +
                        ' )', [DatetimeToDatabase(xDf), DatetimeToDatabase(xDt), DatetimeToDatabase(xDt)]);
  xSqlPlanned := xSqlPlanned + Format(' and (' +
                        '  (endCondition = ''N'') or ' +
                        '  (endCondition = ''D'' and endDate >= %s) or ' +
                        '  (endCondition = ''T'' and endCount > (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement)) ' +
                        ' )', [DatetimeToDatabase(xDf)]);
  xSqlDone := Format('select * from plannedDone where triggerDate between %s and %s', [DatetimeToDatabase(xDf), DatetimeToDatabase(xDt)]);
  if FPlannedObjects <> Nil then begin
    FreeAndNil(FPlannedObjects);
  end;
  if FDoneObjects <> Nil then begin
    FreeAndNil(FDoneObjects);
  end;
  FPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, xSqlPlanned);
  FDoneObjects := TDataObject.GetList(TPlannedDone, PlannedDoneProxy, xSqlDone);
  if AdditionalData = Nil then begin
    FSumObjects.Clear;
    xOvr := TSumElement.Create;
    xOvr.id := '*';
    xOvr.name := 'Og�em dla wszystkich kont';
    xOvr.cashIn := 0;
    xOvr.cashOut := 0;
    FSumObjects.Add(xOvr);
  end;
  RecreateTreeHelper;
  DoneList.BeginUpdate;
  DoneList.Clear;
  DoneList.RootNodeCount := FTreeObjects.Count;
  DoneList.EndUpdate;
  SumList.BeginUpdate;
  if AdditionalData = Nil then begin
    SumList.Clear;
    SumList.RootNodeCount := FSumObjects.Count;
    SumList.EndUpdate;
  end;
end;

procedure TCDoneFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer);
var xDf, xDe: TDateTime;
begin
  inherited InitializeFrame(AAdditionalData, AOutputData);
  UpdateCustomPeriod;
  GetFilterDates(xDf, xDe);
  CDateTimePerStart.Value := xDf;
  CDateTimePerEnd.Value := xDe;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
  if AAdditionalData <> Nil then begin
    PanelFrameButtons.Visible := False;
    Splitter1.Visible := False;
    CStaticFilter.HotTrack := False;
    if TDoneFrameAdditionalData(AAdditionalData).movementType = COutMovement then begin
      CStaticFilter.DataId := '2';
      CStaticFilter.Caption := '<rozch�d>';
    end else begin
      CStaticFilter.DataId := '3';
      CStaticFilter.Caption := '<przych�d>';
    end;
  end;
  ReloadDone;
end;

destructor TCDoneFrame.Destroy;
begin
  FPlannedObjects.Free;
  FDoneObjects.Free;
  FSumObjects.Free;
  FTreeObjects.Free;
  inherited Destroy;
end;

procedure TCDoneFrame.DoneListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TPlannedTreeItem(DoneList.GetNodeData(Node)^) := TPlannedTreeItem(FTreeObjects.Items[Node.Index]);
end;

procedure TCDoneFrame.DoneListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TPlannedTreeItem);
end;

procedure TCDoneFrame.DoneListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TPlannedTreeItem;
begin
  xData := TPlannedTreeItem(DoneList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := IntToStr(Node.Index + 1);
  end else if Column = 1 then begin
    CellText := xData.planned.description;
  end else if Column = 2 then begin
    CellText := DateToStr(xData.triggerDate);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.planned.cash);
  end else if Column = 4 then begin
    if (xData.planned.movementType = CInMovement) then begin
      CellText := 'Przych�d';
    end else if (xData.planned.movementType = COutMovement) then begin
      CellText := 'Rozch�d';
    end;
  end;
end;

procedure TCDoneFrame.DoneListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    with Sender do begin
      if SortColumn <> Column then begin
        SortColumn := Column;
        SortDirection := sdAscending;
      end else begin
        case SortDirection of
          sdAscending: SortDirection := sdDescending;
          sdDescending: SortDirection := sdAscending;
        end;
      end;
    end;
  end;
end;

procedure TCDoneFrame.DoneListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TPlannedTreeItem;
    xData2: TPlannedTreeItem;
begin
  xData1 := TPlannedTreeItem(DoneList.GetNodeData(Node1)^);
  xData2 := TPlannedTreeItem(DoneList.GetNodeData(Node2)^);
  if Column = 0 then begin
    if Node1.Index > Node2.Index then begin
      Result := 1;
    end else if Node1.Index < Node2.Index then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 1 then begin
    Result := AnsiCompareText(xData1.planned.description, xData2.planned.description);
  end else if Column = 2 then begin
    if xData1.triggerDate > xData2.triggerDate then begin
      Result := 1;
    end else if xData1.triggerDate < xData2.triggerDate then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 3 then begin
    if xData1.planned.cash > xData2.planned.cash then begin
      Result := 1;
    end else if xData1.planned.cash < xData2.planned.cash then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 4 then begin
    Result := AnsiCompareText(xData1.planned.movementType, xData2.planned.movementType);
  end;
end;

procedure TCDoneFrame.DoneListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TPlannedTreeItem;
begin
  xData := TPlannedTreeItem(DoneList.GetNodeData(Node)^);
  HintText := xData.planned.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCDoneFrame.DoneListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  with TargetCanvas do begin
    if not Odd(Node.Index) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    EraseAction := eaColor;
  end;
end;

function TCDoneFrame.GetList: TVirtualStringTree;
begin
  Result := DoneList;
end;

procedure TCDoneFrame.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAREFRESH then begin
      ReloadDone;
    end;
  end;
end;

class function TCDoneFrame.GetTitle: String;
begin
  Result := 'Operacje zaplanowane';
end;

function TCDoneFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xOt, xFt: String;
    xDf, xDt: TDateTime;
begin
  xOt := TPlannedTreeItem(AObject).planned.movementType;
  if CStaticFilter.DataId = '2' then begin
    xFt := COutMovement;
  end else if CStaticFilter.DataId = '3' then begin
    xFt := CInMovement;
  end else begin
    xFt := '';
  end;
  Result := (Pos(xOt, xFt) > 0) or (xFt = '');
  if Result then begin
    GetFilterDates(xDf, xDt);
    Result := (xDf <= TPlannedTreeItem(AObject).triggerDate) and (TPlannedTreeItem(AObject).triggerDate <= xDt);
  end;
end;

procedure TCDoneFrame.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('1=<dowolny typ>');
  xList.Add('2=<rozch�d>');
  xList.Add('3=<przych�d>');
  xGid := CEmptyDataGid;
  xText := '';
  xRect := Rect(10, 10, 200, 300);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

procedure TCDoneFrame.CStaticFilterChanged(Sender: TObject);
begin
  UpdateCustomPeriod;
  ReloadDone;
end;

procedure TCDoneFrame.SumListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  with TargetCanvas do begin
    if not Odd(Node.Index) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    EraseAction := eaColor;
  end;
end;

procedure TCDoneFrame.SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TSumElement;
    xData2: TSumElement;
begin
  xData1 := TSumElement(SumList.GetNodeData(Node1)^);
  xData2 := TSumElement(SumList.GetNodeData(Node2)^);
  if (xData1.id = '*') then begin
    if TVirtualStringTree(Sender).Header.SortDirection = sdAscending then begin
      Result := -1;
    end else begin
      Result := 1;
    end;
  end else if (xData2.id = '*') then begin
    if TVirtualStringTree(Sender).Header.SortDirection = sdAscending then begin
      Result := 1;
    end else begin
      Result := -1;
    end;
  end else begin
    if Column = 0 then begin
      Result := AnsiCompareText(xData1.name, xData2.name);
    end else if Column = 1 then begin
      if xData1.cashOut > xData2.cashOut then begin
        Result := 1;
      end else if xData1.cashOut < xData2.cashOut then begin
        Result := -1;
      end else begin
        Result := 0;
      end;
    end else if Column = 2 then begin
      if xData1.cashIn > xData2.cashIn then begin
        Result := 1;
      end else if xData1.cashIn < xData2.cashIn then begin
        Result := -1;
      end else begin
        Result := 0;
      end;
    end else if Column = 3 then begin
      if (xData1.cashIn - xData1.cashOut) > (xData2.cashIn - xData2.cashOut) then begin
        Result := 1;
      end else if (xData1.cashIn - xData1.cashOut) < (xData2.cashIn - xData2.cashOut) then begin
        Result := -1;
      end else begin
        Result := 0;
      end;
    end;
  end;
end;

procedure TCDoneFrame.SumListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TSumElement);
end;

procedure TCDoneFrame.SumListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TSumElement;
begin
  xData := TSumElement(SumList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := xData.name;
  end else if Column = 1 then begin
    CellText := CurrencyToString(xData.cashOut);
  end else if Column = 2 then begin
    CellText := CurrencyToString(xData.cashIn);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.cashIn - xData.cashOut);
  end;
end;

procedure TCDoneFrame.SumListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    with Sender do begin
      if SortColumn <> Column then begin
        SortColumn := Column;
        SortDirection := sdAscending;
      end else begin
        case SortDirection of
          sdAscending: SortDirection := sdDescending;
          sdDescending: SortDirection := sdAscending;
        end;
      end;
    end;
  end;
end;

procedure TCDoneFrame.SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TSumElement(SumList.GetNodeData(Node)^) := TSumElement(FSumObjects.Items[Node.Index]);
end;

procedure TCDoneFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('1=<tylko dzi�>');
  xList.Add('2=<w tym tygodni>');
  xList.Add('3=<w tym miesi�cu>');
  xList.Add('4=<ostatnie 7 dni>');
  xList.Add('5=<ostatnie 14 dni>');
  xList.Add('6=<ostatnie 30 dni>');
  xList.Add('7=<w przysz�ym tygodni>');
  xList.Add('8=<w przysz�ym miesi�cu>');
  xList.Add('9=<nast�pne 7 dni>');
  xList.Add('10=<nast�pne 14 dni>');
  xList.Add('11=<nast�pne 30 dni>');
  xList.Add('12=<dowolny>');
  xGid := CEmptyDataGid;
  xText := '';
  xRect := Rect(10, 10, 200, 400);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

procedure TCDoneFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
var xId: TDataGid;
begin
  ADateFrom := 0;
  ADateTo := 0;
  xId := CStaticPeriod.DataId;
  if xId = '1' then begin
    ADateFrom := GWorkDate;
    ADateTo := GWorkDate;
  end else if xId = '2' then begin
    ADateFrom := StartOfTheWeek(GWorkDate);
    ADateTo := EndOfTheWeek(GWorkDate);
  end else if xId = '3' then begin
    ADateFrom := StartOfTheMonth(GWorkDate);
    ADateTo := EndOfTheMonth(GWorkDate);
  end else if xId = '4' then begin
    ADateFrom := IncDay(GWorkDate, -6);
    ADateTo := GWorkDate;
  end else if xId = '5' then begin
    ADateFrom := IncDay(GWorkDate, -13);
    ADateTo := GWorkDate;
  end else if xId = '6' then begin
    ADateFrom := IncDay(GWorkDate, -29);
    ADateTo := GWorkDate;
  end else if xId = '7' then begin
    ADateFrom := StartOfTheWeek(IncDay(GWorkDate, 7));
    ADateTo := EndOfTheWeek(IncDay(GWorkDate, 7));
  end else if xId = '8' then begin
    ADateFrom := StartOfTheMonth(IncDay(EndOfTheMonth(GWorkDate), 1));
    ADateTo := EndOfTheMonth(IncDay(EndOfTheMonth(GWorkDate), 1));
  end else if xId = '9' then begin
    ADateFrom := GWorkDate;
    ADateTo := IncDay(GWorkDate, 6);
  end else if xId = '10' then begin
    ADateFrom := GWorkDate;
    ADateTo := IncDay(GWorkDate, 13);
  end else if xId = '11' then begin
    ADateFrom := GWorkDate;
    ADateTo := IncDay(GWorkDate, 29);
  end else if xId = '12' then begin
    ADateFrom := CDateTimePerStart.Value;
    ADateTo := CDateTimePerEnd.Value;
  end;
end;

procedure TCDoneFrame.UpdateCustomPeriod;
var xF, xE: TDateTime;
begin
  CDateTimePerStart.HotTrack := CStaticPeriod.DataId = '12';
  CDateTimePerEnd.HotTrack := CStaticPeriod.DataId = '12';
  if CStaticPeriod.DataId <> '12' then begin
    GetFilterDates(xF, xE);
    CDateTimePerStart.Value := xF;
    CDateTimePerEnd.Value := xE;
  end;
end;

procedure TCDoneFrame.CDateTimePerStartChanged(Sender: TObject);
begin
  ReloadDone;
end;

constructor TPlannedTreeItem.Create(APlanned: TPlannedMovement; ADone: TPlannedDone; ATriggerDate: TDateTime);
begin
  inherited Create;
  FPlanned := APlanned;
  FDone := ADone;
  FtriggerDate := ATriggerDate;
end;

procedure TCDoneFrame.RecreateTreeHelper;
var xCount: Integer;
    xDF, xDT: TDateTime;
begin
  FTreeObjects.Clear;
  GetFilterDates(xDF, xDT);
  for xCount := 0 to FPlannedObjects.Count - 1 do begin
    RecreatePlannedMovements(TPlannedMovement(FPlannedObjects.Items[xCount]), xDF, xDT);
  end;
end;

procedure TCDoneFrame.RecreatePlannedMovements(AMovement: TPlannedMovement; AFromDate, AToDate: TDateTime);
var xCurDate: TDateTime;
    xValid: Boolean;
    xTimes: Integer;
    xElement: TPlannedTreeItem;
    xDone: TPlannedDone;
    xSum: TSumElement;
begin
  xCurDate := AFromDate;
  xTimes := AMovement.doneCount;
  while (xCurDate <= AToDate) do begin
    if AMovement.scheduleType = CScheduleTypeOnce then begin
      xValid := AMovement.scheduleDate = xCurDate;
    end else begin
      if AMovement.triggerType = CTriggerTypeWeekly then begin
        xValid := DayOfTheWeek(xCurDate) = (AMovement.triggerDay + 1);
      end else begin
        xValid := (DayOfTheMonth(xCurDate) = AMovement.triggerDay) or ((DayOfTheMonth(xCurDate) = DaysInMonth(xCurDate)) and (AMovement.triggerDay = 0));
      end;
      if AMovement.endCondition = CEndConditionTimes then begin
        xValid := xValid and (xTimes < AMovement.endCount);
        if xValid then begin
          Inc(xTimes);
        end;
      end else if AMovement.endCondition = CEndConditionDate then begin
        xValid := xValid and (xCurDate <= AMovement.endDate);
      end;
    end;
    if xValid then begin
      xDone := FindPlannedDone(AMovement, xCurDate);
      xElement := TPlannedTreeItem.Create(AMovement, xDone, xCurDate);
      FTreeObjects.Add(xElement);
      if AdditionalData = Nil then begin
        xSum := FSumObjects.FindSumObject('*', True);
        xSum.cashIn := IfThen(AMovement.movementType = CInMovement, AMovement.cash, 0);
        xSum.cashOut := IfThen(AMovement.movementType = COutMovement, AMovement.cash, 0);
        xSum := FSumObjects.FindSumObject(AMovement.idAccount, False);
        if xSum = Nil then begin
          xSum := TSumElement.Create;
          xSum.id := AMovement.idAccount;
          if xSum.id = CEmptyDataGid then begin
            xSum.name := 'Bez zdefiniowanego konta';
          end else begin
            xSum.name := TAccount(TAccount.LoadObject(AccountProxy, AMovement.idAccount, False)).name;
          end;
          FSumObjects.Add(xSum);
        end;
        xSum.cashIn := IfThen(AMovement.movementType = CInMovement, AMovement.cash, 0);
        xSum.cashOut := IfThen(AMovement.movementType = COutMovement, AMovement.cash, 0);
      end;
    end;
    xCurDate := IncDay(xCurDate, 1);
  end;
end;

function TCDoneFrame.FindPlannedDone(APlannedMovement: TPlannedMovement; ATriggerDate: TDateTime): TPlannedDone;
var xCount: Integer;
    xCur: TPlannedDone;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= FDoneObjects.Count - 1) do begin
    xCur := TPlannedDone(FDoneObjects.Items[xCount]);
    if (xCur.idPlannedMovement = APlannedMovement.id) and (xCur.triggerDate = ATriggerDate) then begin
      Result := xCur;
    end;
    Inc(xCount);
  end;
end;

constructor TDoneFrameAdditionalData.Create(AMovementType: TBaseEnumeration);
begin
  inherited Create;
  FmovementType := AMovementType;
end;

function TCDoneFrame.GetSelectedId: ShortString;
var xData: TPlannedTreeItem;
begin
  Result := '';
  if DoneList.FocusedNode <> Nil then begin
    xData := TPlannedTreeItem(DoneList.GetNodeData(DoneList.FocusedNode)^);
    Result := xData.planned.id + '|' + DatetimeToDatabase(xData.triggerDate);
  end;
end;

function TCDoneFrame.GetSelectedText: String;
var xData: TPlannedTreeItem;
begin
  Result := '';
  if DoneList.FocusedNode <> Nil then begin
    xData := TPlannedTreeItem(DoneList.GetNodeData(DoneList.FocusedNode)^);
    if xData.planned.movementType = COutMovement then begin
      Result := xData.planned.description + ' (p�atne do ' + DateToStr(xData.triggerDate) + ')'
    end else begin
      Result := xData.planned.description + ' (wp�yw do ' + DateToStr(xData.triggerDate) + ')'
    end;
  end;
end;

procedure TCDoneFrame.DoneListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var xData: TPlannedTreeItem;
    xCanAccept: Boolean;
begin
  xCanAccept := False;
  if Owner.InheritsFrom(TCFrameForm) then begin
    if Node <> Nil then begin
      xData := TPlannedTreeItem(DoneList.GetNodeData(Node)^);
      xCanAccept := xData.done = Nil;
    end;
    TCFrameForm(Owner).BitBtnOk.Enabled := xCanAccept;
  end;
end;

function TCDoneFrame.FindNode(ADataId: ShortString; AList: TVirtualStringTree): PVirtualNode;
var xCurNode: PVirtualNode;
    xDataobject: TPlannedTreeItem;
begin
  Result := Nil;
  xCurNode := AList.GetFirst;
  while (Result = Nil) and (xCurNode <> Nil) do begin
    xDataobject := TPlannedTreeItem(AList.GetNodeData(xCurNode)^);
    if (xDataobject.planned.id + '|' + DatetimeToDatabase(xDataobject.triggerDate)) = ADataId then begin
      Result := xCurNode;
    end else begin
      xCurNode := AList.GetNext(xCurNode);
    end;
  end;
end;

end.
