unit CPlannedFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, StdCtrls, ExtCtrls, VirtualTrees,
  ActnList, CComponents, CDatabase, Menus, VTHeaderPopup, GraphUtil, AdoDb,
  Contnrs, PngImageList, CImageListsUnit, CDataObjects;

type
  TCPlannedFrame = class(TCBaseFrame)
    PanelFrameButtons: TCPanel;
    PlannedList: TCList;
    ActionList: TActionList;
    ActionMovement: TAction;
    ActionEditMovement: TAction;
    ActionDelMovement: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    CButtonDel: TCButton;
    CButtonEdit: TCButton;
    CButtonOut: TCButton;
    PopupMenuIcons: TPopupMenu;
    MenuItemBigIcons: TMenuItem;
    MenuItemSmallIcons: TMenuItem;
    procedure PlannedListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure PlannedListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure PlannedListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure PlannedListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure PlannedListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure PlannedListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure ActionMovementExecute(Sender: TObject);
    procedure ActionEditMovementExecute(Sender: TObject);
    procedure ActionDelMovementExecute(Sender: TObject);
    procedure PlannedListDblClick(Sender: TObject);
    procedure PlannedListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure PlannedListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
    procedure MenuItemBigIconsClick(Sender: TObject);
    procedure MenuItemSmallIconsClick(Sender: TObject);
  private
    FSmallIconsButtonsImageList: TPngImageList;
    FBigIconsButtonsImageList: TPngImageList;
    FPlannedObjects: TDataObjectList;
    procedure MessageMovementAdded(AId: TDataGid);
    procedure MessageMovementEdited(AId: TDataGid);
    procedure MessageMovementDeleted(AId: TDataGid);
    procedure UpdateIcons;
  protected
    procedure WndProc(var Message: TMessage); override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
    function GetSelectedId: ShortString; override;
  public
    procedure UpdateButtons(AIsSelectedSomething: Boolean); override;
    function GetList: TCList; override;
    procedure ReloadPlanned;
    constructor Create(AOwner: TComponent); override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    class function GetPrefname: String; override;
  end;

implementation

uses CFrameFormUnit, CInfoFormUnit, CConfigFormUnit, CDataobjectFormUnit,
  CAccountsFrameUnit, DateUtils, CListFrameUnit, DB, CMovementFormUnit,
  CPlannedFormUnit, CDoneFrameUnit, CConsts, CPreferences, CTools,
  CPluginConsts, CDatatools;

{$R *.dfm}

constructor TCPlannedFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPlannedObjects := Nil;
end;

procedure TCPlannedFrame.PlannedListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  UpdateButtons(Node <> Nil);
end;

procedure TCPlannedFrame.ReloadPlanned;
begin
  PlannedList.BeginUpdate;
  PlannedList.Clear;
  if FPlannedObjects <> Nil then begin
    FreeAndNil(FPlannedObjects);
  end;
  FPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, 'select * from plannedMovement');
  PlannedList.RootNodeCount := FPlannedObjects.Count;
  PlannedList.EndUpdate;
  PlannedListFocusChanged(PlannedList, PlannedList.FocusedNode, 0);
end;

procedure TCPlannedFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  if not AWithButtons then begin
    PanelFrameButtons.Visible := False;
    List.BevelEdges := [];
  end;
  FSmallIconsButtonsImageList := Nil;
  FBigIconsButtonsImageList := TPngImageList(ActionList.Images);
  if List.ViewPref <> Nil then begin
    MenuItemSmallIcons.Checked := List.ViewPref.ButtonSmall;
    UpdateIcons;
  end;
  ReloadPlanned;
end;

destructor TCPlannedFrame.Destroy;
begin
  if FSmallIconsButtonsImageList <> Nil then begin
    FSmallIconsButtonsImageList.Free;
  end;
  FPlannedObjects.Free;
  inherited Destroy;
end;

procedure TCPlannedFrame.PlannedListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TDataObject(PlannedList.GetNodeData(Node)^) := FPlannedObjects.Items[Node.Index];
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCPlannedFrame.PlannedListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TDataObject);
end;

procedure TCPlannedFrame.PlannedListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TPlannedMovement;
begin
  xData := TPlannedMovement(PlannedList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := IntToStr(Node.Index + 1);
  end else if Column = 1 then begin
    CellText := GetDescText(xData.description);
  end else if Column = 2 then begin
    if (xData.movementType = CInMovement) then begin
      CellText := CInMovementDescription;
    end else if (xData.movementType = COutMovement) then begin
      CellText := COutMovementDescription;
    end else if (xData.movementType = CTransferMovement) then begin
      CellText := CTransferMovementDescription;
    end;
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.cash, '', False);
  end else begin
    CellText := GCurrencyCache.GetSymbol(xData.idMovementCurrencyDef);
  end;
end;

procedure TCPlannedFrame.PlannedListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TPlannedMovement;
    xData2: TPlannedMovement;
begin
  xData1 := TPlannedMovement(PlannedList.GetNodeData(Node1)^);
  xData2 := TPlannedMovement(PlannedList.GetNodeData(Node2)^);
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
    Result := AnsiCompareText(xData1.movementType, xData2.movementType);
  end else if Column = 3 then begin
    if xData1.cash > xData2.cash then begin
      Result := 1;
    end else if xData1.cash < xData2.cash then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end;
end;

procedure TCPlannedFrame.PlannedListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TPlannedMovement;
begin
  xData := TPlannedMovement(PlannedList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCPlannedFrame.MessageMovementAdded(AId: TDataGid);
var xDataobject: TPlannedMovement;
    xNode: PVirtualNode;
begin
  xDataobject := TPlannedMovement(TPlannedMovement.LoadObject(PlannedMovementProxy, AId, True));
  if IsValidFilteredObject(xDataobject) then begin
    FPlannedObjects.Add(xDataobject);
    xNode := PlannedList.AddChild(Nil, xDataobject);
    PlannedList.Sort(xNode, PlannedList.Header.SortColumn, PlannedList.Header.SortDirection);
    PlannedList.FocusedNode := xNode;
    PlannedList.Selected[xNode] := True;
  end else begin
    xDataobject.Free;
  end;
  SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
end;

procedure TCPlannedFrame.MessageMovementDeleted(AId: TDataGid);
var xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, PlannedList);
  if xNode <> Nil then begin
    PlannedList.BeginUpdate;
    FPlannedObjects.Remove(TPlannedMovement(PlannedList.GetNodeData(xNode)^));
    PlannedList.DeleteNode(xNode);
    PlannedList.EndUpdate;
  end;
  SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
end;

procedure TCPlannedFrame.MessageMovementEdited(AId: TDataGid);
var xDataobject: TPlannedMovement;
    xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, PlannedList);
  if xNode <> Nil then begin
    xDataobject := TPlannedMovement(PlannedList.GetNodeData(xNode)^);
    xDataobject.ReloadObject;
    if IsValidFilteredObject(xDataobject) then begin
      PlannedList.InvalidateNode(xNode);
      PlannedList.Sort(xNode, PlannedList.Header.SortColumn, PlannedList.Header.SortDirection);
    end else begin
      PlannedList.DeleteNode(xNode);
      FPlannedObjects.Remove(TPlannedMovement(PlannedList.GetNodeData(xNode)^));
    end;
  end;
  SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
end;

function TCPlannedFrame.GetList: TCList;
begin
  Result := PlannedList;
end;

procedure TCPlannedFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementAdded(xDataGid);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementEdited(xDataGid);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementDeleted(xDataGid);
    end;
  end;
end;

class function TCPlannedFrame.GetTitle: String;
begin
  Result := 'Planowane operacje';
end;

procedure TCPlannedFrame.ActionMovementExecute(Sender: TObject);
var xForm: TCPlannedForm;
begin
  xForm := TCPlannedForm.Create(Nil);
  xForm.ShowDataobject(coAdd, PlannedMovementProxy, Nil, True);
  xForm.Free;
end;

procedure TCPlannedFrame.ActionEditMovementExecute(Sender: TObject);
var xForm: TCPlannedForm;
    xBase: TPlannedMovement;
begin
  if PlannedList.FocusedNode <> Nil then begin
    xBase := TPlannedMovement(PlannedList.GetNodeData(PlannedList.FocusedNode)^);
    xForm := TCPlannedForm.Create(Nil);
    xForm.ShowDataobject(coEdit, PlannedMovementProxy, xBase, True);
    xForm.Free;
  end;
end;

procedure TCPlannedFrame.ActionDelMovementExecute(Sender: TObject);
var xBase: TPlannedMovement;
    xObject: TDataObject;
begin
  xBase := TPlannedMovement(PlannedList.GetNodeData(PlannedList.FocusedNode)^);
  if TPlannedMovement.CanBeDeleted(xBase.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun�� wybrany plan ?', '') then begin
      xObject := TPlannedMovement(TPlannedMovement.LoadObject(PlannedMovementProxy, xBase.id, False));
      xObject.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCPlannedFrame, WM_DATAOBJECTDELETED, Integer(@xBase.id), 0);
    end;
  end;
end;

procedure TCPlannedFrame.PlannedListDblClick(Sender: TObject);
begin
  ActionEditMovement.Execute;
end;

class function TCPlannedFrame.GetPrefname: String;
begin
  Result := 'plannedMovement';
end;

procedure TCPlannedFrame.PlannedListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var xBase: TPlannedMovement;
begin
  if Column = 2 then begin
    xBase := TPlannedMovement(PlannedList.GetNodeData(Node)^);
    if xBase.movementType = CInMovement then begin
      ImageIndex := 0;
    end else if xBase.movementType = COutMovement then begin
      ImageIndex := 1;
    end else if xBase.movementType = CTransferMovement then begin
      ImageIndex := 2;
    end;
  end;
end;

function TCPlannedFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_PLANNEDMOVEMENT) = CSELECTEDITEM_PLANNEDMOVEMENT;
end;

procedure TCPlannedFrame.UpdateButtons(AIsSelectedSomething: Boolean);
begin
  inherited UpdateButtons(AIsSelectedSomething);
  CButtonEdit.Enabled := AIsSelectedSomething;
  CButtonDel.Enabled := AIsSelectedSomething;
end;

function TCPlannedFrame.GetSelectedType: Integer;
begin
  Result := CSELECTEDITEM_PLANNEDMOVEMENT;
end;

function TCPlannedFrame.GetSelectedId: ShortString;
begin
  if PlannedList.FocusedNode <> Nil then begin
    Result := TPlannedMovement(PlannedList.GetNodeData(PlannedList.FocusedNode)^).id;
  end else begin
    Result := CEmptyDataGid;
  end;
end;

procedure TCPlannedFrame.PlannedListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  APrefname := TPlannedMovement(AHelper).movementType;
end;

procedure TCPlannedFrame.MenuItemBigIconsClick(Sender: TObject);
begin
  if not MenuItemBigIcons.Checked then begin
    MenuItemBigIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := False;
    end;
    UpdateIcons;
  end;
end;

procedure TCPlannedFrame.MenuItemSmallIconsClick(Sender: TObject);
begin
  if not MenuItemSmallIcons.Checked then begin
    MenuItemSmallIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := True;
    end;
    UpdateIcons;
  end;
end;

procedure TCPlannedFrame.UpdateIcons;
var xDummy: TPngImageList;
begin
  xDummy := Nil;
  UpdatePanelIcons(PanelFrameButtons,
                   MenuItemBigIcons, MenuItemSmallIcons,
                   FBigIconsButtonsImageList, Nil,
                   ActionList, Nil,
                   FSmallIconsButtonsImageList,
                   xDummy);
end;


end.