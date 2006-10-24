unit CMainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, ExtCtrls, XPStyleActnCtrls, ActnList, ActnMan, ToolWin,
  ActnCtrls, ActnMenus, ImgList, StdCtrls, Buttons, Dialogs, CommCtrl,
  CComponents, VirtualTrees, ActnColorMaps, CConfigFormUnit, PngImageList;

type
  TCMainForm = class(TForm)
    MenuBar: TActionMainMenuBar;
    StatusBar: TStatusBar;
    ImageListActionManager: TPngImageList;
    ActionManager: TActionManager;
    ActionShortcuts: TAction;
    ActionShorcutOperations: TAction;
    ActionShortcutAccounts: TAction;
    ActionShortcutProducts: TAction;
    ActionShortcutCashpoints: TAction;
    ActionShortcutReports: TAction;
    ActionShortcutPlanned: TAction;
    ActionShortcutPlannedDone: TAction;
    ActionStatusbar: TAction;
    ActionAbout: TAction;
    PanelMain: TPanel;
    PanelTitle: TPanel;
    BevelU1: TBevel;
    LabelShortcut: TLabel;
    ImageShortcut: TImage;
    CDateTime: TCDateTime;
    BevelU2: TBevel;
    PanelFrames: TPanel;
    PanelShortcuts: TPanel;
    PanelShortcutsTitle: TPanel;
    SpeedButtonCloseShortcuts: TSpeedButton;
    ShortcutList: TVirtualStringTree;
    ActionCloseConnection: TAction;
    ActionOpenConnection: TAction;
    OpenDialog: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonCloseShortcutsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionShortcutsExecute(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure ShortcutListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ShortcutListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
    procedure ShortcutListClick(Sender: TObject);
    procedure ShortcutListAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure ActionStatusbarExecute(Sender: TObject);
    procedure ActionAboutExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionCloseConnectionExecute(Sender: TObject);
    procedure ActionOpenConnectionExecute(Sender: TObject);
  private
    FShortcutList: TStringList;
    FShortcutsFrames: TStringList;
    FActiveFrame: TFrame;
    function GetShortcutsVisible: Boolean;
    procedure SetShortcutsVisible(const Value: Boolean);
    procedure PerformShortcutAction(AAction: TAction);
    procedure UpdateShortcutList;
    procedure UpdateStatusbar;
    procedure ActionShortcutExecute(ASender: TObject);
    function GetStatusbarVisible: Boolean;
    procedure SetStatusbarVisible(const Value: Boolean);
  protected
    procedure WndProc(var Message: TMessage); override;
  published
    property ShortcutsVisible: Boolean read GetShortcutsVisible write SetShortcutsVisible;
    property StatusbarVisible: Boolean read GetStatusbarVisible write SetStatusbarVisible;
  end;

var
  CMainForm: TCMainForm;

implementation

uses CDataObjects, CDatabase, Math, CBaseFrameUnit,
     CCashpointsFrameUnit, CFrameFormUnit, CAccountsFrameUnit,
     CProductsFrameUnit, CMovementFrameUnit, CListFrameUnit, DateUtils,
     CReportsFrameUnit, CReports, CPlannedFrameUnit, CDoneFrameUnit,
  CAboutFormUnit, CSettings;

{$R *.dfm}

procedure TCMainForm.FormCreate(Sender: TObject);
begin
  FShortcutsFrames := TStringList.Create;
  CDateTime.Value := GWorkDate;
  FShortcutList := TStringList.Create;
  ActionShortcuts.Checked := ShortcutsVisible;
  ActionStatusbar.Checked := StatusbarVisible;
  UpdateShortcutList;
  UpdateStatusbar;
  ShortcutList.RootNodeCount := FShortcutList.Count;
  PerformShortcutAction(ActionShorcutOperations);
end;

function TCMainForm.GetShortcutsVisible: Boolean;
begin
  Result := PanelShortcuts.Visible;
end;

procedure TCMainForm.SetShortcutsVisible(const Value: Boolean);
begin
  DisableAlign;
  if Value then begin
    PanelShortcuts.Visible := True;
    ActionShortcuts.Checked := True;
  end else begin
    PanelShortcuts.Visible := False;
    ActionShortcuts.Checked := False;
  end;
  EnableAlign;
end;

procedure TCMainForm.SpeedButtonCloseShortcutsClick(Sender: TObject);
begin
  ShortcutsVisible := False;
end;

procedure TCMainForm.FormDestroy(Sender: TObject);
begin
  FShortcutsFrames.Free;
  FShortcutList.Free;
  SaveFormPosition(Self);
  FinalizeSettings(CSettingsFilename);
end;

procedure TCMainForm.PerformShortcutAction(AAction: TAction);
var xFrame: TCBaseFrame;
    xIndex: Integer;
    xBrush: HBRUSH;
    xClass: TCBaseFrameClass;
begin
  xIndex := FShortcutsFrames.IndexOf(AAction.Caption);
  if xIndex = -1 then begin
    if AAction = ActionShorcutOperations then begin
      xClass := TCMovementFrame;
    end else if AAction = ActionShortcutPlanned then begin
      xClass := TCPlannedFrame;
    end else if AAction = ActionShortcutPlannedDone then begin
      xClass := TCDoneFrame;
    end else if AAction = ActionShortcutCashpoints then begin
      xClass := TCCashpointsFrame;
    end else if AAction = ActionShortcutAccounts then begin
      xClass := TCAccountsFrame;
    end else if AAction = ActionShortcutProducts then begin
      xClass := TCProductsFrame;
    end else if AAction = ActionShortcutReports then begin
      xClass := TCReportsFrame;
    end else begin
      xClass := TCBaseFrame;
    end;
    xFrame := xClass.Create(Self);
    xFrame.Name := AAction.Name + 'Frame';
    xFrame.Width := PanelFrames.Width;
    xFrame.Height := PanelFrames.Height;
    xFrame.DisableAlign;
    xFrame.Visible := False;
    xFrame.InitializeFrame(Nil, Nil);
    xFrame.Parent := PanelFrames;
    xFrame.EnableAlign;
    FShortcutsFrames.AddObject(AAction.Caption, xFrame);
  end else begin
    xFrame := TCBaseFrame(FShortcutsFrames.Objects[xIndex]);
  end;
  if FActiveFrame <> xFrame then begin
    if FActiveFrame <> Nil then begin
      FActiveFrame.Hide;
    end;
    FActiveFrame := xFrame;
    FActiveFrame.Parent := PanelFrames;
    FActiveFrame.Show;
    LabelShortcut.Caption := AAction.Caption;
    xBrush := CreateSolidBrush(ColorToRGB(PanelTitle.Color));
    SelectObject(ImageShortcut.Canvas.Handle, xBrush);
    FillRect(ImageShortcut.Canvas.Handle, Rect(0, 0, ImageShortcut.Width, ImageShortcut.Height), xBrush);
    DeleteObject(xBrush);
    ImageListActionManager.Draw(ImageShortcut.Canvas, 0, 0, AAction.ImageIndex);
    ImageShortcut.Refresh;
  end;
end;

procedure TCMainForm.ActionShortcutsExecute(Sender: TObject);
begin
  ShortcutsVisible := not ShortcutsVisible;
end;

procedure TCMainForm.CDateTimeChanged(Sender: TObject);
var xIndex: Integer;
begin
  xIndex := FShortcutsFrames.IndexOf(ActionShorcutOperations.Caption);
  if xIndex <> -1 then begin
    TCMovementFrame(FShortcutsFrames.Objects[xIndex]).ReloadToday;
    TCMovementFrame(FShortcutsFrames.Objects[xIndex]).ReloadSums;
  end;
end;

procedure TCMainForm.ShortcutListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  CellText := FShortcutList.Strings[Node.Index];
end;

procedure TCMainForm.ShortcutListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
begin
  if NewNode <> Nil then begin
    Sender.Cursor := crHandPoint;
  end else begin
    Sender.Cursor := crDefault;
  end;
end;

procedure TCMainForm.ShortcutListClick(Sender: TObject);
var xAction: TAction;
begin
  if ShortcutList.FocusedNode <> Nil then begin
    xAction := TAction(FShortcutList.Objects[ShortcutList.FocusedNode.Index]);
    xAction.Execute;
  end;
end;

procedure TCMainForm.UpdateShortcutList;
var xCount: Integer;
    xAction: TAction;
begin
  for xCount := 0 to ActionManager.ActionCount - 1 do begin
    xAction := TAction(ActionManager.Actions[xCount]);
    if xAction.Category = 'Skr�ty' then begin
      FShortcutList.AddObject(xAction.Caption, xAction);
      xAction.OnExecute := ActionShortcutExecute;
    end;
  end;
end;

procedure TCMainForm.ShortcutListAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
var xIndex, xLeft, xTop: Integer;
begin
  xIndex := TAction(FShortcutList.Objects[Node.Index]).ImageIndex;
  xLeft := ((ShortcutList.Width - ImageListActionManager.Width) div 2);
  xTop := 0;
  ImageListActionManager.Draw(TargetCanvas, xLeft, xTop, xIndex);
end;

procedure TCMainForm.ActionShortcutExecute(ASender: TObject);
begin
  PerformShortcutAction(TAction(ASender));
end;

procedure TCMainForm.ActionStatusbarExecute(Sender: TObject);
begin
  StatusbarVisible := not StatusbarVisible;
end;

function TCMainForm.GetStatusbarVisible: Boolean;
begin
  Result := StatusBar.Visible;
end;

procedure TCMainForm.SetStatusbarVisible(const Value: Boolean);
begin
  DisableAlign;
  if Value then begin
    StatusBar.Visible := True;
    ActionStatusbar.Checked := True;
  end else begin
    StatusBar.Visible := False;
    ActionStatusbar.Checked := False;
  end;
  EnableAlign;
end;

procedure TCMainForm.UpdateStatusbar;
var xCount: Integer;
    xAction: TAction;
begin
  PanelMain.Visible := GDataProvider.IsConnected;
  if PanelMain.Visible then begin
    Caption := 'CManager - obs�uga finans�w (na dzie� ' + DateToStr(GWorkDate) + ')';
    StatusBar.SimpleText := ' ' + AnsiLowerCase(ExpandFileName(GDatabaseName));
  end else begin
    Caption := 'CManager - obs�uga finans�w';
    StatusBar.SimpleText := ' Nie wybrano pliku danych';
  end;
  for xCount := 0 to ActionManager.ActionCount - 1 do begin
    xAction := TAction(ActionManager.Actions[xCount]);
    if xAction.Category = 'Skr�ty' then begin
      xAction.Visible := GDataProvider.IsConnected;
    end;
  end;
  TActionClient(ActionManager.ActionBars.ActionBars[1].Items.Items[2]).Visible := GDataProvider.IsConnected;
  ActionShortcuts.Visible := GDataProvider.IsConnected;
  ActionCloseConnection.Enabled := GDataProvider.IsConnected;
  ActionOpenConnection.Enabled := not GDataProvider.IsConnected;
end;

procedure TCMainForm.ActionAboutExecute(Sender: TObject);
var xAbout: TCAboutForm;
begin
  xAbout := TCAboutForm.Create(Nil);
  xAbout.ShowConfig(coNone);
  xAbout.Free;
end;

procedure TCMainForm.FormShow(Sender: TObject);
begin
  LoadFormPosition(Self);
end;

procedure TCMainForm.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WM_FORMMAXIMIZE then begin
    WindowState := wsMaximized;
  end else if Message.Msg = WM_FORMMINIMIZE then begin
    WindowState := wsMaximized;
  end;
end;

procedure TCMainForm.ActionCloseConnectionExecute(Sender: TObject);
begin
  GDataProvider.DisconnectFromDatabase;
  UpdateStatusbar;
end;

procedure TCMainForm.ActionOpenConnectionExecute(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    if InitializeDataProvider(OpenDialog.FileName) then begin
      UpdateStatusbar;
    end;
  end;
end;

end.

