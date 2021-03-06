unit CLimitsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, CComponents,
  ExtCtrls, VirtualTrees, ActnList, VTHeaderPopup, CDataobjectFrameUnit, CDatabase,
  CDataObjectFormUnit, StdCtrls, CImageListsUnit;

type
  TCLimitsFrame = class(TCDataobjectFrame)
  protected
    function GetSelectedType: Integer; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
  public
    procedure ReloadDataobjects; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetStaticFilter: TStringList; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    class function GetTitle: String; override;
  end;

implementation

uses CDataObjects, CDatatools, CCashpointFormUnit, CLimitFormUnit, CConsts,
  CPluginConsts;

{$R *.dfm}

class function TCLimitsFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TMovementLimit;
end;

function TCLimitsFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCLimitForm;
end;

class function TCLimitsFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := MovementLimitProxy;
end;

function TCLimitsFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_LIMIT;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCLimitsFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CLimitActive + '=<aktywne>');
    Add(CLimitDisabled + '=<wy��czone>');
  end;
end;

class function TCLimitsFrame.GetTitle: String;
begin
  Result := 'Limity';
end;

function TCLimitsFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_LIMIT) = CSELECTEDITEM_LIMIT;
end;

function TCLimitsFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := inherited IsValidFilteredObject(AObject) or (IntToStr(Integer(TMovementLimit(AObject).isActive)) = CStaticFilter.DataId); 
end;

procedure TCLimitsFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else if CStaticFilter.DataId = CLimitActive then begin
    xCondition := ' where isActive = 1'
  end else if CStaticFilter.DataId = CLimitDisabled then begin
    xCondition := ' where isActive = 0'
  end;
  Dataobjects := TMovementLimit.GetList(TMovementLimit, MovementLimitProxy, 'select * from movementLimit' + xCondition);
end;

end.
