unit CChangePasswordFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, ComCtrls, CComponents,
  StdCtrls, Buttons, ExtCtrls, CDatabase;

type
  TCChangePasswordForm = class(TCProgressForm)
    EditPassword: TEdit;
    EditNew: TEdit;
    EditRetype: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private
    FDataProvider: TDataProvider;
  protected
    procedure InitializeLabels; override;
    procedure InitializeForm; override;
    function DoWork: TDoWorkResult; override;
    function GetProgressType: TWaitType; override;
    procedure FinalizeLabels; override;
    function CanAccept: Boolean; override;
  end;

implementation

{$R *.dfm}

uses FileCtrl, CInitializeProviderFormUnit, CMainFormUnit,
  CConsts, CTools, CAdox, StrUtils, CInfoFormUnit;

function TCChangePasswordForm.CanAccept: Boolean;
begin
  if EditNew.Text <> EditRetype.Text then begin
    ShowInfo(itError, 'Pole "Nowe has�o" i "Powt�rz has�o" nie maj� takiej samej zawarto�ci', '');
    Result := False;
  end else begin
    Result := True;
  end;
end;

function TCChangePasswordForm.DoWork: TDoWorkResult;
var xError: String;
    xPrevDatafile, xPrevPassword: String;
    xStatus: TInitializeProviderResult;
    xPassword: String;
begin
  AddToReport('Rozpocz�cie wykonywania zmiany has�a pliku danych...');
  AddToReport('Zamykanie pliku danych...');
  xPrevDatafile := FDataProvider.Filename;
  xPrevPassword := FDataProvider.Password;
  SendMessage(CMainForm.Handle, WM_CLOSECONNECTION, 0, 0);
  AddToReport('Zmiana has�a pliku danych...');
  if DbChangeDatabasePassword(xPrevDatafile, EditPassword.Text, EditNew.Text, xError) then begin
    AddToReport('Wykonano zmian� has�a pliku danych');
    Result := dwrSuccess;
    xPassword := EditNew.Text;
  end else begin
    AddToReport('Zmiana has�a pliku danych zako�czone b��dem');
    AddToReport(xError);
    xPassword := xPrevPassword;
    Result := dwrError;
  end;
  AddToReport('Otwieranie pliku danych...');
  xStatus := InitializeDataProvider(xPrevDatafile, xPassword, FDataProvider);
  if xStatus = iprSuccess then begin
    CMainForm.ActionShortcutExecute(CMainForm.ActionShortcutStart);
    CMainForm.UpdateStatusbar;
  end else begin
    AddToReport('Nie mo�na otworzy� pliku danych ' + xError);
  end;
  AddToReport('Procedura zmiany has�a pliku danych zako�czona ' + IfThen(Result = dwrSuccess, 'poprawnie', 'z b��dami'));
end;

procedure TCChangePasswordForm.FinalizeLabels;
begin
  EditPassword.Visible := False;
  EditNew.Visible := False;
  EditRetype.Visible := False;
  Label1.Visible := False;
  Label2.Visible := False;
  Label3.Visible := False;
  if DoWorkResult = dwrSuccess then begin
    LabelInfo.Caption := 'Zmieniono has�o pliku danych';
  end else if DoWorkResult = dwrError then begin
    LabelInfo.Caption := 'B��d zmiany has�a pliku danych';
  end;
end;

function TCChangePasswordForm.GetProgressType: TWaitType;
begin
  Result := wtNone;
end;

procedure TCChangePasswordForm.InitializeForm;
begin
  inherited InitializeForm;
  FDataProvider := TDataProvider(TCProgressSimpleAdditionalData(AdditionalData).Data);
  LabelDescription.Caption := MinimizeName(FDataProvider.Filename, LabelDescription.Canvas, LabelDescription.Width);
  ActiveControl := EditPassword;
end;

procedure TCChangePasswordForm.InitializeLabels;
begin
  LabelInfo.Caption := 'Trwa zmiana has�a pliku danych';
end;

end.
