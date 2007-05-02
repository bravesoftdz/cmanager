unit CConsts;

interface

uses Messages;

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

  WMOPT_NONE = 0;
  WMOPT_BASEMOVEMENT = 1;
  WMOPT_MOVEMENTLIST = 2;

const
  CEmptyDataGid = '';
  CDefaultConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  CDefaultFilename = 'CManager.dat';

  CFilterAllElements = '@';

  CInMovement = 'I';
  COutMovement = 'O';
  CTransferMovement = 'T';

  CInProduct = 'I';
  COutProduct = 'O';

  CBankAccount = 'B';
  CCashAccount = 'C';

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

  CLongDateFormat = 'ddd, yyyy-MM-dd';
  CBaseDateFormat = 'yyyy-MM-dd';
  CDayNameDateFormat = 'ddd';
  CMonthnameDateFormat = 'MMMM yyyy';

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

  CCurrencyRateFilterToday = 'T';
  CCurrencyRateFilterYesterday = 'Y';
  CCurrencyRateFilterWeek = 'W';
  CCurrencyRateFilterMonth = 'M';
  CCurrencyRateFilterOther = 'O';

  CCurrencyRateTypeAverage = 'A';
  CCurrencyRateTypeSell = 'S';
  CCurrencyRateTypeBuy = 'B';

  CCurrencyRateTypeAverageDesc = 'kurs �redni';
  CCurrencyRateTypeSellDesc = 'kurs sprzeda�y';
  CCurrencyRateTypeBuyDesc = 'kurs kupna';

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
  CDescPatternsKeys: array[0..4, 0..4] of string =
    (('BaseMovementOut', 'BaseMovementIn', 'BaseMovementTr', 'BaseMovementPlannedOut', 'BaseMovementPlannedIn'),
     ('MovementListOut', 'MovementListIn', '', '', ''),
     ('PlannedMovementOut', 'PlannedMovementIn', '', '', ''),
     ('MovementListElement', '', '', '', ''),
     ('Currencyrate', '', '', '', ''));

  CDescPatternsNames: array[0..4, 0..4] of string =
    (('Rozch�d jednorazowy', 'Przych�d jednorazowy', 'Transfer', 'Planowany rozch�d', 'Planowany przych�d'),
     ('Rozch�d', 'Przych�d', '', '', ''),
     ('Rozch�d', 'Przych�d', '', '', ''),
     ('Wszystkie elementy', '', '', '', ''),
     ('Wszystkie elementy', '', '', '', ''));


  CBackupActionOnce = 0;
  CBackupActionAlways = 1;
  CBackupActionAsk = 2;
  CBackupActionNever = 3;

implementation

end.
