unit CProgressXXXFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Math, ComCtrls, ImgList,
  PngImageList, CComponents;

const
  CIMAGE_OK = 0;
  CIMAGE_ERROR = 1;
  CIMAGE_WARNING = 2;
  CIMAGE_UNKNOWN = 3;

type
  TProgressClass = class of TCProgressXXXForm;
  TDoWorkResult = (dwrUnknown, dwrSuccess, dwrWarning, dwrError);

  TWaitType = (wtProgressbar, wtAnimate);

  TWaitThread = class(TThread)
  private
    FProgress: TStaticText;
    FWaitHandle: THandle;
    FCurLeft: Integer;
    FCurWidth: Integer;
    FBtnFaceBrush: HBRUSH;
    FHighliteBrush: HBRUSH;
    FImage: TBitmap;
    FImageRect: TRect;
  protected
    procedure DoAnimate;
    procedure Execute; override;
  public
    constructor Create(AWaitHandle: THandle; AProgress: TStaticText);
    property Progress: TStaticText read FProgress write FProgress;
    property WaitHandle: THandle read FWaitHandle write FWaitHandle;
  end;

  TCProgressAdditionalData = class(TObject)
  end;

  TCProgressSimpleAdditionalData = class(TCProgressAdditionalData)
  private
    FData: TObject;
  public
    constructor Create(AData: TObject);
    property Data: TObject read FData;
  end;

  TCProgressXXXForm = class(TForm)
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    PngImageList: TPngImageList;
    PanelImage: TPanel;
    CImage: TCImage;
    ProgressText: TStaticText;
    ProgressBar: TProgressBar;
    LabelInfo: TLabel;
    LabelDescription: TLabel;
    CStaticDesc: TCStatic;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CStaticDescGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FWaitThread: TWaitThread;
    FWaitHandle: THandle;
    FWaitType: TWaitType;
    FReport: TStringList;
    FDoWorkResult: TDoWorkResult;
    FAdditionalData: TCProgressAdditionalData;
    procedure InitializeProgress(AWaitType: TWaitType; AMin: Integer = 0; AMax: Integer = 100);
    procedure FinalizeProgress;
    function GetDisabled: Boolean;
    procedure SetDisabled(const Value: Boolean);
  protected
    procedure InitializeForm; virtual;
    function GetMin: Integer; virtual;
    function GetMax: Integer; virtual;
    function GetAutoclose: Boolean; virtual;
    function GetFormTitle: String; virtual;
    function GetProgressType: TWaitType; virtual;
    function DoWork: TDoWorkResult; virtual; abstract;
    procedure AddToReport(AText: String);
    function CanAccept: Boolean; virtual;
    function ShowProgress(AAdditionalData: TCProgressAdditionalData = Nil): TDoWorkResult; virtual;
    procedure InitializeLabels; virtual; abstract;
    procedure FinalizeLabels; virtual; abstract;
  public
    property Disabled: Boolean read GetDisabled write SetDisabled;
    property Report: TStringList read FReport;
    property DoWorkResult: TDoWorkResult read FDoWorkResult write FDoWorkResult;
    property AdditionalData: TCProgressAdditionalData read FAdditionalData write FAdditionalData;
    destructor Destroy; override;
  end;

function ShowProgressForm(AClass: TProgressClass; AAdditionalData: TCProgressAdditionalData = Nil): TDoWorkResult;

implementation

uses CMemoFormUnit;

{$R *.dfm}

constructor TWaitThread.Create(AWaitHandle: THandle; AProgress: TStaticText);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FProgress := AProgress;
  FWaitHandle := AWaitHandle;
  FCurLeft := 1;
  FCurWidth := 0;
end;

procedure TWaitThread.DoAnimate;
var xDC: HDC;
begin
  with FImage.Canvas do begin
    Brush.Color := clBtnFace;
    FillRect(Rect(0, 0, FProgress.Width, FProgress.Height));
    if FCurWidth < (FProgress.Width div 2) then begin
      Inc(FCurWidth);
    end else begin
      if FCurLeft > FProgress.Width - 3 then begin
        FCurLeft := 1;
        FCurWidth := 0;
      end else begin
        Inc(FCurLeft);
      end;
    end;
    Brush.Color := clHighlight;
    FillRect(Rect(FCurLeft, 1, Min(FCurLeft + FCurWidth, FProgress.Width - 3), FProgress.Height - 3));
  end;
  xDC := GetDC(FProgress.Handle);
  try
    BitBlt(xDC, 0, 0, FProgress.Width, FProgress.Height, FImage.Canvas.Handle, 0, 0, SRCCOPY);
  finally
    ReleaseDC(FProgress.Handle, xDC);
  end;
  InvalidateRect(FProgress.Handle, Nil, True);
end;

procedure TWaitThread.Execute;
var xRes: Integer;
begin
  FBtnFaceBrush := CreateSolidBrush(ColorToRGB(clBtnFace));
  FHighliteBrush := CreateSolidBrush(ColorToRGB(clHighlight));
  FImage := TBitmap.Create;
  FImage.Width := FProgress.Width;
  FImage.Height := FProgress.Height;
  FImageRect := Rect(0, 0, FProgress.Width, FProgress.Height);
  while not Terminated do begin
    xRes := WaitForSingleObject(FWaitHandle, 5);
    if xRes = WAIT_TIMEOUT then begin
      DoAnimate;
    end;
  end;
  FImage.Free;
  DeleteObject(FBtnFaceBrush);
  DeleteObject(FHighliteBrush);
end;

procedure TCProgressXXXForm.BitBtnOkClick(Sender: TObject);
begin
  if CanAccept then begin
    Disabled := True;
    InitializeProgress(GetProgressType, GetMin, GetMax);
    InitializeLabels;
    FDoWorkResult := DoWork;
    FinalizeProgress;
    FinalizeLabels;
    if (FDoWorkResult = dwrSuccess) and GetAutoclose then begin
      ModalResult := mrOk;
    end;
  end;
end;

procedure TCProgressXXXForm.FinalizeProgress;
begin
  ProgressText.Visible := False;
  ProgressBar.Visible := False;
  if FWaitType = wtAnimate then begin
    FWaitThread.Terminate;
    SetEvent(FWaitHandle);
    FWaitThread.WaitFor;
    FWaitThread.Free;
  end;
  if FDoWorkResult = dwrSuccess then begin
    CImage.ImageIndex := CIMAGE_OK;
  end else if FDoWorkResult = dwrWarning then begin
    CImage.ImageIndex := CIMAGE_WARNING;
  end else if FDoWorkResult = dwrError then begin
    CImage.ImageIndex := CIMAGE_ERROR;
  end else begin
    CImage.ImageIndex := CIMAGE_UNKNOWN;
  end;
  Disabled := False;
  BitBtnOk.Visible := False;
  CStaticDesc.Visible := True;
  BitBtnCancel.Caption := '&Wyj�cie';
  BitBtnCancel.Default := True;
  BitBtnCancel.SetFocus;
end;

function TCProgressXXXForm.GetDisabled: Boolean;
begin
  Result := not BitBtnCancel.Enabled;
end;

function TCProgressXXXForm.GetMax: Integer;
begin
  Result := 100;
end;

function TCProgressXXXForm.GetMin: Integer;
begin
  Result := 0;
end;

procedure TCProgressXXXForm.InitializeProgress(AWaitType: TWaitType; AMin, AMax: Integer);
begin
  FWaitType := AWaitType;
  if AWaitType = wtProgressbar then begin
    ProgressBar.Visible := True;
    ProgressText.Visible := False;
    ProgressBar.Min := AMin;
    ProgressBar.Position := AMin;
    ProgressBar.Max := AMax;
  end else begin
    ProgressBar.Visible := False;
    ProgressText.Visible := True;
    FWaitHandle := CreateEvent(Nil, True, False, Nil);
    FWaitThread := TWaitThread.Create(FWaitHandle, ProgressText);
    FWaitThread.Resume;
  end;
end;


procedure TCProgressXXXForm.SetDisabled(const Value: Boolean);
var hMenu: THandle;
    xOpt: Cardinal;
begin
  BitBtnOk.Enabled := not Value;
  BitBtnCancel.Enabled := not Value;
  hMenu := GetSystemMenu(Handle, False);
  if Value then begin
    xOpt := MF_DISABLED + MF_GRAYED;
  end else begin
    xOpt := MF_ENABLED;
  end;
  EnableMenuItem(hMenu, SC_CLOSE, xOpt);
  Refresh;
end;

function ShowProgressForm(AClass: TProgressClass; AAdditionalData: TCProgressAdditionalData = Nil): TDoWorkResult;
var xForm: TCProgressXXXForm;
begin
  xForm := AClass.Create(Nil);
  Result := xForm.ShowProgress(AAdditionalData);
  xForm.Free;
end;

procedure TCProgressXXXForm.BitBtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCProgressXXXForm.FormCreate(Sender: TObject);
begin
  ProgressText.Visible := False;
  ProgressBar.Visible := False;
  FReport := TStringList.Create;
end;

procedure TCProgressXXXForm.InitializeForm;
begin
  FDoWorkResult := dwrUnknown;
  CImage.ImageIndex := CIMAGE_UNKNOWN;
  Caption := GetFormTitle;
end;

procedure TCProgressXXXForm.FormDestroy(Sender: TObject);
begin
  FReport.Free;
end;

procedure TCProgressXXXForm.AddToReport(AText: String);
begin
  FReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + AText);
end;

function TCProgressXXXForm.GetProgressType: TWaitType;
begin
  Result := wtAnimate;
end;

function TCProgressXXXForm.CanAccept: Boolean;
begin
  Result := True;
end;

function TCProgressXXXForm.ShowProgress(AAdditionalData: TCProgressAdditionalData = Nil): TDoWorkResult;
begin
  FAdditionalData := AAdditionalData;
  InitializeForm;
  ShowModal;
  Result := FDoWorkResult;
end;

procedure TCProgressXXXForm.CStaticDescGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := False;
  ShowReport('Raport z wykonanych czynno�ci', Report.Text, 400, 300);
end;

procedure TCProgressXXXForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    BitBtnCancel.Click;
  end;
end;

function TCProgressXXXForm.GetAutoclose: Boolean;
begin
  Result := False;
end;

function TCProgressXXXForm.GetFormTitle: String;
begin
  Result := 'CManager';
end;

destructor TCProgressXXXForm.Destroy;
begin
  if FAdditionalData <> Nil then begin
    FAdditionalData.Free;
  end;
  inherited Destroy;
end;

{ TCProgressSimpleAdditionalData }

constructor TCProgressSimpleAdditionalData.Create(AData: TObject);
begin
  inherited Create;
  FData := AData;
end;

end.
