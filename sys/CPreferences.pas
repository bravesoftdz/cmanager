unit CPreferences;

interface

uses Classes, Graphics, Contnrs, MsXml;

type
  TPrefList = class;
  TPrefItemClass = class of TPrefItem;

  TPrefItem = class(TObject)
  private
    FPrefname: String;
    function FindNode(AParentNode: IXMLDOMNode; ACanCreate: Boolean): IXMLDOMNode;
  protected
    procedure LoadFromParentNode(AParentNode: IXMLDOMNode);
    procedure SaveToParentNode(AParentNode: IXMLDOMNode);
  public
    procedure LoadFromXml(ANode: IXMLDOMNode); virtual;
    procedure SaveToXml(ANode: IXMLDOMNode); virtual;
    procedure Clone(APrefItem: TPrefItem); virtual;
    constructor Create(APrefname: String); virtual;
    function GetNodeName: String; virtual; abstract;
  published
    property Prefname: String read FPrefname write FPrefname;
  end;

  TPrefList = class(TObjectList)
  private
    FItemClass: TPrefItemClass;
    function GetItems(AIndex: Integer): TPrefItem;
    procedure SetItems(AIndex: Integer; const Value: TPrefItem);
    function GetByPrefname(APrefname: String): TPrefItem;
  public
    procedure Clone(APrefList: TPrefList);
    constructor Create(AItemClass: TPrefItemClass);
    procedure LoadFromParentNode(AParentNode: IXMLDOMNode);
    procedure SavetToParentNode(AParentNode: IXMLDOMNode);
    property Items[AIndex: Integer]: TPrefItem read GetItems write SetItems;
    property ByPrefname[APrefname: String]: TPrefItem read GetByPrefname;
  end;

  TFontPref = class(TPrefItem)
  private
    FBackground: TColor;
    FFont: TFont;
    FDesc: String;
  public
    procedure LoadFromXml(ANode: IXMLDOMNode); override;
    procedure SaveToXml(ANode: IXMLDOMNode); override;
    procedure Clone(APrefItem: TPrefItem); override;
    function GetNodeName: String; override;
    property Font: TFont read FFont;
    property Background: TColor read FBackground write FBackground;
    property Desc: String read FDesc;
    constructor Create(APrefname: String); override;
    constructor CreateFontPref(APrefname: String; ADesc: String);
    destructor Destroy; override;
  end;

  TViewPref = class(TPrefItem)
  private
    FFontprefs: TPrefList;
  public
    procedure LoadFromXml(ANode: IXMLDOMNode); override;
    procedure SaveToXml(ANode: IXMLDOMNode); override;
    procedure Clone(APrefItem: TPrefItem); override;
    function GetNodeName: String; override;
    constructor Create(APrefname: String); override;
    destructor Destroy; override;
    property Fontprefs: TPrefList read FFontprefs;
  end;

  TBasePref = class(TPrefItem)
  private
    FstartupDatafileMode: Integer;
    FstartupDatafileName: String;
    FlastOpenedDatafilename: String;
    FshowShortcutBar: Boolean;
    FshowStatusBar: Boolean;
    FstartupInfo: Boolean;
    FstartupInfoType: Integer;
    FstartupInfoDays: Integer;
    FstartupInfoIn: Boolean;
    FstartupInfoOldIn: Boolean;
    FstartupInfoOut: Boolean;
    FstartupInfoOldOut: Boolean;
    FstartupInfoAlways: Boolean;
  public
    procedure LoadFromXml(ANode: IXMLDOMNode); override;
    procedure SaveToXml(ANode: IXMLDOMNode); override;
    function GetNodeName: String; override;
    procedure Clone(APrefItem: TPrefItem); override;
  published
    property startupDatafileMode: Integer read FstartupDatafileMode write FstartupDatafileMode;
    property startupDatafileName: String read FstartupDatafileName write FstartupDatafileName;
    property lastOpenedDatafilename: String read FlastOpenedDatafilename write FlastOpenedDatafilename;
    property showShortcutBar: Boolean read FshowShortcutBar write FshowShortcutBar;
    property showStatusBar: Boolean read FshowStatusBar write FshowStatusBar;
    property startupInfo: Boolean read FstartupInfo write FstartupInfo;
    property startupInfoType: Integer read FstartupInfoType write FstartupInfoType;
    property startupInfoDays: Integer read FstartupInfoDays write FstartupInfoDays;
    property startupInfoIn: Boolean read FstartupInfoIn write FstartupInfoIn;
    property startupInfoOut: Boolean read FstartupInfoOut write FstartupInfoOut;
    property startupInfoOldIn: Boolean read FstartupInfoOldIn write FstartupInfoOldIn;
    property startupInfoOldOut: Boolean read FstartupInfoOldOut write FstartupInfoOldOut;
    property startupInfoAlways: Boolean read FstartupInfoAlways write FstartupInfoAlways;
  end;

var GViewsPreferences: TPrefList;
    GBasePreferences: TBasePref;

implementation

uses CSettings, CMovementFrameUnit, CConsts, CDatabase;

procedure SaveFontToXml(ANode: IXMLDOMNode; AFont: TFont);
begin
  SetXmlAttribute('FontName', ANode, AFont.Name);
  SetXmlAttribute('Size', ANode, AFont.Size);
  SetXmlAttribute('Color', ANode, AFont.Color);
  SetXmlAttribute('IsBold', ANode, fsBold in AFont.Style);
  SetXmlAttribute('IsItalic', ANode, fsItalic in AFont.Style);
  SetXmlAttribute('IsUnderline', ANode, fsUnderline in AFont.Style);
  SetXmlAttribute('IsStrikeout', ANode, fsStrikeOut in AFont.Style);
end;

procedure LoadFontFromXml(ANode: IXMLDOMNode; AFont: TFont);
begin
  AFont.Name := GetXmlAttribute('FontName', ANode, 'MS Sans Serif');
  AFont.Size := GetXmlAttribute('Size', ANode, 8);
  AFont.Color := GetXmlAttribute('Color', ANode, clWindowText);
  if GetXmlAttribute('IsBold', ANode, False) then begin
    AFont.Style := AFont.Style +  [fsBold];
  end else begin
    AFont.Style := AFont.Style - [fsBold];
  end;
  if GetXmlAttribute('IsItalic', ANode, False) then begin
    AFont.Style := AFont.Style + [fsItalic];
  end else begin
    AFont.Style := AFont.Style - [fsItalic];
  end;
  if GetXmlAttribute('IsUnderline', ANode, False) then begin
    AFont.Style := AFont.Style + [fsUnderline];
  end else begin
    AFont.Style := AFont.Style - [fsUnderline];
  end;
  if GetXmlAttribute('IsStrikeout', ANode, False) then begin
    AFont.Style := AFont.Style + [fsStrikeOut];
  end else begin
    AFont.Style := AFont.Style - [fsStrikeOut];
  end;
end;

procedure TPrefItem.Clone(APrefItem: TPrefItem);
begin
  FPrefname := APrefItem.Prefname;
end;

constructor TPrefItem.Create(APrefname: String);
begin
  inherited Create;
  FPrefname := APrefname;
end;

function TPrefItem.FindNode(AParentNode: IXMLDOMNode; ACanCreate: Boolean): IXMLDOMNode;
var xNode: IXMLDOMNode;
begin
  xNode := AParentNode.firstChild;
  Result := Nil;
  while (xNode <> Nil) and (Result = Nil) do begin
    if xNode.nodeName = GetNodeName then begin
      if GetXmlAttribute('name', xNode, '') = FPrefname then begin
        Result := xNode;
      end;
    end;
    xNode := xNode.nextSibling;
  end;
  if ACanCreate and (Result = Nil) then begin
    Result := AParentNode.ownerDocument.createElement(GetNodeName);
    AParentNode.appendChild(Result);
    SetXmlAttribute('name', Result, FPrefname);
  end;
end;

procedure TPrefItem.LoadFromParentNode(AParentNode: IXMLDOMNode);
var xNode: IXMLDOMNode;
begin
  xNode := FindNode(AParentNode, False);
  if xNode <> Nil then begin
    LoadFromXml(xNode);
  end;
end;

procedure TPrefItem.LoadFromXml(ANode: IXMLDOMNode);
begin
end;

procedure TPrefItem.SaveToParentNode(AParentNode: IXMLDOMNode);
var xNode: IXMLDOMNode;
begin
  xNode := FindNode(AParentNode, True);
  SaveToXml(xNode);
end;

procedure TPrefList.Clone(APrefList: TPrefList);
var xCount: Integer;
    xObj: TPrefItem;
    xSou: TPrefItem;
begin
  Clear;
  for xCount := 0 to APrefList.Count - 1 do begin
    xSou := APrefList.Items[xCount];
    xObj := FItemClass.Create(xSou.FPrefname);
    xObj.Clone(xSou);
    Add(xObj);
  end;
end;

constructor TPrefList.Create(AItemClass: TPrefItemClass);
begin
  inherited Create(True);
  FItemClass := AItemClass;
end;

function TPrefList.GetByPrefname(APrefname: String): TPrefItem;
var xCount: Integer;
begin
  xCount := 0;
  Result := Nil;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if Items[xCount].Prefname = APrefname then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TPrefList.GetItems(AIndex: Integer): TPrefItem;
begin
  Result := TPrefItem(inherited Items[AIndex]);
end;

procedure TPrefList.LoadFromParentNode(AParentNode: IXMLDOMNode);
var xCount: Integer;
begin
  for xCount := 0 to Count - 1 do begin
    Items[xCount].LoadFromParentNode(AParentNode);
  end;
end;

procedure TPrefList.SavetToParentNode(AParentNode: IXMLDOMNode);
var xCount: Integer;
begin
  for xCount := 0 to Count - 1 do begin
    Items[xCount].SaveToParentNode(AParentNode);
  end;
end;

procedure TPrefList.SetItems(AIndex: Integer; const Value: TPrefItem);
begin
  inherited Items[AIndex] := Value;
end;

procedure TViewPref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  FFontprefs.Clone(TViewPref(APrefItem).Fontprefs);
end;

constructor TViewPref.Create(APrefname: String);
begin
  inherited Create(APrefname);
  FFontprefs := TPrefList.Create(TFontPref);
end;

destructor TViewPref.Destroy;
begin
  FFontprefs.Free;
  inherited Destroy;
end;

function TViewPref.GetNodeName: String;
begin
  Result := 'viewpref';
end;

procedure TFontPref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  FBackground := TFontPref(APrefItem).Background;
  FFont.Assign(TFontPref(APrefItem).Font);
  FDesc := TFontPref(APrefItem).Desc;
end;

constructor TFontPref.Create(APrefname: String);
begin
  inherited Create(APrefname);
  FBackground := clWindow;
  FFont := TFont.Create;
  FFont.Color := clWindowText;
  FFont.Style := [];
  FFont.Size := 8;
  FFont.Name := 'MS Sans Serif';
end;

constructor TFontPref.CreateFontPref(APrefname, ADesc: String);
begin
  Create(APrefname);
  FDesc := ADesc;
end;

destructor TFontPref.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

function TFontPref.GetNodeName: String;
begin
  Result := 'fontpref';
end;

procedure TFontPref.LoadFromXml(ANode: IXMLDOMNode);
begin
  FBackground := GetXmlAttribute('background', ANode, FBackground);
  LoadFontFromXml(ANode, FFont);
end;

procedure TFontPref.SaveToXml(ANode: IXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('background', ANode, FBackground);
  SaveFontToXml(ANode, FFont);
end;

procedure TPrefItem.SaveToXml(ANode: IXMLDOMNode);
begin
end;

procedure TViewPref.LoadFromXml(ANode: IXMLDOMNode);
var xFontprefs: IXMLDOMNode;
begin
  inherited LoadFromXml(ANode);
  xFontprefs := ANode.selectSingleNode('fontprefs');
  if xFontprefs <> Nil then begin
    FFontprefs.LoadFromParentNode(xFontprefs);
  end;
end;

procedure TViewPref.SaveToXml(ANode: IXMLDOMNode);
var xFontprefs: IXMLDOMNode;
begin
  inherited SaveToXml(ANode);
  xFontprefs := ANode.selectSingleNode('fontprefs');
  if xFontprefs = Nil then begin
    xFontprefs := ANode.ownerDocument.createElement('fontprefs');
    ANode.appendChild(xFontprefs);
  end;
  FFontprefs.SavetToParentNode(xFontprefs);
end;

procedure TBasePref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  FstartupDatafileMode := TBasePref(APrefItem).startupDatafileMode;
  FstartupDatafileName := TBasePref(APrefItem).startupDatafileName;
  FlastOpenedDatafilename := TBasePref(APrefItem).lastOpenedDatafilename;
  FshowShortcutBar := TBasePref(APrefItem).showShortcutBar;
  FshowStatusBar := TBasePref(APrefItem).showStatusBar;
  FstartupInfo := TBasePref(APrefItem).startupInfo;
  FstartupInfoType := TBasePref(APrefItem).startupInfoType;
  FstartupInfoDays := TBasePref(APrefItem).startupInfoDays;
  FstartupInfoIn := TBasePref(APrefItem).startupInfoIn;
  FstartupInfoOut := TBasePref(APrefItem).startupInfoOut;
  FstartupInfoAlways := TBasePref(APrefItem).startupInfoAlways;
  FstartupInfoOldIn := TBasePref(APrefItem).startupInfoOldIn;
  FstartupInfoOldOut := TBasePref(APrefItem).startupInfoOldOut;
end;

function TBasePref.GetNodeName: String;
begin
  Result := 'basepref';
end;

procedure TBasePref.LoadFromXml(ANode: IXMLDOMNode);
begin
  inherited LoadFromXml(ANode);
  FstartupDatafileMode := GetXmlAttribute('startupfilemode', ANode, CStartupFilemodeThisfile);
  FstartupDatafileName := GetXmlAttribute('startupfilename', ANode, GetSystemPathname(CDefaultFilename));
  FlastOpenedDatafilename := GetXmlAttribute('lastopenedfilename', ANode, '');
  FshowShortcutBar := GetXmlAttribute('showShortcutBar', ANode, True);
  FshowStatusBar := GetXmlAttribute('showStatusBar', ANode, True);
  FstartupInfo := GetXmlAttribute('startupInfo', ANode, False);
  FstartupInfoType := GetXmlAttribute('startupInfoType', ANode, CStartupInfoToday);
  FstartupInfoDays := GetXmlAttribute('startupInfoDays', ANode, 1);
  FstartupInfoIn := GetXmlAttribute('startupInfoIn', ANode, True);
  FstartupInfoOut := GetXmlAttribute('startupInfoOut', ANode, True);
  FstartupInfoOldIn := GetXmlAttribute('startupInfoOldIn', ANode, True);
  FstartupInfoOldOut := GetXmlAttribute('startupInfoOldOut', ANode, True);
  FstartupInfoAlways := GetXmlAttribute('startupInfoAlways', ANode, True);
end;

procedure TBasePref.SaveToXml(ANode: IXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('startupfilemode', ANode, FstartupDatafileMode);
  SetXmlAttribute('startupfilename', ANode, FstartupDatafileName);
  SetXmlAttribute('lastopenedfilename', ANode, FlastOpenedDatafilename);
  SetXmlAttribute('showShortcutBar', ANode, FshowShortcutBar);
  SetXmlAttribute('showStatusBar', ANode, FshowStatusBar);
  SetXmlAttribute('startupInfo', ANode, FstartupInfo);
  SetXmlAttribute('startupInfoType', ANode, FstartupInfoType);
  SetXmlAttribute('startupInfoDays', ANode, FstartupInfoDays);
  SetXmlAttribute('startupInfoIn', ANode, FstartupInfoIn);
  SetXmlAttribute('startupInfoOut', ANode, FstartupInfoOut);
  SetXmlAttribute('startupInfoOldIn', ANode, FstartupInfoOldIn);
  SetXmlAttribute('startupInfoOldOut', ANode, FstartupInfoOldOut);
  SetXmlAttribute('startupInfoAlways', ANode, FstartupInfoAlways);
end;

initialization
  GViewsPreferences := TPrefList.Create(TViewPref);
  GViewsPreferences.Add(TViewPref.Create('baseMovement'));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('I', 'Przych�d jednorazowy'));
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Rozch�d jednorazowy'));
    Fontprefs.Add(TFontPref.CreateFontPref('T', 'Transfer �rodk�w'));
    Fontprefs.Add(TFontPref.CreateFontPref('CI', 'Planowany przych�d'));
    Fontprefs.Add(TFontPref.CreateFontPref('CO', 'Planowany rozch�d'));
  end;
  GViewsPreferences.Add(TViewPref.Create('plannedDone'));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('R', 'Gotowe do realizacji'));
    Fontprefs.Add(TFontPref.CreateFontPref('W', 'Operacje zaleg�e'));
    Fontprefs.Add(TFontPref.CreateFontPref('DO', 'Wykonane'));
    Fontprefs.Add(TFontPref.CreateFontPref('DA', 'Uznane za wykonane'));
    Fontprefs.Add(TFontPref.CreateFontPref('DD', 'Odrzucone jako niezasadne'));
  end;
  GViewsPreferences.Add(TViewPref.Create('plannedMovement'));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('I', 'Przych�d'));
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Rozch�d'));
  end;
  GBasePreferences := TBasePref.Create('basepreferences');
  with GBasePreferences do begin
    startupDatafileMode := CStartupFilemodeFirsttime;
    startupDatafileName := GetSystemPathname(CDefaultFilename);
    showShortcutBar := True;
    showStatusBar := True;
    lastOpenedDatafilename := '';
  end;
finalization
  GViewsPreferences.Free;
  GBasePreferences.Free;
end.
