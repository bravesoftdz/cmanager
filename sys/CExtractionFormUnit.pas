unit CExtractionFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, VirtualTrees, Contnrs,
  CDatabase, CBaseFrameUnit, CExtractionItemFormUnit;

type
  TExtractionAdditionalData = class(TAdditionalData)
  private
    FcreationDate: TDateTime;
    FstartDate: TDateTime;
    FendDate: TDateTime;
    Fdescription: String;
    Fmovements: TObjectList;
  public
    constructor Create(ACDate, ASDate, AEDate: TDateTime; ADescription: String);
    destructor Destroy; override;
    property movements: TObjectList read Fmovements write Fmovements;
  end;

  TCExtractionForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    CDateTime: TCDateTime;
    CStaticAccount: TCStatic;
    Label1: TLabel;
    ComboBoxState: TComboBox;
    Label2: TLabel;
    CDateTime1: TCDateTime;
    Label4: TLabel;
    CDateTime2: TCDateTime;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TCRichedit;
    ComboBoxTemplate: TComboBox;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    GroupBox3: TGroupBox;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    CButtonOut: TCButton;
    CButtonEdit: TCButton;
    CButtonDel: TCButton;
    MovementList: TCList;
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountChanged(Sender: TObject);
    procedure CDateTime1Changed(Sender: TObject);
    procedure CDateTime2Changed(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure ComboBoxStateChange(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure MovementListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure MovementListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure MovementListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure MovementListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure MovementListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure MovementListDblClick(Sender: TObject);
    procedure MovementListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure MovementListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
  private
    Fmovements: TObjectList;
    Fdeleted: TObjectList;
    Fmodified: TObjectList;
    Fadded: TObjectList;
    procedure UpdateDescription;
    procedure UpdateButtons;
    procedure MessageMovementAdded(AData: TExtractionListElement);
    procedure MessageMovementEdited(AData: TExtractionListElement);
    procedure MessageMovementDeleted(AData: TExtractionListElement);
    function FindNodeByData(AData: TExtractionListElement): PVirtualNode;
  protected
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    procedure ReadValues; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure WndProc(var Message: TMessage); override;
    procedure AfterCommitData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CTemplates, CPreferences, CConsts,
  CRichtext, CDescpatternFormUnit, DateUtils, CInfoFormUnit, CDataObjects,
  Math, CConfigFormUnit, CExtractionsFrameUnit, StrUtils;

{$R *.dfm}

procedure TCExtractionForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCExtractionForm.CStaticAccountChanged(Sender: TObject);
var xCount: Integer;
begin
  for xCount := 0 to Fmovements.Count - 1 do begin
    TExtractionListElement(Fmovements.Items[xCount]).idAccount := CStaticAccount.DataId;
  end;
  UpdateDescription;
end;

procedure TCExtractionForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[5][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GAccountExtractionTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;


procedure TCExtractionForm.InitializeForm;
var xItem: TExtractionListElement;
begin
  inherited InitializeForm;
  if AdditionalData = Nil then begin
    CDateTime.Value := GWorkDate;
    CDateTime1.Value := StartOfTheMonth(GWorkDate);
    CDateTime2.Value := EndOfTheMonth(GWorkDate);
  end else begin
    CDateTime.Value := TExtractionAdditionalData(AdditionalData).FcreationDate;
    CDateTime1.Value := TExtractionAdditionalData(AdditionalData).FstartDate;
    CDateTime2.Value := TExtractionAdditionalData(AdditionalData).FendDate;
    ComboBoxTemplate.ItemIndex := 0;
    SimpleRichText(TExtractionAdditionalData(AdditionalData).Fdescription, RichEditDesc);
    while TExtractionAdditionalData(AdditionalData).movements.Count > 0 do begin
      xItem := TExtractionListElement(TExtractionAdditionalData(AdditionalData).movements.First);
      xItem := TExtractionListElement(TExtractionAdditionalData(AdditionalData).movements.Extract(xItem));
      Fmovements.Add(xItem);
      Fadded.Add(xItem);
    end;
    MovementList.RootNodeCount := Fmovements.Count;
  end;
  MovementListFocusChanged(MovementList, MovementList.FocusedNode, 0);
  UpdateButtons;
  UpdateDescription;
end;

procedure TCExtractionForm.CDateTime1Changed(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionForm.CDateTime2Changed(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionForm.ComboBoxStateChange(Sender: TObject);
begin
  UpdateButtons;
  UpdateDescription;
end;

procedure TCExtractionForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GAccountExtractionTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCExtractionForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[5][0], xPattern) then begin
    UpdateDescription;
  end;
end;

function TCExtractionForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticAccount.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano konta z jakim b�dzie zwi�zany wyci�g. Czy wy�wietli� list� teraz ?', '') then begin
      CStaticAccount.DoGetDataId;
    end;
  end;
end;

function TCExtractionForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TAccountExtraction;
end;

procedure TCExtractionForm.FillForm;
var xList: TDataObjectList;
    xCount: Integer;
    xElement: TExtractionListElement;
    xMovement: TExtractionItem;
begin
  inherited FillForm;
  with TAccountExtraction(Dataobject) do begin
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    GDataProvider.BeginTransaction;
    CStaticAccount.DataId := idAccount;
    CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
    CDateTime.Value := regDate;
    CDateTime1.Value := startDate;
    CDateTime2.Value := endDate;
    SimpleRichText(description, RichEditDesc);
    if extractionState = CExtractionStateOpen then begin
      ComboBoxState.ItemIndex := 0;
    end else if extractionState = CExtractionStateClose then begin
      ComboBoxState.ItemIndex := 1;
    end else begin
      ComboBoxState.ItemIndex := 2;
    end;
    xList := GetMovements;
    Fmovements.Clear;
    for xCount := 0 to xList.Count - 1 do begin
      xElement := TExtractionListElement.Create;
      xMovement := TExtractionItem(xList.Items[xCount]);
      xElement.id := xMovement.id;
      xElement.description := xMovement.description;
      xElement.movementType := xMovement.movementType;
      xElement.cash := xMovement.cash;
      xElement.idCurrencyDef := xMovement.idCurrencyDef;
      xElement.regTime := xMovement.regDate;
      xElement.idAccount := idAccount;
      Fmovements.Add(xElement);
    end;
    xList.Free;
    GDataProvider.RollbackTransaction;
    MovementList.RootNodeCount := Fmovements.Count;
    UpdateButtons;
  end;
end;

procedure TCExtractionForm.ReadValues;
begin
  inherited ReadValues;
  with TAccountExtraction(Dataobject) do begin
    description := RichEditDesc.Text;
    idAccount := CStaticAccount.DataId;
    regDate := CDateTime.Value;
    startDate := CDateTime1.Value;
    endDate := CDateTime2.Value;
    if ComboBoxState.ItemIndex = 0 then begin
      extractionState := CExtractionStateOpen;
    end else if ComboBoxState.ItemIndex = 1 then begin
      extractionState := CExtractionStateClose;
    end else begin
      extractionState := CExtractionStateStated;
    end;
  end;
end;

function TCExtractionForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCExtractionsFrame;
end;

constructor TCExtractionForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fadded := TObjectList.Create(False);
  Fmovements := TObjectList.Create(True);
  Fmodified := TObjectList.Create(False);
  Fdeleted := TObjectList.Create(True);
end;

destructor TCExtractionForm.Destroy;
begin
  Fadded.Free;
  Fdeleted.Free;
  Fmodified.Free;
  Fmovements.Free;
  inherited Destroy;
end;

procedure TCExtractionForm.Action1Execute(Sender: TObject);
var xForm: TCExtractionItemForm;
    xElement: TExtractionListElement;
begin
  if CStaticAccount.DataId = CEmptyDataGid then begin
    if ShowInfo(itQuestion, 'Nie wybrano konta dotycz�cego wyci�gu. Czy wy�wietli� list� teraz ?', '') then begin
      CStaticAccount.DoGetDataId;
    end;
  end else begin
    xElement := TExtractionListElement.Create;
    xElement.isNew := True;
    xElement.movementType := CInMovement;
    xElement.idAccount := CStaticAccount.DataId;
    xElement.idCurrencyDef := CCurrencyDefGid_PLN;
    xElement.regTime := GWorkDate;
    xForm := TCExtractionItemForm.CreateFormElement(Application, xElement);
    if xForm.ShowConfig(coAdd) then begin
      Perform(WM_DATAOBJECTADDED, Integer(xElement), 0);
      UpdateButtons;
    end else begin
      xElement.Free;
    end;
    xForm.Free;
  end;
end;

procedure TCExtractionForm.UpdateButtons;
begin
  CDateTime.Enabled := ComboBoxState.ItemIndex = 0;
  CDateTime1.Enabled := ComboBoxState.ItemIndex = 0;
  CDateTime2.Enabled := ComboBoxState.ItemIndex = 0;
  CStaticAccount.Enabled := ComboBoxState.ItemIndex = 0;
  CButtonOut.Enabled := ComboBoxState.ItemIndex = 0;
  CButtonEdit.Enabled := ComboBoxState.ItemIndex = 0;
  CButtonDel.Enabled := ComboBoxState.ItemIndex = 0;
end;

procedure TCExtractionForm.Action2Execute(Sender: TObject);
var xForm: TCExtractionItemForm;
    xElement: TExtractionListElement;
begin
  if MovementList.FocusedNode <> Nil then begin
    xElement := TExtractionListElement(MovementList.GetNodeData(MovementList.FocusedNode)^);
    xForm := TCExtractionItemForm.CreateFormElement(Application, xElement);
    if xForm.ShowConfig(coEdit) then begin
      Perform(WM_DATAOBJECTEDITED, Integer(xElement), 0);
      UpdateButtons;
    end;
    xForm.Free;
  end;
end;

procedure TCExtractionForm.Action3Execute(Sender: TObject);
var xElement: TExtractionListElement;
begin
  if ShowInfo(itQuestion, 'Czy chcesz usun�� wybran� operacj� ?', '') then begin
    xElement := TExtractionListElement(MovementList.GetNodeData(MovementList.FocusedNode)^);
    Perform(WM_DATAOBJECTDELETED, Integer(xElement), 0);
    UpdateButtons;
  end;
end;

procedure TCExtractionForm.MessageMovementAdded(AData: TExtractionListElement);
var xNode: PVirtualNode;
begin
  Fmovements.Add(AData);
  Fadded.Add(AData);
  xNode := MovementList.AddChild(Nil, AData);
  MovementList.Sort(xNode, MovementList.Header.SortColumn, MovementList.Header.SortDirection);
  MovementList.FocusedNode := xNode;
  MovementList.Selected[xNode] := True;
end;

procedure TCExtractionForm.MessageMovementDeleted(AData: TExtractionListElement);
var xNode: PVirtualNode;
    xData: TExtractionListElement;
begin
  xNode := FindNodeByData(AData);
  if xNode <> Nil then begin
    MovementList.BeginUpdate;
    if Fmodified.IndexOf(AData) <> -1 then begin
      Fmodified.Remove(AData);
    end;
    if Fadded.IndexOf(AData) <> -1 then begin
      Fadded.Remove(AData);
    end;
    xData := TExtractionListElement(Fmovements.Extract(AData));
    if not xData.isNew then begin
      Fdeleted.Add(xData);
    end;
    MovementList.DeleteNode(xNode);
    MovementList.EndUpdate;
  end;
end;

procedure TCExtractionForm.MessageMovementEdited(AData: TExtractionListElement);
var xNode:  PVirtualNode;
begin
  if (Fmodified.IndexOf(AData) = -1) and (Fadded.IndexOf(AData) = -1) then begin
    Fmodified.Add(AData);
  end;
  xNode := FindNodeByData(AData);
  MovementList.InvalidateNode(xNode);
  MovementList.Sort(xNode, MovementList.Header.SortColumn, MovementList.Header.SortDirection);
end;

function TCExtractionForm.FindNodeByData(AData: TExtractionListElement): PVirtualNode;
var xCurNode: PVirtualNode;
begin
  Result := Nil;
  xCurNode := MovementList.GetFirst;
  while (xCurNode <> Nil) and (Result = Nil) do begin
    if TExtractionListElement(MovementList.GetNodeData(xCurNode)^) = AData then begin
      Result := xCurNode;
    end else begin
      xCurNode := MovementList.GetNextSibling(xCurNode);
    end;
  end;
end;

procedure TCExtractionForm.WndProc(var Message: TMessage);
var xData: TExtractionListElement;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xData := TExtractionListElement(WParam);
      MessageMovementAdded(xData);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xData := TExtractionListElement(WParam);
      MessageMovementEdited(xData);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xData := TExtractionListElement(WParam);
      MessageMovementDeleted(xData);
    end;
  end;
end;

procedure TCExtractionForm.AfterCommitData;
var xCount: Integer;
    xItem: TExtractionItem;
begin
  inherited AfterCommitData;
  GDataProvider.BeginTransaction;
  for xCount := 0 to Fadded.Count - 1 do begin
    with TExtractionListElement(Fadded.Items[xCount]) do begin
      xItem := TExtractionItem.CreateObject(ExtractionItemProxy, False);
      xItem.id := id;
      xItem.description := description;
      xItem.cash := cash;
      xItem.movementType := movementType;
      xItem.regDate := regTime;
      xItem.idCurrencyDef := idCurrencyDef;
      xItem.idAccountExtraction := Dataobject.id;
    end;
  end;
  for xCount := 0 to Fmodified.Count - 1 do begin
    with TExtractionListElement(Fmodified.Items[xCount]) do begin
      xItem := TExtractionItem(TExtractionItem.LoadObject(ExtractionItemProxy, id, False));
      xItem.description := description;
      xItem.cash := cash;
      xItem.movementType := movementType;
      xItem.regDate := regTime;
      xItem.idCurrencyDef := idCurrencyDef;
    end;
  end;
  for xCount := 0 to Fdeleted.Count - 1 do begin
    with TExtractionListElement(Fdeleted.Items[xCount]) do begin
      xItem := TExtractionItem(TExtractionItem.LoadObject(ExtractionItemProxy, id, False));
      xItem.DeleteObject;
    end;
  end;
  GDataProvider.CommitTransaction;
end;

procedure TCExtractionForm.MovementListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TExtractionListElement(MovementList.GetNodeData(Node)^) := TExtractionListElement(Fmovements.Items[Node.Index]);
end;

procedure TCExtractionForm.MovementListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TExtractionListElement;
begin
  xData := TExtractionListElement(MovementList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := IntToStr(Node.Index + 1);
  end else if Column = 1 then begin
    CellText := DateToStr(xData.regTime);
  end else if Column = 2 then begin
    CellText := xData.description;
  end else if Column = 3 then begin
    CellText := CurrencyToString(IfThen(xData.movementType = CInMovement, 1, -1) * xData.cash, '', False);
  end else if Column = 4 then begin
    CellText := GCurrencyCache.GetSymbol(xData.idCurrencyDef);
  end else if Column = 5 then begin
    CellText := IfThen(xData.movementType = CInMovement, 'Uznanie', 'Obci��enie');
  end;
end;

procedure TCExtractionForm.MovementListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TExtractionListElement);
end;

procedure TCExtractionForm.MovementListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TExtractionListElement;
begin
  xData := TExtractionListElement(MovementList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCExtractionForm.MovementListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  CButtonEdit.Enabled := Node <> Nil;
  CButtonDel.Enabled := Node <> Nil;
end;

procedure TCExtractionForm.MovementListDblClick(Sender: TObject);
begin
  Action2.Execute;
end;

procedure TCExtractionForm.MovementListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TExtractionListElement;
    xData2: TExtractionListElement;
begin
  xData1 := TExtractionListElement(MovementList.GetNodeData(Node1)^);
  xData2 := TExtractionListElement(MovementList.GetNodeData(Node2)^);
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
    if xData1.cash > xData2.cash then begin
      Result := 1;
    end else if xData1.cash < xData2.cash then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end;
end;

function TCExtractionForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@datawyciagu@' then begin
    Result := GetFormattedDate(CDateTime.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@oddaty@' then begin
    Result := GetFormattedDate(CDateTime1.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@dodaty@' then begin
    Result := GetFormattedDate(CDateTime2.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@status@' then begin
    Result := ComboBoxState.Text;
  end else if ATemplate = '@konto@' then begin
    Result := '<konto>';
    if CStaticAccount.DataId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      Result := TAccount(TAccount.LoadObject(AccountProxy, CStaticAccount.DataId, False)).name;
      GDataProvider.RollbackTransaction;
    end;
  end;
end;

procedure TCExtractionForm.MovementListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var xData: TExtractionListElement;
begin
  if Column = 5 then begin
    xData := TExtractionListElement(MovementList.GetNodeData(Node)^);
    ImageIndex := IfThen(xData.movementType = CInMovement, 0, 1);
  end;
end;

constructor TExtractionAdditionalData.Create(ACDate, ASDate, AEDate: TDateTime; ADescription: String);
begin
  inherited Create;
  FcreationDate := ACDate;
  FstartDate := ASDate;
  FendDate := AEDate;
  Fdescription := ADescription;
  Fmovements := TObjectList.Create;
end;

destructor TExtractionAdditionalData.Destroy;
begin
  Fmovements.Free;
  inherited Destroy;
end;

end.
