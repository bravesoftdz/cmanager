unit CDataobjectFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VirtualTrees,
  CComponents, ExtCtrls, VTHeaderPopup, CDatabase, ActnList, CDataobjectFormUnit,
  StdCtrls, CImageListsUnit, CPreferences;

type
  TCDataobjectFrameData = class(TObject)
  private
    FFilterId: String;
  public
    constructor CreateWithFilter(AFilterId: String);
    constructor CreateNew;
    property FilterId: String read FFilterId;
  end;

  TCDataobjectFrame = class(TCBaseFrame)
    FilterPanel: TCPanel;
    List: TCDataList;
    ButtonPanel: TCPanel;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    ActionListButtons: TActionList;
    ActionAdd: TAction;
    ActionEdit: TAction;
    ActionDelete: TAction;
    CButtonAdd: TCButton;
    CButtonEdit: TCButton;
    CButtonDelete: TCButton;
    Label2: TLabel;
    CStaticFilter: TCStatic;
    Dodaj1: TMenuItem;
    Edytuj1: TMenuItem;
    Usu1: TMenuItem;
    CButtonHistory: TCButton;
    ActionListHistory: TActionList;
    ActionHistory: TAction;
    Historia1: TMenuItem;
    PopupMenuIcons: TPopupMenu;
    MenuItemBigIcons: TMenuItem;
    MenuItemSmallIcons: TMenuItem;
    BevelPanel: TCPanel;
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure CStaticFilterChanged(Sender: TObject);
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ListDblClick(Sender: TObject);
    procedure ListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ActionHistoryExecute(Sender: TObject);
    procedure MenuItemBigIconsClick(Sender: TObject);
    procedure MenuItemSmallIconsClick(Sender: TObject);
  private
    FSmallIconsButtonsImageList: TPngImageList;
    FSmallIconsHistoryImageList: TPngImageList;
    FBigIconsButtonsImageList: TPngImageList;
    FBigIconsHistoryImageList: TPngImageList;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure MessageMovementAdded(AId: TDataGid; AOptions: Integer); virtual;
    procedure MessageMovementEdited(AId: TDataGid; AOptions: Integer); virtual;
    procedure MessageMovementDeleted(AId: TDataGid; AOptions: Integer); virtual;
    procedure RefreshData; virtual;
    function GetAdditionalDataForObject: TAdditionalData; virtual;
    procedure DoCheckChanged; override;
    procedure DoActionAddExecute; virtual;
    procedure DoActionEditExecute; virtual;
    procedure DoActionDeleteExecute; virtual;
    procedure AfterDeleteObject(ADataobject: TDataObject); virtual;
    procedure DoAddingNewDataobject(ADataobject: TDataObject); virtual;
    procedure DoEditingNewDataobject(ADataobject: TDataObject); virtual;
    procedure DoDeletingNewDataobject(ADataobject: TDataObject); virtual;
  public
    Dataobjects: TDataObjectList;
    procedure UpdateButtons(AIsSelectedSomething: Boolean); override;
    procedure RecreateTreeHelper; virtual;
    procedure ReloadDataobjects; virtual;
    procedure ClearDataobjects; virtual;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    destructor Destroy; override;
    function GetList: TCList; override;
    function GetSelectedId: TDataGid; override;
    function GetSelectedText: String; override;
    function GetHistoryText: String; virtual;
    procedure ShowHistory(AGid: TDataGid); virtual;
    function GetInitialFilter: String; virtual;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; virtual; abstract;
    function GetDataobjectParent(ADataobject: TDataObject): TCListDataElement; virtual;
    function GetStaticFilter: TStringList; virtual;
    procedure ReloadSums; virtual;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function FindNodeId(ANode: PVirtualNode): ShortString; override;
    function FindNode(ADataId: TDataGid; AList: TCList): PVirtualNode; override;
    procedure ShowFrame; override;
    procedure HideFrame; override;
    function IsAllElementChecked(ACheckedCount: Integer): Boolean; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetPrefname: String; override;
    procedure UpdateIcons; virtual;
  end;

implementation

uses CFrameFormUnit, CConsts, CConfigFormUnit, CInfoFormUnit, CDatatools,
  CListFrameUnit, CTools;

{$R *.dfm}

procedure TCDataobjectFrame.ClearDataobjects;
begin
  if Assigned(Dataobjects) then begin
    FreeAndNil(Dataobjects);
  end;
end;

destructor TCDataobjectFrame.Destroy;
begin
  if FSmallIconsButtonsImageList <> Nil then begin
    FSmallIconsButtonsImageList.Free;
  end;
  if FSmallIconsHistoryImageList <> Nil then begin
    FSmallIconsHistoryImageList.Free;
  end;
  ClearDataobjects;
  inherited Destroy;
end;

function TCDataobjectFrame.GetList: TCList;
begin
  Result := List;
end;

function TCDataobjectFrame.GetSelectedId: TDataGid;
begin
  Result := List.SelectedId;
end;

function TCDataobjectFrame.GetSelectedText: String;
begin
  Result := List.SelectedText;
end;

procedure TCDataobjectFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
var xFilters: TStringList;
    xHistory: String;
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  FSmallIconsButtonsImageList := Nil;
  FSmallIconsHistoryImageList := Nil;
  FBigIconsButtonsImageList := TPngImageList(ActionListButtons.Images);
  FBigIconsHistoryImageList := TPngImageList(ActionListHistory.Images);
  Dataobjects := Nil;
  xHistory := GetHistoryText;
  if xHistory <> '' then begin
    ActionHistory.Caption := xHistory;
    CButtonHistory.Width := CButtonHistory.Canvas.TextWidth(ActionHistory.Caption) + CButtonHistory.PicOffset + ActionListHistory.Images.Width + 10;
    CButtonHistory.Left := ButtonPanel.Width - CButtonHistory.Width - 15;
    CButtonHistory.Anchors := [akTop, akRight];
  end;
  ActionHistory.Visible := xHistory <> '';
  CStaticFilter.DataId := GetInitialFilter;
  xFilters := GetStaticFilter;
  if xFilters <> Nil then begin
    if AAdditionalData <> Nil then begin
      CStaticFilter.DataId := TCDataobjectFrameData(AAdditionalData).FilterId;
      CStaticFilter.Caption := xFilters.Values[CStaticFilter.DataId];
    end;
    FilterPanel.Visible := True;
  end else begin
    FilterPanel.Visible := False;
  end;
  xFilters.Free;
  if (not AWithButtons) then begin
    BevelPanel.Visible := False;
    ButtonPanel.Visible := False;
    ActionAdd.Visible := False;
    ActionEdit.Visible := False;
    ActionDelete.Visible := False;
    ActionHistory.Visible := False;
    ActionAdd.Enabled := GetDataobjectClass(WMOPT_NONE) <> Nil;
    ActionEdit.Enabled := GetDataobjectClass(WMOPT_NONE) <> Nil;
    ActionDelete.Enabled := GetDataobjectClass(WMOPT_NONE) <> Nil;
    ActionHistory.Enabled := GetDataobjectClass(WMOPT_NONE) <> Nil;
  end;
  Dodaj1.Visible := ActionAdd.Visible and ButtonPanel.Visible;
  Edytuj1.Visible := ActionEdit.Visible and ButtonPanel.Visible;
  Usu1.Visible := ActionDelete.Visible and ButtonPanel.Visible;
  Historia1.Visible := ActionHistory.Visible and ButtonPanel.Visible;
  if List.ViewPref <> Nil then begin
    MenuItemSmallIcons.Checked := List.ViewPref.ButtonSmall;
    UpdateIcons;
  end;
  RefreshData;
end;

procedure TCDataobjectFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
begin
  ReloadDataobjects;
  RecreateTreeHelper;
end;

procedure TCDataobjectFrame.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  UpdateButtons(Node <> Nil);
end;

procedure TCDataobjectFrame.MessageMovementAdded(AId: TDataGid; AOptions: Integer);
var xDataobject: TDataObject;
    xElement: TCListDataElement;
    xNode: PVirtualNode;
begin
  xDataobject := GetDataobjectClass(AOptions).LoadObject(GetDataobjectProxy(AOptions), AId, True);
  DoAddingNewDataobject(xDataobject);
  if IsValidFilteredObject(xDataobject) then begin
    xElement := TCListDataElement.Create(MultipleChecks <> Nil, List, xDataobject);
    Dataobjects.Add(xDataobject);
    xNode := GetDataobjectParent(xDataobject).AppendDataElement(xElement);
    if MultipleChecks <> Nil then begin
      xNode.CheckType := ctCheckBox;
      xNode.CheckState := csCheckedNormal;
    end;
  end else begin
    xDataobject.Free;
  end;
  ReloadSums;
end;

procedure TCDataobjectFrame.MessageMovementDeleted(AId: TDataGid; AOptions: Integer);
var xElement: TCListDataElement;
    xDataobject: TDataObject;
begin
  xElement := List.RootElement.FindDataElement(AId, GetDataobjectClass(WMOPT_NONE).ClassName);
  if xElement <> Nil then begin
    xDataobject := xElement.Data as TDataObject;
    DoDeletingNewDataobject(xDataobject);
  end;
  List.RootElement.DeleteDataElement(AId, GetDataobjectClass(WMOPT_NONE).ClassName);
  ReloadSums;
end;

procedure TCDataobjectFrame.MessageMovementEdited(AId: TDataGid; AOptions: Integer);
var xElement: TCListDataElement;
    xDataobject: TDataObject;
begin
  xElement := List.RootElement.FindDataElement(AId, GetDataobjectClass(WMOPT_NONE).ClassName);
  if xElement <> Nil then begin
    xDataobject := xElement.Data as TDataObject;
    DoEditingNewDataobject(xDataobject);
    if IsValidFilteredObject(xDataobject) then begin
      List.RootElement.RefreshDataElement(AId, xDataobject.ClassName);
    end else begin
      List.RootElement.DeleteDataElement(AId, xDataobject.ClassName);
      Dataobjects.Remove(xDataobject);
    end;
  end;
  ReloadSums;
end;

procedure TCDataobjectFrame.ReloadSums;
begin
end;

procedure TCDataobjectFrame.UpdateButtons(AIsSelectedSomething: Boolean);
var xGotClass: Boolean;
begin
  inherited UpdateButtons(AIsSelectedSomething);
  xGotClass := GetDataobjectClass(WMOPT_NONE) <> Nil;
  ActionAdd.Enabled := xGotClass;
  ActionEdit.Enabled := (List.FocusedNode <> Nil) and xGotClass;
  ActionDelete.Enabled := (List.FocusedNode <> Nil) and xGotClass;
  ActionHistory.Enabled := (List.FocusedNode <> Nil) and xGotClass;
end;

procedure TCDataobjectFrame.WndProc(var Message: TMessage);
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
    end else if Msg = WM_DATAREFRESH then begin
      RefreshData;
    end;
  end;
end;

procedure TCDataobjectFrame.ActionAddExecute(Sender: TObject);
begin
  DoActionAddExecute;
end;

procedure TCDataobjectFrame.ActionEditExecute(Sender: TObject);
begin
  DoActionEditExecute;
end;

procedure TCDataobjectFrame.ActionDeleteExecute(Sender: TObject);
begin
  DoActionDeleteExecute;
end;

procedure TCDataobjectFrame.RecreateTreeHelper;
begin
  CopyListToTreeHelper(Dataobjects, List.RootElement, MultipleChecks <> Nil);
end;

procedure TCDataobjectFrame.CStaticFilterChanged(Sender: TObject);
begin
  RefreshData;
end;

procedure TCDataobjectFrame.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
begin
  xList := GetStaticFilter;
  if xList <> Nil then begin
    AAccepted := ShowList(xList, ADataGid, AText, False);
  end;
end;

function TCDataobjectFrame.GetStaticFilter: TStringList;
begin
  Result := Nil;
end;

constructor TCDataobjectFrameData.CreateNew;
begin
  inherited Create;
  FFilterId := CFilterAllElements;
end;

constructor TCDataobjectFrameData.CreateWithFilter(AFilterId: String);
begin
  CreateNew;
  FFilterId := AFilterId;
end;

procedure TCDataobjectFrame.ListDblClick(Sender: TObject);
begin
  if List.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) and (TCFrameForm(Owner).BitBtnOk.Visible) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end else begin
      ActionEdit.Execute;
    end;
  end;
end;

procedure TCDataobjectFrame.ReloadDataobjects;
begin
  if Dataobjects <> Nil then begin
    FreeAndNil(Dataobjects);
  end;
end;

function TCDataobjectFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (CStaticFilter.DataId = CFilterAllElements);
end;

procedure TCDataobjectFrame.RefreshData;
begin
  List.ReloadTree;
  ListFocusChanged(List, List.FocusedNode, 0);
  ReloadSums;
end;

procedure TCDataobjectFrame.ListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xFirst, xSecond: TCDataListElementObject;
begin
  if Column <> -1 then begin
    xFirst := List.GetTreeElement(Node1).Data;
    xSecond := List.GetTreeElement(Node2).Data;
    Result := xFirst.GetElementCompare(Column, xSecond, List.ViewTextSelector);
  end;
end;

function TCDataobjectFrame.GetDataobjectParent(ADataobject: TDataObject): TCListDataElement;
begin
  Result := List.RootElement;
end;

function TCDataobjectFrame.FindNodeId(ANode: PVirtualNode): ShortString;
begin
  Result := List.GetTreeElement(ANode).Data.GetElementId;
end;

function TCDataobjectFrame.FindNode(ADataId: TDataGid; AList: TCList): PVirtualNode;
var xCurNode: PVirtualNode;
    xData: TCListDataElement;
begin
  Result := Nil;
  xCurNode := AList.GetFirst;
  while (Result = Nil) and (xCurNode <> Nil) do begin
    xData := TCDataList(AList).GetTreeElement(xCurNode);
    if xData.Data.GetElementId = ADataId then begin
      Result := xCurNode;
    end else begin
      xCurNode := AList.GetNext(xCurNode);
    end;
  end;
end;

function TCDataobjectFrame.GetInitialFilter: String;
begin
  Result := CFilterAllElements;
end;

function TCDataobjectFrame.GetHistoryText: String;
begin
  Result := '';
end;

procedure TCDataobjectFrame.ActionHistoryExecute(Sender: TObject);
begin
  ShowHistory(GetSelectedId);
end;

procedure TCDataobjectFrame.ShowHistory(AGid: TDataGid);
begin
end;

procedure TCDataobjectFrame.HideFrame;
begin
  inherited HideFrame;
  ActionAdd.ShortCut := 0;
  ActionEdit.ShortCut := 0;
  ActionDelete.ShortCut := 0;
end;

procedure TCDataobjectFrame.ShowFrame;
begin
  inherited ShowFrame;
  ActionAdd.ShortCut := ShortCut(Word('D'), [ssCtrl]);
  ActionEdit.ShortCut := ShortCut(Word('E'), [ssCtrl]);
  ActionDelete.ShortCut := ShortCut(Word('U'), [ssCtrl]);
end;

function TCDataobjectFrame.GetAdditionalDataForObject: TAdditionalData;
begin
  Result := Nil;
end;

function TCDataobjectFrame.IsAllElementChecked(ACheckedCount: Integer): Boolean;
begin
  Result := GDataProvider.GetSqlInteger('select count(*) from ' + GetDataObjectProxy(WMOPT_NONE).TableName, -1) = ACheckedCount;
end;

procedure TCDataobjectFrame.DoCheckChanged;
begin
  UpdateButtons(List.SelectedCount > 0);
end;

class function TCDataobjectFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := Nil;
end;

procedure TCDataobjectFrame.DoActionAddExecute;
var xForm: TCDataobjectForm;
begin
  xForm := GetDataobjectForm(WMOPT_NONE).Create(Nil);
  xForm.ShowDataobject(coAdd, GetDataobjectProxy(WMOPT_NONE), Nil, True, GetAdditionalDataForObject);
  xForm.Free;
end;

procedure TCDataobjectFrame.DoActionDeleteExecute;
var xData: TDataObject;
    xBase: TDataObject;
begin
  xBase := TDataObject(List.SelectedElement.Data);
  if xBase.CanBeDeleted(xBase.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun�� obiekt o nazwie "' + xBase.GetElementText + '" ?', '') then begin
      xData := GetDataobjectClass(WMOPT_NONE).LoadObject(GetDataobjectProxy(WMOPT_NONE), xBase.id, False);
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      AfterDeleteObject(xBase);
      SendMessageToFrames(TCBaseFrameClass(ClassType), WM_DATAOBJECTDELETED, Integer(@xBase.id), 0);
    end;
  end;
end;

procedure TCDataobjectFrame.DoActionEditExecute;
var xForm: TCDataobjectForm;
begin
  xForm := GetDataobjectForm(WMOPT_NONE).Create(Nil);
  xForm.ShowDataobject(coEdit, GetDataobjectProxy(WMOPT_NONE), TDataObject(List.SelectedElement.Data), True, GetAdditionalDataForObject);
  xForm.Free;
end;

procedure TCDataobjectFrame.AfterDeleteObject(ADataobject: TDataObject);
begin
end;

class function TCDataobjectFrame.GetPrefname: String;
begin
  Result := ClassName;
end;

procedure TCDataobjectFrame.UpdateIcons;
begin
  UpdatePanelIcons(ButtonPanel,
                   MenuItemBigIcons, MenuItemSmallIcons,
                   FBigIconsButtonsImageList, FBigIconsHistoryImageList,
                   ActionListButtons, ActionListHistory,
                   FSmallIconsButtonsImageList, FSmallIconsHistoryImageList);
end;

procedure TCDataobjectFrame.MenuItemBigIconsClick(Sender: TObject);
begin
  if not MenuItemBigIcons.Checked then begin
    MenuItemBigIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := False;
    end;
    UpdateIcons;
  end;
end;

procedure TCDataobjectFrame.MenuItemSmallIconsClick(Sender: TObject);
begin
  if not MenuItemSmallIcons.Checked then begin
    MenuItemSmallIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := True;
    end;
    UpdateIcons;
  end;
end;

procedure TCDataobjectFrame.DoAddingNewDataobject(ADataobject: TDataObject);
begin
end;

procedure TCDataobjectFrame.DoDeletingNewDataobject(ADataobject: TDataObject);
begin
end;

procedure TCDataobjectFrame.DoEditingNewDataobject(ADataobject: TDataObject);
begin
end;

end.