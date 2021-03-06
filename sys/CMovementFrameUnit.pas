unit CMovementFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, StdCtrls, ExtCtrls, VirtualTrees,
  ActnList, CComponents, CDatabase, Menus, VTHeaderPopup, GraphUtil, AdoDb,
  Contnrs, PngImageList, CImageListsUnit, CDataObjects, Buttons, Math, StrUtils;

type
  TMovementTreeElementType = (mtObject, mtList);

  TMovementTreeElement = class(TTreeObject)
  private
    FelementType: TMovementTreeElementType;
    FcurrencyView: String;
    function GetDescription: String;
    function Getcash: Currency;
    function Getregdate: TDateTime;
    function GetmovementType: TBaseEnumeration;
    function GetidCurrencyDef: TDataGid;
    function GetisStated: Boolean;
    function GetId: TDataGid;
  public
    property elementType: TMovementTreeElementType read FelementType write FelementType;
    property description: String read GetDescription;
    property cash: Currency read Getcash;
    property regDate: TDateTime read Getregdate;
    property idCurrencyDef: TDataGid read GetidCurrencyDef;
    property movementType: TBaseEnumeration read GetmovementType;
    property isStated: Boolean read GetisStated;
    property currencyView: String read FcurrencyView write FcurrencyView;
    property id: TDataGid read GetId;
  end;

  TCMovementFrame = class(TCBaseFrame)
    PanelFrameButtons: TCPanel;
    ActionList: TActionList;
    ActionMovement: TAction;
    ActionEditMovement: TAction;
    ActionDelMovement: TAction;
    Panel1: TCPanel;
    BevelPanel: TCPanel;
    CButtonOut: TCButton;
    CButtonEdit: TCButton;
    CButtonDel: TCButton;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    Splitter1: TSplitter;
    ActionAddList: TAction;
    CButton1: TCButton;
    PopupMenuSums: TPopupMenu;
    Ustawienialisty2: TMenuItem;
    PopupMenuIcons: TPopupMenu;
    MenuItemBigIcons: TMenuItem;
    MenuItemSmallIcons: TMenuItem;
    MenuItemsumsVisible: TMenuItem;
    Panel: TCPanel;
    LabelFilterMovement: TLabel;
    LabelFilterPeriod: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabelFilterCurrency: TLabel;
    CStaticPeriod: TCStatic;
    CStaticFilter: TCStatic;
    CDateTimePerStart: TCDateTime;
    CDateTimePerEnd: TCDateTime;
    CStaticViewCurrency: TCStatic;
    TodayList: TCList;
    PanelSum: TCPanel;
    SumList: TCList;
    Panel2: TCPanel;
    MenuItemPatternsVisible: TMenuItem;
    PanelPatterns: TCPanel;
    Splitter2: TSplitter;
    Panel3: TCPanel;
    QuickpatternList: TCDataList;
    PopupMenuQuickPatterns: TPopupMenu;
    MenuItemQuickpatterns: TMenuItem;
    N4: TMenuItem;
    MenuItemshowUserQuickpatterns: TMenuItem;
    MenuItemStatisticQuickPatterns: TMenuItem;
    ButtonPatternVisible: TCPanel;
    ButtonCloseShortcuts: TCPanel;
    CButtonShowHideFilters: TCPanel;
    Label1: TLabel;
    CStaticFastFilter: TCStatic;
    Label2: TLabel;
    FilterEditDescription: TEdit;
    procedure ActionMovementExecute(Sender: TObject);
    procedure ActionEditMovementExecute(Sender: TObject);
    procedure ActionDelMovementExecute(Sender: TObject);
    procedure TodayListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure TodayListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure TodayListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure TodayListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure TodayListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure TodayListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticFilterChanged(Sender: TObject);
    procedure SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure SumListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure SumListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CDateTimePerStartChanged(Sender: TObject);
    procedure TodayListDblClick(Sender: TObject);
    procedure TodayListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ActionAddListExecute(Sender: TObject);
    procedure TodayListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure SumListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure CStaticViewCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticViewCurrencyChanged(Sender: TObject);
    procedure Ustawienialisty2Click(Sender: TObject);
    procedure TodayListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
    procedure MenuItemBigIconsClick(Sender: TObject);
    procedure MenuItemSmallIconsClick(Sender: TObject);
    procedure ButtonCloseShortcutsClick(Sender: TObject);
    procedure MenuItemsumsVisibleClick(Sender: TObject);
    procedure ButtonClosePatternsClick(Sender: TObject);
    procedure MenuItemPatternsVisibleClick(Sender: TObject);
    procedure ButtonPatternVisibleClick(Sender: TObject);
    procedure QuickpatternListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure QuickpatternListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
    procedure MenuItemQuickpatternsClick(Sender: TObject);
    procedure QuickpatternListClick(Sender: TObject);
    procedure MenuItemshowUserQuickpatternsClick(Sender: TObject);
    procedure MenuItemStatisticQuickPatternsClick(Sender: TObject);
    procedure CButtonShowHideFiltersClick(Sender: TObject);
    procedure FilterEditDescriptionChange(Sender: TObject);
    procedure CStaticFastFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticFastFilterChanged(Sender: TObject);
  private
    FSmallIconsButtonsImageList: TPngImageList;
    FBigIconsButtonsImageList: TPngImageList;
    FTodayObjects: TDataObjectList;
    FTodayLists: TDataObjectList;
    FTreeHelper: TTreeObjectList;
    FSumRoot: TSumElement;
    FQuickPatternElements: TCListDataElement;
    FAdvancedFilterVisible: Boolean;
    procedure MessageMovementAdded(AId: TDataGid; AOption: Integer);
    procedure MessageMovementEdited(AId: TDataGid; AOption: Integer);
    procedure MessageMovementDeleted(AId: TDataGid; AOption: Integer);
    procedure UpdateCustomPeriod;
    procedure RecreateTreeHelper;
    function FindParentMovementList(AListGid: TDataGid): TTreeObjectList;
    function FindObjectNode(ADataGid: TDataGid; AType: Integer): PVirtualNode;
    procedure DeleteObjectsWithMovementList(AListId: TDataGid);
    procedure SetAdvancedFilterVisible(const Value: Boolean);
  protected
    procedure UpdateSumAndPatterns;
    procedure WndProc(var Message: TMessage); override;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
    function GetSelectedType: Integer; override;
    function GetSelectedId: ShortString; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedText: String; override;
    procedure DoRepaintLists; override;
    procedure UpdateIcons;
    procedure ReloadQuickPatterns;
  public
    procedure UpdateButtons(AIsSelectedSomething: Boolean); override;
    function GetList: TCList; override;
    procedure ReloadToday;
    procedure ReloadSums;
    constructor Create(AOwner: TComponent); override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    class function GetPrefname: String; override;
    procedure SaveFramePreferences; override;
    procedure LoadFramePreferences; override;
    property AdvancedFilterVisible: Boolean read FAdvancedFilterVisible write SetAdvancedFilterVisible;
    procedure ShowFrame; override;
    procedure HideFrame; override;
  end;

implementation

uses CFrameFormUnit, CInfoFormUnit, CConfigFormUnit, CDataobjectFormUnit,
  CAccountsFrameUnit, DateUtils, CListFrameUnit, DB, CMovementFormUnit,
  Types, CDoneFormUnit, CDoneFrameUnit, CConsts, CPreferences,
  CListPreferencesFormUnit, CReports, CMovmentListElementFormUnit,
  CMovementListFormUnit, CTools, CPluginConsts, CDatatools,
  CFilterDetailFrameUnit, CDebug;

{$R *.dfm}

procedure TCMovementFrame.ActionMovementExecute(Sender: TObject);
var xForm: TCMovementForm;
    xBase: TMovementTreeElement;
    xObject: TBaseMovement;
begin
  xForm := TCMovementForm.Create(Nil);
  xObject := Nil;
  if (GetKeyState(VK_CONTROL) < 0) and (TodayList.FocusedNode <> Nil) then begin
    xBase := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^);
    if xBase.elementType = mtObject then begin
      xObject := TBaseMovement(xBase.Dataobject);
    end;
  end;
  xForm.ShowDataobject(coAdd, BaseMovementProxy, xObject, True);
  xForm.Free;
end;

function SortByDate(AItem1, AItem2: Pointer): Integer;
begin
  if TTreeObject(AItem1).Dataobject.created > TTreeObject(AItem2).Dataobject.created then begin
    Result := 1;
  end else if TTreeObject(AItem1).Dataobject.created < TTreeObject(AItem2).Dataobject.created then begin
    Result := -1;
  end else begin
    Result := 0;
  end;
end;

procedure TCMovementFrame.ActionEditMovementExecute(Sender: TObject);
var xForm: TCDataobjectForm;
    xBase: TMovementTreeElement;
    xIsCtrl: Boolean;
begin
  if TodayList.FocusedNode <> Nil then begin
    xIsCtrl := GetAsyncKeyState(VK_CONTROL) < 0;
    xBase := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^);
    if xBase.elementType = mtObject then begin
      xForm := TCMovementForm.Create(Nil);
      if xIsCtrl then begin
        xForm.ShowDataobject(coAdd, BaseMovementProxy, xBase.Dataobject, True);
      end else begin
        xForm.ShowDataobject(coEdit, BaseMovementProxy, xBase.Dataobject, True);
      end;
      xForm.Free;
    end else if xBase.elementType = mtList then begin
      xForm := TCMovementListForm.Create(Nil);
      if xIsCtrl then begin
        xForm.ShowDataobject(coAdd, MovementListProxy, xBase.Dataobject, True);
      end else begin
        xForm.ShowDataobject(coEdit, MovementListProxy, xBase.Dataobject, True);
      end;
      xForm.Free;
    end;
  end;
end;

procedure TCMovementFrame.ActionDelMovementExecute(Sender: TObject);
var xBase: TMovementTreeElement;
    xIdTemp1, xIdTemp2, xIdTemp3, xIdTemp4, xIdTemp5: TDataGid;
begin
  if TodayList.FocusedNode <> Nil then begin
    xBase := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^);
    if xBase.elementType = mtObject then begin
      if TBaseMovement(xBase.Dataobject).isInvestmentMovement then begin
        ShowInfo(itWarning, 'Nie mo�na usun�� operacji, gdy� powsta�a ona na bazie operacji inwestycyjnej', '')
      end else if TBaseMovement(xBase.Dataobject).isDepositMovement then begin
        ShowInfo(itWarning, 'Nie mo�na usun�� operacji, gdy� powsta�a ona na bazie operacji lokat', '')
      end else begin
        if ShowInfo(itQuestion, 'Czy chcesz usun�� wybran� operacj� ?', '') then begin
          xIdTemp1 := xBase.Dataobject.id;
          xIdTemp2 := TBaseMovement(xBase.Dataobject).idAccount;
          xIdTemp3 := TBaseMovement(xBase.Dataobject).idSourceAccount;
          xIdTemp4 :=  TBaseMovement(xBase.Dataobject).idMovementList;
          xIdTemp5 :=  TBaseMovement(xBase.Dataobject).idPlannedDone;
          xBase.Dataobject.DeleteObject;
          GDataProvider.CommitTransaction;
          SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTDELETED, Integer(@xIdTemp1), WMOPT_BASEMOVEMENT);
          SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp2), WMOPT_BASEMOVEMENT);
          if (xIdTemp3 <> CEmptyDataGid) then begin
            SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp3), WMOPT_BASEMOVEMENT);
          end;
          if (xIdTemp4 <> CEmptyDataGid) then begin
            SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp4), WMOPT_MOVEMENTLIST);
          end;
          if xIdTemp5 <> CEmptyDataGid then begin
            SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
          end;
        end;
      end;
    end else if xBase.elementType = mtList then begin
      if ShowInfo(itQuestion, 'Czy chcesz usun�� wybran� list� operacji ?', '') then begin
        xBase := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^);
        xIdTemp1 := xBase.Dataobject.id;
        xIdTemp2 := TMovementList(xBase.Dataobject).idAccount;
        xBase.Dataobject.DeleteObject;
        GDataProvider.CommitTransaction;
        SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTDELETED, Integer(@xIdTemp1), WMOPT_MOVEMENTLIST);
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp2), WMOPT_BASEMOVEMENT);
      end;
    end;
  end;
end;

constructor TCMovementFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTodayObjects := Nil;
  FTodayLists := Nil;
  FAdvancedFilterVisible := False;
  FSumRoot := TSumElement.Create;
  FQuickPatternElements := TCListDataElement.Create(False, QuickpatternList, Nil, True, False);
end;

procedure TCMovementFrame.TodayListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  UpdateButtons(Node <> Nil);
end;

procedure TCMovementFrame.ReloadToday;
var xConditionOperations, xConditionLists: String;
    xDf, xDt: TDateTime;
begin
  TodayList.BeginUpdate;
  TodayList.Clear;
  GetFilterDates(xDf, xDt);
  xConditionOperations := Format('regDate between %s and %s', [DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False)]);
  if CStaticFilter.DataId = '2' then begin
    xConditionOperations := xConditionOperations + Format(' and movementType = ''%s''', [COutMovement]);
  end else if CStaticFilter.DataId = '3' then begin
    xConditionOperations := xConditionOperations + Format(' and movementType = ''%s''', [CInMovement]);
  end else if CStaticFilter.DataId = '4' then begin
    xConditionOperations := xConditionOperations + ' and movementType = ''' + CTransferMovement + '''';
  end;
  if FilterEditDescription.Text <> '' then begin
    xConditionOperations := xConditionOperations + ' and description like ''%' + FilterEditDescription.Text + '%''';
  end;
  xConditionLists := xConditionOperations;
  if CStaticFastFilter.DataId <> CEmptyDataGid then begin
    xConditionOperations := xConditionOperations + ' and (' + TMovementFilter.GetFilterCondition(CStaticFastFilter.DataId, False, 'idAccount', 'idCashpoint', 'idProduct') + ')';
    xConditionLists := xConditionLists + ' and (' + TMovementFilter.GetFilterCondition(CStaticFastFilter.DataId, False, 'idAccount', 'idCashpoint', '') + ')';
  end;
  if FTodayObjects <> Nil then begin
    FreeAndNil(FTodayObjects);
  end;
  if FTodayLists <> Nil then begin
    FreeAndNil(FTodayLists);
  end;
  FTodayObjects := TDataObject.GetList(TBaseMovement, BaseMovementProxy, 'select * from StnBaseMovement where ' + xConditionOperations + ' order by created');
  FTodayLists := TDataObject.GetList(TMovementList, MovementListProxy, 'select * from StnMovementList where ' + xConditionLists + ' order by created');
  RecreateTreeHelper;
  TodayList.RootNodeCount := FTreeHelper.Count;
  TodayListFocusChanged(TodayList, TodayList.FocusedNode, 0);
  TodayList.EndUpdate;
end;

procedure TCMovementFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  FSmallIconsButtonsImageList := Nil;
  FBigIconsButtonsImageList := TPngImageList(ActionList.Images);
  CStaticPeriod.DataId := '1';
  FTreeHelper := TTreeObjectList.Create(True);
  UpdateCustomPeriod;
  Label5.Left := Panel.Width - 8;
  CDateTimePerEnd.Left := Label5.Left - CDateTimePerEnd.Width;
  Label4.Left := CDateTimePerEnd.Left - 15;
  CDateTimePerStart.Left := Label4.Left - CDateTimePerStart.Width;
  Label3.Left := CDateTimePerStart.Left - 18;
  LabelFilterPeriod.Left := CStaticViewCurrency.Left + CStaticViewCurrency.Width;
  CStaticPeriod.Left := LabelFilterPeriod.Left + LabelFilterPeriod.Width + 4;
  CDateTimePerStart.Value := GWorkDate;
  CDateTimePerEnd.Value := GWorkDate;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
  AdvancedFilterVisible := False;
  FilterEditDescription.Anchors := [akLeft, akTop, akRight];
  FilterEditDescription.Width := Panel.Width - FilterEditDescription.Left - 16;
  if not AWithButtons then begin
    BevelPanel.Visible := False;
    Panel1.Visible := False;
  end;
  SumList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesMovementListSum]);
  if List.ViewPref <> Nil then begin
    MenuItemSmallIcons.Checked := List.ViewPref.ButtonSmall;
    UpdateIcons;
  end;
  QuickpatternList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesQuickpatternsRun]);
  MenuItemshowUserQuickpatterns.Checked := TBaseMovementFramePref(FramePreferences).userPatternsVisible;
  MenuItemStatisticQuickPatterns.Checked := TBaseMovementFramePref(FramePreferences).statisticPatternsVisible;
  ReloadToday;
  ReloadSums;
  ReloadQuickPatterns;
end;

destructor TCMovementFrame.Destroy;
begin
  if FSmallIconsButtonsImageList <> Nil then begin
    FSmallIconsButtonsImageList.Free;
  end;
  FTreeHelper.Free;
  FTodayObjects.Free;
  FTodayLists.Free;
  FSumRoot.Free;
  FQuickPatternElements.Free;
  inherited Destroy;
end;

procedure TCMovementFrame.TodayListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var xTreeList: TTreeObjectList;
    xTreeObject: TMovementTreeElement;
begin
  if ParentNode = Nil then begin
    xTreeList := FTreeHelper;
  end else begin
    xTreeList := TTreeObject(TodayList.GetNodeData(ParentNode)^).Childobjects;
  end;
  xTreeObject := TMovementTreeElement(xTreeList.Items[Node.Index]);
  TTreeObject(TodayList.GetNodeData(Node)^) := xTreeObject;
  if xTreeObject.Childobjects.Count > 0 then begin
    InitialStates := InitialStates + [ivsHasChildren, ivsExpanded];
  end;
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCMovementFrame.TodayListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TMovementTreeElement);
end;

procedure TCMovementFrame.TodayListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TMovementTreeElement;
begin
  CellText := '';
  xData := TMovementTreeElement(TodayList.GetNodeData(Node)^);
  if Column = 0 then begin
    if TodayList.NodeParent[Node] = Nil then begin
      CellText := IntToStr(Node.Index + 1);
    end;
  end else if Column = 1 then begin
    CellText := GetDescText(xData.description);
  end else if Column = 2 then begin
    CellText := Date2StrDate(xData.regDate);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.cash, xData.idCurrencyDef, False);
  end else if Column = 4 then begin
    CellText := GCurrencyCache.GetSymbol(xData.idCurrencyDef);
  end else if Column = 5 then begin
    if (xData.movementType = CInMovement) then begin
      CellText := CInMovementDescription;
    end else if (xData.movementType = COutMovement) then begin
      CellText := COutMovementDescription;
    end else begin
      CellText := CTransferMovementDescription;
    end;
  end else if Column = 6 then begin
    if xData.movementType = CTransferMovement then begin
      if TBaseMovement(xData.Dataobject).isStated and TBaseMovement(xData.Dataobject).isSourceStated then begin
        CellText := 'Uzgodniona';
      end else begin
        CellText := 'Do uzgodnienia';
      end;
    end else begin
      if xData.isStated then begin
        CellText := 'Uzgodniona';
      end else begin
        CellText := 'Do uzgodnienia';
      end;
    end;
  end;
end;

procedure TCMovementFrame.TodayListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TMovementTreeElement;
    xData2: TMovementTreeElement;
begin
  xData1 := TMovementTreeElement(TodayList.GetNodeData(Node1)^);
  xData2 := TMovementTreeElement(TodayList.GetNodeData(Node2)^);
  if Column = 0 then begin
    if Node1.Index > Node2.Index then begin
      Result := 1;
    end else if Node1.Index < Node2.Index then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 1 then begin
    Result := AnsiCompareText(xData1.description, xData2.description);
  end else if Column = 2 then begin
    if xData1.regDate > xData2.regDate then begin
      Result := 1;
    end else if xData1.regDate < xData2.regDate then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 3 then begin
    if xData1.cash > xData2.cash then begin
      Result := 1;
    end else if xData1.cash < xData2.cash then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 4 then begin
    Result := AnsiCompareText(xData1.idCurrencyDef, xData2.idCurrencyDef);
  end else if Column = 5 then begin
    Result := AnsiCompareText(xData1.movementType, xData2.movementType);
  end;
end;

procedure TCMovementFrame.TodayListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TMovementTreeElement;
begin
  xData := TMovementTreeElement(TodayList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCMovementFrame.MessageMovementAdded(AId: TDataGid; AOption: Integer);
var xDataobject: TDataObject;
    xNode: PVirtualNode;
    xTreeElement: TMovementTreeElement;
    xParent: PVirtualNode;
begin
  if AOption = WMOPT_BASEMOVEMENT then begin
    xDataobject := TBaseMovement.LoadObject(BaseMovementProxy, AId, True);
  end else begin
    xDataobject := TMovementList.LoadObject(MovementListProxy, AId, True);
  end;
  if IsValidFilteredObject(xDataobject) then begin
    xTreeElement := TMovementTreeElement.Create;
    xTreeElement.Dataobject := xDataobject;
    xTreeElement.currencyView := CStaticViewCurrency.DataId;
    if AOption = WMOPT_BASEMOVEMENT then begin
      xTreeElement.elementType := mtObject;
      FTodayObjects.Add(xDataobject);
    end else begin
      xTreeElement.elementType := mtList;
      FTodayLists.Add(xDataobject);
    end;
    if AOption = WMOPT_BASEMOVEMENT then begin
      if TBaseMovement(xDataobject).idMovementList <> CEmptyDataGid then begin
        xParent := FindObjectNode(TBaseMovement(xDataobject).idMovementList, WMOPT_MOVEMENTLIST);
        TMovementTreeElement(TodayList.GetNodeData(xParent)^).Childobjects.Add(xTreeElement);
      end else begin
        xParent := Nil;
        FTreeHelper.Add(xTreeElement);
      end;
    end else begin
      xParent := Nil;
      FTreeHelper.Add(xTreeElement);
    end;
    xNode := TodayList.AddChild(xParent, xTreeElement);
    TodayList.Sort(xNode, TodayList.Header.SortColumn, TodayList.Header.SortDirection);
    TodayList.FocusedNode := xNode;
    TodayList.Selected[xNode] := True;
  end else begin
    xDataobject.Free;
  end;
  ReloadSums;
  if MenuItemStatisticQuickPatterns.Checked then begin
    ReloadQuickPatterns;
  end;
end;

procedure TCMovementFrame.MessageMovementDeleted(AId: TDataGid; AOption: Integer);
var xNode: PVirtualNode;
    xTreeList: TTreeObjectList;
    xData: TMovementTreeElement;
begin
  xNode := FindObjectNode(AId, AOption);
  if xNode <> Nil then begin
    xData := TMovementTreeElement(TodayList.GetNodeData(xNode)^);
    if TodayList.NodeParent[xNode] = Nil then begin
      xTreeList := FTreeHelper;
    end else begin
      xTreeList := TTreeObject(TodayList.GetNodeData(xNode.Parent)^).Childobjects;
    end;
    TodayList.BeginUpdate;
    if AOption = WMOPT_BASEMOVEMENT then begin
      FTodayObjects.Remove(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject);
    end else if AOption = WMOPT_MOVEMENTLIST then begin
      DeleteObjectsWithMovementList(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject.id);
      FTodayLists.Remove(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject)
    end;
    xTreeList.Remove(xData);
    TodayList.DeleteNode(xNode);
    TodayList.EndUpdate;
  end;
  ReloadSums;
  if MenuItemStatisticQuickPatterns.Checked then begin
    ReloadQuickPatterns;
  end;
end;

procedure TCMovementFrame.MessageMovementEdited(AId: TDataGid; AOption: Integer);
var xNode: PVirtualNode;
    xBase: TMovementTreeElement;
    xTreeList: TTreeObjectList;
begin
  xNode := FindObjectNode(AId, AOption);
  if xNode <> Nil then begin
    xBase := TMovementTreeElement(TodayList.GetNodeData(xNode)^);
    xBase.Dataobject.ReloadObject;
    if IsValidFilteredObject(xBase.Dataobject) then begin
      TodayList.InvalidateNode(xNode);
      TodayList.Sort(xNode, TodayList.Header.SortColumn, TodayList.Header.SortDirection);
    end else begin
      if TodayList.NodeParent[xNode] = Nil then begin
        xTreeList := FTreeHelper;
      end else begin
        xTreeList := TTreeObject(TodayList.GetNodeData(xNode.Parent)^).Childobjects;
      end;
      TodayList.BeginUpdate;
      if AOption = WMOPT_BASEMOVEMENT then begin
        FTodayObjects.Remove(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject);
      end else if AOption = WMOPT_MOVEMENTLIST then begin
        DeleteObjectsWithMovementList(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject.id);
        FTodayLists.Remove(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject)
      end;
      xTreeList.Remove(xBase);
      TodayList.DeleteNode(xNode);
      TodayList.EndUpdate;
    end;
  end;
  ReloadSums;
  if MenuItemStatisticQuickPatterns.Checked then begin
    ReloadQuickPatterns;
  end;
end;

function TCMovementFrame.GetList: TCList;
begin
  Result := TodayList;
end;

procedure TCMovementFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementAdded(xDataGid, LParam);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementEdited(xDataGid, LParam);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementDeleted(xDataGid, LParam);
    end else if Msg = WM_NOTIFYMESSAGE then begin
      if LParam = WMOPT_REFRESHQUICKPATTERNS then begin
        ReloadQuickPatterns;
      end;
    end else if Msg = WM_DATAREFRESH then begin
      ReloadToday;
      ReloadSums;
    end;
  end;
end;

class function TCMovementFrame.GetTitle: String;
begin
  Result := 'Operacje wykonane';
end;

function TCMovementFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xOt, xFt: String;
    xDf, xDt: TDateTime;
    xRd:  TDateTime;
    xDesc: String;
begin
  if AObject.InheritsFrom(TBaseMovement) then begin
    xOt := TBaseMovement(AObject).movementType;
    xRd := TBaseMovement(AObject).regDate;
    xDesc := TBaseMovement(AObject).description;
  end else begin
    xOt := TMovementList(AObject).movementType;
    xRd := TMovementList(AObject).regDate;
    xDesc := TMovementList(AObject).description;
  end;
  if CStaticFilter.DataId = '2' then begin
    xFt := COutMovement;
  end else if CStaticFilter.DataId = '3' then begin
    xFt := CInMovement;
  end else if CStaticFilter.DataId = '4' then begin
    xFt := CTransferMovement;
  end else begin
    xFt := '';
  end;
  Result := (Pos(xOt, xFt) > 0) or (xFt = '');
  if Result then begin
    GetFilterDates(xDf, xDt);
    Result := (xDf <= xRd) and (xRd <= xDt);
  end;
  if Result and (FilterEditDescription.Text <> '') then begin
    Result := Pos(AnsiUpperCase(FilterEditDescription.Text), AnsiUpperCase(xDesc)) > 0;
  end;
end;

procedure TCMovementFrame.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('1=<dowolny typ>');
  xList.Add('2=<rozch�d>');
  xList.Add('3=<przych�d>');
  xList.Add('4=<transfer>');
  xGid := CEmptyDataGid;
  xText := '';
  xRect := Rect(10, 10, 200, 300);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

procedure TCMovementFrame.CStaticFilterChanged(Sender: TObject);
begin
  UpdateCustomPeriod;
  ReloadToday;
  ReloadSums;
end;

procedure TCMovementFrame.ReloadSums;
var xDs: TADOQuery;
    xSql: String;
    xObj: TSumElement;
    xPar: TSumElement;
    xDf, xDt: TDateTime;
    xMultiCurrency: Boolean;
    xOneCurrency: TDataGid;
    xSumObj: TSumElement;
    xIs, xEs, xCs, xLikeDesc, xFastCondition: String;
begin
  GetFilterDates(xDf, xDt);
  if CStaticViewCurrency.DataId = CCurrencyViewBaseMovements then begin
    xIs := 'movementIncome';
    xEs := 'movementExpense';
    xCs := 'idMovementCurrencyDef';
  end else begin
    xIs := 'income';
    xEs := 'expense';
    xCs := 'idAccountCurrencyDef';
  end;
  if CStaticFastFilter.DataId <> CEmptyDataGid then begin
    xFastCondition := xFastCondition + ' and (' + TMovementFilter.GetFilterCondition(CStaticFastFilter.DataId, False, 'idAccount', 'idCashpoint', 'idProduct') + ')';
  end else begin
    xFastCondition := '';
  end;
  if FilterEditDescription.Text <> '' then begin
    xLikeDesc := ' and description like ''%' + FilterEditDescription.Text + '%''';
  end else begin
    xLikeDesc := '';
  end;
  xSql := Format('select v.*, a.name from ' +
                 ' (select idAccount, %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses from balances where ' +
                 '   movementType <> ''%s'' and ' +
                 '   regDate between %s and %s %s %s group by idAccount, %s) as v ' +
                 '   left outer join account a on a.idAccount = v.idAccount',
       [xCs, xIs, xEs, CTransferMovement, DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False), xLikeDesc, xFastCondition, xCs]);
  xDs := GDataProvider.OpenSql(xSql);
  xMultiCurrency := IsMultiCurrencyDataset(xDs, 'idCurrencyDef', xOneCurrency);
  SumList.BeginUpdate;
  SumList.Clear;
  FSumRoot.childs.Clear;
  if xMultiCurrency then begin
    xSumObj := Nil;
    while not xDs.Eof do begin
      xObj := FSumRoot.childs.FindSumObjectByCur(xDs.FieldByName('idCurrencyDef').AsString, False);
      if xObj = Nil then begin
        xObj := TSumElement.Create;
        xObj.id := '*';
        xObj.idCurrencyDef := xDs.FieldByName('idCurrencyDef').AsString;
        xObj.cashIn := 0;
        xObj.cashOut := 0;
        xObj.name := 'Razem w ' + GCurrencyCache.GetSymbol(xObj.idCurrencyDef);
        FSumRoot.AddChild(xObj);
      end;
      xDs.Next;
    end;
  end else begin
    xSumObj := TSumElement.Create;
    xSumObj.id := '*';
    xSumObj.idCurrencyDef := xOneCurrency;
    xSumObj.cashIn := 0;
    xSumObj.cashOut := 0;
    xSumObj.name := 'Razem wszystkie operacje';
    FSumRoot.AddChild(xSumObj);
  end;
  xDs.First;
  while not xDs.Eof do begin
    if xMultiCurrency then begin
      xPar := FSumRoot.childs.FindSumObjectByCur(xDs.FieldByName('idCurrencyDef').AsString, False);
    end else begin
      xPar := FSumRoot;
    end;
    if xPar <> Nil then begin
      xObj := xPar.childs.FindSumObjectById(xDs.FieldByName('idAccount').AsString, False);
      if xObj = Nil then begin
        xObj := TSumElement.Create;
        xPar.AddChild(xObj);
      end;
      xObj.id := xDs.FieldByName('idAccount').AsString;
      xObj.name := xDs.FieldByName('name').AsString;
      xObj.cashIn := xObj.cashIn + xDs.FieldByName('incomes').AsCurrency;
      xObj.idCurrencyDef := xDs.FieldByName('idCurrencyDef').AsString;
      xObj.cashOut := xObj.cashOut + xDs.FieldByName('expenses').AsCurrency;
      xPar.cashIn := xPar.cashIn + xObj.cashIn;
      xPar.cashOut := xPar.cashOut + xObj.cashOut;
      if not xMultiCurrency then begin
        with xSumObj do begin
          cashIn := cashIn + xObj.cashIn;
          cashOut := cashOut + xObj.cashOut;
        end;
      end;
    end;
    xDs.Next;
  end;
  SumList.RootNodeCount := FSumRoot.childs.Count;
  SumList.EndUpdate;
  xDs.Free;
end;

procedure TCMovementFrame.SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TSumElement;
    xData2: TSumElement;
begin
  xData1 := TSumElement(SumList.GetNodeData(Node1)^);
  xData2 := TSumElement(SumList.GetNodeData(Node2)^);
  if (Copy(xData1.id, 1, 1) = '*') then begin
    if TCList(Sender).Header.SortDirection = sdAscending then begin
      Result := -1;
    end else begin
      Result := 1;
    end;
  end else if (Copy(xData2.id, 1, 1) = '*') then begin
    if TCList(Sender).Header.SortDirection = sdAscending then begin
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

procedure TCMovementFrame.SumListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TSumElement);
end;

procedure TCMovementFrame.SumListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TSumElement;
begin
  xData := TSumElement(SumList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := xData.name;
  end else if Column = 1 then begin
    CellText := CurrencyToString(xData.cashOut, '', False);
  end else if Column = 2 then begin
    CellText := CurrencyToString(xData.cashIn, '', False);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.cashIn - xData.cashOut, '', False);
  end else if Column = 4 then begin
    CellText := GCurrencyCache.GetSymbol(xData.idCurrencyDef);
  end;
end;

procedure TCMovementFrame.SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var xDate: TSumElement;
begin
  if ParentNode = Nil then begin
    TSumElement(SumList.GetNodeData(Node)^) := TSumElement(FSumRoot.childs.Items[Node.Index]);
  end else begin
    xDate := TSumElement(SumList.GetNodeData(ParentNode)^);
    TSumElement(SumList.GetNodeData(Node)^) := TSumElement(xDate.childs.Items[Node.Index]);
  end;
  if TSumElement(SumList.GetNodeData(Node)^).childs.Count > 0 then begin
    InitialStates := InitialStates + [ivsHasChildren];
  end;
end;

procedure TCMovementFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('1=<tylko dzi�>');
  xList.Add('2=<w tym tygodniu>');
  xList.Add('3=<w tym miesi�cu>');
  xList.Add('4=<ostatnie 7 dni>');
  xList.Add('5=<ostatnie 14 dni>');
  xList.Add('6=<ostatnie 30 dni>');
  xList.Add('7=<wybrany zakres>');
  xList.Add('8=<dowolny>');
  xGid := CEmptyDataGid;
  xText := '';
  xRect := Rect(10, 10, 200, 300);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

procedure TCMovementFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
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
    ADateFrom := CDateTimePerStart.Value;
    ADateTo := CDateTimePerEnd.Value;
  end else if xId = '8' then begin
    ADateFrom := LowestDatetime;
    ADateTo := HighestDatetime;
  end;
end;

procedure TCMovementFrame.UpdateCustomPeriod;
var xF, xE: TDateTime;
begin
  CDateTimePerStart.HotTrack := CStaticPeriod.DataId = '7';
  CDateTimePerEnd.HotTrack := CStaticPeriod.DataId = '7';
  Label4.Visible := CStaticPeriod.DataId <> '8';;
  Label4.Update;
  Label5.Visible := CStaticPeriod.DataId <> '8';;
  Label5.Update;
  Label3.Visible := CStaticPeriod.DataId <> '8';;
  Label3.Update;
  CDateTimePerStart.Visible := CStaticPeriod.DataId <> '8';
  CDateTimePerEnd.Visible := CStaticPeriod.DataId <> '8';;
  if CStaticPeriod.DataId <> '7' then begin
    GetFilterDates(xF, xE);
    CDateTimePerStart.Value := xF;
    CDateTimePerEnd.Value := xE;
  end else begin
    if IsLowestDatetime(CDateTimePerStart.Value) then begin
      CDateTimePerStart.Value := GWorkDate;
    end;
    if IsHighestDatetime(CDateTimePerEnd.Value) then begin
      CDateTimePerEnd.Value := GWorkDate;
    end;
  end;
end;

procedure TCMovementFrame.CDateTimePerStartChanged(Sender: TObject);
begin
  ReloadToday;
  ReloadSums;
end;

procedure TCMovementFrame.TodayListDblClick(Sender: TObject);
begin
  ActionEditMovement.Execute;
end;

class function TCMovementFrame.GetPrefname: String;
begin
  Result := 'baseMovement';
end;

procedure TCMovementFrame.TodayListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var xBase: TMovementTreeElement;
begin
 xBase := TMovementTreeElement(TodayList.GetNodeData(Node)^);
  if Column = 5 then begin
    if xBase.movementType = CInMovement then begin
      ImageIndex := 0;
    end else if xBase.movementType = COutMovement then begin
      ImageIndex := 1;
    end else if xBase.movementType = CTransferMovement then begin
      ImageIndex := 2;
    end;
  end else if Column = 6 then begin
    if xBase.movementType = CTransferMovement then begin
      if TBaseMovement(xBase.Dataobject).isStated and TBaseMovement(xBase.Dataobject).isSourceStated then begin
        ImageIndex := 4;
      end else begin
        ImageIndex := 3;
      end;
    end else begin
      if xBase.isStated then begin
        ImageIndex := 4;
      end else begin
        ImageIndex := 3;
      end;
    end;
  end;
end;

procedure TCMovementFrame.RecreateTreeHelper;
var xCount: Integer;
    xItem, xListItem: TMovementTreeElement;
    xParentList: TTreeObjectList;
begin
  FTreeHelper.Clear;
  for xCount := 0 to FTodayLists.Count - 1 do begin
    xItem := TMovementTreeElement.Create;
    xItem.elementType := mtList;
    xItem.Dataobject := FTodayLists.Items[xCount];
    xItem.currencyView := CStaticViewCurrency.DataId;
    FTreeHelper.Add(xItem);
  end;
  for xCount := 0 to FTodayObjects.Count - 1 do begin
    xItem := TMovementTreeElement.Create;
    xItem.elementType := mtObject;
    xItem.Dataobject := FTodayObjects.Items[xCount];
    xItem.currencyView := CStaticViewCurrency.DataId;
    if TBaseMovement(xItem.Dataobject).idMovementList <> CEmptyDataGid then begin
      xParentList := FindParentMovementList(TBaseMovement(xItem.Dataobject).idMovementList);
    end else begin
      xParentList := FTreeHelper;
    end;
    if xParentList <> Nil then begin
      xParentList.Add(xItem);
    end else begin
      xListItem := TMovementTreeElement.Create;
      xListItem.elementType := mtList;
      xListItem.Dataobject := TMovementList(TMovementList.LoadObject(MovementListProxy, TBaseMovement(xItem.Dataobject).idMovementList, False));
      xListItem.currencyView := CStaticViewCurrency.DataId;
      FTreeHelper.Add(xListItem);
      FTodayLists.Add(xListItem.Dataobject);
      xListItem.Childobjects.Add(xItem);
    end;
  end;
  for xCount := FTreeHelper.Count - 1 downto 0 do begin
    xItem := TMovementTreeElement(FTreeHelper.Items[xCount]);
    if (xItem.elementType = mtList) and (xItem.Childobjects.Count = 0) then begin
      FTreeHelper.Remove(xItem);
    end;
  end;
  FTreeHelper.Sort(SortByDate);
end;

function TCMovementFrame.FindParentMovementList(AListGid: TDataGid): TTreeObjectList;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (xCount <= FTreeHelper.Count - 1) and (Result = Nil) do begin
    if FTreeHelper.Items[xCount].Dataobject.id = AListGid then begin
      Result := FTreeHelper.Items[xCount].Childobjects;
    end;
    Inc(xCount);
  end;
end;

function TMovementTreeElement.Getcash: Currency;
begin
  if FelementType = mtObject then begin
    if FcurrencyView = CCurrencyViewBaseMovements then begin
      Result := TBaseMovement(Dataobject).movementCash;
    end else begin
      Result := TBaseMovement(Dataobject).cash;
    end;
  end else begin
    Result := TmovementList(Dataobject).cash;
  end;
end;

function TMovementTreeElement.GetDescription: String;
begin
  if FelementType = mtObject then begin
    Result := TBaseMovement(Dataobject).description;
  end else begin
    Result := TmovementList(Dataobject).description;
  end;
end;

function TMovementTreeElement.GetId: TDataGid;
begin
  Result := Dataobject.id;
end;

function TMovementTreeElement.GetidCurrencyDef: TDataGid;
begin
  if FelementType = mtObject then begin
    if FcurrencyView = CCurrencyViewBaseMovements then begin
      Result := TBaseMovement(Dataobject).idMovementCurrencyDef;
    end else begin
      Result := TBaseMovement(Dataobject).idAccountCurrencyDef;
    end;
  end else begin
    Result := TMovementList(Dataobject).idAccountCurrencyDef;
  end;
end;

function TMovementTreeElement.GetisStated: Boolean;
begin
  if FelementType = mtObject then begin
    Result := TBaseMovement(Dataobject).isStated
  end else begin
    Result := TMovementList(Dataobject).isStated;
  end;
end;

function TMovementTreeElement.GetmovementType: TBaseEnumeration;
begin
  if FelementType = mtObject then begin
    Result := TBaseMovement(Dataobject).movementType;
  end else begin
    Result := TMovementList(Dataobject).movementType;
  end;
end;

function TMovementTreeElement.Getregdate: TDateTime;
begin
  if FelementType = mtObject then begin
    Result := TBaseMovement(Dataobject).regDate;
  end else begin
    Result := TMovementList(Dataobject).regDate;
  end;
end;

procedure TCMovementFrame.ActionAddListExecute(Sender: TObject);
var xForm: TCMovementListForm;
begin
  xForm := TCMovementListForm.Create(Nil);
  xForm.ShowDataobject(coAdd, MovementListProxy, Nil, True);
  xForm.Free;
end;

procedure TCMovementFrame.TodayListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var xData: TMovementTreeElement;
begin
  xData := TMovementTreeElement(TodayList.GetNodeData(Node)^);
  ChildCount := xData.Childobjects.Count;
end;

function TCMovementFrame.FindObjectNode(ADataGid: TDataGid; AType: Integer): PVirtualNode;
var xNode: PVirtualNode;
    xBase: TMovementTreeElement;
begin
  Result := Nil;
  xNode :=TodayList.GetFirst;
  while (Result = Nil) and (xNode <> Nil) do begin
    xBase := TMovementTreeElement(TodayList.GetNodeData(xNode)^);
    if ((AType = WMOPT_BASEMOVEMENT) and (xBase.elementType = mtObject)) or ((AType = WMOPT_MOVEMENTLIST) and (xBase.elementType = mtList)) then begin
      if xBase.Dataobject.id = ADataGid then begin
        Result := xNode;
      end;
    end;
    xNode := TodayList.GetNext(xNode);
  end;
end;

procedure TCMovementFrame.DeleteObjectsWithMovementList(AListId: TDataGid);
var xCount: Integer;
begin
  for xCount := FTodayObjects.Count - 1 downto 0 do begin
    if TBaseMovement(FTodayObjects.Items[xCount]).idMovementList = AListId then begin
      FTodayObjects.Remove(FTodayObjects.Items[xCount]);
    end;
  end;
end;

procedure TCMovementFrame.SumListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var xDate: TSumElement;
begin
  xDate := TSumElement(SumList.GetNodeData(Node)^);
  ChildCount := xDate.childs.Count;
end;

procedure TCMovementFrame.CStaticViewCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ShowCurrencyViewTypeBaseMovement(ADataGid, AText);
end;

procedure TCMovementFrame.CStaticViewCurrencyChanged(Sender: TObject);
begin
  ReloadToday;
  ReloadSums;
end;

function TCMovementFrame.GetSelectedType: Integer;
var xData: TMovementTreeElement;
begin
  if TodayList.FocusedNode <> Nil then begin
    xData := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^);
    if xData.elementType = mtObject then begin
      Result := CSELECTEDITEM_BASEMOVEMENT;
    end else begin
      Result := CSELECTEDITEM_MOVEMENTLIST;
    end;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCMovementFrame.GetSelectedId: ShortString;
begin
  if TodayList.FocusedNode <> Nil then begin
    Result := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^).id;
  end else begin
    Result := CEmptyDataGid;
  end;
end;

function TCMovementFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := ((APluginSelectedItemTypes and CSELECTEDITEM_BASEMOVEMENT) = CSELECTEDITEM_BASEMOVEMENT) or
            ((APluginSelectedItemTypes and CSELECTEDITEM_MOVEMENTLIST) = CSELECTEDITEM_MOVEMENTLIST);
end;

procedure TCMovementFrame.UpdateButtons(AIsSelectedSomething: Boolean);
begin
  inherited UpdateButtons(AIsSelectedSomething);
  CButtonEdit.Enabled := AIsSelectedSomething;
  ActionEditMovement.Enabled := AIsSelectedSomething;
  CButtonDel.Enabled := AIsSelectedSomething;
  ActionDelMovement.Enabled := AIsSelectedSomething;
end;

function TCMovementFrame.GetSelectedText: String;
begin
  if TodayList.FocusedNode <> Nil then begin
    Result := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^).description;
  end else begin
    Result := '';
  end;
end;

procedure TCMovementFrame.DoRepaintLists;
begin
  inherited DoRepaintLists;
  SumList.ReinitNode(SumList.RootNode, True);
  SumList.Repaint;
  QuickpatternList.ReinitNode(QuickpatternList.RootNode, True);
  QuickpatternList.Repaint;
end;

procedure TCMovementFrame.Ustawienialisty2Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(SumList.ViewPref) then begin
    SendMessageToFrames(TCBaseFrameClass(ClassType), WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

procedure TCMovementFrame.TodayListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  APrefname := TMovementTreeElement(AHelper).movementType;
  if TMovementTreeElement(AHelper).elementType = mtObject then begin
    if TBaseMovement(TMovementTreeElement(AHelper).Dataobject).idPlannedDone <> CEmptyDataGid then begin
      APrefname := 'C' + APrefname;
    end;
  end else begin
    APrefname := 'S' + APrefname;
  end;
end;

procedure TCMovementFrame.MenuItemBigIconsClick(Sender: TObject);
begin
  if not MenuItemBigIcons.Checked then begin
    MenuItemBigIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := False;
    end;
    UpdateIcons;
  end;
end;

procedure TCMovementFrame.MenuItemSmallIconsClick(Sender: TObject);
begin
  if not MenuItemSmallIcons.Checked then begin
    MenuItemSmallIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := True;
    end;
    UpdateIcons;
  end;
end;

procedure TCMovementFrame.UpdateIcons;
var xDummy: TPngImageList;
begin
  xDummy := Nil;
  UpdatePanelIcons(Panel1,
                   MenuItemBigIcons, MenuItemSmallIcons,
                   FBigIconsButtonsImageList, Nil,
                   ActionList, Nil,
                   FSmallIconsButtonsImageList,
                   xDummy);
end;

procedure TCMovementFrame.ButtonCloseShortcutsClick(Sender: TObject);
begin
  TBaseMovementFramePref(FramePreferences).sumListVisible := False;
  UpdateSumAndPatterns;
end;

procedure TCMovementFrame.UpdateSumAndPatterns;
begin
  MenuItemsumsVisible.Checked := TBaseMovementFramePref(FramePreferences).sumListVisible;
  MenuItemPatternsVisible.Checked := TBaseMovementFramePref(FramePreferences).patternsListVisible;
  if TBaseMovementFramePref(FramePreferences).sumListVisible and TBaseMovementFramePref(FramePreferences).patternsListVisible then begin
    PanelSum.Visible := True;
    PanelPatterns.Visible := True;
    PanelSum.Align := alClient;
    PanelPatterns.Align := alRight;
    Splitter2.Visible := True;
    if TBaseMovementFramePref(FramePreferences).patternListWidth <> -1 then begin
      PanelPatterns.Width := TBaseMovementFramePref(FramePreferences).patternListWidth;
    end;
  end else if TBaseMovementFramePref(FramePreferences).sumListVisible and not TBaseMovementFramePref(FramePreferences).patternsListVisible then begin
    TBaseMovementFramePref(FramePreferences).patternListWidth := PanelPatterns.Width;
    PanelSum.Visible := True;
    Splitter2.Visible := False;
    PanelPatterns.Visible := False;
    PanelSum.Align := alClient;
    PanelPatterns.Align := alRight;
  end else if not TBaseMovementFramePref(FramePreferences).sumListVisible and TBaseMovementFramePref(FramePreferences).patternsListVisible then begin
    TBaseMovementFramePref(FramePreferences).patternListWidth := PanelPatterns.Width;
    PanelSum.Visible := False;
    Splitter2.Visible := False;
    PanelPatterns.Visible := True;
    PanelPatterns.Align := alClient;
    PanelSum.Align := alLeft;
  end else begin
    TBaseMovementFramePref(FramePreferences).patternListWidth := PanelPatterns.Width;
    PanelSum.Visible := False;
    PanelPatterns.Visible := False;
    PanelSum.Align := alClient;
    PanelPatterns.Align := alRight;
    Splitter2.Visible := False;
  end;
  if TBaseMovementFramePref(FramePreferences).sumListVisible or TBaseMovementFramePref(FramePreferences).patternsListVisible then begin
    PanelFrameButtons.AutoSize := False;
    if TBaseMovementFramePref(FramePreferences).sumListHeight <> -1 then begin
      PanelFrameButtons.AutoSize := False;
      PanelFrameButtons.Height := TBaseMovementFramePref(FramePreferences).sumListHeight;
    end;
  end else begin
    TBaseMovementFramePref(FramePreferences).sumListHeight := PanelFrameButtons.Height;
    PanelFrameButtons.AutoSize := True;
  end;
  Splitter1.Enabled := TBaseMovementFramePref(FramePreferences).sumListVisible or TBaseMovementFramePref(FramePreferences).patternsListVisible;
  ButtonCloseShortcuts.Left := Panel2.Width - 16;
  ButtonPatternVisible.Left := Panel3.Width - 16;
end;

procedure TCMovementFrame.MenuItemsumsVisibleClick(Sender: TObject);
begin
  TBaseMovementFramePref(FramePreferences).sumListVisible := not MenuItemsumsVisible.Checked;
  UpdateSumAndPatterns;
end;

procedure TCMovementFrame.SaveFramePreferences;
begin
  if TBaseMovementFramePref(FramePreferences).sumListVisible or TBaseMovementFramePref(FramePreferences).patternsListVisible then begin
    TBaseMovementFramePref(FramePreferences).sumListHeight := PanelFrameButtons.Height;
  end;
  if TBaseMovementFramePref(FramePreferences).patternsListVisible then begin
    TBaseMovementFramePref(FramePreferences).patternListWidth := PanelPatterns.Width;
  end;
  inherited SaveFramePreferences;
end;

procedure TCMovementFrame.LoadFramePreferences;
begin
  inherited LoadFramePreferences;
  UpdateSumAndPatterns;
end;

procedure TCMovementFrame.ButtonClosePatternsClick(Sender: TObject);
begin
  TBaseMovementFramePref(FramePreferences).patternsListVisible := False;
  UpdateSumAndPatterns;
end;

procedure TCMovementFrame.MenuItemPatternsVisibleClick(Sender: TObject);
begin
  TBaseMovementFramePref(FramePreferences).patternsListVisible := not MenuItemPatternsVisible.Checked;
  UpdateSumAndPatterns;
end;

procedure TCMovementFrame.ButtonPatternVisibleClick(Sender: TObject);
begin
  TBaseMovementFramePref(FramePreferences).patternsListVisible := False;
  UpdateSumAndPatterns;
end;

procedure TCMovementFrame.ReloadQuickPatterns;
begin
  QuickpatternList.BeginUpdate;
  QuickpatternList.ReloadTree;
  QuickpatternList.EndUpdate;
end;

procedure TCMovementFrame.QuickpatternListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xQp: TDataObjectList;
    xCount: Integer;
    xQuickPattern: TQuickPattern;
    xElement: TQuickPatternElement;
    xQe: TADOQuery;
    xName, xDesc: String;
begin
  FQuickPatternElements.Clear;
  if TBaseMovementFramePref(FramePreferences).userPatternsVisible then begin
    xQp := TQuickPattern.GetAllObjects(QuickPatternProxy);
    for xCount := 0 to xQp.Count - 1 do begin
      xQuickPattern := TQuickPattern(xQp.Items[xCount]);
      xElement := TQuickPatternElement.Create(xQuickPattern.name, xQuickPattern.description, xQuickPattern.movementType,
                                              xQuickPattern.idAccount, xQuickPattern.idSourceAccount, xQuickPattern.idCashPoint, xQuickPattern.idProduct, False);
      ARootElement.AppendDataElement(TCListDataElement.Create(False, QuickpatternList, xElement, True, True));
    end;
    xQp.Free;
  end;
  if TBaseMovementFramePref(FramePreferences).statisticPatternsVisible then begin
    xQe := GDataProvider.OpenSql('select top 5 *, ' +
                                   '(select name from account where idAccount = x.idAccount) as accountName, ' +
                                   '(select name from account where idAccount = x.idSourceAccount) as sourceAccountName, ' +
                                   '(select name from cashpoint where idCashpoint = x.idCashpoint) as cashpointName, ' +
                                   '(select name from product where idProduct = x.idProduct) as productName ' +
                                 'from movementStatistics x where x.movementCount > 0 order by movementCount desc ');
    while not xQe.Eof do begin
      if xQe.FieldByName('movementType').AsString = CTransferMovement then begin
        xName := 'Z ' + xQe.FieldByName('sourceAccountName').AsString + ' do ' + xQe.FieldByName('accountName').AsString;
        xDesc := xName + ', do tej pory ' + IntToStr(xQe.FieldByName('movementCount').AsInteger) + ' operacji';
      end else if xQe.FieldByName('movementType').AsString = CInMovement then begin
        xName := xQe.FieldByName('productName').AsString + ' (' + xQe.FieldByName('accountName').AsString + ')';
        xDesc := xName + ', do tej pory ' + IntToStr(xQe.FieldByName('movementCount').AsInteger) + ' operacji';
      end else if xQe.FieldByName('movementType').AsString = COutMovement then begin
        xName := xQe.FieldByName('productName').AsString + ' (' + xQe.FieldByName('accountName').AsString + ')';
        xDesc := xName + ', do tej pory ' + IntToStr(xQe.FieldByName('movementCount').AsInteger) + ' operacji';
      end;
      xElement := TQuickPatternElement.Create(xName, xDesc, xQe.FieldByName('movementType').AsString,
                                              xQe.FieldByName('idAccount').AsString, xQe.FieldByName('idSourceAccount').AsString,
                                              xQe.FieldByName('idCashpoint').AsString, xQe.FieldByName('idProduct').AsString, True);
      ARootElement.AppendDataElement(TCListDataElement.Create(False, QuickpatternList, xElement, True, True));
      xQe.Next;
    end;
    xQe.Free;
  end;
end;

procedure TCMovementFrame.QuickpatternListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
var xData: TCListDataElement;
begin
  xData := TCListDataElement(AHelper);
  APrefname := IfThen(TQuickPatternElement(xData.Data).isStatistic, 'S', 'D');
end;

procedure TCMovementFrame.MenuItemQuickpatternsClick(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(QuickpatternList.ViewPref) then begin
    SendMessageToFrames(TCBaseFrameClass(ClassType), WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

procedure TCMovementFrame.QuickpatternListClick(Sender: TObject);
var xForm: TCMovementForm;
    xElement: TCListDataElement;
begin
  xElement := QuickpatternList.SelectedElement;
  if (QuickpatternList.FocusedNode <> Nil) and (xElement <> Nil) then begin
    xForm := TCMovementForm.Create(Nil);
    xForm.ShowDataobject(coAdd, BaseMovementProxy, Nil, True, TMovementAdditionalData.Create(0, 0, Nil, TQuickPatternElement(xElement.Data)));
    xForm.Free;
  end;
end;

procedure TCMovementFrame.MenuItemshowUserQuickpatternsClick(Sender: TObject);
begin
  MenuItemshowUserQuickpatterns.Checked := not MenuItemshowUserQuickpatterns.Checked;
  TBaseMovementFramePref(FramePreferences).userPatternsVisible := MenuItemshowUserQuickpatterns.Checked;
  ReloadQuickPatterns;
end;

procedure TCMovementFrame.MenuItemStatisticQuickPatternsClick(Sender: TObject);
begin
  MenuItemStatisticQuickPatterns.Checked := not MenuItemStatisticQuickPatterns.Checked;
  TBaseMovementFramePref(FramePreferences).statisticPatternsVisible := MenuItemStatisticQuickPatterns.Checked;
  ReloadQuickPatterns;
end;

procedure TCMovementFrame.CButtonShowHideFiltersClick(Sender: TObject);
begin
  AdvancedFilterVisible := not AdvancedFilterVisible;
end;

procedure TCMovementFrame.SetAdvancedFilterVisible(const Value: Boolean);
begin
  FAdvancedFilterVisible := Value;
  if FAdvancedFilterVisible then begin
    CButtonShowHideFilters.Caption := '6';
    Panel.Height := 65;
  end else begin
    CButtonShowHideFilters.Caption := '4';
    Panel.Height := 21;
  end;
end;

procedure TCMovementFrame.FilterEditDescriptionChange(Sender: TObject);
begin
  ReloadToday;
  ReloadSums;
end;

procedure TCMovementFrame.CStaticFastFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := DoTemporaryMovementFilter(ADataGid, AText);
end;

procedure TCMovementFrame.CStaticFastFilterChanged(Sender: TObject);
begin
  ReloadToday;
  ReloadSums;
end;

procedure TCMovementFrame.HideFrame;
begin
  inherited HideFrame;
  ActionMovement.ShortCut := 0;
  ActionEditMovement.ShortCut := 0;
  ActionDelMovement.ShortCut := 0;
  ActionAddList.ShortCut := 0;
end;

procedure TCMovementFrame.ShowFrame;
begin
  inherited ShowFrame;
  ActionMovement.ShortCut := ShortCut(Word('D'), [ssCtrl]);;
  ActionEditMovement.ShortCut := ShortCut(Word('E'), [ssCtrl]);;
  ActionDelMovement.ShortCut := ShortCut(Word('U'), [ssCtrl]);;
  ActionAddList.ShortCut := ShortCut(Word('L'), [ssCtrl]);;
end;

end.
