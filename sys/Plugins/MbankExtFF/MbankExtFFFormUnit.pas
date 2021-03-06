unit MbankExtFFFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons, MsHtml, ActiveX, Types, StrUtils;

type
  TExtractionType = (etCreditCard, etMonthExtraction, etPeriodExtraction);

  TMbankExtFFForm = class(TForm)
    Image: TImage;
    Label1: TLabel;
    OpenDialog: TOpenDialog;
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    EditName: TEdit;
    SpeedButton1: TSpeedButton;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FExtOutput: String;
    function PrepareOutputHtml(AInpage: String; var AError: String): Boolean;
    function PrepareOutputCsv(AInpage: String; var AError: String): Boolean;
    function DecodeDate(AStr: String; AIsCreditCard: Boolean; var AStart, AEnd: TDateTime): Boolean;
  public
    property ExtOutput: String read FExtOutput;
  end;

implementation

uses CTools, DateUtils, CXml, CPluginConsts;

{$R *.dfm}

procedure TMbankExtFFForm.BitBtnOkClick(Sender: TObject);
var xStr: TStringList;
    xError: String;
    xExt: String;
    xRes: Boolean;
begin
  if Trim(EditName.Text) = '' then begin
    MessageBox(Handle, 'Nie podano nazwy pliku z wyci�giem', 'B��d', MB_OK + MB_ICONERROR);
    EditName.SetFocus;
  end else if not FileExists(EditName.Text) then begin
    MessageBox(Handle, PChar('Brak pliku o nazwie ' + EditName.Text), 'B��d', MB_OK + MB_ICONERROR);
  end else begin
    xExt := AnsiLowerCase(ExtractFileExt(EditName.Text));
    if (xExt = '.txt') or (xExt = '.csv') or (xExt = '.htm') or (xExt = '.html') then begin
      xStr := TStringList.Create;
      try
        try
          xStr.LoadFromFile(EditName.Text);
          if (xExt = '.txt') or (xExt = '.csv') then begin
            xRes := PrepareOutputCsv(xStr.Text, xError);
          end else begin
            xRes := PrepareOutputHtml(xStr.Text, xError);
          end;
          if xRes then begin
            ModalResult := mrOk;
          end else begin
            if xError = '' then begin
              xError := 'Plik nie zawiera danych o wyci�gach z mBanku';
            end;
            MessageBox(Handle, PChar(xError), 'B��d', MB_OK + MB_ICONERROR);
          end;
        except
          on E: Exception do begin
            MessageBox(Handle, PChar('Nie mo�na wczyta� pliku ' + EditName.Text), 'B��d', MB_OK + MB_ICONERROR);
          end;
        end;
      finally
        xStr.Free;
      end;
    end else begin
      MessageBox(Handle, PChar('Nieznane rozszerzenie pliku z wyci�giem. Plik powienien mie� ' + sLineBreak +
                         'jedno z nast�puj�cych rozszerze� *.txt, *.csv, *.htm, *.html'), 'B��d', MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TMbankExtFFForm.BitBtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMbankExtFFForm.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    EditName.Text := OpenDialog.FileName;
  end;
end;

function TMbankExtFFForm.DecodeDate(AStr: String; AIsCreditCard: Boolean; var AStart, AEnd: TDateTime): Boolean;
var xMonth: Integer;
    xYear: Integer;
begin
  AStart := 0;
  AEnd := 0;
  Result := False;
  if AIsCreditCard then begin
    AStart := XsdToDateTime(Copy(AStr, 1, 10));
    AEnd := XsdToDateTime(Copy(AStr, Length(AStr) - 9, 10));
    Result := (AStart <> 0) and (AEnd <> 0);
  end else begin
    xMonth := GetMonthNumber(Copy(AStr, 1, Length(AStr) - 5));
    if (xMonth > 0) and (xMonth <= 12) then begin
      xYear := StrToIntDef(Copy(AStr, Length(AStr) - 3, 4), 0);
      if xYear > 0 then begin
        Result := TryEncodeDate(xYear, xMonth, 1, AStart);
        if Result then begin
          Result := TryEncodeDate(xYear, xMonth, DaysInMonth(AStart), AEnd);
        end;
      end;
    end;
  end;
end;

function TMbankExtFFForm.PrepareOutputHtml(AInpage: String; var AError: String): Boolean;

  function AppendExtractionItem(ARootNode: ICXMLDOMNode; ARow: IHTMLElement; AExtractionType: TExtractionType; var AError: String): Boolean;
  var xAll: IHTMLElementCollection;
      xCount: Integer;
      xElement: IHTMLElement;
      xData: Integer;
      xDatesStr: TStringList;
      xTitlesStr: TStringList;
      xCashStr, xTitle: String;
      xRegDate, xAccountingDate: TDateTime;
      xCash: Currency;
      xCurrStr: String;
      xExtractionNode: ICXMLDOMNode;
      xAppenRow: Boolean;
  begin
    Result := True;
    AError := 'Nieokre�lono lub okre�lono niepoprawnie dane dla elementu wyci�gu';
    xAll := ARow.all as IHTMLElementCollection;
    xCount := 0;
    xData := 0;
    xDatesStr := TStringList.Create;
    xTitlesStr := TStringList.Create;
    xCashStr := '';
    xAppenRow := False;
    if AExtractionType = etCreditCard then begin
      if xAll.length > 1 then begin
        xElement := xAll.item(0, varEmpty) as IHTMLElement;
        if StrToIntDef(xElement.innerText, -1) >= 1 then begin
          xAppenRow := True;
          while (xCount <= xAll.length - 1) and Result do begin
            xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
            if xCount = 1 then begin
              xDatesStr.Text := xElement.innerText;
            end else if xCount = 3 then begin
              xTitlesStr.Text := PolishConversion(splISO, splWindows, xElement.innerText);
            end else if xCount = 4 then begin
              if xTitlesStr.Text <> '' then begin
                xTitlesStr.Text := xTitlesStr.Text + ' ';
              end;
              xTitlesStr.Text := xTitlesStr.Text + PolishConversion(splISO, splWindows, xElement.innerText);
            end else if xCount = 5 then begin
              xCashStr := StringReplace(xElement.innerText, '.', '', [rfReplaceAll, rfIgnoreCase]);
              xCashStr := StringReplace(xCashStr, ' ', '', [rfReplaceAll, rfIgnoreCase]);
              xCurrStr := Copy(xCashStr, Length(xCashStr) - 2, 3);
              Delete(xCashStr, Length(xCashStr) - 2, 3);
            end;
            Inc(xCount);
          end;
        end;
      end;
    end else if AExtractionType = etPeriodExtraction then begin
      xCurrStr := 'PLN';
      xAppenRow := True;
      while (xCount <= xAll.length - 1) and Result do begin
        xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
        if xElement.className = 'data' then begin
          if xData = 0 then begin
            if Pos(sLineBreak, xElement.innerText) > 0 then begin
              xDatesStr.Text := xElement.innerText;
            end else begin
              xDatesStr.Text := Copy(xElement.innerText, 1, 10) + sLineBreak + Copy(xElement.innerText, 12, 10);
            end;
          end else if xData = 1 then begin
            xTitlesStr.Text := PolishConversion(splUtf8, splWindows, xElement.innerText);
          end else if xData = 2 then begin
            xCashStr := StringReplace(xElement.innerText, '.', '', [rfReplaceAll, rfIgnoreCase]);
          end;
          Inc(xData);
        end;
        Inc(xCount);
      end;
    end else if AExtractionType = etMonthExtraction then begin
      xCurrStr := 'PLN';
      xAppenRow := True;
      while (xCount <= xAll.length - 1) and Result do begin
        xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
        if xElement.className = 'data' then begin
          if xData = 0 then begin
            if Pos(sLineBreak, xElement.innerText) > 0 then begin
              xDatesStr.Text := xElement.innerText;
            end else begin
              xDatesStr.Text := Copy(xElement.innerText, 1, 10) + sLineBreak + Copy(xElement.innerText, 12, 10);
            end;
          end else if xData = 1 then begin
            xTitlesStr.Text := PolishConversion(splISO, splWindows, xElement.innerText);
          end else if xData = 2 then begin
            xCashStr := StringReplace(xElement.innerText, '.', '', [rfReplaceAll, rfIgnoreCase]);
          end;
          Inc(xData);
        end;
        Inc(xCount);
      end;
    end;
    if xAppenRow then begin
      if (xDatesStr.Text <> '') and (xTitlesStr.Text <> '') and (xCashStr <> '') then begin
        if xDatesStr.Count > 0 then begin
          xRegDate := XsdToDateTime(xDatesStr.Strings[0]);
        end else begin
          xRegDate := 0;
        end;
        if xDatesStr.Count > 1 then begin
          xAccountingDate := XsdToDateTime(xDatesStr.Strings[1]);
        end else begin
          xAccountingDate := 0;
        end;
        if (xRegDate <> 0) and (xAccountingDate <> 0) then begin
          xCash := StrToCurrencyDecimalDot(xCashStr);
          xTitle := xTitlesStr.Text;
          xExtractionNode := ARootNode.ownerDocument.createElement('extractionItem');
          ARootNode.appendChild(xExtractionNode);
          SetXmlAttribute('operationDate', xExtractionNode, FormatDateTime('yyyy-mm-dd', xRegDate));
          SetXmlAttribute('accountingDate', xExtractionNode, FormatDateTime('yyyy-mm-dd', xAccountingDate));
          if xCash > 0 then begin
            SetXmlAttribute('type', xExtractionNode, CEXTRACTION_INMOVEMENT);
          end else begin
            SetXmlAttribute('type', xExtractionNode, CEXTRACTION_OUTMOVEMENT);
          end;
          SetXmlAttribute('currency', xExtractionNode, xCurrStr);
          SetXmlAttribute('description', xExtractionNode, xTitle);
          SetXmlAttribute('cash', xExtractionNode, StringReplace(Trim(Format('%-10.4f', [Abs(xCash)])), ',', '.', [rfReplaceAll, rfIgnoreCase]));
        end else begin
          Result := False;
        end;
      end else begin
        Result := False;
      end;
    end;
    xDatesStr.Free;
    xTitlesStr.Free;
    if Result then begin
      AError := '';
    end;
  end;

var xDoc: IHTMLDocument2;
    xVar: Variant;
    xBody, xElement: IHTMLElement;
    xAll: IHTMLElementCollection;
    xCount, xPosA, xPosB: Integer;
    xFinished: Boolean;
    xTabCount: Integer;
    xTabHeader, xTabBase, xTabOperations: IHTMLTable;
    xBaseRow: IHTMLElement;
    xPeriodStr: String;
    xStartDate, xEndDate: TDateTime;
    xOutXml: ICXMLDOMDocument;
    xDocElement: ICXMLDOMElement;
    xExtractionType: TExtractionType;
    xStr: String;
begin
  Result := False;
  FExtOutput := '';
  xPosA := Pos('RACHUNKU KARTY KREDYTOWEJ', AInpage);
  if xPosA > 0 then begin
    xExtractionType := etCreditCard;
  end else begin
    xPosA := Pos('Elektroniczne zestawienie operacji za okres od', AInpage);
    if xPosA > 0 then begin
      xExtractionType := etPeriodExtraction;
    end else begin
      xExtractionType := etMonthExtraction;
    end;
  end;
  try
    xDoc := CoHTMLDocument.Create as IHTMLDocument2;
    try
      try
        xDoc.designMode := 'on';
        while xDoc.readyState <> 'complete' do begin
          Application.ProcessMessages;
        end;
        xVar := VarArrayCreate([0, 0], VarVariant);
        xVar[0] := AInpage;
        xDoc.Write(PSafeArray(System.TVarData(xVar).VArray));
        xDoc.designMode := 'off';
        while xDoc.readyState <> 'complete' do begin
          Application.ProcessMessages;
        end;
        AError := 'Wskazany plik nie jest poprawnym wyci�giem mBanku';
        xBody := xDoc.body;
        if xBody <> Nil then begin
          xAll := xBody.all as IHTMLElementCollection;
          if xAll <> Nil then begin
            if xExtractionType = etCreditCard then begin
              xCount := 0;
              xFinished := False;
              xTabCount := 0;
              xTabHeader := Nil;
              xTabBase := Nil;
              while (xCount <= xAll.length - 1) and (not xFinished) do begin
                xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
                if AnsiLowerCase(xElement.tagName) = 'table' then begin
                  Inc(xTabCount);
                end;
                if (xTabCount = 3) and (xTabHeader = Nil) then begin
                  xTabHeader := xElement as IHTMLTable;
                end;
                if (xTabCount = 9) and (xTabBase = Nil) then begin
                  xTabBase := xElement as IHTMLTable;
                end;
                Inc(xCount);
                xFinished := (xTabHeader <> Nil) and (xTabBase <> Nil);
              end;
              if (xTabHeader <> Nil) and (xTabBase <> Nil) then begin
                xPeriodStr := AnsiUpperCase((xTabHeader.rows.item(0, varEmpty) as IHTMLElement).innerText);
                xPosA := Pos('ZA OKRES OD', xPeriodStr);
                if xPosA > 0 then begin
                  xPeriodStr := Copy(xPeriodStr, xPosA + 12, MaxInt);
                  if DecodeDate(xPeriodStr, True, xStartDate, xEndDate) then begin
                    xOutXml := GetXmlDocument;
                    xDocElement := xOutXml.createElement('accountExtraction');
                    xOutXml.appendChild(xDocElement);
                    SetXmlAttribute('creationDate', xDocElement, FormatDateTime('yyyy-mm-dd', xEndDate));
                    SetXmlAttribute('startDate', xDocElement, FormatDateTime('yyyy-mm-dd', xStartDate));
                    SetXmlAttribute('endDate', xDocElement, FormatDateTime('yyyy-mm-dd', xEndDate));
                    xStr := PolishConversion(splISO, splWindows, (xTabHeader.rows.item(0, varEmpty) as IHTMLElement).innerText);
                    SetXmlAttribute('description', xDocElement, TrimStr(xStr, sLineBreak));
                    if xTabBase.rows <> Nil then begin
                      if xTabBase.rows.length >= 0 then begin
                      xCount := 0;
                        Result := True;
                        while (xCount <= xTabBase.rows.length - 1) and Result do begin
                          if (xCount >= 1) and (xCount < xTabBase.rows.length - 1) then begin
                            xElement := xTabBase.rows.item(xCount, varEmpty) as IHTMLElement;
                            if AnsiLowerCase(xElement.className) <> 'head' then begin
                              Result := AppendExtractionItem(xDocElement, xElement, etCreditCard, AError);
                            end;
                          end;
                          Inc(xCount);
                        end;
                      end;
                    end;
                    if Result then begin
                      FExtOutput := GetStringFromDocument(xOutXml);
                    end;
                  end;
                end;
              end;
            end else if xExtractionType = etPeriodExtraction then begin
              xCount := 0;
              xFinished := False;
              xTabCount := 0;
              xTabBase := Nil;
              xTabHeader := Nil;
              while (xCount <= xAll.length - 1) and (not xFinished) do begin
                xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
                if AnsiLowerCase(xElement.tagName) = 'table' then begin
                  Inc(xTabCount);
                end;
                if (xTabCount = 1) and (xTabHeader = Nil) then begin
                  xTabHeader := xElement as IHTMLTable;
                end;
                if (xTabCount = 6) and (xTabBase = Nil) then begin
                  xTabBase := xElement as IHTMLTable;
                end;
                Inc(xCount);
                xFinished := (xTabHeader <> Nil) and (xTabBase <> Nil);
              end;
              if (xTabHeader <> Nil) and (xTabBase <> Nil) then begin
                xPeriodStr := (xTabHeader as IHTMLElement).innerText;
                xPosA := Pos('Elektroniczne zestawienie operacji za okres od', xPeriodStr);
                if xPosA > 0 then begin
                  xPosB := Pos('Opis rachunku', xPeriodStr);
                  xStr := SubstringFromTo(xPeriodStr, xPosA,xPosB);
                  xStr := PolishConversion(splUtf8, splWindows, StringReplace(xStr, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]));
                  xPeriodStr := SubstringFromTo(xPeriodStr, xPosA, xPosB);
                  xPeriodStr := StringReplace(xPeriodStr, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]);
                  xPeriodStr := Trim(StringReplace(xPeriodStr, 'Elektroniczne zestawienie operacji za okres od', '', [rfReplaceAll, rfIgnoreCase]));
                  xStartDate := XsdToDateTime(Copy(xPeriodStr, 1, 10));
                  xEndDate := XsdToDateTime(Copy(xPeriodStr, 15, 10));
                  if (xStartDate <> 0) and (xEndDate <> 0) then begin
                    xOutXml := GetXmlDocument;
                    xDocElement := xOutXml.createElement('accountExtraction');
                    xOutXml.appendChild(xDocElement);
                    SetXmlAttribute('creationDate', xDocElement, FormatDateTime('yyyy-mm-dd', xEndDate));
                    SetXmlAttribute('startDate', xDocElement, FormatDateTime('yyyy-mm-dd', xStartDate));
                    SetXmlAttribute('endDate', xDocElement, FormatDateTime('yyyy-mm-dd', xEndDate));
                    SetXmlAttribute('description', xDocElement, xStr);
                    xCount := 2;
                    Result := True;
                    while (xCount <= xTabBase.rows.length - 2) and Result do begin
                      xElement := xTabBase.rows.item(xCount, varEmpty) as IHTMLElement;
                      Result := AppendExtractionItem(xDocElement, xElement, etPeriodExtraction, AError);
                      Inc(xCount);
                    end;
                    if Result then begin
                      FExtOutput := GetStringFromDocument(xOutXml);
                    end;
                  end;
                end;
              end;
            end else begin
              xCount := 0;
              xFinished := False;
              xTabCount := 0;
              xTabHeader := Nil;
              xTabBase := Nil;
              while (xCount <= xAll.length - 1) and (not xFinished) do begin
                xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
                if AnsiLowerCase(xElement.tagName) = 'table' then begin
                  Inc(xTabCount);
                end;
                if (xTabCount = 3) and (xTabHeader = Nil) then begin
                  xTabHeader := xElement as IHTMLTable;
                end;
                if (xTabCount = 6) and (xTabBase = Nil) then begin
                  xTabBase := xElement as IHTMLTable;
                end;
                Inc(xCount);
                xFinished := (xTabHeader <> Nil) and (xTabBase <> Nil);
              end;
              if (xTabHeader <> Nil) and (xTabBase <> Nil) then begin
                xPeriodStr := AnsiUpperCase((xTabHeader.rows.item(0, varEmpty) as IHTMLElement).innerText);
                xPosA := Pos('ZA', xPeriodStr);
                if xPosA > 0 then begin
                  xPeriodStr := Copy(xPeriodStr, xPosA + 3, MaxInt);
                  if DecodeDate(xPeriodStr, False, xStartDate, xEndDate) then begin
                    xOutXml := GetXmlDocument;
                    xDocElement := xOutXml.createElement('accountExtraction');
                    xOutXml.appendChild(xDocElement);
                    SetXmlAttribute('creationDate', xDocElement, FormatDateTime('yyyy-mm-dd', xEndDate));
                    SetXmlAttribute('startDate', xDocElement, FormatDateTime('yyyy-mm-dd', xStartDate));
                    SetXmlAttribute('endDate', xDocElement, FormatDateTime('yyyy-mm-dd', xEndDate));
                    SetXmlAttribute('description', xDocElement, PolishConversion(splISO, splWindows, (xTabHeader.rows.item(0, varEmpty) as IHTMLElement).innerText));
                    if xTabBase.rows.length >= 4 then begin
                      xBaseRow := (xTabHeader.rows.item(3, varEmpty) as IHTMLElement);
                      xAll := xBaseRow.all as IHTMLElementCollection;
                      xTabOperations := Nil;
                      xCount := 0;
                      while (xCount <= xAll.length - 1) and (xTabOperations = Nil) do begin
                        xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
                        if AnsiLowerCase(xElement.tagName) = 'table' then begin
                          xTabOperations := xElement as IHTMLTable;
                        end;;
                        Inc(xCount);
                      end;
                      if xTabOperations <> Nil then begin
                        xCount := 0;
                        Result := True;
                        while (xCount <= xTabOperations.rows.length - 1) and Result do begin
                          if (xCount > 1) and (xCount < xTabOperations.rows.length - 1) then begin
                            xElement := xTabOperations.rows.item(xCount, varEmpty) as IHTMLElement;
                            Result := AppendExtractionItem(xDocElement, xElement, etMonthExtraction, AError);
                          end;
                          Inc(xCount);
                        end;
                      end;
                    end;
                    if Result then begin
                      FExtOutput := GetStringFromDocument(xOutXml);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      except
        AError := 'B��d wczytywania pliku zawieraj�cego wyci�g';
      end;
    finally
      xDoc := Nil;
    end;
  except
    AError := 'Brak obiektu IHTMLDocument2';
  end;
end;

procedure TMbankExtFFForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    ModalResult := mrCancel;
  end;
end;

function TMbankExtFFForm.PrepareOutputCsv(AInpage: String; var AError: String): Boolean;

  function AppendExtractionItem(ARootNode: ICXMLDOMNode; ARow: TStringDynArray; AExtractionType: TExtractionType; ACurrencyStr: String; var AError: String): Boolean;
  var xTitle, xCurrStr, xCashStr: String;
      xRegDate, xAccountingDate: TDateTime;
      xCash: Currency;
      xExtractionNode: ICXMLDOMNode;
  begin
    AError := 'Nieokre�lono lub okre�lono niepoprawnie dane dla elementu wyci�gu';
    Result := True;
    xRegDate := 0;
    xAccountingDate := 0;
    xCash := 0;
    if AExtractionType = etCreditCard then begin
      try
        xRegDate := XsdToDateTime(ARow[Low(ARow) + 1]);
      except
        on E: Exception do begin
          AError := 'Nierozpoznany format daty ' + ARow[Low(ARow) + 1];
          Result := False;
        end;
      end;
      if Result then begin
        try
          xAccountingDate := XsdToDateTime(ARow[Low(ARow) + 2]);
        except
          on E: Exception do begin
            AError := 'Nierozpoznany format daty ' + ARow[Low(ARow) + 2];
            Result := False;
          end;
        end;
        if Result then begin
          xTitle := Trim(ARow[Low(ARow) + 3]) + sLineBreak + Trim(ARow[Low(ARow) + 4]);
          xCashStr := StringReplace(Trim(ARow[Low(ARow) + 5]), '.', '', [rfReplaceAll, rfIgnoreCase]);
          xCashStr := StringReplace(xCashStr, ' ', '', [rfReplaceAll, rfIgnoreCase]);
          xCash := StrToCurrencyDecimalDot(xCashStr);
          xCurrStr := Trim(ARow[Low(ARow) + 6]);
          Result := (xRegDate <> 0) and (xAccountingDate <> 0);
        end;
      end;
    end else if (AExtractionType = etMonthExtraction) then begin
      try
        xRegDate := XsdToDateTime(ARow[Low(ARow)]);
      except
        on E: Exception do begin
          AError := 'Nierozpoznany format daty ' + ARow[Low(ARow)];
          Result := False;
        end;
      end;
      if Result then begin
        try
          xAccountingDate := XsdToDateTime(ARow[Low(ARow) + 1]);
        except
          on E: Exception do begin
            AError := 'Nierozpoznany format daty ' + ARow[Low(ARow) + 1];
            Result := False;
          end;
        end;
        if Result then begin
          xCashStr := StringReplace(Trim(ARow[Low(ARow) + 7]), '.', '', [rfReplaceAll, rfIgnoreCase]);
          xCashStr := StringReplace(xCashStr, ' ', '', [rfReplaceAll, rfIgnoreCase]);
          xCash := StrToCurrencyDecimalDot(xCashStr);
          xTitle := Trim(ARow[Low(ARow) + 2]) + sLineBreak + Trim(ARow[Low(ARow) + 3]) + sLineBreak +
                    Trim(ARow[Low(ARow) + 4]) + sLineBreak + Trim(ARow[Low(ARow) + 5]) + sLineBreak +
                    Trim(ARow[Low(ARow) + 6]);
          xCurrStr := ACurrencyStr;
          Result := (xRegDate <> 0) and (xAccountingDate <> 0);
        end;
      end;
    end else if (AExtractionType = etPeriodExtraction) then begin
      try
        xRegDate := XsdToDateTime(ARow[Low(ARow)]);
      except
        on E: Exception do begin
          AError := 'Nierozpoznany format daty ' + ARow[Low(ARow)];
          Result := False;
        end;
      end;
      if Result then begin
        try
          xAccountingDate := XsdToDateTime(ARow[Low(ARow) + 1]);
        except
          on E: Exception do begin
            AError := 'Nierozpoznany format daty ' + ARow[Low(ARow) + 1];
            Result := False;
          end;
        end;
        if Result then begin
          xCashStr := StringReplace(Trim(ARow[Low(ARow) + 3]), '.', '', [rfReplaceAll, rfIgnoreCase]);
          xCashStr := StringReplace(xCashStr, ' ', '', [rfReplaceAll, rfIgnoreCase]);
          xCash := StrToCurrencyDecimalDot(xCashStr);
          xTitle := Trim(TrimStr(ARow[Low(ARow) + 2], '"'));
          xCurrStr := ACurrencyStr;
          Result := (xRegDate <> 0) and (xAccountingDate <> 0);
        end;
      end;
    end;
    if Result then begin
      xExtractionNode := ARootNode.ownerDocument.createElement('extractionItem');
      ARootNode.appendChild(xExtractionNode);
      SetXmlAttribute('operationDate', xExtractionNode, FormatDateTime('yyyy-mm-dd', xRegDate));
      SetXmlAttribute('accountingDate', xExtractionNode, FormatDateTime('yyyy-mm-dd', xAccountingDate));
      if xCash > 0 then begin
        SetXmlAttribute('type', xExtractionNode, CEXTRACTION_INMOVEMENT);
      end else begin
        SetXmlAttribute('type', xExtractionNode, CEXTRACTION_OUTMOVEMENT);
      end;
      SetXmlAttribute('currency', xExtractionNode, xCurrStr);
      SetXmlAttribute('description', xExtractionNode, xTitle);
      SetXmlAttribute('cash', xExtractionNode, StringReplace(Trim(Format('%-10.4f', [Abs(xCash)])), ',', '.', [rfReplaceAll, rfIgnoreCase]));
    end;
    if Result then begin
      AError := '';
    end;
  end;

  function SplitToArray(AString: String): TStringDynArray;
  var xStr: String;
      xPos: Integer;
      xPart: String;
  begin
    xStr := AString;
    SetLength(Result, 0);
    repeat
      xPos := Pos(';', xStr);
      if xPos > 0 then begin
        xPart := Trim(Copy(xStr, 1, xPos - 1));
        Delete(xStr, 1, xPos);
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)] := xPart;
      end else begin
        xPart := Trim(xStr);
        if (xPart <> '') then begin
          SetLength(Result, Length(Result) + 1);
          Result[High(Result)] := xPart;
        end;
        xStr := '';
      end;
    until xStr = '';
  end;

var xIsCreditCard: Boolean;
    xLines: TStringList;
    xStartDate, xEndDate: TDateTime;
    xM, xY: Word;
    xCount: Integer;
    xSplit: TStringDynArray;
    xTitle: String;
    xOutXml: ICXMLDOMDocument;
    xDocElement: ICXMLDOMNode;
    xPeriodStr, xCurrencyStr: String;
    xOperationsBlock, xDateBlock, xCurrencyBlock: Boolean;
    xValid: Boolean;
begin
  FExtOutput := '';
  xLines := TStringList.Create;
  xOutXml := GetXmlDocument;
  xDocElement := xOutXml.createElement('accountExtraction');
  xOutXml.appendChild(xDocElement);
  try
    xLines.Text := AInpage;
    xIsCreditCard := Pos('Z RACHUNKU KARTY KREDYTOWEJ', AInpage) > 0;
    if xIsCreditCard then begin
      xCount := 0;
      xTitle := '';
      xOperationsBlock := False;
      xValid := True;
      while (xCount <= xLines.Count - 1) and xValid do begin
        xSplit := SplitToArray(xLines.Strings[xCount]);
        if Length(xSplit) > 0 then begin
          if xSplit[Low(xSplit)] = 'WYCI�G NR' then begin
            xTitle := xSplit[Low(xSplit)] + ' ' + xSplit[High(xSplit)];
            Inc(xCount);
            if xCount <= xLines.Count then begin
              xSplit := SplitToArray(xLines.Strings[xCount]);
              if Length(xSplit) > 0 then begin
                xTitle := xTitle + ' ' + xSplit[Low(xSplit)];
              end;
            end;
            Inc(xCount);
            if xCount <= xLines.Count then begin
              xSplit := SplitToArray(xLines.Strings[xCount]);
              if Length(xSplit) > 0 then begin
                xTitle := xTitle + ' ' + xSplit[Low(xSplit)];
              end;
            end;
            Inc(xCount);
            if xCount <= xLines.Count then begin
              xSplit := SplitToArray(xLines.Strings[xCount]);
              if Length(xSplit) > 0 then begin
                xTitle := xTitle + sLineBreak + xSplit[Low(xSplit)];
                xPeriodStr := Trim(Copy(xSplit[Low(xSplit)], 13, MaxInt));
                DecodeDate(xPeriodStr, True, xStartDate, xEndDate);
              end;
            end;
          end;
          if xOperationsBlock then begin
            if Length(xSplit) = 8 then begin
              if StrToIntDef(Trim(xSplit[Low(xSplit)]), -1) > 0 then begin
                xValid := AppendExtractionItem(xDocElement, xSplit, etCreditCard, '', AError);
              end else begin
                xOperationsBlock := False;
              end;
            end else begin
              xOperationsBlock := False;
            end;
          end;
          if AnsiUpperCase(xSplit[Low(xSplit)]) = '#NR OPER.' then begin
            xOperationsBlock := True;
          end;
        end else begin
          xOperationsBlock := False;
        end;
        Inc(xCount);
      end;
      Result := xValid and (xStartDate <> 0) and (xEndDate <> 0);
    end else begin
      xCount := 0;
      xTitle := '';
      xOperationsBlock := False;
      xCurrencyBlock := False;
      xDateBlock := False;
      xValid := True;
      while (xCount <= xLines.Count - 1) and xValid do begin
        xSplit := SplitToArray(xLines.Strings[xCount]);
        if Length(xSplit) > 0 then begin
          if AnsiUpperCase(xSplit[Low(xSplit)]) = 'ELEKTRONICZNE ZESTAWIENIE OPERACJI ZA' then begin
            xY := StrToIntDef(Copy(xSplit[High(xSplit)], 1, 4), 0);
            xM := StrToIntDef(Copy(xSplit[High(xSplit)], 6, 2), 0);
            if (xY = 0) or (xM = 0) then begin
              xY := StrToIntDef(Copy(xSplit[High(xSplit)], 4, 4), 0);
              xM := StrToIntDef(Copy(xSplit[High(xSplit)], 1, 2), 0);
            end;
            if (xY <> 0) and (xM <> 0) then begin
              xStartDate := EncodeDateTime(xY, xM, 1, 0, 0, 0, 0);
              xEndDate := EncodeDateTime(xY, xM, DaysInAMonth(xY, xM), 0, 0, 0, 0);
            end;
            xTitle := xSplit[Low(xSplit)] + ' ' + xSplit[High(xSplit)];
          end;
          if xOperationsBlock then begin
            if Length(xSplit) = 9 then begin
              xValid := AppendExtractionItem(xDocElement, xSplit, etMonthExtraction, xCurrencyStr, AError);
            end else if Length(xSplit) = 5 then begin
              xValid := AppendExtractionItem(xDocElement, xSplit, etPeriodExtraction, xCurrencyStr, AError);
            end else begin
              xOperationsBlock := False;
            end;
          end;
          if xDateBlock then begin
            if Length(xSplit) = 2 then begin
              xStartDate := XsdToDateTime(xSplit[Low(xSplit)]);
              xEndDate := XsdToDateTime(xSplit[High(xSplit)]);
            end else begin
              xDateBlock := False;
            end;
          end;
          if xCurrencyBlock then begin
            xCurrencyStr := xSplit[Low(xSplit)];
            xCurrencyBlock := False;
          end;
          if AnsiUpperCase(xSplit[Low(xSplit)]) = '#DATA OPERACJI' then begin
            xOperationsBlock := True;
          end;
          if AnsiUpperCase(xSplit[Low(xSplit)]) = '#ZA OKRES:' then begin
            xDateBlock := True;
          end;
          if AnsiUpperCase(xSplit[Low(xSplit)]) = '#WALUTA' then begin
            xCurrencyBlock := True;
          end;
        end else begin
          xOperationsBlock := False;
          xDateBlock := False;
        end;
        Inc(xCount);
      end;
      Result := xValid and (xStartDate <> 0) and (xEndDate <> 0);
    end;
    if Result then begin
      SetXmlAttribute('creationDate', xDocElement, FormatDateTime('yyyy-mm-dd', xEndDate));
      SetXmlAttribute('startDate', xDocElement, FormatDateTime('yyyy-mm-dd', xStartDate));
      SetXmlAttribute('endDate', xDocElement, FormatDateTime('yyyy-mm-dd', xEndDate));
      SetXmlAttribute('description', xDocElement, xTitle);
      FExtOutput := GetStringFromDocument(xOutXml);
    end;
  finally
    xLines.Free;
    xOutXml := Nil;
  end;
end;

end.
