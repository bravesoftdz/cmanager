unit CDatatools;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses Windows, SysUtils, Classes, Controls, ShellApi, CDatabase, CComponents, CBackups,
     DateUtils, AdoDb, VirtualTrees, CXml, Db;

function ExportDatabase(AFilename, ATargetFile: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
function ImportDatabase(AFilename, ATargetFile: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
function BackupDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
function GetDefaultBackupFilename(ADatabaseName: String): String;
function CheckDatabase(AFilename: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
function CheckPendingInformations: Boolean;
procedure CheckForUpdates(AQuiet: Boolean);
procedure CheckForBackups;
function CheckDatabaseStructure(AFrom, ATo: Integer; var xError: String): Boolean;
procedure CopyListToTreeHelper(AList: TDataObjectList; ARootElement: TCListDataElement; ACheckSupport: Boolean);
procedure UpdateCurrencyRates(ARatesText: String);
procedure UpdateExchanges(AExchangesText: String);
procedure UpdateExtractions(AExtractionText: String);
procedure ReloadCaches;
procedure ExportListToExcel(AList: TCList; AFilename: String);
procedure SetComponentUnitdef(AUnitdefId: TDataGid; AComponent: TCCurrEdit);
function GetRatesXsd: ICXMLDOMDocument;
function GetExchangesXsd: ICXMLDOMDocument;
function GetExtractionsXsd: ICXMLDOMDocument;
function GetChartsXsd: ICXMLDOMDocument;
function CurrencyToString(ACurrency: Currency; ACurrencyId: String = ''; AWithSymbol: Boolean = True; ADecimal: Integer = 2): String;
function DatabaseToDatetime(ADatetime: String): TDateTime;
function GetFieldValueDef(ADataset: TADOQuery; AFieldname: String; ADefValue: Variant): Variant;

implementation

uses Variants, ComObj, CConsts, CWaitFormUnit, ZLib, CProgressFormUnit,
  CDataObjects, CInfoFormUnit, CStartupInfoFormUnit, Forms,
  CTools, StrUtils, CPreferences, CUpdateCurrencyRatesFormUnit,
  CAdox, CDataobjectFormUnit, CExtractionFormUnit, CConfigFormUnit,
  CExtractionItemFormUnit, CUpdateExchangesFormUnit;

function BackupDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
var xTool: TBackupRestore;
begin
  if not Assigned(AProgressEvent) then begin
    ShowWaitForm(wtProgressbar, 'Trwa wykonywanie kopii pliku danych. Prosz� czeka�...');
  end;
  xTool := TBackupRestore.Create(AOverwrite, AProgressEvent);
  try
    Result := xTool.CompressFile(AFilename, ATargetFilename, AError);
  finally
    xTool.Free;
  end;
  if not Assigned(AProgressEvent) then begin
    HideWaitForm;
  end;
end;

function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
var xTool: TBackupRestore;
begin
  if not Assigned(AProgressEvent) then begin
    ShowWaitForm(wtProgressbar, 'Trwa odtwarzanie kopii pliku danych. Prosz� czeka�...');
  end;
  xTool := TBackupRestore.Create(AOverwrite, AProgressEvent);
  try
    Result := xTool.DecompressFile(AFilename, ATargetFilename, AError);
  finally
    xTool.Free;
  end;
  if not Assigned(AProgressEvent) then begin
    HideWaitForm;
  end;
end;

function CheckDatabase(AFilename: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
var xError, xDesc: String;
    xAccounts: TDataObjectList;
    xAccount: TAccount;
    xInstrument: TInstrument;
    xInvestments: TDataObjectList;
    xInvestment: TInvestmentItem;
    xStep, xCount: Integer;
    xSum: Currency;
    xSuspectedCount: Integer;
begin
  xSuspectedCount := 0;
  Result := InitializeDataProvider(AFilename, xError, xDesc) = iprSuccess;
  if Result then begin
    GDataProvider.BeginTransaction;
    xAccounts := TAccount.GetAllObjects(AccountProxy);
    xInvestments := TInvestmentItem.GetAllObjects(InvestmentItemProxy);
    if xAccounts.Count > 0 then begin
      xStep := Trunc(100 / (xAccounts.Count + xInvestments.Count));
      for xCount := 0 to xAccounts.Count - 1 do begin
        xAccount := TAccount(xAccounts.Items[xCount]);
        AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Sprawdzanie konta ' + xAccount.name);
        xSum := GDataProvider.GetSqlCurrency('select sum(cash) as cash from transactions where idAccount = ' + DataGidToDatabase(xAccount.id), 0);
        if xSum + xAccount.initialBalance <> xAccount.cash then begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Stan konta ' + xAccount.name +
                  Format(' wynosi %.2f, powinien wynosi� %.2f', [xAccount.cash, xSum + xAccount.initialBalance]));
          xAccount.cash := xAccount.initialBalance + xSum;
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Zmodyfikowano stan konta ' + xAccount.name);
          inc(xSuspectedCount);
        end else begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Stan konta ' + xAccount.name + ' jest poprawny');
        end;
        AProgressEvent(xStep);
      end;
      for xCount := 0 to xInvestments.Count - 1 do begin
        xInvestment := TInvestmentItem(xInvestments.Items[xCount]);
        xAccount := TAccount(TAccount.LoadObject(AccountProxy, xInvestment.idAccount, False));
        xInstrument := TInstrument(TInstrument.LoadObject(InstrumentProxy, xInvestment.idInstrument, False));
        AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Sprawdzanie inwestycji ' + xAccount.name + ' - ' + xInstrument.name);
        xSum := GDataProvider.GetSqlCurrency('select sum(quantity) as quantity from investments where idAccount = ' + DataGidToDatabase(xInvestment.idAccount) + ' and idInstrument = ' + DataGidToDatabase(xInvestment.idInstrument), 0);
        if xSum <> xInvestment.quantity then begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Stan inwestycji ' + xAccount.name + ' - ' + xInstrument.name +
                  Format(' wynosi %d, powinien wynosi� %.0f', [xInvestment.quantity, xSum]));
          xInvestment.quantity := Trunc(xSum);
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Zmodyfikowano stan inwestycji ' + xAccount.name + ' - ' + xInstrument.name);
          inc(xSuspectedCount);
        end else begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Stan inwestycji ' + xAccount.name + ' - ' + xInstrument.name + ' jest poprawny');
        end;
        AProgressEvent(xStep);
      end;
    end;
    if Result then begin
      GDataProvider.CommitTransaction;
    end else begin
      GDataProvider.RollbackTransaction;
    end;
    xAccounts.Free;
    xInvestments.Free;
    GDataProvider.DisconnectFromDatabase;
    if xSuspectedCount = 0 then begin
      AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Nie znaleziono �adnych nieprawid�owo�ci');
    end else begin
      AReport.Add(FormatDateTime('hh:nn:ss', Now) + Format(' Skorygowano %d nieprawid�owo�ci', [xSuspectedCount]));
    end;
  end else begin
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xError);
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xDesc);
  end;
end;

function GetDefaultBackupFilename(ADatabaseName: String): String;
var xFilename: String;
begin
  xFilename := FormatDateTime('yymmdd_hhnnss', Now) + '.cmb';
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ADatabaseName)) + xFilename;
end;

function CheckPendingInformations: Boolean;
var xInfo: TCStartupInfoForm;
begin
  if GDataProvider.IsConnected then begin
    xInfo := TCStartupInfoForm.Create(Nil);
    Result := xInfo.PrepareInfoFrame;
    if Result then begin
      Result := xInfo.ShowModal = mrOk;
    end;
    xInfo.Free;
  end else begin
    Result := False;
  end;
end;

procedure CheckForUpdates(AQuiet: Boolean);
var xQuiet: String;
begin
  if AQuiet then begin
    xQuiet := '/quiet';
  end else begin
    xQuiet := '';
  end;
  ShellExecute(0, 'open', PChar('cupdate.exe'), PChar(xQuiet), '.', SW_SHOW)
end;

function CheckDatabaseStructure(AFrom, ATo: Integer; var xError: String): Boolean;
var xResName: String;
    xCommand: String;
begin
  Result := False;
  try
    xResName := Format('SQLUPD_%d_%d', [AFrom, ATo]);
    xCommand := GetStringFromResources(xResName, RT_RCDATA);
    Result := GDataProvider.ExecuteSql(xCommand, False);
  except
    on E: Exception do begin
      xError := E.Message;
    end;
  end;
end;

function ImportDatabase(AFilename, ATargetFile: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
var xError, xDesc: String;
    xStr: TStringList;
begin
  Result := InitializeDataProvider(ATargetFile, xError, xDesc) = iprSuccess;
  if Result then begin
    xStr := TStringList.Create;
    try
      try
        xStr.LoadFromFile(AFilename);
        GDataProvider.BeginTransaction;
        Result := GDataProvider.ExecuteSql(xStr.Text, False);
        if not Result then begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Podczas eksportu wyst�pi� b��d ' + GDataProvider.LastError);
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Wykonywana komenda "' + GDataProvider.LastStatement + '"');
          AError := GDataProvider.LastError;
          GDataProvider.RollbackTransaction;
        end else begin
          GDataProvider.CommitTransaction;
        end;
      except
        on E: Exception do begin
          Result := False;
          AError := E.Message;
        end;
      end;
    finally
      xStr.Free;
      GDataProvider.DisconnectFromDatabase;
    end;
  end else begin
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xError);
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xDesc);
  end;
end;

function ExportDatabase(AFilename, ATargetFile: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
var xError, xDesc: String;
    xStr: TStringList;
    xCount: Integer;
    xMin, xMax: Integer;
begin
  Result := InitializeDataProvider(AFilename, xError, xDesc) = iprSuccess;
  if Result then begin
    xStr := TStringList.Create;
    try
      try
        xMin := Low(CDatafileTables);
        xCount := xMin;
        xMax := High(CDatafileTables);
        while (xCount <= xMax) and Result do begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Eksportowanie tabeli ' + CDatafileTables[xCount]);
          if CDatafileDeletes[xCount] <> '' then begin
            xStr.Add('delete from ' + CDatafileDeletes[xCount] + ';');
          end;
          Result := GDataProvider.ExportTable(CDatafileTables[xCount], CDatafileTablesExportConditions[xCount], xStr);
          if not Result then begin
            AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Podczas eksportu wyst�pi� b��d ' + GDataProvider.LastError);
            AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Wykonywana komenda "' + GDataProvider.LastStatement + '"');
            AError := GDataProvider.LastError;
          end;
          Inc(xCount);
          AProgressEvent(Trunc(100 * xCount/(xMax - xMin)));
        end;
        xStr.SaveToFile(ATargetFile);
      except
        on E: Exception do begin
          Result := False;
          AError := E.Message;
        end;
      end;
    finally
      xStr.Free;
      GDataProvider.DisconnectFromDatabase;
    end;
  end else begin
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xError);
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xDesc);
  end;
end;

procedure CopyListToTreeHelper(AList: TDataObjectList; ARootElement: TCListDataElement; ACheckSupport: Boolean);
var xCount: Integer;
    xElement: TCListDataElement;
begin
  if AList <> Nil then begin
    for xCount := 0 to AList.Count - 1 do begin
      xElement := TCListDataElement.Create(ACheckSupport, ARootElement.ParentList, AList.Items[xCount]);
      ARootElement.Add(xElement);
    end;
  end;
end;

procedure CheckForBackups;
var xPref: TBackupPref;
    xMustbackup: Boolean;
begin
  xMustbackup := False;
  xPref := TBackupPref(GBackupsPreferences.ByPrefname[GDatabaseName]);
  if GBasePreferences.backupAction = CBackupActionOnce then begin
    if xPref <> Nil then begin
      xMustbackup := DateOf(xPref.lastBackup) <> DateOf(Now);
    end else begin
      xMustbackup := True;
    end;
  end else if GBasePreferences.backupAction = CBackupActionAlways then begin
    xMustbackup := True;
  end else if GBasePreferences.backupAction = CBackupActionAsk then begin
    if xPref = Nil then begin
      xMustbackup := ShowInfo(itQuestion, 'Nie uda�o si� uzyska� informacji kiedy wykonywano ostatni raz kopi� pliku danych.\n' +
                                          'Czy chcesz wykona� kopi� pliku danych teraz?', '');
    end else begin
      if DaysBetween(Today, xPref.lastBackup) + 1 >= GBasePreferences.backupDaysOld then begin
        xMustbackup := ShowInfo(itQuestion, 'Ostatnio wykonywa�e� kopi� pliku danych ' + IntToStr(DaysBetween(Today, xPref.lastBackup) + 1) + ' dni temu.\n' + 
                                            'Czy chcesz wykona� kopi� pliku danych teraz?', '');
      end;
    end;
  end;
  if xMustbackup then begin
    GBackupThread := TBackupThread.Create(GDatabaseName);
  end;
end;

procedure UpdateExchanges(AExchangesText: String);
var xDoc: ICXMLDOMDocument;
    xRoot: ICXMLDOMNode;
    xValid: Boolean;
    xError: String;
    xForm: TCUpdateExchangesForm;
begin
  if GDataProvider.IsConnected then begin
    xValid := False;
    xDoc := GetDocumentFromString(AExchangesText, GetExchangesXsd);
    if xDoc.parseError.errorCode = 0 then begin
      xRoot := xDoc.selectSingleNode('exchanges');
      if xRoot <> Nil then begin
        xValid := True;
        xForm := TCUpdateExchangesForm.Create(Application);
        xForm.SourceXml := xDoc;
        xForm.SourceRoot := xRoot;
        xForm.InitializeForm;
        xForm.ShowModal;
        xForm.Free;
      end else begin
        xError := 'Brak elementu zbiorczego';
      end;
    end else begin
      xError := GetParseErrorDescription(xDoc.parseError, True);
    end;
    if not xValid then begin
      ShowInfo(itError, 'Otrzymane dane nie s� poprawn� tabel� notowa�', xError);
    end;
  end else begin
    ShowInfo(itError, 'Nie mo�na wczyta� tabeli notowa� poniewa� �aden plik danych nie jest otwarty', '');
  end;
end;

procedure UpdateCurrencyRates(ARatesText: String);
var xDoc: ICXMLDOMDocument;
    xRoot: ICXMLDOMNode;
    xList: ICXMLDOMNodeList;
    xValid: Boolean;
    xError: String;
    xBindingDate: TDateTime;
    xCahpointName: String;
    xForm: TCUpdateCurrencyRatesForm;
begin
  if GDataProvider.IsConnected then begin
    xValid := False;
    xDoc := GetDocumentFromString(ARatesText, GetRatesXsd);
    if xDoc.parseError.errorCode = 0 then begin
      xRoot := xDoc.selectSingleNode('currencyRates');
      if xRoot <> Nil then begin
        xBindingDate := XsdToDateTime(GetXmlAttribute('bindingDate', xRoot, ''));
        if xBindingDate <> 0 then begin
          xCahpointName := GetXmlAttribute('cashpointName', xRoot, '');
          if xCahpointName <> '' then begin
            xValid := True;
            xList := xRoot.selectNodes('currencyRate');
            if xList.length > 0 then begin
              xForm := TCUpdateCurrencyRatesForm.Create(Application);
              xForm.Xml := xDoc;
              xForm.Root := xRoot;
              xForm.SourceRates := xList;
              xForm.BindingDate := xBindingDate;
              xForm.CashpointName := xCahpointName;
              xForm.InitializeForm;
              xForm.ShowModal;
              xForm.Free;
            end else begin
              ShowInfo(itInfo, 'Tabela nie zawiera �adnych kurs�w walut', xError);
            end;
          end else begin
            xError := 'Brak okre�lenia kontrahenta - dostawcy tabeli kurs�w';
          end;
        end else begin
          xError := 'Brak okre�lenia daty wa�no�ci tabeli kurs�w';
        end;
      end else begin
        xError := 'Brak elementu zbiorczego';
      end;
    end else begin
      xError := GetParseErrorDescription(xDoc.parseError, True);
    end;
    if not xValid then begin
      ShowInfo(itError, 'Otrzymane dane nie s� poprawn� tabel� kurs�w walut', xError);
    end;
  end else begin
    ShowInfo(itError, 'Nie mo�na wczyta� tabeli kurs�w walut poniewa� �aden plik danych nie jest otwarty', '');
  end;
end;

procedure ReloadCaches;
var xC: TDataObjectList;
    xCount: Integer;
    xCur: TCurrencyDef;
    xUni: TUnitDef;
begin
  if GDataProvider.IsConnected then begin
    xC := TCurrencyDef.GetAllObjects(CurrencyDefProxy);
    for xCount := 0 to xC.Count - 1 do begin
      xCur := TCurrencyDef(xC.Items[xCount]);
      GCurrencyCache.Change(xCur.id, xCur.symbol, xCur.iso);
    end;
    xC.Free;
    xC := TUnitDef.GetAllObjects(UnitDefProxy);
    for xCount := 0 to xC.Count - 1 do begin
      xUni := TUnitDef(xC.Items[xCount]);
      GUnitdefCache.Change(xUni.id, xUni.symbol, '');
    end;
    xC.Free;
    GActiveProfileId := CEmptyDataGid;
    GDefaultProfileId := GDataProvider.GetCmanagerParam('GActiveProfileId', CEmptyDataGid);
    GDefaultProductId := GDataProvider.GetCmanagerParam('GDefaultProductId', CEmptyDataGid);
    GDefaultAccountId := GDataProvider.GetCmanagerParam('GDefaultAccountId', CEmptyDataGid);
    GDefaultCashpointId := GDataProvider.GetCmanagerParam('GDefaultCashpointId', CEmptyDataGid);
  end;
end;

procedure ExportListToExcel(AList: TCList; AFilename: String);
var xConnection: TADOConnection;
    xQuery: TADOQuery;
    xCatalog, xSheet, xColumn: OleVariant;
    xError: String;
    xCount: Integer;
    xNode: PVirtualNode;
    xSum: Extended;
begin
  xError := '';
  xCatalog := DbCreateExcelFile(AFilename, xError);
  if not VarIsEmpty(xCatalog) then begin
    try
      try
        xSheet := CreateOleObject('Adox.Table');
        xSheet.Name := 'Lista';
        for xCount := 0 to AList.Header.Columns.Count - 1 do begin
          xColumn := CreateOleObject('Adox.Column');
          xColumn.Name := AList.Header.Columns.Items[xCount].Text;
          if AList.SumColumn(xCount, xSum) then begin
            xColumn.Type := $00000005;
          end;
          xSheet.Columns.Append(xColumn);
        end;
        xCatalog.Tables.Append(xSheet);
      except
        on E: Exception do begin
          xError := E.Message;
        end;
      end;
    finally
      xColumn := Unassigned;
      xSheet := Unassigned;
      xCatalog := Unassigned;
    end;
    if xError = '' then begin
      xConnection := TADOConnection.Create(nil);
      xConnection.LoginPrompt := False;
      xConnection.ConnectionString := Format('Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Extended Properties="Excel 8.0;HDR=Yes"', [AFilename]);
      xQuery := TADOQuery.Create(Nil);
      xQuery.Connection := xConnection;
      try
        try
          xQuery.SQL.Text := 'select * from [lista$]';
          xQuery.Open;
          xNode := AList.GetFirst;
          while (xNode <> Nil) do begin
            xQuery.Append;
            xQuery.Edit;
            for xCount := 0 to AList.Header.Columns.Count - 1 do begin
              xQuery.Fields.Fields[xCount].Value := AList.Text[xNode, xCount];
            end;
            xQuery.Post;
            xNode := AList.GetNext(xNode);
          end;
        except
          on E: Exception do begin
            xError := E.Message;
          end;
        end;
      finally
        xQuery.Free;
        xConnection.Free;
      end;
    end;
  end;
  if xError <> '' then begin
    ShowInfo(itError, 'Nie uda�o si� wykona� eksportu do pliku w formacie Excel', xError);
  end;
end;

procedure UpdateExtractions(AExtractionText: String);
var xDoc: ICXMLDOMDocument;
    xRoot: ICXMLDOMNode;
    xList: ICXMLDOMNodeList;
    xValid: Boolean;
    xError, xDesc: String;
    xCreationDate, xStartDate, xEndDate: TDateTime;
    xForm: TCDataobjectForm;
    xCount: Integer;
    xParams: TExtractionAdditionalData;
    xNode: ICXMLDOMNode;
    xRegDate, xAccountingDate: TDateTime;
    xCash: Currency;
    xMovementType, xCurrencyIso: String;
    xItem: TExtractionListElement;
    xCurrCache: TCurrCacheItem;
begin
  if GDataProvider.IsConnected then begin
    xValid := False;
    xDoc := GetDocumentFromString(AExtractionText, GetExtractionsXsd);
    if xDoc.parseError.errorCode = 0 then begin
      xRoot := xDoc.selectSingleNode('accountExtraction');
      if xRoot <> Nil then begin
        xCreationDate := XsdToDateTime(GetXmlAttribute('creationDate', xRoot, ''));
        if xCreationDate <> 0 then begin
          xStartDate := XsdToDateTime(GetXmlAttribute('startDate', xRoot, ''));
          xEndDate := XsdToDateTime(GetXmlAttribute('endDate', xRoot, ''));
          if (xStartDate <> 0) and (xEndDate <> 0) then begin
            xValid := True;
            xDesc := GetXmlAttribute('description', xRoot, '');
            xList := xRoot.selectNodes('extractionItem');
            xCount := 0;
            xParams := TExtractionAdditionalData.Create(xCreationDate, xStartDate, xEndDate, xDesc);
            while xValid and (xCount <= xList.length - 1) do begin
              xNode := xList.item[xCount];
              xRegDate := XsdToDateTime(GetXmlAttribute('operationDate', xNode, ''));
              xAccountingDate := XsdToDateTime(GetXmlAttribute('accountingDate', xNode, ''));
              if (xRegDate <> 0) and (xAccountingDate <> 0) then begin
                xCash := StrToCurrencyDecimalDot(GetXmlAttribute('cash', xNode, ''));
                xMovementType := GetXmlAttribute('type', xNode, '');
                if (xMovementType = CInMovement) or (xMovementType = COutMovement) then begin
                  xCurrencyIso := GetXmlAttribute('currency', xNode, '');
                  xCurrCache := GCurrencyCache.ByIso[xCurrencyIso];
                  if xCurrCache <> Nil then begin
                    xItem := TExtractionListElement.Create;
                    xItem.movementType := xMovementType;
                    xItem.cash := xCash;
                    xItem.description := GetXmlAttribute('description', xNode, '');
                    xItem.regTime := xRegDate;
                    xItem.accountingDate := xAccountingDate;
                    xItem.idAccount := CEmptyDataGid;
                    xItem.idCurrencyDef := xCurrCache.CurrId;
                    xParams.movements.Add(xItem);
                  end else begin
                    xValid := False;
                    xError := 'Brak waluty o symbolu Iso "' + xCurrencyIso + '". Zdefiniuj walut� o takim symbolu i spr�buj ponownie';
                  end;
                end else begin
                  xValid := False;
                  xError := 'Brak okre�lenia typu operacji wyci�gu dla elementu numer ' + IntToStr(xCount);
                end;
              end else begin
                xValid := False;
                xError := 'Brak okre�lenia daty operacji lub daty ksi�gowania dla elementu numer ' + IntToStr(xCount);
              end;
              Inc(xCount);
            end;
            if xValid then begin
              xForm :=  TCExtractionForm.Create(Nil);
              xForm.ShowDataobject(coAdd, AccountExtractionProxy, Nil, True, xParams);
              xForm.Free;
            end;
          end else begin
            xError := 'Brak okre�lenia daty pocz�tku lub daty ko�ca wyci�gu';
          end;
        end else begin
          xError := 'Brak okre�lenia daty utworzenia wyci�gu';
        end;
      end else begin
        xError := 'Brak elementu zbiorczego';
      end;
    end else begin
      xError := GetParseErrorDescription(xDoc.parseError, True);
    end;
    if not xValid then begin
      ShowInfo(itError, 'Otrzymane dane nie s� poprawnym wyci�giem bankowym', xError);
    end;
  end else begin
    ShowInfo(itError, 'Nie mo�na wczyta� wyci�gu poniewa� �aden plik danych nie jest otwarty', '');
  end;
end;

procedure SetComponentUnitdef(AUnitdefId: TDataGid; AComponent: TCCurrEdit);
var xSymbol: String;
begin
  AComponent.Enabled := AUnitdefId <> CEmptyDataGid;
  if AUnitdefId <> CEmptyDataGid then begin
    xSymbol := GDataProvider.GetSqlString('select symbol from unitDef where idUnitDef = ' + DataGidToDatabase(AUnitdefId), '');
    AComponent.SetCurrencyDef(AUnitdefId, xSymbol);
    AComponent.Value := 1;
  end else begin
    AComponent.SetCurrencyDef(CEmptyDataGid, '');
    AComponent.Value := 1;
  end;
end;

function GetRatesXsd: ICXMLDOMDocument;
begin
  Result := GetDocumentFromString(GetStringFromResources('RATESXSD', RT_RCDATA), Nil);
end;

function GetExchangesXsd: ICXMLDOMDocument;
begin
  Result := GetDocumentFromString(GetStringFromResources('EXCHANGESXSD', RT_RCDATA), Nil);
end;

function GetExtractionsXsd: ICXMLDOMDocument;
begin
  Result := GetDocumentFromString(GetStringFromResources('EXTRACTIONSXSD', RT_RCDATA), Nil);
end;

function GetChartsXsd: ICXMLDOMDocument;
begin
  Result := GetDocumentFromString(GetStringFromResources('CHARTSXSD', RT_RCDATA), Nil);
end;

function CurrencyToString(ACurrency: Currency; ACurrencyId: String = ''; AWithSymbol: Boolean = True; ADecimal: Integer = 2): String;
var xCurSymbol: String;
begin
  if AWithSymbol then begin
    if ACurrencyId = '' then begin
      xCurSymbol := GCurrencyCache.GetSymbol(CCurrencyDefGid_PLN);
    end else begin
      xCurSymbol := GCurrencyCache.GetSymbol(ACurrencyId);
    end;
    Result := CurrToStrF(ACurrency, ffNumber, ADecimal) + ' ' + xCurSymbol;
  end else begin
    Result := CurrToStrF(ACurrency, ffNumber, ADecimal);
  end;
end;

function DatabaseToDatetime(ADatetime: String): TDateTime;
var xY, xM, xD: Word;
    xDs: String;
begin
  xDs := StringReplace(ADatetime, '''', '', [rfReplaceAll, rfIgnoreCase]);
  xDs := StringReplace(xDs, '-', '', [rfReplaceAll, rfIgnoreCase]);
  xDs := StringReplace(xDs, '#', '', [rfReplaceAll, rfIgnoreCase]);
  xY := StrToIntDef(Copy(xDs, 1, 4), 0);
  xM := StrToIntDef(Copy(xDs, 5, 2), 0);
  xD := StrToIntDef(Copy(xDs, 7, 2), 0);
  try
    Result := EncodeDate(xY, xM, xD);
  except
    Result := 0;
  end;
end;

function GetFieldValueDef(ADataset: TADOQuery; AFieldname: String; ADefValue: Variant): Variant;
var xField: TField;
begin
  xField := ADataset.FindField(AFieldname);
  if xField <> Nil then begin
    Result := xField.AsVariant;
  end else begin
    Result := ADefValue;
  end;
end;

end.
