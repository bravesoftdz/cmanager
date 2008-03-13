unit CArchDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, ComCtrls,
  CComponents, StdCtrls, Buttons, ExtCtrls, CDatabase;

type
  TArchOperation = (aoBackup, aoRestore);

  TCArchAdditionalData = class(TCProgressSimpleAdditionalData)
  private
    FOperation: TArchOperation;
  public
    constructor Create(AData: TObject; AOperation: TArchOperation);
    property Operation: TArchOperation read FOperation;
  end;

  TCArchDatafileForm = class(TCProgressForm)
    CStaticFilename: TCStatic;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FDataProvider: TDataProvider;
    FOperation: TArchOperation;
    procedure ProgressEvent(AStepBy: Integer);
  protected
    procedure InitializeLabels; override;
    procedure InitializeForm; override;
    function DoWork: TDoWorkResult; override;
    procedure FinalizeLabels; override;
    function CanAccept: Boolean; override;
  end;

implementation

{$R *.dfm}

uses FileCtrl, StrUtils, CAdox, CDataObjects, CInfoFormUnit, CDatatools,
  CBackups, CTools, CPreferences;

function TCArchDatafileForm.CanAccept: Boolean;
var xText: String;
begin
  Result := inherited CanAccept;
  if Result then begin
    if(CStaticFilename.DataId = '') then begin
      case FOperation of
        aoRestore: xText := 'Nie wybra�e� nazwy archiwum, z kt�rego ma by� odtworzony plik danych';
        aoBackup: xText := 'Nie wybra�e� nazwy pliku, do kt�rego ma by� wykonana archiwizacja pliku danych';
      end;
      ShowInfo(itError, xText, '');
      Result := False;
    end else if FOperation = aoRestore then begin
      Result := ShowInfo(itQuestion, 'Wykonanie odtworzenia pliku danych z archiwum spowoduje zast�pienie\n' +
                                     'wszystkich danych znajduj�cych si� w aktualnie otwartym pliku danych.\n' +
                                     'Czy jeste� pewny, �e chcesz wykona� odtworzenia pliku danych z archiwum?', '');
    end;
  end;
end;

function TCArchDatafileForm.DoWork: TDoWorkResult;
var xError: String;
    xBeforeSize: Int64;
    xAfterSize: Int64;
    xBackupPref: TBackupPref;
    xTempfilename: String;
begin
  Result := dwrError;
  AddToReport('Rozpocz�cie wykonywania ' + IfThen(FOperation = aoBackup, 'archiwum', 'przywracania') + ' pliku danych...');
  try
    if FOperation = aoBackup then begin
      xBeforeSize := FileSize(FDataProvider.Filename);
      if CmbBackup(FDataProvider.Filename, CStaticFilename.DataId, True, xError, ProgressEvent) then begin
        xAfterSize := FileSize(CStaticFilename.DataId);
        xBackupPref := TBackupPref(GBackupsPreferences.ByPrefname[FDataProvider.Filename]);
        if xBackupPref = Nil then begin
          xBackupPref := TBackupPref.CreateBackupPref(FDataProvider.Filename, Now);
          GBackupsPreferences.Add(xBackupPref);
        end else begin
          xBackupPref.lastBackup := Now;
        end;
        AddToReport(Format('Wielko�ci pliku danych: %.2f MB, pliku kopii %.2f MB', [xBeforeSize / (1024 * 1024), xAfterSize / (1024 * 1024)]));
        Result := dwrSuccess;
      end else begin
        AddToReport('B��d podczas wykonywania archiwum pliku, opis ' + xError);
      end;
    end else begin
      xBeforeSize := FileSize(CStaticFilename.DataId);
      xTempfilename := ChangeFileExt(FDataProvider.Filename, '.' + FormatDateTime('yymmddhhnnss', Now));
      if CmbRestore(xTempfilename, CStaticFilename.DataId, True, xError, ProgressEvent) then begin
        xAfterSize := FileSize(xTempfilename);
        AddToReport(Format('Wielko�ci pliku danych: %.2f MB, pliku kopii %.2f MB', [xAfterSize / (1024 * 1024), xBeforeSize / (1024 * 1024)]));

        Result := dwrSuccess;
      end else begin
        AddToReport('B��d podczas przywracania pliku danych z archiwum, opis ' + xError);
      end;
    end;
  finally
  end;
  AddToReport('Procedura wykonania ' + IfThen(FOperation = aoBackup, 'archwium', 'przywracania') + ' pliku danych zako�czona ' + IfThen(Result = dwrSuccess, 'poprawnie', 'z b��dami'));
end;

procedure TCArchDatafileForm.FinalizeLabels;
begin
  case FOperation of
    aoBackup: begin
      if DoWorkResult = dwrSuccess then begin
        LabelInfo.Caption := 'Wykonano archiwum pliku danych';
      end else if DoWorkResult = dwrError then begin
        LabelInfo.Caption := 'B��d wykonywania archiwum pliku danych';
      end;
    end;
    aoRestore: begin
      if DoWorkResult = dwrSuccess then begin
        LabelInfo.Caption := 'Przywr�cono plik danych z archiwum';
      end else if DoWorkResult = dwrError then begin
        LabelInfo.Caption := 'B��d przywracania pliku danych z archiwum';
      end;
    end;
  end;
end;

procedure TCArchDatafileForm.InitializeForm;
begin
  inherited InitializeForm;
  FDataProvider := TDataProvider(TCProgressSimpleAdditionalData(AdditionalData).Data);
  FOperation := TCArchAdditionalData(AdditionalData).Operation;
  LabelDescription.Caption := MinimizeName(FDataProvider.Filename, LabelDescription.Canvas, LabelDescription.Width);
  case FOperation of
    aoBackup: begin
      LabelInfo.Caption := 'Wykonaj archiwum plik danych';
      CImage.ImageIndex := 4;
      CStaticFilename.DataId := GetDefaultBackupFilename(FDataProvider.Filename);
      CStaticFilename.Caption := MinimizeName(CStaticFilename.DataId, CStaticFilename.Canvas, CStaticFilename.Width);
    end;
    aoRestore: begin
      LabelInfo.Caption := 'Przywr�� plik danych z archiwum';
      CImage.ImageIndex := 3;
      CStaticFilename.TextOnEmpty := '<kliknij tutaj aby wybra� plik archiwum>'
    end;
  end;
end;

procedure TCArchDatafileForm.InitializeLabels;
begin
  case FOperation of
    aoBackup: LabelInfo.Caption := 'Trwa wykonywanie archiwum pliku danych';
    aoRestore: LabelInfo.Caption := 'Trwa przywracanie pliku danych z archiwum';
  end;
  CStaticFilename.Visible := False;
end;

constructor TCArchAdditionalData.Create(AData: TObject; AOperation: TArchOperation);
begin
  inherited Create(AData);
  FOperation := AOperation;
end;

procedure TCArchDatafileForm.CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xDialog: TOpenDialog;
begin
  if FOperation = aoRestore then begin
    xDialog := OpenDialog;
  end else begin
    xDialog := SaveDialog;
  end;
  AAccepted := xDialog.Execute;
  if AAccepted then begin
    ADataGid := xDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticFilename.Canvas, CStaticFilename.Width);
  end;
end;

procedure TCArchDatafileForm.ProgressEvent(AStepBy: Integer);
begin
  ProgressBar.Position := AStepBy;
end;

end.
