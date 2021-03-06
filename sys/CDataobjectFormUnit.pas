unit CDataobjectFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CDatabase, CBaseFrameUnit,
  CComponents;

type
  TCDataobjectFormClass = class of TCDataobjectForm;

  TAdditionalData = class(TObject);

  TAdditionalDataWithId = class(TAdditionalData)
  private
    Fid: TDataGid;
  public
    constructor CreateId(AId: TDataGid);
  published
    property id: TDataGid read Fid write Fid;
  end;


  TCDataobjectForm = class(TCConfigForm)
    procedure FormDestroy(Sender: TObject);
  private
    FDataobject: TDataObject;
    FAdditionalData: TAdditionalData;
  protected
    function GetDataobjectClass: TDataObjectClass; virtual; abstract;
    function GetUpdateFrameMessage: Integer; virtual;
    function GetUpdateFrameOption: Integer; virtual;
    function GetUpdateFrameClass: TCBaseFrameClass; virtual; abstract;
    procedure AfterCommitData; virtual;
    procedure InitializeForm; virtual;
    procedure UpdateFrames(ADataGid: TDataGid; AMessage, AOption: Integer); virtual;
    function ShouldFillForm: Boolean; override;
  public
    function ShowDataobject(AOperation: TConfigOperation; AProxy: TDataProxy; ADataobject: TDataObject; ACreateStatic: Boolean; AAdditionalData: TAdditionalData = Nil): TDataGid;
    property Dataobject: TDataObject read FDataobject write FDataobject;
    function ShowConfig(AOperation: TConfigOperation; ACanResize: Boolean = False; ANoneButtonCaption: String = ''): Boolean; override;
    property AdditionalData: TAdditionalData read FAdditionalData;
  end;

implementation

uses CConsts, Math, CTools;

{$R *.dfm}

procedure TCDataobjectForm.AfterCommitData;
begin
end;

procedure TCDataobjectForm.InitializeForm;
begin
  if Operation = coAdd then begin
    Caption := Caption + ' - dodawanie';
  end else if Operation = coEdit then begin
    Caption := Caption + ' - edycja';
  end;
end;

function TCDataobjectForm.ShowConfig(AOperation: TConfigOperation; ACanResize: Boolean = False; ANoneButtonCaption: String = ''): Boolean;
begin
  Accepted := False;
  Operation := AOperation;
  if Operation = coNone then begin
    BitBtnOk.Visible := False;
    BitBtnCancel.Default := True;
    BitBtnCancel.Caption := '&Wyj�cie';
  end;
  if ShouldFillForm then begin
    BeginFilling;
    FillForm;
    EndFilling;
  end;
  if not CanModifyValues then begin
    DisableComponents;
  end;
  ShowModal;
  Result := Accepted;
end;

function TCDataobjectForm.ShowDataobject(AOperation: TConfigOperation; AProxy: TDataProxy; ADataobject: TDataObject; ACreateStatic: Boolean; AAdditionalData: TAdditionalData = Nil): TDataGid;
var xExternalDataobject: Boolean;
begin
  Operation := AOperation;
  Result := CEmptyDataGid;
  FAdditionalData := AAdditionalData;
  InitializeForm;
  xExternalDataobject := (ADataobject <> Nil);
  FDataobject := ADataobject;
  if ShowConfig(AOperation) then begin
    if Operation = coAdd then begin
      FDataobject := GetDataobjectClass.CreateObject(AProxy, ACreateStatic);
    end;
    ReadValues;
    GDataProvider.CommitTransaction;
    AfterCommitData;
    Result := FDataobject.id;
    UpdateFrames(Result, GetUpdateFrameMessage, GetUpdateFrameOption);
  end else begin
    GDataProvider.RollbackTransaction;
  end;
  if (AOperation = coAdd) and Accepted and (not xExternalDataobject) then begin
    FreeAndNil(FDataobject);
  end;
end;

procedure TCDataobjectForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FAdditionalData) then begin
    FreeAndNil(FAdditionalData);
  end;
  inherited;
end;

procedure TCDataobjectForm.UpdateFrames(ADataGid: TDataGid; AMessage, AOption: Integer);
begin
  SendMessageToFrames(GetUpdateFrameClass, AMessage, Integer(@ADataGid), AOption);
end;

function TCDataobjectForm.GetUpdateFrameMessage: Integer;
begin
  Result := IfThen(Operation = coEdit, WM_DATAOBJECTEDITED, WM_DATAOBJECTADDED);
end;

function TCDataobjectForm.GetUpdateFrameOption: Integer;
begin
  Result := WMOPT_NONE;
end;

constructor TAdditionalDataWithId.CreateId(AId: TDataGid);
begin
  inherited Create;
  Fid := AId;
end;

function TCDataobjectForm.ShouldFillForm: Boolean;
begin
  Result := (Operation = coEdit) or ((Dataobject <> Nil) and (Operation = coNone));
end;

end.

