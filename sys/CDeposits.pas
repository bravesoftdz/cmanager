unit CDeposits;

interface

uses CDataObjects, CDatabase, SysUtils, CConsts, DateUtils, Contnrs, StrUtils, AdoDb;

type
  TDepositProgItem = class(TObject)
  private
    Fcaption: String;
    Fdate: TDateTime;
    Foperation: String;
    Fcash: Currency;
    Finterest: Currency;
    Ftax: Currency;
    FnoncapitalizedInterest: Currency;
    FdueStart: TDateTime;
    FdueEnd: TDateTime;
    FperiodStart: TDateTime;
    FperiodEnd: TDateTime;
    FmovementType: TBaseEnumeration;
    FdepositState: TBaseEnumeration;
    FregOrder: Integer;
  public
    constructor Create(AType: TBaseEnumeration);
  published
    property date: TDateTime read Fdate write Fdate;
    property caption: String read Fcaption write Fcaption;
    property operation: String read Foperation write Foperation;
    property cash: Currency read Fcash write Fcash;
    property interest: Currency read Finterest write Finterest;
    property noncapitalizedInterest: Currency read FnoncapitalizedInterest write FnoncapitalizedInterest;
    property dueStart: TDateTime read FdueStart write FdueStart;
    property dueEnd: TDateTime read FdueEnd write FdueEnd;
    property periodStart: TDateTime read FperiodStart write FperiodStart;
    property periodEnd: TDateTime read FperiodEnd write FperiodEnd;
    property movementType: TBaseEnumeration read FmovementType write FmovementType;
    property regOrder: Integer read FregOrder write FregOrder;
    property depositState: TBaseEnumeration read FdepositState write FdepositState;
    property tax: Currency read Ftax write Ftax;
  end;

  TDeposit = class(TObjectList)
  private
    FinitialCash: Currency;
    FinitialPeriodStartDate: TDateTime;
    FinitialPeriodEndDate: TDateTime;
    Fcash: Currency;
    FinterestRate: Currency;
    FnoncapitalizedInterest: Currency;
    FperiodCount: Integer;
    FperiodType: TBaseEnumeration;
    FperiodAction: TBaseEnumeration;
    FdueCount: Integer;
    FdueType: TBaseEnumeration;
    FdueAction: TBaseEnumeration;
    FperiodStartDate: TDateTime;
    FperiodEndDate: TDateTime;
    FdueStartDate: TDateTime;
    FdueEndDate: TDateTime;
    FprogEndDate: TDateTime;
    FdepositState: TBaseEnumeration;
    FcalcTax: Boolean;
    FtaxRate: Currency;
    FoverallTax: Currency;
    function GetItems(AIndex: Integer): TDepositProgItem;
    procedure SetItems(AIndex: Integer; const Value: TDepositProgItem);
    function GetrateOfReturn: Currency;
    function GetPeriodTypeAsString: String;
    function GetdueTypeAsString: String;
  public
    constructor Create;
    function CalculateProg: Boolean;
    function IsSumObject(ANumber: Integer): Boolean;
    property Items[AIndex: Integer]: TDepositProgItem read GetItems write SetItems;
  published
    property cash: Currency read Fcash write Fcash;
    property interestRate: Currency read FinterestRate write FinterestRate;
    property noncapitalizedInterest: Currency read FnoncapitalizedInterest write FnoncapitalizedInterest;
    property periodCount: Integer read FperiodCount write FperiodCount;
    property periodType: TBaseEnumeration read FperiodType write FperiodType;
    property periodAction: TBaseEnumeration read FperiodAction write FperiodAction;
    property dueCount: Integer read FdueCount write FdueCount;
    property dueType: TBaseEnumeration read FdueType write FdueType;
    property dueAction: TBaseEnumeration read FdueAction write FdueAction;
    property periodStartDate: TDateTime read FperiodStartDate write FperiodStartDate;
    property periodEndDate: TDateTime read FperiodEndDate write FperiodEndDate;
    property progEndDate: TDateTime read FprogEndDate write FprogEndDate;
    property rateOfReturn: Currency read GetrateOfReturn;
    property dueStartDate: TDateTime read FdueStartDate write FdueStartDate;
    property dueEndDate: TDateTime read FdueEndDate write FdueEndDate;
    property initialCash: Currency read FinitialCash;
    property initialPeriodStartDate: TDateTime read FinitialPeriodStartDate;
    property initialPeriodEndDate: TDateTime read FinitialPeriodEndDate;
    property periodTypeAsString: String read GetPeriodTypeAsString;
    property dueTypeAsString: String read GetdueTypeAsString;
    property calcTax: Boolean read FcalcTax write FcalcTax;
    property taxRate: Currency read FtaxRate write FtaxRate;
    property overallTax: Currency read FoverallTax;
  end;

procedure UpdateDepositInvestments(ADataProvider: TDataProvider);

implementation

uses CTools, Math, Classes, CPlugins, CDebug;

procedure UpdateDepositInvestmentDues(ADepositInvestment: TDepositInvestment; AToDate: TDateTime);
begin
end;

procedure UpdateDepositInvestmentPeriods(ADi: TDepositInvestment; AToDate: TDateTime);
var xDepositCalculator: TDeposit;
    xFromDate: TDateTime;
    xMovements: TADOQuery;
    xCount: Integer;
    xProgItem: TDepositProgItem;
    xMove: TDepositMovement;
begin
  xFromDate := Min(ADi.periodStartDate, ADi.dueStartDate);
  xDepositCalculator := TDeposit.Create;
  xDepositCalculator.cash := ADi.cash;
  xDepositCalculator.interestRate := ADi.interestRate;
  xDepositCalculator.noncapitalizedInterest := ADi.noncapitalizedInterest;
  xDepositCalculator.periodCount := ADi.periodCount;
  xDepositCalculator.periodType := ADi.periodType;
  xDepositCalculator.dueType := ADi.dueType;
  xDepositCalculator.dueCount := ADi.dueCount;
  xDepositCalculator.periodStartDate := ADi.periodStartDate;
  xDepositCalculator.periodEndDate := ADi.periodEndDate;
  xDepositCalculator.dueStartDate := ADi.dueStartDate;
  xDepositCalculator.dueEndDate := ADi.dueEndDate;
  xDepositCalculator.progEndDate := AToDate;
  xDepositCalculator.periodAction := ADi.periodAction;
  xDepositCalculator.dueAction := ADi.dueAction;
  xDepositCalculator.taxRate := ADi.taxRate;
  xDepositCalculator.calcTax := ADi.calcTax;
  if xDepositCalculator.CalculateProg and (xDepositCalculator.Count > 0) then begin
    xMovements := GDataProvider.OpenSql(Format(
      'select movementType, regDateTime from depositMovement where idDepositInvestment = %s and regDateTime between %s and %s',
      [DataGidToDatabase(ADi.id), DatetimeToDatabase(xFromDate, False), DatetimeToDatabase(AToDate, False)]));
    for xCount := 0 to xDepositCalculator.Count - 1 do begin
      xProgItem := xDepositCalculator.Items[xCount];
      xMovements.Filter := Format('movementType = ''%s'' and regDateTime = %s', [xProgItem.movementType, DatetimeToDatabase(xProgItem.date, False)]);
      xMovements.Filtered := True;
      if xMovements.IsEmpty then begin
        xMove := TDepositMovement.CreateObject(DepositMovementProxy, False);
        xMove.movementType := xProgItem.movementType;
        xMove.regDateTime := xProgItem.date;
        xMove.description := xProgItem.operation;
        if xProgItem.movementType = CDepositMovementDue then begin
          xMove.cash := 0;
          xMove.interest := xProgItem.interest;
        end else begin
          xMove.cash := xProgItem.cash;
          xMove.interest := 0;
        end;
        xMove.idDepositInvestment := ADi.id;
        xMove.idAccount := CEmptyDataGid;
        xMove.idAccountCurrencyDef := CEmptyDataGid;
        xMove.idProduct := CEmptyDataGid;
        xMove.idCurrencyRate := CEmptyDataGid;
        xMove.rateDescription := '';
        xMove.currencyQuantity := 1;
        xMove.currencyRate := 1;
        xMove.accountCash := 0;
        xMove.regOrder := xProgItem.regOrder;
        xMove.depositState := xProgItem.depositState;
        if xProgItem.movementType = CDepositMovementInactivate then begin
          ADi.depositState := CDepositInvestmentInactive;
        end;
      end;
    end;
    xMovements.Free;
    ADi.cash := xDepositCalculator.cash;
    ADi.noncapitalizedInterest := xDepositCalculator.noncapitalizedInterest;
    ADi.periodStartDate := xDepositCalculator.periodStartDate;
    ADi.periodEndDate := xDepositCalculator.periodEndDate;
    ADi.dueStartDate := xDepositCalculator.dueStartDate;
    ADi.dueEndDate := xDepositCalculator.dueEndDate;
  end;
  xDepositCalculator.Free;
end;

procedure UpdateDepositInvestments(ADataProvider: TDataProvider);
var xList: TDataObjectList;
    xCount: Integer;
    xDeposit: TDepositInvestment;
begin
  DebugStartTickCount('UpdateDepositInvestments');
  ADataProvider.BeginTransaction;
  xList := TDepositInvestment.GetList(TDepositInvestment, DepositInvestmentProxy, 'select * from depositInvestment where depositState = ' + QuotedStr(CDepositInvestmentActive));
  for xCount := 0 to xList.Count - 1 do begin
    xDeposit := TDepositInvestment(xList.Items[xCount]);
    UpdateDepositInvestmentPeriods(xDeposit, GWorkDate);
  end;
  ADataProvider.CommitTransaction;
  xList.Free;
  DebugEndTickCounting('UpdateDepositInvestments');
end;

function TDeposit.CalculateProg: Boolean;
var xRateDivider, xDaysBetween: Integer;
    xRatePeriodType: TBaseEnumeration;
    xRatePeriodCount: Integer;
    xCurDate: TDateTime;
    xItem: TDepositProgItem;
    xCalcInterest, xTaxBase: Currency;
begin
  Clear;
  FinitialCash := Fcash;
  FoverallTax := 0;
  FinitialPeriodStartDate := FperiodStartDate;
  FinitialPeriodEndDate := FperiodEndDate;
  FdepositState := CDepositInvestmentActive;
  Result := False;
  xRatePeriodCount := FperiodCount;
  xRatePeriodType := FperiodType;
  if FdueType <> CDepositDueTypeOnDepositEnd then begin
    xRatePeriodCount := FdueCount;
    xRatePeriodType := FdueType;
  end;
  if xRatePeriodType = CDepositTypeDay then begin
    xRateDivider := DaysInYear(FperiodStartDate);
  end else if xRatePeriodType = CDepositTypeWeek then begin
    xRateDivider := WeeksInYear(FperiodStartDate);
  end else if xRatePeriodType = CDepositTypeMonth then begin
    xRateDivider := MonthsPerYear;
  end else begin
    xRateDivider := 1;
  end;
  xCurDate := FperiodStartDate;
  try
    while (xCurDate <= FprogEndDate) and (FdepositState = CDepositInvestmentActive) do begin
      if xCurDate = FdueEndDate then begin
        xItem := TDepositProgItem.Create(CDepositMovementDue);
        xItem.date := FdueEndDate;
        xItem.regOrder := Count + 1;
        xItem.caption := IntToStr(Count + 1);
        xItem.dueStart := FdueStartDate;
        xItem.dueEnd := FdueEndDate;
        xItem.periodStart := FperiodStartDate;
        xItem.periodEnd := FperiodEndDate;
        xItem.depositState := FdepositState;
        if FdueAction = CDepositDueActionAutoCapitalisation then begin
          xItem.operation := 'Kapitalizacja naliczonych odsetek';
        end else begin
          xItem.operation := 'Naliczenie odsetek';
        end;
        xCalcInterest := RoundCurrency((xRatePeriodCount * Fcash * FinterestRate) / (100 * xRateDivider));
        if calcTax then begin
          if Frac(xCalcInterest) >= 0.5 then begin
            xTaxBase := Int(xCalcInterest) + 1;
          end else begin
            xTaxBase := Int(xCalcInterest);
          end;
          xTaxBase := RoundCurrency((xTaxBase * FtaxRate) / 100);
          if Frac(xTaxBase) >= 0.5 then begin
            xTaxBase := Int(xTaxBase) + 1;
          end else begin
            xTaxBase := Int(xTaxBase);
          end;
          xCalcInterest := xCalcInterest - xTaxBase;
          xItem.tax := xTaxBase;
        end;
        if FdueType <> CDepositDueTypeOnDepositEnd then begin
          FdueStartDate := IncDay(FdueEndDate, 1);
          FdueEndDate := TDepositInvestment.EndDueDatetime(FdueStartDate, FdueCount, FdueType);
        end else begin
          FdueStartDate := IncDay(periodEndDate, 1);
          FdueEndDate := TDepositInvestment.EndPeriodDatetime(FdueStartDate, FperiodCount, FperiodType);
        end;
        xItem.cash := Fcash;
        xItem.interest := xCalcInterest;
        if FdueAction = CDepositDueActionAutoCapitalisation then begin
          xItem.interest := xCalcInterest;
          xItem.noncapitalizedInterest := 0;
          FnoncapitalizedInterest := 0;
          Fcash := Fcash + xCalcInterest;
        end else begin
          xItem.interest := xCalcInterest;
          xItem.noncapitalizedInterest := FnoncapitalizedInterest + xCalcInterest;
          FnoncapitalizedInterest := FnoncapitalizedInterest + xCalcInterest;
        end;
        FoverallTax := FoverallTax + xItem.tax;
        Add(xItem);
      end;
      if xCurDate = FperiodEndDate then begin
        if (FdueStartDate <= FperiodEndDate) and (FdueEndDate >= FperiodEndDate) then begin
          xDaysBetween := DaysBetween(FperiodEndDate, FdueStartDate);
          xItem := TDepositProgItem.Create(CDepositMovementDue);
          xItem.date := FperiodEndDate;
          xItem.dueStart := FdueStartDate;
          xItem.dueEnd := FperiodEndDate;
          xItem.periodStart := FperiodStartDate;
          xItem.periodEnd := FperiodEndDate;
          xItem.caption := IntToStr(Count + 1);
          xItem.regOrder := Count + 1;
          xItem.depositState := FdepositState;
          if FdueAction = CDepositDueActionAutoCapitalisation then begin
            xItem.operation := 'Kapitalizacja naliczonych odsetek';
          end else begin
            xItem.operation := 'Naliczenie odsetek';
          end;
          Add(xItem);
          FdueStartDate := FperiodStartDate;
          if FdueType <> CDepositDueTypeOnDepositEnd then begin
            FdueStartDate := IncDay(dueEndDate, 1);
            FdueEndDate := TDepositInvestment.EndDueDatetime(FdueStartDate, FdueCount, FdueType);
          end else begin
            FdueStartDate := IncDay(periodEndDate, 1);
            FdueEndDate := TDepositInvestment.EndPeriodDatetime(FdueStartDate, FperiodCount, FperiodType);
          end;
          xCalcInterest := RoundCurrency((xDaysBetween * Fcash * FinterestRate) / (100 * DaysInYear(FperiodStartDate)));
          xItem.cash := Fcash;
          xItem.interest := xCalcInterest;
          xCalcInterest := RoundCurrency((xRatePeriodCount * Fcash * FinterestRate) / (100 * xRateDivider));
          if calcTax then begin
            if Frac(xCalcInterest) >= 0.5 then begin
              xTaxBase := Int(xCalcInterest) + 1;
            end else begin
              xTaxBase := Int(xCalcInterest);
            end;
            xTaxBase := RoundCurrency((xTaxBase * FtaxRate) / 100);
            if Frac(xTaxBase) >= 0.5 then begin
              xTaxBase := Int(xTaxBase) + 1;
            end else begin
              xTaxBase := Int(xTaxBase);
            end;
            xCalcInterest := xCalcInterest - xTaxBase;
            xItem.tax := xTaxBase;
          end;
          FoverallTax := FoverallTax + xItem.tax;
          if FdueAction = CDepositDueActionAutoCapitalisation then begin
            xItem.noncapitalizedInterest := 0;
            FnoncapitalizedInterest := 0;
          end else begin
            xItem.noncapitalizedInterest := FnoncapitalizedInterest + xCalcInterest;
            FnoncapitalizedInterest := FnoncapitalizedInterest + xCalcInterest;
          end;
        end;
        xItem := TDepositProgItem.Create(IfThen(FperiodAction = CDepositPeriodActionAutoRenew, CDepositMovementRenew, CDepositMovementInactivate));
        xItem.date := FperiodEndDate;
        xItem.regOrder := Count + 1;
        xItem.dueStart := FdueStartDate;
        xItem.dueEnd := FdueEndDate;
        xItem.periodStart := FperiodStartDate;
        xItem.periodEnd := FperiodEndDate;
        xItem.caption := IntToStr(Count + 1);
        xItem.cash := Fcash;
        xItem.interest := 0;
        xItem.noncapitalizedInterest := FnoncapitalizedInterest;
        xItem.depositState := FdepositState;
        if FperiodAction = CDepositPeriodActionChangeInactive then begin
          xItem.operation := 'Koniec czasu trwania lokaty';
          FdepositState := CDepositInvestmentInactive;
        end else begin
          xItem.operation := 'Automatyczne odnowienie lokaty';
          FdepositState := CDepositInvestmentActive;
          FperiodStartDate := IncDay(FperiodEndDate, 1);
          FperiodEndDate := TDepositInvestment.EndPeriodDatetime(FperiodStartDate, FperiodCount, periodType);
        end;
        Add(xItem);
      end;
      xCurDate := IncDay(xCurDate, 1);
    end;
    Result := True;
  except
    Clear;
  end;
end;

constructor TDeposit.Create;
begin
  inherited Create;
  FinitialCash := 0;
  Fcash := 0;
  FinterestRate := 0;
  FnoncapitalizedInterest := 0;
  FperiodCount := 1;
  FperiodType := CDepositTypeMonth;
  FperiodAction := CDepositPeriodActionAutoRenew;
  FdueCount := 1;
  FdueType := CDepositDueTypeOnDepositEnd;
  FdueAction := CDepositDueActionAutoCapitalisation;
  FperiodStartDate := GWorkDate;
  FperiodEndDate := TDepositInvestment.EndPeriodDatetime(FperiodStartDate, FperiodCount, FperiodType);
  FdueStartDate := FperiodStartDate;
  FdueEndDate := FperiodEndDate;
  FprogEndDate := FperiodEndDate;
  FdepositState := CDepositInvestmentActive;
  FcalcTax := False;
  FtaxRate := 0;
  FoverallTax := 0;
end;

function TDeposit.GetdueTypeAsString: String;
begin
  Result := '';
  if FdueType = CDepositDueTypeOnDepositEnd then begin
    Result := 'Koniec czasy trwania lokaty';
  end else if FdueType = CDepositTypeDay then begin
    Result := 'Dzie�';
  end else if FdueType = CDepositTypeWeek then begin
    Result := 'Tydzie�';
  end else if FdueType = CDepositTypeMonth then begin
    Result := 'Miesi�c';
  end else begin
    Result := 'Rok';
  end;
end;

function TDeposit.GetItems(AIndex: Integer): TDepositProgItem;
begin
  Result := TDepositProgItem(inherited Items[AIndex]);
end;

function TDeposit.GetPeriodTypeAsString: String;
begin
  if FperiodType = CDepositTypeDay then begin
    Result := 'Dzie�';
  end else if FperiodType = CDepositTypeWeek then begin
    Result := 'Tydzie�';
  end else if FperiodType = CDepositTypeMonth then begin
    Result := 'Miesi�c';
  end else begin
    Result := 'Rok';
  end;
end;

function TDeposit.GetrateOfReturn: Currency;
begin
  Result := RoundCurrency((100 * (Fcash + FnoncapitalizedInterest) / FinitialCash), 4) - 100;
end;

function TDeposit.IsSumObject(ANumber: Integer): Boolean;
begin
  Result := StrToIntDef(Items[ANumber].caption, -1) <> -1;
end;

procedure TDeposit.SetItems(AIndex: Integer; const Value: TDepositProgItem);
begin
  inherited Items[AIndex] := Value;
end;

constructor TDepositProgItem.Create(AType: TBaseEnumeration);
begin
  inherited Create;
  FmovementType := AType;
end;

end.
