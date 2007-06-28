unit CFilterDetailFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VirtualTrees,
  ExtCtrls, CImageListsUnit, CDatabase, CDataObjects, CConsts, StdCtrls,
  CComponents, Buttons;

type
  TFilterDetailData = class(TObject)
  private
    FPredefinedId: TDataGid;
    FAccountIds: TStringList;
    FProductIds: TStringList;
    FCashpointIds: TStringList;
  public
    constructor Create;
    property PredefinedId: TDataGid read FPredefinedId write FPredefinedId;
    property AccountIds: TStringList read FAccountIds write FAccountIds;
    property ProductIds: TStringList read FProductIds write FProductIds;
    property CashpointIds: TStringList read FCashpointIds write FCashpointIds;
    destructor Destroy; override;
  end;

  TCFilterDetailFrame = class(TCBaseFrame)
    PanelThumbs: TPanel;
    ThumbsList: TVirtualStringTree;
    Splitter: TSplitter;
    PanelFrames: TPanel;
    PanelShortcutsTitle: TPanel;
    SpeedButtonCloseShortcuts: TSpeedButton;
    Panel1: TPanel;
    CStaticFilter: TCStatic;
    procedure ThumbsListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ThumbsListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ThumbsListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure CStaticPredefinedGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticPredefinedChanged(Sender: TObject);
  private
    FActiveFrameIndex: Integer;
    procedure SetActiveFrameIndex(const Value: Integer);
  protected
    procedure SetOnCheckChanged(const Value: TCheckChanged); override;
    function GetSelectedId: ShortString; override;
    procedure SetSelectedId(const Value: ShortString); override;
  public
    ElementFrames: array[0..2] of TCBaseFrame;
    ElementChecks: array[0..2] of TStringList;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    procedure UpdateOutputData; override;
    procedure RecheckMarks;
    procedure ShowFrame; override;
  published
    property ActiveFrameIndex: Integer read FActiveFrameIndex write SetActiveFrameIndex;
  end;

function DoTemporaryMovementFilter(var ADataGid: String; var AText: String): Boolean;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CProductsFrameUnit, CCashpointsFrameUnit,
  CFilterFrameUnit;

{$R *.dfm}

procedure TCFilterDetailFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
var xCount: Integer;
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  for xCount := 0 to 2 do begin
    ElementFrames[xCount] := Nil;
    ElementChecks[xCount] := TStringList.Create;
  end;
  if AdditionalData <> Nil then begin
    with TFilterDetailData(AdditionalData) do begin
      ElementChecks[0].Assign(FAccountIds);
      ElementChecks[1].Assign(FProductIds);
      ElementChecks[2].Assign(FCashpointIds);
    end;
  end;
  FActiveFrameIndex := -1;
  ThumbsList.RootNodeCount := 3;
end;

procedure TCFilterDetailFrame.ThumbsListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Node.Index = 0 then begin
    CellText := 'Konta';
  end else if Node.Index = 1 then begin
    CellText := 'Kategorie';
  end else begin
    CellText := 'Kontrahenci';
  end;
end;

procedure TCFilterDetailFrame.ThumbsListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Node.Index = 0 then begin
    ImageIndex := 4;
  end else if Node.Index = 1 then begin
    ImageIndex := 5;
  end else begin
    ImageIndex := 6;
  end;
end;

procedure TCFilterDetailFrame.SetActiveFrameIndex(const Value: Integer);
begin
  if FActiveFrameIndex <> Value then begin
    if FActiveFrameIndex <> -1 then begin
      ElementFrames[FActiveFrameIndex].HideFrame;
    end;
    FActiveFrameIndex := Value;
    if ElementFrames[FActiveFrameIndex] = Nil then begin
      if FActiveFrameIndex = 0 then begin
        ElementFrames[FActiveFrameIndex] := TCAccountsFrame.Create(Self);
      end else if FActiveFrameIndex = 1 then begin
        ElementFrames[FActiveFrameIndex] := TCProductsFrame.Create(Self);
      end else begin
        ElementFrames[FActiveFrameIndex] := TCCashpointsFrame.Create(Self);
      end;
      ElementFrames[FActiveFrameIndex].Visible := False;
      ElementFrames[FActiveFrameIndex].DisableAlign;
      ElementFrames[FActiveFrameIndex].InitializeFrame(Self, Nil, Nil, ElementChecks[FActiveFrameIndex], False);
      if ElementFrames[FActiveFrameIndex].GetList <> Nil then begin
        ElementFrames[FActiveFrameIndex].GetList.TabStop := True;
      end;
      ElementFrames[FActiveFrameIndex].PrepareCheckStates;
      ElementFrames[FActiveFrameIndex].Parent := PanelFrames;
      ElementFrames[FActiveFrameIndex].EnableAlign;
    end;
    ElementFrames[FActiveFrameIndex].OnCheckChanged := OnCheckChanged;
    ElementFrames[FActiveFrameIndex].ShowFrame;
  end;
end;

destructor TCFilterDetailFrame.Destroy;
var xCount: Integer;
begin
  for xCount := 0 to 2 do begin
    if ElementFrames[xCount] <> Nil then begin
      ElementFrames[xCount].Free;
    end;
    ElementChecks[xCount].Free;
  end;
  inherited Destroy;
end;

procedure TCFilterDetailFrame.ThumbsListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  if Node <> Nil then begin
    ActiveFrameIndex := Node.Index;
  end;
end;

class function TCFilterDetailFrame.GetTitle: String;
begin
  Result := 'Ustawienia filtru';
end;

procedure TCFilterDetailFrame.UpdateOutputData;
var xCount: Integer;
begin
  with TFilterDetailData(OutputData) do begin
    for xCount := 0 to 2 do begin
      if ElementFrames[xCount] <> Nil then begin
        ElementFrames[xCount].UpdateOutputData;
      end;
    end;
    FAccountIds.Assign(ElementChecks[0]);
    FProductIds.Assign(ElementChecks[1]);
    FCashpointIds.Assign(ElementChecks[2]);
  end;
end;

constructor TFilterDetailData.Create;
begin
  inherited Create;
  FAccountIds := TStringList.Create;
  FCashpointIds := TStringList.Create;
  FProductIds := TStringList.Create;
  FPredefinedId := CEmptyDataGid;
end;

destructor TFilterDetailData.Destroy;
begin
  FAccountIds.Free;
  FCashpointIds.Free;
  FProductIds.Free;
  inherited Destroy;
end;

procedure TCFilterDetailFrame.RecheckMarks;
var xCount: Integer;
begin
  for xCount := 0 to 2 do begin
    if ElementFrames[xCount] <> Nil then begin
      ElementFrames[xCount].MultipleChecks.Text := ElementChecks[xCount].Text;
      ElementFrames[xCount].PrepareCheckStates;
    end;
  end;
end;

procedure TCFilterDetailFrame.ShowFrame;
begin
  inherited ShowFrame;
  if FActiveFrameIndex = -1 then begin
    ActiveFrameIndex := 0;
    ThumbsList.FocusedNode := ThumbsList.GetFirst;
    ThumbsList.Selected[ThumbsList.FocusedNode] := True;
  end;
end;

procedure TCFilterDetailFrame.SetOnCheckChanged(const Value: TCheckChanged);
var xCount: Integer;
begin
  inherited SetOnCheckChanged(Value);
  for xCount := 0 to 2 do begin
    if ElementFrames[xCount] <> Nil then begin
      ElementFrames[xCount].OnCheckChanged := Value;
    end;
  end;
end;

function TCFilterDetailFrame.GetSelectedId: ShortString;
begin
  //Result := CStaticPredefined.DataId;
end;

procedure TCFilterDetailFrame.SetSelectedId(const Value: ShortString);
begin
  //CStaticPredefined.DataId := Value;
  if Value <> CEmptyDataGid then begin
    GDataProvider.BeginTransaction;
    //CStaticPredefined.Caption := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, Value, False)).name;
    GDataProvider.RollbackTransaction;
  end;
end;

procedure TCFilterDetailFrame.CStaticPredefinedGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCFilterFrame, ADataGid, AText);
end;

procedure TCFilterDetailFrame.CStaticPredefinedChanged(Sender: TObject);
var xFilter: TMovementFilter;
begin
  GDataProvider.BeginTransaction;
  //xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, CStaticPredefined.DataId, False));
  xFilter.LoadSubfilters;
  ElementChecks[0].Assign(xFilter.accounts);
  ElementChecks[1].Assign(xFilter.products);
  ElementChecks[2].Assign(xFilter.cashpoints);
  GDataProvider.RollbackTransaction;
  RecheckMarks;
end;

function DoTemporaryMovementFilter(var ADataGid: String; var AText: String): Boolean;
var xId, xText: String;
    xData: TFilterDetailData;
    xOutput: TFilterDetailData;
{
    xFilter: TMovementFilter;
    xWasTemp: Boolean;
    xPrevious: TDataGid;
}
begin
  xData := TFilterDetailData.Create;
  xOutput := TFilterDetailData.Create;
  Result := TCFrameForm.ShowFrame(TCFilterDetailFrame, xId, xText, xData, Nil, xOutput, Nil, True, TCFrameForm, False);
  xOutput.Free;
  {
  xData := TFilterDetailData.Create;
  xOutput := TFilterDetailData.Create;
  xPrevious := ADataGid;
  if ADataGid <> CEmptyDataGid then begin
    GDataProvider.BeginTransaction;
    xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, ADataGid, False));
    xFilter.LoadSubfilters;
    xData.AccountIds.Assign(xFilter.accounts);
    xData.ProductIds.Assign(xFilter.products);
    xData.CashpointIds.Assign(xFilter.cashpoints);
    xData.PredefinedId := ADataGid;
    xWasTemp := xFilter.isTemp;
    GDataProvider.RollbackTransaction;
  end else begin
    xWasTemp := True;
  end;
  Result := TCFrameForm.ShowFrame(TCFilterDetailFrame, xId, xText, xData, Nil, xOutput, Nil, True, TCTempFilterForm);
  if Result then begin
    GDataProvider.BeginTransaction;
    xFilter := Nil;
    if not ((ADataGid = CEmptyDataGid) and (xOutput.PredefinedId = CEmptyDataGid)) then begin
      if xWasTemp and (xOutput.PredefinedId <> CEmptyDataGid) and (xOutput.PredefinedId <> xPrevious) then begin
        if xPrevious <> CEmptyDataGid then begin
          xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, xPrevious, False));
          xFilter.DeleteObject;
        end;
        xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, xOutput.PredefinedId, False));
      end else begin
        if xPrevious = xOutput.PredefinedId then begin
          xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, xPrevious, False));
        end;
      end;
    end;
    if xFilter = Nil then begin
      xFilter := TMovementFilter.CreateObject(MovementFilterProxy, False);
      xFilter.name := 'szczeg�y filtru';
      xFilter.description := 'filtr tymczasowy';
      xFilter.isTemp := True;
    end;
    if xFilter.isTemp then begin
      xFilter.accounts := xOutput.AccountIds;
      xFilter.products := xOutput.ProductIds;
      xFilter.cashpoints := xOutput.CashpointIds;
    end;
    ADataGid := xFilter.id;
    AText := xFilter.name;
    GDataProvider.CommitTransaction;
  end;
  xOutput.Free;
  }
end;

end.
