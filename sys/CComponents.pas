unit CComponents;

interface

uses Windows, Messages, Graphics, Controls, ActnList, Classes, CommCtrl, ImgList,
     Buttons, StdCtrls, ExtCtrls, SysUtils, ComCtrls, IntfUIHandlers, ShDocVw,
     ActiveX, PngImageList, VirtualTrees, GraphUtil, Contnrs, Types, RichEdit,
     ShellApi;

type
  TPicturePosition = (ppLeft, ppTop, ppRight);

  TCButton = class(TGraphicControl)
  private
    FMouseIn: Boolean;
    FPicPosition: TPicturePosition;
    FPicOffset: Integer;
    FTxtOffset: Integer;
    FFramed: Boolean;
    procedure SetPicturePosition(const Value: TPicturePosition);
    procedure SetPicOffset(const Value: Integer);
    procedure SetTxtOffset(const Value: Integer);
    procedure SetFramed(const Value: Boolean);
  protected
    procedure Paint; override;
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Canvas;
  published
    property PicPosition: TPicturePosition read FPicPosition write SetPicturePosition;
    property PicOffset: Integer read FPicOffset write SetPicOffset;
    property TxtOffset: Integer read FTxtOffset write SetTxtOffset;
    property Framed: Boolean read FFramed write SetFramed;
    property Action;
    property Anchors;
    property Caption;
    property Enabled;
    property OnClick;
    property Color;
    property Font;
  end;

  TCImage = class(TGraphicControl)
  private
    FImageList: TPngImageList;
    FImageIndex: Integer;
    procedure SetImageIndex(const Value: Integer);
    procedure SeTPngImageList(const Value: TPngImageList);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ImageList: TPngImageList read FImageList write SeTPngImageList;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
  end;

  TOnGetDataId = procedure (var ADataGid: String; var AText: String; var AAccepted: Boolean) of Object;
  TOnClearDataId = procedure (ACurrentDataGid: String; var ACanClear: Boolean) of Object;

  TCStatic = class(TStaticText)
  private
    FDataId: string;
    FOnGetDataId: TOnGetDataId;
    FOnClearDataId: TOnClearDataId;
    FOnChanged: TNotifyEvent;
    FTextOnEmpty: string;
    FHotTrack: Boolean;
    FOldColor: TColor;
    FCanvas: TCanvas;
    FInternalIsFocused: Boolean;
    procedure SetDataId(const Value: string);
    procedure SetTextOnEmpty(const Value: string);
  protected
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Loaded; override;
    procedure Click; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoGetDataId;
    procedure DoClearDataId(var ACanAccept: Boolean);
    property Canvas: TCanvas read FCanvas;
    destructor Destroy; override;
    function CanFocus: Boolean; override;
  published
    property DataId: string read FDataId write SetDataId;
    property TextOnEmpty: string read FTextOnEmpty write SetTextOnEmpty;
    property Action;
    property OnKeyDown;
    property OnKeyPress;
    property Enabled;
    property OnGetDataId: TOnGetDataId read FOnGetDataId write FOnGetDataId;
    property OnClearDataId: TOnClearDataId read FOnClearDataId write FOnClearDataId;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property HotTrack: Boolean read FHotTrack write FHotTrack;
  end;

  TCDateTime = class(TStaticText)
  private
    FValue: TDateTime;
    FOnChanged: TNotifyEvent;
    FHotTrack: Boolean;
    FOldColor: TColor;
    FInternalIsFocused: Boolean;
    FCanvas: TCanvas;
    procedure SetValue(const Value: TDateTime);
    procedure UpdateCaption;
  protected
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanFocus: Boolean; override;
  published
    property Value: TDateTime read FValue write SetValue;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property HotTrack: Boolean read FHotTrack write FHotTrack;
  end;

  TCEditError = class(Exception);

  TCCurrEdit = class(TCustomEdit)
  private
    FAlign: TAlignment;
    FValue: Currency;
    FMaxDigits: smallint;
    FDecimals: smallint;
    FCurrencyStr: string;
    FOldText: string;
    FShowKSeps: boolean;
    FEditMode: boolean;
    FWithCalculator: Boolean;
    FCurrencyId: String;
    procedure SetTextFromValue;
    function LeftStr(OrgStr: string; CharCount: smallint): string;
    function RightStr(OrgStr: string; CharCount: smallint): string;
    function InsertChars(OrgStr, InsChars: string; CharPos: smallint): string;
    function DeleteChars(OrgStr: string; CharPos, CharCount: smallint): string;
    function ReplaceChars(OrgStr, ReplChars: string; CharPos: smallint): string;
    function ReplaceChars2(OrgStr: string; ReplChar: Char; CharPos, CharCount: smallint): string;
    function GetDecimals: smallint;
    procedure SetDecimals(Value: smallint);
    function GetValue: Currency;
    procedure SetValue(Value: Currency);
    procedure SetCurrencyStr(const Value: String);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    function FormatIt(AValue: Double; ShowMode: boolean): string;
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Update; override;
    function AsCurrency: Currency;
    function AsFloat: double;
    function AsString: string;
    destructor Destroy; override;
    procedure SetCurrencyDef(AId, ASymbol: String);
  published
    property AutoSelect;
    property AutoSize;
    property Anchors;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Decimals: smallint read GetDecimals write SetDecimals;
    property Value: Currency read GetValue write SetValue;
    property ThousandSep: Boolean read FShowKSeps write FShowKSeps;
    property CurrencyStr: String read FCurrencyStr write SetCurrencyStr;
    property BevelEdges;
    property BevelKind;
    property BevelOuter;
    property BevelInner;
    property BevelWidth;
    property WithCalculator: Boolean read FWithCalculator write FWithCalculator;
    property CurrencyId: String read FCurrencyId write FCurrencyId;
  end;

  TCBrowser = class(TWebBrowser, IDocHostUIHandler)
  private
    FAutoVSize: Boolean;
    procedure SetAutoVSize(const Value: Boolean);
  public
    function LoadFromString(AInString: String): Boolean;
    function ShowContextMenu(const dwID: Cardinal; const ppt: PPoint; const pcmdtReserved: IInterface; const pdispReserved: IDispatch): HRESULT; stdcall;
    function GetHostInfo(var pInfo: TDocHostUIInfo): HRESULT; stdcall;
    function ShowUI(const dwID: Cardinal; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function EnableModeless(const fEnable: LongBool): HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function OnDocWindowActivate(const fActivate: BOOL): HResult; stdcall;
    function OnFrameWindowActivate(const fActivate: BOOL): HResult; stdcall;
    function ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fFrameWindow: BOOL): HResult; stdcall;
    function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HResult; stdcall;
    function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD ): HResult; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
    function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HResult; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult; stdcall;
    procedure WaitFor;
    procedure CancelRequest;
    constructor Create(AOwner: TComponent); override;
  published
    property AutoVSize: Boolean read FAutoVSize write SetAutoVSize;
  end;

  TCIntEdit = class(TEdit)
  private
    function GetValue: Integer;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoExit; override;
    procedure DoEnter; override;
  public
    property Value: Integer read GetValue;
  end;

  TCDataList = class;

  TCDataListElementObject = class
  public
    function GetElementType: String; virtual;
    function GetElementId: String; virtual;
    function GetElementText: String; virtual;
    function GetElementHint(AColumnIndex: Integer): String; virtual;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; virtual; abstract;
    function GetColumnImage(AColumnIndex: Integer): Integer; virtual;
    function GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject): Integer; virtual;
    procedure GetElementReload; virtual; 
  end;

  TCListDataElement = class(TObjectList)
  private
    FFreeDataOnClear: Boolean;
    FParentList: TCDataList;
    FData: TCDataListElementObject;
    FNode: PVirtualNode;
    function GetItems(AIndex: Integer): TCListDataElement;
    procedure SetItems(AIndex: Integer; const Value: TCListDataElement);
  public
    constructor Create(AParentList: TCDataList; AData: TCDataListElementObject; AFreeDataOnClear: Boolean = False);
    function FindDataElement(AId: String; AElementType: String = ''; ARecursive: Boolean = True): TCListDataElement;
    procedure DeleteDataElement(AId: String; AElementType: String = '');
    procedure RefreshDataElement(AId: String; AElementType: String = '');
    function AppendDataElement(ANodeData: TCListDataElement): PVirtualNode;
    property Items[AIndex: Integer]: TCListDataElement read GetItems write SetItems;
    property ParentList: TCDataList read FParentList write FParentList;
    property Data: TCDataListElementObject read FData write FData;
    property Node: PVirtualNode read FNode write FNode;
    destructor Destroy; override;
    property FreeDataOnClear: Boolean read FFreeDataOnClear write FFreeDataOnClear;
  end;

  TCList = class(TVirtualStringTree)
  private
    FOddColor: TColor;
    FAutoExpand: Boolean;
    procedure SetOddColor(const Value: TColor);
  protected
    procedure DoBeforeItemErase(Canvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var Color: TColor; var EraseAction: TItemEraseAction); override;
    procedure DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetVisibleIndex(ANode: PVirtualNode): Integer;
    function SumColumn(AColumnIndex: TColumnIndex; var ASum: Extended): Boolean;
  published
    property OddColor: TColor read FOddColor write SetOddColor;
    property AutoExpand: Boolean read FAutoExpand write FAutoExpand;
  end;

  TCDataListOnReloadTree = procedure (Sender: TCDataList; ARootElement: TCListDataElement) of object;

  TCDataList = class(TCList)
  private
    FCOnReloadTree: TCDataListOnReloadTree;
    FRootElement: TCListDataElement;
    function GetSelectedId: String;
    function GetSelectedText: String;
    function GetSelectedElement: TCListDataElement;
  protected
    procedure ValidateNodeDataSize(var Size: Integer); override;
    procedure DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates); override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString); override;
    function DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var Index: Integer): TCustomImageList; override;
    procedure DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal); override;
    function DoGetNodeHint(Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle): WideString; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReloadTree;
    function GetTreeElement(ANode: PVirtualNode): TCListDataElement;
    property RootElement: TCListDataElement read FRootElement;
    property SelectedId: String read GetSelectedId;
    property SelectedText: String read GetSelectedText;
    property SelectedElement: TCListDataElement read GetSelectedElement;
  published
    property OnCDataListReloadTree: TCDataListOnReloadTree read FCOnReloadTree write FCOnReloadTree;
  end;

  TCStatusPanel = class(TStatusPanel)
  private
    FImageIndex: Integer;
    FClickable: Boolean;
    procedure SetImageIndex(const Value: Integer);
  public
    constructor Create(Collection: TCollection); override;
  published
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Clickable: Boolean read FClickable write FClickable;
  end;

  TCStatusBar = class(TStatusBar)
  private
    FImageList: TPngImageList;
  protected
    function GetPanelClass: TStatusPanelClass; override;
    procedure DrawPanel(Panel: TStatusPanel; const Rect: TRect); override;
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
  public
    procedure SetPngImageList(const Value: TPngImageList);
    procedure UpdateCursor;
    function GetPanelWithMouse: TCStatusPanel;
    constructor Create(AOwner: TComponent); override;
  published
    property ImageList: TPngImageList read FImageList write SetPngImageList;
  end;

  TURLClickEvent = procedure(Sender :TObject; const URL: string) of object;

  TCRichedit = class(TRichEdit)
  private
    FOnURLClick: TURLClickEvent;
    procedure DoURLClick(const AURL: string);
  protected
    procedure CreateWnd; override;
    procedure CNNotify(var Message: TMessage); message CN_NOTIFY;
  published
    property OnURLClick: TURLClickEvent read FOnURLClick write FOnURLClick;
  end;

function GetCurrencySymbol: string;
procedure SetCurrencySymbol(ACurrencyId: String; ACurrencySymbol: String);
function FindNodeWithIndex(AIndex: Cardinal; AList: TVirtualStringTree): PVirtualNode;

var CurrencyComponents: TObjectList;

procedure Register;

implementation

uses Forms, CCalendarFormUnit, DateUtils, ComObj, CCalculatorFormUnit,
  Math;

procedure Register;
begin
  RegisterComponents('CManager', [TCButton, TCImage, TCStatic, TCCurrEdit, TCDateTime, TCBrowser, TCIntEdit, TCList, TCDataList, TCStatusBar, TCRichedit]);
end;

procedure TCButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  Invalidate;
end;

procedure TCButton.CMMouseenter(var Message: TMessage);
begin
  if (not (csDesigning in ComponentState)) and Enabled then begin
    FMouseIn := True;
    Font.Style := Font.Style + [fsUnderline];
    Font.Color := clNavy;
    Invalidate;
  end;
end;

procedure TCButton.CMMouseleave(var Message: TMessage);
begin
  if (not (csDesigning in ComponentState)) and Enabled then begin
    FMouseIn := False;
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := clWindowText;
    Invalidate;
  end;
end;

constructor TCButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := clBtnFace;
  FMouseIn := False;
  FPicPosition := ppTop;
  FPicOffset := 10;
  FTxtOffset := 15;
  FFramed := False;
  Cursor := crHandPoint;
  Color := clWindow;
end;

procedure TCButton.Paint;
var
  xDC: HDC;
  xTextHeight: Integer;
  xTextWidth: Integer;
  xImgX, xImgY: Integer;
  xTxtX, xTxtY: Integer;
  xImages: TCustomImageList;
begin
  xDC := Canvas.Handle;
  if Action <> nil then begin
    xImages := TCustomAction(Action).ActionList.Images;
  end else begin
    xImages := nil;
  end;
  if FFramed then begin
    Canvas.Brush.Style := bsSolid;
    if (FMouseIn and Enabled) or (csDesigning in ComponentState) then begin
      Canvas.Brush.Color := clBtnFace;
      Canvas.Pen.Color := clAppWorkSpace;
      Canvas.RoundRect(0, 0, Width, Height, 10, 10);
    end;
  end;
  xImgX := 0;
  xImgY := 0;
  xTxtX := 0;
  xTxtY := 0;
  xTextHeight := Canvas.TextHeight(Caption);
  xTextWidth := Canvas.TextWidth(Caption);
  case FPicPosition of
    ppLeft: begin
        if xImages <> nil then begin
          xImgY := (Height - xImages.Height) div 2;
          xTxtX := xImgX + xImages.Width + FTxtOffset;
        end else begin
          xTxtX := FTxtOffset;
        end;
        xImgX := FPicOffset;
        xTxtY := (Height - xTextHeight) div 2;
      end;
    ppRight: begin
        if xImages <> nil then begin
          xImgY := (Height - xImages.Height) div 2;
          xTxtX := Width - (xImgX + xImages.Width + FTxtOffset) - Canvas.TextWidth(Caption);
        end else begin
          xTxtX := FTxtOffset;
        end;
        xImgX := Width - FPicOffset - xImages.Width;
        xTxtY := (Height - xTextHeight) div 2;
      end;
    ppTop: begin
        if xImages <> nil then begin
          xImgX := (Width - xImages.Width) div 2;
          xTxtY := xImgY + xImages.Height + FTxtOffset;
        end else begin
          xTxtY := FTxtOffset;
        end;
        xImgY := FPicOffset;
        xTxtX := (Width - xTextWidth) div 2;
      end;
  end;
  if (Action <> nil) then begin
    if (TCustomAction(Action).ImageIndex <> -1) and (xImages <> Nil) then begin
      ImageList_Draw(xImages.Handle, TCustomAction(Action).ImageIndex, xDC, xImgX, xImgY, ILD_NORMAL);
    end;
  end;
  Canvas.Brush.Style := bsClear;
  if (csDesigning in ComponentState) then begin
    Canvas.Brush.Color := Color;
  end else begin
    if FMouseIn and FFramed and Enabled then begin
      Canvas.Brush.Color := clBtnFace;
    end else begin
      Canvas.Brush.Color := Color;
    end;
  end;
  if Enabled then begin
    Canvas.Font.Color := Font.Color;
    Canvas.Font.Style := Font.Style;
  end else begin
    Canvas.Font.Color := clInactiveCaption;
    Canvas.Font.Style := [];
  end;
  Canvas.TextOut(xTxtX, xTxtY, Caption);
end;

procedure TCButton.SetEnabled(Value: Boolean);
begin
  inherited SetEnabled(Value);
  Invalidate;
end;

procedure TCButton.SetFramed(const Value: Boolean);
begin
  if FFramed <> Value then begin
    FFramed := Value;
    Invalidate;
  end;
end;

procedure TCButton.SetPicOffset(const Value: Integer);
begin
  if FPicOffset <> Value then begin
    FPicOffset := Value;
    Invalidate;
  end;
end;

procedure TCButton.SetPicturePosition(const Value: TPicturePosition);
begin
  if FPicPosition <> Value then begin
    FPicPosition := Value;
    Invalidate;
  end;
end;

procedure TCButton.SetTxtOffset(const Value: Integer);
begin
  if FTxtOffset <> Value then begin
    FTxtOffset := Value;
    Invalidate;
  end;
end;

constructor TCImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImageList := nil;
  FImageIndex := -1;
end;

procedure TCImage.Paint;
var
  xImgX, xImgY: Integer;
begin
  if (FImageList <> nil) and (FImageIndex <> -1) then begin
    xImgX := (Width - FImageList.Width) div 2;
    xImgY := (Height - FImageList.Height) div 2;
    ImageList.Draw(Canvas, xImgX, xImgY, FImageIndex);
  end;
  if (csDesigning in ComponentState) then begin
    Canvas.Brush.Color := clBtnFace;
    Canvas.Pen.Color := clAppWorkSpace;
    Canvas.Rectangle(0, 0, Width, Height);
  end;
end;

procedure TCImage.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then begin
    FImageIndex := Value;
    Invalidate;
  end;
end;

procedure TCImage.SeTPngImageList(const Value: TPngImageList);
begin
  if FImageList <> Value then begin
    FImageList := Value;
    FImageIndex := -1;
    Invalidate;
  end;
end;

function TCStatic.CanFocus: Boolean;
begin
  Result := (inherited CanFocus) and FHotTrack;
end;

procedure TCStatic.Click;
var xId, xText: String;
    xAccepted: Boolean;
begin
  inherited Click;
  if Enabled and FHotTrack then begin
    if Assigned(FOnGetDataId) then begin
      xId := DataId;
      xText := Caption;
      FOnGetDataId(xId, xText, xAccepted);
      if xAccepted then begin
        Caption := xText;
        DataId := xId;
        if Assigned(FOnChanged) then begin
          FOnChanged(Self);
        end;
      end;
    end;
  end;
end;

procedure TCStatic.CMMouseenter(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style + [fsUnderline];
    FOldColor := Font.Color;
    Font.Color := clNavy;
    Cursor := crHandPoint;
  end;
end;

procedure TCStatic.CMMouseleave(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := FOldColor;
    Cursor := crDefault;
  end;
end;

constructor TCStatic.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOnGetDataId := Nil;
  FOnClearDataId := Nil;
  FOnChanged := Nil;
  AutoSize := False;
  Height := 21;
  Width := 150;
  BorderStyle := sbsNone;
  BevelKind := bkTile;
  Cursor := crDefault;
  ParentColor := False;
  Color := clWindow;
  FTextOnEmpty := '<kliknij tutaj aby wybra�>';
  Caption := FTextOnEmpty;
  FDataId := '';
  FHotTrack := True;
  FCanvas := TControlCanvas.Create;
  TabStop := True;
  Transparent := False;
  TControlCanvas(FCanvas).Control := Self;
end;

destructor TCStatic.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

procedure TCStatic.DoClearDataId(var ACanAccept: Boolean);
begin
  ACanAccept := True;
  if Assigned(FOnClearDataId) then begin
    FOnClearDataId(FDataId, ACanAccept);
  end;
end;

procedure TCStatic.DoEnter;
begin
  inherited;
  FInternalIsFocused := True;
  Invalidate;
end;

procedure TCStatic.DoExit;
begin
  FInternalIsFocused := False;
  Invalidate;
  inherited;
end;

procedure TCStatic.DoGetDataId;
begin
  Click;
end;

procedure TCStatic.KeyDown(var Key: Word; Shift: TShiftState);
var xCanClear: Boolean;
begin
  inherited;
  if Key = VK_SPACE then begin
    Click;
  end else if Key = VK_DELETE then begin
    DoClearDataId(xCanClear);
    if xCanClear then begin
      DataId := '';
      if Assigned(FOnChanged) then begin
         FOnChanged(Self);
      end;
    end;
  end;
end;

procedure TCStatic.Loaded;
begin
  inherited Loaded;
  if FDataId = '' then begin
    Caption := FTextOnEmpty;
  end;
end;

procedure TCStatic.SetDataId(const Value: string);
begin
  if FDataId <> Value then begin
    FDataId := Value;
    if FDataId = '' then begin
      Caption := FTextOnEmpty;
    end;
  end else begin
    if Value = '' then begin
      Caption := FTextOnEmpty;
    end;
  end;
end;


procedure TCStatic.SetTextOnEmpty(const Value: string);
begin
  FTextOnEmpty := Value;
  if FDataId = '' then begin
    Caption := FTextOnEmpty;
  end;
end;

function GetCurrencySymbol: string;
var xRes: Cardinal;
    xPch: PChar;
begin
  xRes := GetLocaleInfo(GetUserDefaultLCID, LOCALE_SCURRENCY, nil, 0);
  GetMem(xPch, xRes);
  GetLocaleInfo(GetUserDefaultLCID, LOCALE_SCURRENCY, xPch, xRes);
  Result := StrPas(xPch);
  FreeMem(xPch);
end;

constructor TCCurrEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCurrencyStr := GetCurrencySymbol;
  FValue := 0;
  FDecimals := 2;
  FMaxDigits := 17 - FDecimals;
  FAlign := taRightJustify;
  FShowKSeps := True;
  FEditMode := False;
  FWithCalculator := True;
  FCurrencyId := '';
  SetTextFromValue;
  if not (csDesigning in ComponentState) then begin
    if CurrencyComponents <> Nil then begin
      CurrencyComponents.Add(Self);
    end;
  end;
end;

procedure TCCurrEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array[TAlignment] of Word = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_NUMBER or ES_MULTILINE or Alignments[FAlign];
end;

procedure TCCurrEdit.Update;
begin
  inherited Update;
  SetTextFromValue;
end;

procedure TCCurrEdit.DoEnter;
begin
  FEditMode := True;
  SetTextFromValue;
  FOldText := Text;
  SelectAll;
  inherited DoEnter;
end;

procedure TCCurrEdit.DoExit;
begin
  FEditMode := False;
  SetTextFromValue;
  inherited DoExit;
end;

procedure TCCurrEdit.KeyDown(var Key: Word; Shift: TShiftState);
var txt: string;
    tlen, cPos: integer;
    InputParsed: Boolean;
    DoBeep: Boolean;
    xFromCalc: Double;
begin
  if ReadOnly then Exit;
  DoBeep := False;
  InputParsed := False;
  if Key = VK_DELETE then begin
    cPos := SelStart;
    txt := FormatIt(StrToCurr(Text), False);
    tlen := Length(txt);
    if ((cPos = tlen) or (cPos = tlen - FDecimals - 1)) then begin
      InputParsed := True;
      DoBeep := True;
    end;
    if ((not InputParsed) and (SelStart = 0) and (SelLength = tlen)) then begin
      txt := FormatIt(0, False);
      InputParsed := True;
    end;
    if ((not InputParsed) and (cPos >= tlen - FDecimals - 1) and (cPos < tlen)) then begin
      if SelLength = 0 then begin
        if cPos < tlen - 1 then txt := DeleteChars(txt, cPos, 1) + '0'
        else txt := ReplaceChars(txt, '0', cPos);
      end else begin
        txt := ReplaceChars2(txt, '0', cPos, SelLength);
      end;
      InputParsed := True;
    end;
    if ((not InputParsed) and (cPos <= tlen - FDecimals - 1)) then begin
      if SelLength = 0 then begin
        if LeftStr(txt, 1) <> '0' then begin
          if tlen = FDecimals + 2 then txt := ReplaceChars(txt, '0', cPos)
          else txt := DeleteChars(txt, cPos, 1);
        end else begin
          DoBeep := True;
        end;
      end else begin
        if cPos + SelLength <= tlen - FDecimals - 1 then begin
          txt := DeleteChars(txt, cPos, SelLength);
        end else begin
          DoBeep := True;
        end;
      end;
    end;
    if Text <> txt then begin
      cPos := SelStart;
      Text := FormatIt(StrToCurr(txt), False);
      SelStart := cPos;
      Modified := True;
    end;
    Key := 0;
  end else if ((Key = Ord('C')) or (Key = Ord('c'))) and FWithCalculator then begin
    ShowCalculator(Self, FDecimals, xFromCalc);
    Value := xFromCalc;
    Key := 0;
  end;
  if DoBeep then Beep;
  inherited KeyDown(Key, Shift);
end;

procedure TCCurrEdit.KeyPress(var Key: Char);
var
  txt: string;
  tlen, cPos: integer;
  DelPressed: boolean;
  ExitFlag: boolean;
  Negative: boolean;
  InputParsed: boolean;
begin
  if ReadOnly then exit;

  InputParsed := False; //Defaults
  ExitFlag := False;

  if LeftStr(Text, 1) = '-' then Negative := True //Negative-Flag
  else Negative := False;

  cPos := SelStart;
  txt := FormatIt(StrToCurr(Text), False);
  tlen := Length(txt);

  if not (Key in ['0'..'9', DecimalSeparator, '-', Char(#8)]) then {//Filter Keys} begin
    InputParsed := True; //Job done
  end;

  if ((not InputParsed) and (Key = Char(#8))) then begin
    DelPressed := True; //Del-Pressed-Flag
    InputParsed := True;
  end
  else begin
    DelPressed := False;
  end;

  if (((not InputParsed) or (DelPressed)) and (SelStart = 0) and (SelLength = tlen)) then {//Delete complete} begin
    txt := FormatIt(0, False);
    tlen := Length(txt);
    cPos := 0;
    SelLength := 0;
  end;

  if ((not InputParsed) and (Key = '-')) then {//Minus-Handling} begin
    if ((cPos = 0) and (not Negative)) then {//First Position and not Negative} begin
      if SelLength = 0 then begin
        txt := InsertChars(txt, '-', 0);
        cPos := cPos + 1; //New Cursor-Pos
        Negative := True;
      end
      else begin
        if cPos + SelLength <= tlen - FDecimals - 1 then begin
          txt := DeleteChars(txt, cPos, SelLength); //Replace Selection with '-'
          txt := InsertChars(txt, '-', 0);
          cPos := cPos + 1; //New Cursor-Pos
          Negative := True;
        end;
      end;
    end;
    InputParsed := True; //Job done
  end;

  if ((not InputParsed) and (Key = '0')) then {//leading zero not wanted} begin
    if ((cPos = 0) and (not Negative)) then {//positive case} begin
      InputParsed := True; //Job done
    end;

    if ((cPos < 2) and (Negative)) then {//negative case} begin
      InputParsed := True; //Job done
    end;

  end;

  if ((not InputParsed) and (FDecimals > 0) and (Key = DecimalSeparator)) then {//DecimalSeparator-Handling} begin
    if cPos < tlen - FDecimals then begin
      cPos := tlen - FDecimals; //Put Cursor to Decimals-Area
    end;
    InputParsed := True; //Job done
  end;

  if ((DelPressed) and (FDecimals > 0) and (cPos >= tlen - FDecimals - 1)) then {//Delete in Decimal Area} begin
    if SelLength = 0 then begin
      if cPos > tlen - FDecimals then begin
        txt := ReplaceChars(txt, '0', cPos - 1); //Replace '0' instead of Deleting
        cPos := cPos - 1; //New Cursor-Pos
      end;
    end
    else begin
      txt := ReplaceChars2(txt, '0', cPos, SelLength);
    end;
  end;

  if ((not InputParsed) and (FDecimals > 0) and (cPos >= tlen)) then {//Add no more Decimals at last Pos} begin
    InputParsed := True; //Job done
  end;

  if ((not InputParsed) and (FDecimals > 0) and (cPos >= tlen - FDecimals)) then begin
    if SelLength = 0 then begin
      txt := ReplaceChars(txt, Key, cPos); //Dont Insert, instead Overwrite Decimals in Decimal Area
      cPos := cPos + 1; //New Cursor-Pos
    end
    else begin
      if cpos >= tlen - FDecimals then begin
        txt := ReplaceChars2(txt, '0', cPos, SelLength);
        txt := ReplaceChars(txt, Key, cPos); //Dont Insert, instead Overwrite Decimals in Decimal Area
        cPos := cPos + 1; //New Cursor-Pos
      end;
    end;
    InputParsed := True; //Job done
  end;

  if ((DelPressed) and (cPos <= tlen - FDecimals - 1)) then {//General Delete-Handling} begin
    if SelLength = 0 then begin
      if cPos > 0 then begin
        if tlen = FDecimals + 2 then txt := ReplaceChars(txt, '0', cPos - 1) //Special-Handling for x.xx
        else txt := DeleteChars(txt, cPos - 1, 1);
        cPos := cPos - 1; //New Cursor-Pos
      end;
    end
    else begin
      if cPos + SelLength <= tlen - FDecimals - 1 then begin
        txt := DeleteChars(txt, cPos, SelLength);
        SelStart := cPos - 1;
      end;
    end;
  end;

  if ((not InputParsed) and (cPos <= tlen - FDecimals - 1)) then {//Input, Insert-Handling} begin
    if SelLength = 0 then begin
      if tlen < FMaxDigits then begin
        if (((LeftStr(txt, 1) = '0') and (cPos = 0) and (not Negative)) or ((LeftStr(txt, 2) = '-0') and (cPos = 1) and (Negative))) then begin
          txt := ReplaceChars(txt, Key, cPos); //Special Handling for -0.xx/0.xx
          cPos := cPos + 1; //New Cursor-Pos
        end
        else begin
          if ((Negative) and (cPos = 0)) then begin
          end
          else begin
            txt := InsertChars(txt, Key, cPos);
            cPos := cPos + 1; //New Cursor-Pos
          end;
        end;
      end;
    end
    else begin
      if cPos + SelLength <= tlen - FDecimals - 1 then begin
        txt := DeleteChars(txt, cPos, SelLength);
        txt := InsertChars(txt, Key, cPos);
      end;
    end;
    InputParsed := True; //Job done
  end;

  if ((not ExitFlag) and (InputParsed)) then begin
    if Text <> txt then begin
      Text := FormatIt(StrToCurr(txt), False); //Reformat
      if ((Negative) and (LeftStr(Text, 1) <> '-')) then Text := InsertChars(Text, '-', 0);
      Modified := True;
    end;
    SelStart := cPos;
    key := #0;
  end;

  inherited KeyPress(Key);

end;

function TCCurrEdit.GetDecimals: smallint;
begin
  result := FDecimals;
end;

procedure TCCurrEdit.SetDecimals(Value: smallint);
begin
  if ((Value >= 0) and (Value <= 4)) then begin
    FDecimals := Value;
  end
  else begin
    FDecimals := 2;
    raise TCEditError.Create('"' + IntToStr(Value) + '" is not valid for Decimals (0 to 4)');
  end;
  Update;
end;

function TCCurrEdit.GetValue: Currency;
begin
  result := FValue;
end;

procedure TCCurrEdit.SetValue(Value: Currency);
var
  test: string;
begin
  try
    test := FormatCurr('0.00', Value);
  except
    FValue := 0;
    raise TCEditError.Create('"' + FloatToStr(Value) + '" is not valid for Value');
  end;
  FValue := Value;
  Update;
end;

procedure TCCurrEdit.SetTextFromValue;
begin
  if FEditMode then begin
    Text := FormatIt(FValue, False);
  end else begin
    Text := FormatIt(FValue, True) + ' ' + FCurrencyStr;
  end;
end;

//Special Public-Methods

function TCCurrEdit.AsCurrency: Currency;
begin
  result := FValue;
end;

function TCCurrEdit.AsFloat: double;
begin
  result := FValue;
end;

function TCCurrEdit.AsString: string;
begin
  result := CurrToStr(FValue);
end;

function TCCurrEdit.FormatIt(AValue: Double; ShowMode: boolean): string;
var
  decimals, mask: string;
  x: smallint;
begin
  decimals := '';
  if ShowMode and FShowKSeps then mask := ',0.'
  else mask := '0.';
  for x := 0 to FDecimals - 1 do
    decimals := decimals + '0';
  mask := mask + decimals;
  try
    result := FormatCurr(mask, AValue);
    if not ShowMode then FValue := StrToCurr(result);
  except
    result := '0' + DecimalSeparator + decimals;
    if not ShowMode then begin
      FValue := 0;
      SetTextFromValue;
    end;
    raise TCEditError.Create('"' + FloatToStr(AValue) + '" is not a valid value');
  end;
end;

function TCCurrEdit.LeftStr(OrgStr: string; CharCount: smallint): string;
begin
  try
    result := Copy(OrgStr, 0, CharCount);
  except
    result := '';
  end;
end;

function TCCurrEdit.RightStr(OrgStr: string; CharCount: smallint): string;
begin
  result := Copy(OrgStr, (Length(OrgStr) - CharCount) + 1, Length(OrgStr));
end;

function TCCurrEdit.DeleteChars(OrgStr: string; CharPos, CharCount: smallint): string;
begin
  result := LeftStr(OrgStr, CharPos) + RightStr(OrgStr, Length(OrgStr) - CharPos - CharCount);
end;

function TCCurrEdit.InsertChars(OrgStr, InsChars: string; CharPos: smallint): string;
begin
  result := LeftStr(OrgStr, CharPos) + InsChars + RightStr(OrgStr, Length(OrgStr) - CharPos);
end;

function TCCurrEdit.ReplaceChars(OrgStr, ReplChars: string; CharPos: smallint): string;
begin
  result := LeftStr(OrgStr, CharPos) + ReplChars + RightStr(OrgStr, Length(OrgStr) - CharPos - Length(ReplChars));
end;

function TCCurrEdit.ReplaceChars2(OrgStr: string; ReplChar: Char; CharPos, CharCount: smallint): string;
var
  x: smallint;
begin
  result := OrgStr;
  for x := 0 to CharCount - 1 do begin
    result := ReplaceChars(result, ReplChar, CharPos + x);
  end;
end;

function TCDateTime.CanFocus: Boolean;
begin
  Result := (inherited CanFocus) and FHotTrack;
end;

procedure TCDateTime.Click;
var xDate: TDateTime;
begin
  inherited Click;
  if HotTrack then begin
    xDate := FValue;
    if FValue = 0 then begin
      xDate := Today;
    end;
    if ShowCalendar(Self, xDate) then begin
      Value := xDate;
      if Assigned(FOnChanged) then begin
        FOnChanged(Self);
      end;
    end;
  end;
end;

procedure TCDateTime.CMMouseenter(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style + [fsUnderline];
    FOldColor := Font.Color;
    Font.Color := clNavy;
    Cursor := crHandPoint;
  end;
end;

procedure TCDateTime.CMMouseleave(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := FOldColor;
    Cursor := crDefault;
  end;
end;

constructor TCDateTime.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := False;
  Height := 21;
  Width := 150;
  BorderStyle := sbsNone;
  BevelKind := bkTile;
  Cursor := crDefault;
  ParentColor := False;
  Color := clWindow;
  FValue := 0;
  FOnChanged := Nil;
  UpdateCaption;
  FHotTrack := True;
  FCanvas := TControlCanvas.Create;
  TabStop := True;
  Transparent := False;
  TControlCanvas(FCanvas).Control := Self;
end;

destructor TCDateTime.Destroy;
begin
  FCanvas.Free;
  inherited;
end;

procedure TCDateTime.DoEnter;
begin
  inherited;
  FInternalIsFocused := True;
  Invalidate;
end;

procedure TCDateTime.DoExit;
begin
  FInternalIsFocused := False;
  Invalidate;
  inherited;
end;

procedure TCDateTime.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then begin
    Click;
  end;
end;

procedure TCDateTime.SetValue(const Value: TDateTime);
begin
  if FValue <> Value then begin
    FValue := DateOf(Value);
    UpdateCaption;
  end;
end;

procedure TCDateTime.UpdateCaption;
begin
  if FValue <> 0 then begin
    Caption := FormatDateTime('yyyy-mm-dd', FValue);
  end else begin
    Caption := '<wybierz dat�>';
  end;
end;

procedure TCBrowser.CancelRequest;
begin
  if Busy then begin
    Stop;
  end;
end;

constructor TCBrowser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Silent := True;
end;

function TCBrowser.EnableModeless(const fEnable: LongBool): HRESULT;
begin
  Result := S_OK;
end;

function TCBrowser.FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult;
begin
  ppDORet := nil;
  Result := S_FALSE;
end;

function TCBrowser.GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult;
begin
  ppDropTarget := nil;
  Result := E_FAIL;
end;

function TCBrowser.GetExternal(out ppDispatch: IDispatch): HResult;
begin
  ppDispatch := nil;
  Result := E_FAIL;
end;

function TCBrowser.GetHostInfo(var pInfo: TDocHostUIInfo): HRESULT;
begin
  try
    ZeroMemory(@pInfo, SizeOf(TDocHostUIInfo));
    pInfo.cbSize := SizeOf(TDocHostUIInfo);
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_NO3DBORDER;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TCBrowser.GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD): HResult;
begin
  Result := E_FAIL;
end;

function TCBrowser.HideUI: HRESULT;
begin
  Result := S_OK;
end;

function TCBrowser.LoadFromString(AInString: String): Boolean;
var xPersistStreamInit: IPersistStreamInit;
    xStreamAdapter: IStream;
    xStream: TStringStream;
begin
  Result := False;
  if Document = Nil then begin
    Navigate('about:blank');
  end;
  if Document.QueryInterface(IPersistStreamInit, xPersistStreamInit) = S_OK then begin
    if xPersistStreamInit.InitNew = S_OK then begin
      xStream := TStringStream.Create(AInString);
      xStreamAdapter:= TStreamAdapter.Create(xStream, soOwned);
      Result := xPersistStreamInit.Load(xStreamAdapter) = S_OK;
    end;
  end;
end;

function TCBrowser.OnDocWindowActivate(const fActivate: BOOL): HResult;
begin
  Result := S_OK;
end;

function TCBrowser.OnFrameWindowActivate(const fActivate: BOOL): HResult;
begin
  Result := S_OK;
end;

function TCBrowser.ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fFrameWindow: BOOL): HResult;
begin
  Result := S_FALSE;
end;

procedure TCBrowser.SetAutoVSize(const Value: Boolean);
begin
  FAutoVSize := Value;
end;

function TCBrowser.ShowContextMenu(const dwID: Cardinal; const ppt: PPoint; const pcmdtReserved: IInterface; const pdispReserved: IDispatch): HRESULT;
begin
  Result := S_OK
end;

function TCBrowser.ShowUI(const dwID: Cardinal; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT;
begin
  Result := S_OK;
end;

function TCBrowser.TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HResult;
begin
  Result := S_FALSE;
end;

function TCBrowser.TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HResult;
begin
  Result := E_FAIL;
end;

function TCBrowser.UpdateUI: HRESULT;
begin
  Result := S_OK;
end;

procedure TCBrowser.WaitFor;
begin
  while ReadyState <> READYSTATE_COMPLETE do begin
    Forms.Application.ProcessMessages;
  end;
end;

procedure TCIntEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_NUMBER or ES_MULTILINE or ES_RIGHT;
end;

procedure TCIntEdit.DoEnter;
begin
  SelStart := 0;
  SelLength := Length(Text);
  inherited;
end;

procedure TCIntEdit.DoExit;
begin
  if StrToIntDef(Text, -1) = -1 then begin
    Text := '0';
  end;
  inherited;
end;

function TCIntEdit.GetValue: Integer;
begin
  Result := StrToIntDef(Text, -1);
end;

procedure TCStatic.WndProc(var Message: TMessage);
var xRect: TRect;
begin
  inherited;
  if Message.Msg = WM_PAINT then begin
    if FInternalIsFocused and CanFocus then begin
      xRect := ClientRect;
      //InflateRect(xRect, -1, -1);
      DrawFocusRect(Canvas.Handle, xRect);
    end;
  end else if Message.Msg = WM_SETFOCUS then begin
    Invalidate;
  end;
end;

procedure TCDateTime.WndProc(var Message: TMessage);
var xRect: TRect;
begin
  inherited;
  if Message.Msg = WM_PAINT then begin
    if FInternalIsFocused and CanFocus then begin
      xRect := ClientRect;
      //InflateRect(xRect, -1, -1);
      DrawFocusRect(FCanvas.Handle, xRect);
    end;
  end else if Message.Msg = WM_SETFOCUS then begin
    Invalidate;
  end;
end;

procedure TCCurrEdit.SetCurrencyStr(const Value: String);
begin
  FCurrencyStr := Value;
  SetTextFromValue;
end;

constructor TCList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOddColor := GetHighLightColor(clWindow, -10);
  FAutoExpand := True;
  DefaultText := '';
end;

procedure TCList.DoBeforeItemErase(Canvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var Color: TColor; var EraseAction: TItemEraseAction);
var xIndex: Cardinal;
begin
  with Canvas do begin
    xIndex := GetVisibleIndex(Node);
    if not Odd(xIndex) then begin
      Color := clWindow;
    end else begin
      Color := FOddColor;
    end;
    EraseAction := eaColor;
  end;
  inherited;
end;

procedure TCList.DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    if Header.SortColumn <> Column then begin
      Header.SortColumn := Column;
      Header.SortDirection := sdAscending;
    end else begin
      case Header.SortDirection of
        sdAscending: Header.SortDirection := sdDescending;
        sdDescending: Header.SortDirection := sdAscending;
      end;
    end;
  end;
  inherited;
end;

function TCList.GetVisibleIndex(ANode: PVirtualNode): Integer;
begin
  Result := -1;
  while Assigned(ANode) do begin
    Inc(Result);
    ANode := GetPreviousVisible(ANode);
  end;
end;

function TCList.SumColumn(AColumnIndex: TColumnIndex; var ASum: Extended): Boolean;
var xNode: PVirtualNode;
    xStr: String;
    xCode: Integer;
    xValue: Extended;
begin
  Result := True;
  ASum := 0;
  xNode := GetFirst;
  while (xNode <> Nil) and Result do begin
    xStr := Text[xNode, AColumnIndex];

    Val(StringReplace(xStr, ',', '.', [rfReplaceAll, rfIgnoreCase]), xValue, xCode);
    Result := Result and (xCode = 0);
    if Result then begin
      ASum := ASum + xValue;
    end;
    xNode := GetNext(xNode);
  end;
  if not Result then begin
    ASum := 0;
  end;
end;

procedure TCList.SetOddColor(const Value: TColor);
begin
  if FOddColor <> Value then begin
    FOddColor := Value;
    Refresh;
  end;
end;

function TCListDataElement.AppendDataElement(ANodeData: TCListDataElement): PVirtualNode;
begin
  FParentList.BeginUpdate;
  Result := FParentList.AddChild(Node, ANodeData);
  Add(ANodeData);
  TCListDataElement(FParentList.GetNodeData(Result)^).Node := Result;
  FParentList.FocusedNode := Result;
  FParentList.Selected[Result] := True;
  FParentList.Sort(Result, FParentList.Header.SortColumn, FParentList.Header.SortDirection);
  FParentList.EndUpdate;
end;

constructor TCListDataElement.Create(AParentList: TCDataList; AData: TCDataListElementObject; AFreeDataOnClear: Boolean = False);
begin
  inherited Create(True);
  FParentList := AParentList;
  FFreeDataOnClear := AFreeDataOnClear;
  FData := AData;
end;

procedure TCListDataElement.DeleteDataElement(AId, AElementType: String);
var xElement: TCListDataElement;
begin
  xElement := FindDataElement(AId, AElementType);
  if xElement <> Nil then begin
    FParentList.BeginUpdate;
    FParentList.DeleteNode(xElement.Node);
    Remove(xElement);
    FParentList.EndUpdate;
  end;
end;

destructor TCListDataElement.Destroy;
begin
  if FFreeDataOnClear and Assigned(FData) then begin
    FreeAndNil(FData);
  end;
  inherited Destroy;
end;

function TCListDataElement.FindDataElement(AId: String; AElementType: String = ''; ARecursive: Boolean = True): TCListDataElement;
var xCount: Integer;
    xElement: TCListDataElement;
begin
  xCount := 0;
  Result := Nil;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    xElement := Items[xCount];
    if (xElement.Data.GetElementType = AElementType) and (xElement.Data.GetElementId = AId) then begin
      Result := xElement;
    end;
    Inc(xCount);
  end;
  if (Result = Nil) and ARecursive then begin
    xCount := 0;
    while (xCount <= Count - 1) and (Result = Nil) do begin
      Result := Items[xCount].FindDataElement(AId, AElementType, ARecursive);
      Inc(xCount);
    end;
  end;
end;

function TCListDataElement.GetItems(AIndex: Integer): TCListDataElement;
begin
  Result := TCListDataElement(inherited Items[AIndex]);
end;

procedure TCListDataElement.RefreshDataElement(AId, AElementType: String);
var xElement: TCListDataElement;
begin
  xElement := FindDataElement(AId, AElementType);
  if xElement <> Nil then begin
    FParentList.BeginUpdate;
    xElement.Data.GetElementReload;
    FParentList.InvalidateNode(xElement.Node);
    FParentList.Sort(xElement.Node, FParentList.Header.SortColumn, FParentList.Header.SortDirection);
    FParentList.EndUpdate;
  end;
end;

procedure TCListDataElement.SetItems(AIndex: Integer; const Value: TCListDataElement);
begin
  inherited Items[AIndex] := Value;
end;

constructor TCDataList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRootElement := TCListDataElement.Create(Self, Nil);
  FCOnReloadTree := Nil;
end;

destructor TCDataList.Destroy;
begin
  FRootElement.Free;
  inherited Destroy;
end;

procedure TCDataList.DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates);
var xData: TCListDataElement;
    xParent: TCListDataElement;
begin
  if Parent = Nil then begin
    xData := FRootElement.Items[Node.Index];
  end else begin
    xParent := TCListDataElement(GetNodeData(Parent)^);
    xData := xParent.Items[Node.Index];
  end;
  TCListDataElement(GetNodeData(Node)^) := xData;
  xData.Node := Node;
  if xData.Count > 0 then begin
    InitStates := InitStates + [ivsHasChildren];
    if AutoExpand then begin
      InitStates := InitStates + [ivsExpanded];
    end;
  end;
end;

function TCDataList.GetTreeElement(ANode: PVirtualNode): TCListDataElement;
begin
  Result := TCListDataElement(GetNodeData(ANode)^);
end;

function TCDataList.GetSelectedId: String;
begin
  Result := '';
  if FocusedNode <> Nil then begin
    Result := GetTreeElement(FocusedNode).Data.GetElementId;
  end;
end;

function TCDataList.GetSelectedText: String;
begin
  Result := '';
  if FocusedNode <> Nil then begin
    Result := GetTreeElement(FocusedNode).Data.GetElementText;
  end;
end;

procedure TCDataList.ReloadTree;
begin
  BeginUpdate;
  Clear;
  FRootElement.Clear;
  if Assigned(FCOnReloadTree) then begin
    FCOnReloadTree(Self, FRootElement);
  end;
  RootNodeCount := FRootElement.Count;
  EndUpdate;
  UpdateScrollBars(False);
end;

procedure TCDataList.ValidateNodeDataSize(var Size: Integer);
begin
  Size := SizeOf(TCListDataElement);
end;

procedure TCDataList.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
begin
  inherited DoGetText(Node, Column, TextType, Text);
  if Text = '' then begin
    if Header.Columns.Items[Column].Text = 'Lp' then begin
      Text := IntToStr(Node.Index + 1);
    end else begin
      Text := GetTreeElement(Node).Data.GetColumnText(Column, TextType = ttStatic);
    end;
  end;
end;

function TCDataList.DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var Index: Integer): TCustomImageList;
begin
  inherited DoGetImageIndex(Node, Kind, Column, Ghosted, Index);
  if Index = -1 then begin
    Index := GetTreeElement(Node).Data.GetColumnImage(Column);
  end;
  Result := Nil;
end;

function TCDataList.GetSelectedElement: TCListDataElement;
begin
  Result := Nil;
  if FocusedNode <> Nil then begin
    Result := GetTreeElement(FocusedNode);
  end;
end;

procedure TCDataList.DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal);
begin
  inherited DoInitChildren(Node, ChildCount);
  if ChildCount = 0 then begin
    ChildCount := GetTreeElement(Node).Count;
  end;
end;

function TCDataList.DoGetNodeHint(Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle): WideString;
begin
  Result := inherited DoGetNodeHint(Node, Column, LineBreakStyle);
  if Result = '' then begin
    Result := GetTreeElement(Node).Data.GetElementHint(Column);
    LineBreakStyle := hlbDefault;
  end;
end;

function TCDataListElementObject.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := -1;
end;

function TCDataListElementObject.GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject): Integer;
begin
  Result := AnsiCompareStr(GetColumnText(AColumnIndex, False), ACompareWith.GetColumnText(AColumnIndex, False));
end;

function TCDataListElementObject.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := GetElementText;
end;

function TCDataListElementObject.GetElementId: String;
begin
  Result := '';
end;

procedure TCDataListElementObject.GetElementReload;
begin
end;

function TCDataListElementObject.GetElementText: String;
begin
  Result := GetElementId;
end;

function TCDataListElementObject.GetElementType: String;
begin
  Result := ClassName;
end;

procedure TCStatusBar.CMMouseenter(var Message: TMessage);
begin
  UpdateCursor;
end;

procedure TCStatusBar.CMMouseleave(var Message: TMessage);
begin
  if (not (csDesigning in ComponentState)) and Enabled then begin
    Cursor := crDefault;
  end;
end;

constructor TCStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  FImageList := Nil;
end;

procedure TCStatusBar.DrawPanel(Panel: TStatusPanel; const Rect: TRect);
var xImageIndex: Integer;
    xMargin: Integer;
begin
  inherited DrawPanel(Panel, Rect);
  if Panel.Style = psOwnerDraw then begin
    xMargin := 0;
    if (FImageList <> Nil) then begin
      xImageIndex := TCStatusPanel(Panel).ImageIndex;
      if xImageIndex <> -1 then begin
        ImageList.Draw(Canvas, Rect.Left + 2, Rect.Top, xImageIndex);
        xMargin := ImageList.Width + 4;
      end;
    end;
    Canvas.TextOut(Rect.Left + xMargin, 4, Panel.Text);
  end;
end;

function TCStatusBar.GetPanelClass: TStatusPanelClass;
begin
  Result := TCStatusPanel;
end;

function TCStatusBar.GetPanelWithMouse: TCStatusPanel;
var xP: TPoint;
    xCount: Integer;
    xRect: TRect;
begin
  Result := Nil;
  xP := Self.ScreenToClient(Mouse.CursorPos);
  xCount := 0;
  while (xCount <= Panels.Count - 1) and (Result = Nil) do begin
    if SendMessage(Handle, SB_GETRECT, xCount, Integer(@xRect)) = 1 then begin
      if (xP.X >= xRect.Left) and (xP.X <= xRect.Right) then begin
        Result := TCStatusPanel(Panels.Items[xCount]);
      end;
    end;
    Inc(xCount);
  end;
end;

procedure TCStatusBar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  UpdateCursor;
end;

procedure TCStatusBar.SetPngImageList(const Value: TPngImageList);
begin
  if FImageList <> Value then begin
    FImageList := Value;
    Invalidate;
  end;
end;

constructor TCStatusPanel.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FImageIndex := -1;
  FClickable := False;
end;

procedure TCStatusPanel.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then begin
    FImageIndex := Value;
    TStatusBar(TStatusPanels(Collection).Owner).Invalidate;
  end;
end;

procedure TCStatusBar.UpdateCursor;
var xPanel: TCStatusPanel;
begin
  if (not (csDesigning in ComponentState)) and Enabled then begin
    xPanel := GetPanelWithMouse;
    if (xPanel <> Nil) then begin
      if xPanel.Clickable then begin
        Cursor := crHandPoint;
      end else begin
        Cursor := crDefault;
      end;
    end;
  end;
end;

destructor TCCurrEdit.Destroy;
begin
  if not (csDesigning in ComponentState) then begin
    if CurrencyComponents <> Nil then begin
      CurrencyComponents.Remove(Self);
    end;
  end;
  inherited Destroy;
end;

procedure SetCurrencySymbol(ACurrencyId: String; ACurrencySymbol: String);
var xCount: Integer;
    xCur: TCCurrEdit;
begin
  for xCount := 0 to CurrencyComponents.Count - 1 do begin
    xCur := TCCurrEdit(CurrencyComponents.Items[xCount]);
    if xCur.CurrencyId = ACurrencyId then begin
      xCur.CurrencyStr := ACurrencySymbol;
    end;
  end;
end;

procedure TCCurrEdit.SetCurrencyDef(AId, ASymbol: String);
begin
  FCurrencyId := AId;
  CurrencyStr := ASymbol;
end;

function FindNodeWithIndex(AIndex: Cardinal; AList: TVirtualStringTree): PVirtualNode;
var xCur: PVirtualNode;
begin
  Result := Nil;
  xCur := AList.GetFirst;
  while (xCur <> Nil) and (Result = Nil) do begin
    if AList.AbsoluteIndex(xCur) = AIndex then begin
      Result := xCur;
    end;
    xCur := AList.GetNext(xCur);
  end;
end;

procedure TCRichedit.CNNotify(var Message: TMessage);
var xP: TENLink;
    xURL: string;
    xMsg: TWMNotify;
begin
  xMsg := TWMNotify(Message);
  if (xMsg.NMHdr^.code = EN_LINK) then begin
    xP := TENLink(Pointer(xMsg.NMHdr)^);
    if (xP.Msg = WM_LBUTTONDOWN) then begin
      try
        SendMessage(Handle, EM_EXSETSEL, 0, Longint(@(xP.chrg)));
        xURL := SelText;
        DoURLClick(xURL);
      except
      end;
    end;
  end;
  inherited;
end;

procedure TCRichedit.DoURLClick(const AURL: string);
begin
  if Assigned(FOnURLClick) then begin
    OnURLClick(Self, AURL);
  end else begin
    ShellExecute(0, nil, PChar(AURL), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TCRichedit.CreateWnd;
var xMask: Integer;
begin
  inherited CreateWnd;
  xMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(Handle, EM_SETEVENTMASK, 0, xMask or ENM_LINK);
  SendMessage(Handle, EM_AUTOURLDETECT, Integer(True), 0);
end;

initialization
  CurrencyComponents := TObjectList.Create(False);
finalization
  FreeAndNil(CurrencyComponents);
end.

