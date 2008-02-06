unit CConsts;

interface

uses Windows, Messages;

const
  WM_DATAOBJECTADDED = WM_USER + 1;
  WM_DATAOBJECTEDITED = WM_USER + 2;
  WM_DATAOBJECTDELETED = WM_USER + 3;
  WM_DATAREFRESH = WM_USER + 4;
  WM_FORMMAXIMIZE = WM_USER + 5;
  WM_FORMMINIMIZE = WM_USER + 6;
  WM_OPENCONNECTION = WM_USER + 7;
  WM_CLOSECONNECTION = WM_USER + 8;
  WM_MUSTREPAINT = WM_USER + 9;
  WM_PREFERENCESCHANGED = WM_USER + 10;
  WM_STATBACKUPSTARTED = WM_USER + 11;
  WM_STATPROGRESS = WM_USER + 12;
  WM_STATBACKUPFINISHEDSUCC = WM_USER + 13;
  WM_STATBACKUPFINISHEDERR = WM_USER + 14;
  WM_STATCLEAR = WM_USER + 15;
  WM_GETSELECTEDID = WM_USER + 16;
  WM_GETSELECTEDTYPE = WM_USER + 17;

  WMOPT_NONE = 0;
  WMOPT_BASEMOVEMENT = 1;
  WMOPT_MOVEMENTLIST = 2;

const
  CCSSReportFile = 'report.css';
  CXSLReportFile = 'transform.xml';
  CHTMReportFile = 'report.htm';
  CXSLDefaultTransformResname = 'DEFAULTXSL';

const
  CDefaultConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  CDefaultFilename = 'CManager.dat';

  CFilterAllElements = '@';

  CInMovement = 'I';
  COutMovement = 'O';
  CTransferMovement = 'T';

  CInvestmentSellMovement = 'S';
  CInvestmentBuyMovement = 'B';

  CInProduct = 'I';
  COutProduct = 'O';

  CBankAccount = 'B';
  CCashAccount = 'C';
  CInvestmentAccount = 'I';

  CScheduleTypeOnce = 'O';
  CScheduleTypeCyclic = 'C';

  CEndConditionTimes = 'T';
  CEndConditionDate = 'D';
  CEndConditionNever = 'N';

  CFreeDayExedcutes = 'E';
  CFreeDayIncrements = 'I';
  CFreeDayDecrements = 'D';

  CTriggerTypeWeekly = 'W';
  CTriggerTypeMonthly = 'M';

  CDoneOperation = 'O';
  CDoneDeleted = 'D';
  CDoneAccepted = 'A';

  CGroupByDay = 'D';
  CGroupByWeek = 'W';
  CGroupByMonth = 'M';

  CGroupByAccount = 'A';
  CGroupByCashpoint = 'C';
  CGroupByProduct = 'P';
  CGroupByNone = 'N';

  CLongDateFormat = 'ddd, yyyy-MM-dd';
  CBaseDateFormat = 'yyyy-MM-dd';
  CDayNameDateFormat = 'ddd';
  CMonthnameDateFormat = 'MMMM yyyy';
  CLongTimeFormat = 'HH:mm:ss';

  CStartupFilemodeLastOpened = 0;
  CStartupFilemodeThisfile = 1;
  CStartupFilemodeNeveropen = 2;
  CStartupFilemodeFirsttime = 3;

  CStartupInfoToday = 0;
  CStartupInfoNextday = 1;
  CStartupInfoThisweek = 2;
  CStartupInfoNextweek = 3;
  CStartupInfoThismonth = 4;
  CStartupInfoNextmonth = 5;
  CStartupInfoDays = 6;

  CCashpointTypeAll = 'W';
  CCashpointTypeIn = 'I';
  CCashpointTypeOut = 'O';
  CCashpointTypeOther = 'X';

  CLimitActive = '1';
  CLimitDisabled = '0';

  CLimitBoundaryTypeToday = 'T';
  CLimitBoundaryTypeWeek = 'W';
  CLimitBoundaryTypeMonth = 'M';
  CLimitBoundaryTypeQuarter = 'Q';
  CLimitBoundaryTypeHalfyear = 'H';
  CLimitBoundaryTypeYear = 'Y';
  CLimitBoundaryTypeDays = 'D';

  CLimitBoundaryCondEqual = '=';
  CLimitBoundaryCondLess = '<';
  CLimitBoundaryCondGreater = '>';
  CLimitBoundaryCondLessEqual = '<=';
  CLimitBoundaryCondGreaterEqual = '>=';

  CLimitSumtypeOut = 'O';
  CLimitSumtypeIn = 'I';
  CLimitSumtypeBalance = 'B';

  CLimitSumtypeOutDescription = 'Rozchody';
  CLimitSumtypeInDescription = 'Przychody';
  CLimitSumtypeBalanceDescription = 'Saldo';

  CFilterToday = 'T';
  CFilterYesterday = 'Y';
  CFilterWeek = 'W';
  CFilterMonth = 'M';
  CFilterOther = 'O';

  CCurrencyRateTypeAverage = 'A';
  CCurrencyRateTypeSell = 'S';
  CCurrencyRateTypeBuy = 'B';

  CCurrencyRateTypeAverageDesc = 'kurs �redni';
  CCurrencyRateTypeSellDesc = 'kurs sprzeda�y';
  CCurrencyRateTypeBuyDesc = 'kurs kupna';

  CCurrencyViewBaseMovements = 'M';
  CCurrencyViewBaseAccounts = 'A';

  CCurrencyViewInvestmentMovements = 'M';
  CCurrencyViewInvestmentAccounts = 'A';

  CExtractionStateOpen = 'O';
  CExtractionStateClose = 'C';
  CExtractionStateStated = 'S';

  CExtractionStateOpenDescription = 'Otwarty';
  CExtractionStateCloseDescription = 'Zamkni�ty';
  CExtractionStateStatedDescription = 'Uzgodniony';

  CXsltTypeDefault = 'D';
  CXsltTypeSystem = 'S';
  CXsltTypePrivate = 'P';

  CInstrumentTypeIndex = 'I';
  CInstrumentTypeStock = 'S';
  CInstrumentTypeBond = 'B';
  CInstrumentTypeFundinv = 'F';
  CInstrumentTypeFundret = 'R';
  CInstrumentTypeUndefined = 'U';

  CInstrumentTypeIndexDesc = 'Indeks gie�dowy';
  CInstrumentTypeStockDesc = 'Akcje';
  CInstrumentTypeBondDesc = 'Obligacje';
  CInstrumentTypeFundinvDesc = 'Fundusz inwestycyjny';
  CInstrumentTypeFundretDesc = 'Fundusz emerytalny';
  CInstrumentTypeUndefinedDesc = 'Nieokre�lony';

const
  CInMovementDescription = 'Przych�d';
  COutMovementDescription = 'Rozch�d';
  CTransferMovementDescription = 'Transfer';

  CLimitSupressedDesc = 'Przekroczony';
  CLimitValidDesc = 'Poprawny';

  CPlannedDoneDescription = 'Wykonana';
  CPlannedRejectedDescription = 'Odrzucona';
  CPlannedAcceptedDescription = 'Uznana';
  CPlannedScheduledTodayDescription = 'Na dzi�';
  CPlannedScheduledReady = 'Zaplanowana';
  CPlannedScheduledOvertime = 'Zaleg�a';

const
  CBaseMovementTypes: array[0..4] of String = ('Rozch�d jednorazowy', 'Przych�d jednorazowy', 'Transfer', 'Planowany rozch�d', 'Planowany przych�d');

  CSimpleMovementTypes: array[0..2] of String = ('Rozch�d jednorazowy', 'Przych�d jednorazowy', 'Transfer');
  CSimpleMovementSymbols: array[0..2] of String = ('O', 'I', 'T');

  CDescPatternsKeys: array[0..8, 0..4] of string =
    (('BaseMovementOut', 'BaseMovementIn', 'BaseMovementTr', 'BaseMovementPlannedOut', 'BaseMovementPlannedIn'),
     ('MovementListOut', 'MovementListIn', '', '', ''),
     ('PlannedMovementOut', 'PlannedMovementIn', '', '', ''),
     ('MovementListElement', '', '', '', ''),
     ('Currencyrate', '', '', '', ''),
     ('AccountExctraction', '', '', '', ''),
     ('ExctractionItem', 'ExtractionItemIn', 'ExtractionItemOut', '', ''),
     ('InstrumentValue', '', '', '', ''),
     ('InvestmentMovementBuy', 'InvestmentMovementSell', 'InvestmentMovementBuyFree', 'InvestmentMovementSellFree', ''));

  CDescPatternsNames: array[0..8, 0..4] of string =
    (('Rozch�d jednorazowy', 'Przych�d jednorazowy', 'Transfer', 'Planowany rozch�d', 'Planowany przych�d'),
     ('Rozch�d', 'Przych�d', '', '', ''),
     ('Rozch�d', 'Przych�d', '', '', ''),
     ('Wszystkie elementy', '', '', '', ''),
     ('Wszystkie elementy', '', '', '', ''),
     ('Wszystkie elementy', '', '', '', ''),
     ('Uznanie', 'Obci��enie', '', '', ''),
     ('Wszystkie elementy', '', '', '', ''),
     ('Zakup', 'Sprzeda�', 'Przyj�cie do portfela', 'Wydanie z portfela', ''));



  CBackupActionOnce = 0;
  CBackupActionAlways = 1;
  CBackupActionAsk = 2;
  CBackupActionNever = 3;

  CParamTypeText = 'text';
  CParamTypeDecimal = 'decimal';
  CParamTypeDate = 'date';
  CParamTypePeriod = 'period';
  CParamTypeDataobject = 'dataobject';
  CParamTypeBoolean = 'boolean';
  CParamTypeProperty = 'property';
  CParamTypeList = 'list';

  CReportParamTypes: array[0..7, 0..1] of String =
    (
     ('tekst', CParamTypeText),
     ('liczba', CParamTypeDecimal),
     ('data', CParamTypeDate),
     ('zakres dat', CParamTypePeriod),
     ('obiekt', CParamTypeDataobject),
     ('wyb�r tak/nie', CParamTypeBoolean),
     ('cecha', CParamTypeProperty),
     ('lista warto�ci', CParamTypeList)
    );

    CPropertyItems: String =
     '<?xml version="1.0" encoding="Windows-1250"?>' + 
     '<list>' +
     '  <property name="rodzaj operacji">' +
     '    <item name="przych�d" value="' + CInMovement + '"/>' +
     '    <item name="rozch�d" value="' + COutMovement + '"/>' +
     '    <item name="transfer" value="' + CTransferMovement + '"/>' +
     '  </property>' +
     '  <property name="rodzaj planowanej operacji">' +
     '    <item name="przych�d" value="' + CInMovement + '"/>' +
     '    <item name="rozch�d" value="' + COutMovement + '"/>' +
     '  </property>' +
     '  <property name="rodzaj harmonogramu">' +
     '    <item name="jednorazowy" value="' + CScheduleTypeOnce + '"/>' +
     '    <item name="cykliczny" value="' + CScheduleTypeCyclic + '"/>' +
     '  </property>' +
     '  <property name="spos�b wykonania planu">' +
     '    <item name="wykonana" value="' + CDoneOperation + '"/>' +
     '    <item name="zaakceptowana" value="' + CDoneAccepted + '"/>' +
     '    <item name="odrzucona" value="' + CDoneDeleted + '"/>' +
     '  </property>' +
     '  <property name="rodzaj kategorii">' +
     '    <item name="przych�d" value="' + CInProduct + '"/>' +
     '    <item name="rozch�d" value="' + COutProduct + '"/>' +
     '  </property>' +
     '  <property name="rodzaj konta">' +
     '    <item name="bankowe" value="' + CBankAccount + '"/>' +
     '    <item name="got�wkowe" value="' + CCashAccount + '"/>' +
     '    <item name="inwestycyjne" value="' + CInvestmentAccount + '"/>' +
     '  </property>' +
     '  <property name="rodzaj kontrahenta">' +
     '    <item name="dost�pny wsz�dzie" value="' + CCashpointTypeAll + '"/>' +
     '    <item name="tylko przychody" value="' + CCashpointTypeIn + '"/>' +
     '    <item name="tylko rozchody" value="' + CCashpointTypeOut + '"/>' +
     '    <item name="pozosta�e" value="' + CCashpointTypeOther + '"/>' +
     '  </property>' +
     '  <property name="rodzaj kursu waluty">' +
     '    <item name="kurs �redni" value="' + CCurrencyRateTypeAverage + '"/>' +
     '    <item name="kurs sprzeda�y" value="' + CCurrencyRateTypeSell + '"/>' +
     '    <item name="kurs kupna" value="' + CCurrencyRateTypeBuy + '"/>' +
     '  </property>' +
     '  <property name="status wyci�gu">' +
     '    <item name="otwrty" value="' + CExtractionStateOpen + '"/>' +
     '    <item name="zamkni�ty" value="' + CExtractionStateClose + '"/>' +
     '    <item name="uzgodniony" value="' + CExtractionStateStated + '"/>' +
     '  </property>' +
     '  <property name="rodzaj instrumentu">' +
     '    <item name="Indeks gie�dowy" value="' + CInstrumentTypeIndex + '"/>' +
     '    <item name="Akcje" value="' + CInstrumentTypeStock + '"/>' +
     '    <item name="Obligacje" value="' + CInstrumentTypeBond + '"/>' +
     '    <item name="Fundusz inwestycyjny" value="' + CInstrumentTypeFundinv + '"/>' +
     '    <item name="Fundusz emerytalny" value="' + CInstrumentTypeFundret + '"/>' +
     '    <item name="Nieokre�lony" value="' + CInstrumentTypeUndefined + '"/>' +
     '  </property>' +
     '</list>';

implementation

end.
