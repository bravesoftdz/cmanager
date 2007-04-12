library NBPCurrencyRates;

{$R *.res}

uses
  MsXml,
  Windows,
  Controls,
  Messages,
  Forms,
  CPluginConsts in '..\CPluginConsts.pas',
  CXml in '..\..\CXml.pas',
  NBPCurrencyRatesConfigFormUnit in 'NBPCurrencyRatesConfigFormUnit.pas' {NBPCurrencyRatesConfigForm},
  NBPCurrencyRatesProgressFormUnit in 'NBPCurrencyRatesProgressFormUnit.pas' {NBPCurrencyRatesProgressForm},
  CHttpRequest in '..\..\CHttpRequest.pas',
  CRichtext in '..\..\CRichtext.pas';

function Plugin_Initialize(AAppHandle: HWND): Boolean; stdcall; export;
begin
  Application.Handle := AAppHandle;
  Result := True;
end;

function Plugin_Execute(AXml: IXMLDOMDocument): Boolean; stdcall; export;
var xConfiguration, xOutput: String;
begin
  NBPCurrencyRatesProgressForm := TNBPCurrencyRatesProgressForm.Create(Application);
  NBPCurrencyRatesProgressForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  xConfiguration := GetXmlAttribute('configuration', AXml.documentElement, '');
  Result := NBPCurrencyRatesProgressForm.RetriveCurrencyRates(xConfiguration, xOutput);
  if Result then begin
    SetXmlAttribute('output', AXml.documentElement,  xOutput);
  end;
  NBPCurrencyRatesProgressForm.Free;
end;

procedure Plugin_Info(AXml: IXMLDOMDocument); stdcall; export
begin
  SetXmlAttribute('type', AXml.documentElement, CPLUGINTYPE_CURRENCYRATE);
  SetXmlAttribute('description', AXml.documentElement, 'Pobieranie �rednich kurs�w walut z NBP');
  SetXmlAttribute('menu', AXml.documentElement, 'Pobierz �rednie kursy walut NBP');
end;

function Plugin_Configure(AXml: IXMLDOMDocument): Boolean; stdcall; export;
var xForm: TNBPCurrencyRatesConfigForm;
    xConfiguration: String;
begin
  Result := False;
  xForm := TNBPCurrencyRatesConfigForm.Create(Application);
  xForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  xConfiguration := GetXmlAttribute('configuration', AXml.documentElement, '');
  if xConfiguration <> '' then begin
    xForm.EditName.Text := xConfiguration;
  end;
  if xForm.ShowModal = mrOk then begin
    SetXmlAttribute('configuration', AXml.documentElement,  xForm.EditName.Text);
    Result := True;
  end;
  xForm.Free;
end;

exports
  Plugin_Initialize,
  Plugin_Configure,
  Plugin_Execute,
  Plugin_Info;
end.
