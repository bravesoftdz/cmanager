unit CXml;

interface

uses Windows, ActiveX, CXmlTlb, Classes, ComObj, ShellApi;

type
  ICXMLDOMNode = IXMLDOMNode;
  ICXMLDOMDocument = IXMLDOMDocument3;
  ICXMLDOMNodeList = IXMLDOMNodeList;
  ICXMLDOMElement = IXMLDOMElement;
  ICXMLDOMParseError = IXMLDOMParseError;
  ICXMLDOMProcessingInstruction = IXMLDOMProcessingInstruction;
  ICXMLDOMSchemaCollection = IXMLDOMSchemaCollection;

const
  CNODE_PROCESSING_INSTRUCTION = NODE_PROCESSING_INSTRUCTION;

procedure SetXmlAttribute(AName: String; ANode: ICXMLDOMNode; AValue: OleVariant; ARecursive: Boolean = False);
function GetXmlAttribute(AName: String; ANode: ICXMLDOMNode; ADefault: OleVariant): OleVariant;
function GetDocumentFromString(AString: String; AXsd: ICXMLDOMDocument): ICXMLDOMDocument;
function GetDocumentFromFile(AFilename: String; AXsd: ICXMLDOMDocument): ICXMLDOMDocument;
function GetNewSchema: ICXMLDOMSchemaCollection;
function GetNewDocument: ICXMLDOMDocument;
function GetStringFromDocument(ADocument: ICXMLDOMDocument): String;
function GetXmlNodeValue(ANodeName: String; ARootNode: ICXMLDOMNode; ADefault: String): String;
function GetXmlDocument(AEncoding: String = 'Windows-1250'): ICXMLDOMDocument;
function GetSchemaCacheFromXsd(AXsd: ICXMLDOMDocument): ICXMLDOMSchemaCollection;
procedure AppendEncoding(var AXml: ICXMLDOMDocument; AEncoding: String = 'Windows-1250');
function GetParseErrorDescription(AError: ICXMLDOMParseError; AWithLinebraks: Boolean): String;
function IsValidXmlparserInstalled(AShowError: Boolean; AShowQuestion: Boolean): Boolean;
procedure SetXmlIdForEach(ANodes: ICXMLDOMNodeList; ARecursive: Boolean);

resourcestring
  CNoValidMsxmlFoundError = 'Nie znaleziono bibliotek MSXML w wersji 6.0 lub wy�szej. Aplikacja nie mo�e by� uruchomiona.';
  CNoValidMsxmlFoundQuestion = 'Nie znaleziono bibliotek MSXML w wersji 6.0 lub wy�szej. Aplikacja nie mo�e by� uruchomiona.' + sLineBreak +
                               'Zainstaluj najnowsze biblioteki MSXML. Czy chcesz otworzy� w domy�lnej przegl�darce stron�,' + sLineBreak +
                               'z kt�rej b�dziesz m�g� pobra� niezb�dne pakiety?';
  CXmlDownloadLink = 'http://www.microsoft.com/downloads/details.aspx?familyid=993C0BCF-3BCF-4009-BE21-27E85E1857B1&displaylang=en';

implementation

uses SysUtils, StrUtils, CTools;

procedure AppendEncoding(var AXml: ICXMLDOMDocument; AEncoding: String = 'Windows-1250');
var xProc: ICXMLDOMProcessingInstruction;
begin
  xProc := AXml.createProcessingInstruction('xml', 'version="1.0" encoding="' + AEncoding + '"');
  if AXml.hasChildNodes then begin
    AXml.insertBefore(xProc, AXml.firstChild);
  end else begin
    AXml.appendChild(xProc);
  end;
end;

function GetXmlDocument(AEncoding: String = 'Windows-1250'): ICXMLDOMDocument;
begin
  Result := GetNewDocument;
  Result.validateOnParse := True;
  Result.resolveExternals := True;
  Result.async := false;
  AppendEncoding(Result, AEncoding);
end;

function GetXmlNodeValue(ANodeName: String; ARootNode: ICXMLDOMNode; ADefault: String): String;
var xNode: ICXMLDOMNode;
begin
  xNode := ARootNode.selectSingleNode(ANodeName);
  if xNode <> Nil then begin
    Result := xNode.text;
  end else begin
    Result := ADefault;
  end;
end;

function GetXmlAttribute(AName: String; ANode: ICXMLDOMNode; ADefault: OleVariant): OleVariant;
var xNode: ICXMLDOMNode;
begin
  xNode := ANode.attributes.getNamedItem(AName);
  if xNode <> Nil then begin
    Result := xNode.nodeValue;
  end else begin
    Result := ADefault;
  end;
end;

procedure SetXmlAttribute(AName: String; ANode: ICXMLDOMNode; AValue: OleVariant; ARecursive: Boolean = False);
var xNode: ICXMLDOMNode;
    xCount: Integer;
begin
  xNode := ANode.ownerDocument.createAttribute(AName);
  ANode.attributes.setNamedItem(xNode);
  xNode.nodeValue := AValue;
  if ARecursive then begin
    for xCount := 0 to xNode.childNodes.length - 1 do begin
      SetXmlAttribute(AName, xNode.childNodes.item[xCount], AValue, ARecursive);
    end;
  end;
end;

function GetDocumentFromFile(AFilename: String; AXsd: ICXMLDOMDocument): ICXMLDOMDocument;
var xStr: TStringList;
begin
  xStr := TStringList.Create;
  try
    try
      xStr.LoadFromFile(AFilename);
      Result := GetDocumentFromString(xStr.Text, AXsd);
    except
      Result := Nil;
    end;
  finally
    xStr.Free;
  end;
end;

function GetSchemaCacheFromXsd(AXsd: ICXMLDOMDocument): ICXMLDOMSchemaCollection;
begin
  Result := GetNewSchema;
  try
    Result.add('', AXsd);
  except
    on E: Exception do begin
      Result := Nil;
      if IsConsole then begin
        Writeln(E.Message);
      end;
    end;
  end;
end;

function GetDocumentFromString(AString: String; AXsd: ICXMLDOMDocument): ICXMLDOMDocument;
var xStream: TStringStream;
    xHelper: TStreamAdapter;
    xXsdCache: ICXMLDOMSchemaCollection;
    xValid: Boolean;
begin
  xValid := False;
  if AXsd <> Nil then begin
    xXsdCache := GetSchemaCacheFromXsd(AXsd);
    if xXsdCache <> Nil then begin
      xValid := True;
    end;
  end else begin
    xValid := True;
  end;
  if xValid then begin
    Result := GetXmlDocument;
    Result.setProperty(WideString('ProhibitDTD'), False);
    if xXsdCache <> Nil then begin
      Result.schemas := xXsdCache;
    end;
    xStream := TStringStream.Create(AString);
    xHelper := TStreamAdapter.Create(xStream);
    try
      Result.load(xHelper as IStream);
    finally
      xStream.Free;
    end;
  end else begin
    Result := Nil;
  end;
end;

function GetStringFromDocument(ADocument: ICXMLDOMDocument): String;
var xStream: TStringStream;
    xHelper: TStreamAdapter;
begin
  xStream := TStringStream.Create('');
  xHelper := TStreamAdapter.Create(xStream);
  ADocument.save(xHelper as IStream);
  Result := xStream.DataString;
  xStream.Free;
end;

function GetParseErrorDescription(AError: ICXMLDOMParseError; AWithLinebraks: Boolean): String;
begin
  Result := '';
  if AError <> Nil then begin
    if AError.errorCode <> 0 then begin
      Result := Trim(AError.reason);
      if RightStr(Result, 1) <> '.' then begin
        Result := Result + '.';
      end;
      Result := Result + ' Linia ' + IntToStr(AError.line) +
                         ', wiersz ' + IntToStr(AError.linepos) +
                         ',' + IfThen(AWithLinebraks, '\n', ' ') + '�r�d�o b��du ' + Trim(AError.srcText);
    end;
  end;
end;

function GetNewDocument: ICXMLDOMDocument;
begin
  Result := CoDOMDocument60.Create;
end;

function GetNewSchema: ICXMLDOMSchemaCollection;
begin
  Result := CoXMLSchemaCache60.Create;
end;

function IsValidXmlparserInstalled(AShowError: Boolean; AShowQuestion: Boolean): Boolean;
var xXml: Variant;
begin
  try
    xXml := CreateOleObject('MSXML2.DOMDocument.6.0');
    Result := True;
    VarClear(xXml);
  except
    Result := False;
    if AShowError then begin
      if IsConsole then begin
        Writeln(CNoValidMsxmlFoundError)
      end else begin
        if AShowQuestion then begin
          if MessageBox(0, PChar(CNoValidMsxmlFoundQuestion), 'Uwaga', MB_YESNO + MB_ICONWARNING) = IDYES then begin
            ShellExecute(0, nil, PChar(CXmlDownloadLink), nil, nil, SW_SHOWNORMAL);
          end;
        end else begin
          MessageBox(0, PChar(CNoValidMsxmlFoundError), 'B��d', MB_OK + MB_ICONERROR);
        end;
      end;
    end;
  end;
end;

procedure SetXmlIdForEach(ANodes: ICXMLDOMNodeList; ARecursive: Boolean);
var xCount: Integer;
begin
  for xCount := 0 to ANodes.length - 1 do begin
    SetXmlAttribute('id', ANodes.item[xCount], CreateNewGuid);
    if ARecursive then begin
      SetXmlIdForEach(ANodes.item[xCount].childNodes, ARecursive);
    end;
  end;
end;

end.
