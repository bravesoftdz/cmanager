        ��  ��                  ̀  4   ��
 S Q L P A T T E R N         0        create table cashPoint (
  idCashPoint uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  cashpointType varchar(1) not null,
  primary key (idCashPoint),
  constraint ck_cashpointType check (cashpointType in ('I', 'O', 'W', 'X'))
);

create table unitDef (
  idUnitDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  description varchar(200),
  primary key (idUnitDef)
);

create table currencyDef (
  idcurrencyDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  iso varchar(40),
  description varchar(200),
  primary key (idcurrencyDef)
);

create table currencyRate (
  idcurrencyRate uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idSourceCurrencyDef uniqueidentifier not null,
  idTargetCurrencyDef uniqueidentifier not null,
  idCashpoint uniqueidentifier not null,
  quantity int not null,
  rate money not null,
  bindingDate datetime not null,
  description varchar(200),
  rateType varchar(1) not null,
  primary key (idcurrencyRate),
  constraint fk_rateSourceCurrencyDef foreign key (idSourceCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateTargetCurrencyDef foreign key (idTargetCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint),
  constraint ck_rateType check (rateType in ('B', 'S', 'A'))
);

create table account (
  idAccount uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  accountType varchar(1) not null,
  cash money not null,
  initialBalance money not null,
  accountNumber varchar(50),
  idCashPoint uniqueidentifier,
  idCurrencyDef uniqueidentifier not null,
  accountState varchar(1) not null,
  primary key (idAccount),
  constraint ck_accountType check (accountType in ('C', 'B', 'I')),
  constraint ck_accountState check (accountState in ('A', 'C')),
  constraint fk_accountCashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_accountCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef)
);

create table product (
  idProduct uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  idParentProduct uniqueidentifier,
  productType varchar(1) not null,
  idUnitDef uniqueidentifier,
  primary key (idProduct),
  constraint fk_parentProduct foreign key (idParentProduct) references product (idProduct),
  constraint ck_productType check (productType in ('I', 'O')),
  constraint fk_productunitDef foreign key (idUnitDef) references unitDef (idUnitDef)
);

create table accountExtraction (
  idAccountExtraction uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idAccount uniqueidentifier not null,
  state varchar(1) not null,
  startDate datetime not null,
  endDate datetime not null,
  regDate datetime not null,
  description varchar(200),
  primary key (idAccountExtraction),
  constraint ck_accountExtractionState check (state in ('O', 'C', 'S')),
  constraint fk_accountExtractionaccount foreign key (idAccount) references account (idAccount)
);

create table extractionItem (
  idExtractionItem uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  regDate datetime not null,
  accountingDate datetime not null,
  movementType varchar(1) not null,
  idCurrencyDef uniqueidentifier not null,
  idAccountExtraction uniqueidentifier not null,
  cash money not null,
  primary key (idExtractionItem),
  constraint ck_extractionItemmovementType check (movementType in ('I', 'O')),
  constraint fk_extractionItemaccountExtraction foreign key (idAccountExtraction) references accountExtraction (idAccountExtraction) on delete cascade,
  constraint fk_extractionItemCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef)
);

create table plannedMovement (
  idPlannedMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  cash money not null,
  movementType varchar(1) not null,
  isActive bit not null,
  idAccount uniqueidentifier,
  idCashPoint uniqueidentifier,
  idProduct uniqueidentifier,
  scheduleType varchar(1) not null,
  scheduleDate datetime not null,
  endCondition varchar(1) not null,
  endCount int,
  endDate datetime,
  triggerType varchar(1) not null,
  triggerDay int not null,
  freeDays varchar(1) not null,
  idMovementCurrencyDef uniqueidentifier not null,
  quantity float not null,
  idUnitdef uniqueidentifier,
  idDestAccount uniqueidentifier,
  primary key (idPlannedMovement),
  constraint ck_plannedType check (movementType in ('I', 'O', 'T')),
  constraint ck_freeDays check (freeDays in ('E', 'D', 'I')),
  constraint fk_plannedMovementAccount foreign key (idAccount) references account (idAccount),
  constraint fk_plannedMovementDestAccount foreign key (idDestAccount) references account (idAccount),
  constraint fk_plannedMovementCashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_plannedMovementProduct foreign key (idProduct) references product (idProduct),
  constraint ck_scheduleType check (scheduleType in ('O', 'C')),
  constraint ck_endCondition check (endCondition in ('T', 'D', 'N')),
  constraint ck_endConditionCountDate check ((endCount is not null) or (endDate is not null)),
  constraint ck_triggerType check (triggerType in ('W', 'M')),
  constraint fk_planndedMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_plannedMovementunitDef foreign key (idUnitDef) references unitDef (idUnitDef)
);

create table plannedDone (
  idPlannedDone uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  triggerDate datetime not null,
  dueDate datetime not null,
  doneDate datetime not null,
  doneState varchar(1) not null,
  idPlannedMovement uniqueidentifier not null,
  description varchar(200),
  cash money not null,
  idDoneCurrencyDef uniqueidentifier not null,
  primary key (idPlannedDone),
  constraint fk_plannedMovement foreign key (idPlannedMovement) references plannedMovement (idPlannedMovement),
  constraint ck_doneState check (doneState in ('O', 'D', 'A')),
  constraint fk_plannedDoneCurrencyDef foreign key (idDoneCurrencyDef) references currencyDef (idCurrencyDef)
);

create table movementList (
  idmovementList uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  idAccount uniqueidentifier not null,
  idCashPoint uniqueidentifier not null,
  regDate datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  movementType varchar(1) not null,
  cash money not null,
  idAccountCurrencyDef uniqueidentifier not null,
  idExtractionItem uniqueidentifier null,
  isStated bit not null,
  primary key (idmovementList),
  constraint ck_movementTypemovementList check (movementType in ('I', 'O')),
  constraint fk_cashpointmovementList foreign key (idCashpoint) references cashpoint (idCashpoint),
  constraint fk_accountmovementList foreign key (idAccount) references account (idAccount),
  constraint fk_movementListAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_movementListExtractionItem foreign key (idExtractionItem) references extractionItem (idExtractionItem)
);

create table quickPattern (
  idQuickPattern uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  movementType varchar(1) not null,
  idAccount uniqueidentifier null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  primary key (idQuickPattern),
  constraint ck_movementTypeQuickPattern check (movementType in ('I', 'O', 'T')),
  constraint fk_accountQuickPattern foreign key (idAccount) references account (idAccount),
  constraint fk_sourceAccountQuickPattern foreign key (idSourceAccount) references account (idAccount),
  constraint fk_cashPointQuickPattern foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_productQuickPattern foreign key (idProduct) references product (idProduct)
);

create table baseMovement (
  idBaseMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  cash money not null,
  movementType varchar(1) not null,
  idAccount uniqueidentifier not null,
  regDate datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  idPlannedDone uniqueidentifier null,
  idMovementList uniqueidentifier null,
  idAccountCurrencyDef uniqueidentifier not null,
  idMovementCurrencyDef uniqueidentifier not null,
  idCurrencyRate uniqueidentifier,
  currencyQuantity int,
  currencyRate money null,
  rateDescription varchar(200),
  movementCash money not null,
  idExtractionItem uniqueidentifier null,
  isStated bit not null,
  idSourceExtractionItem uniqueidentifier null,
  isSourceStated bit not null,
  quantity float not null,
  idUnitdef uniqueidentifier,
  isInvestmentMovement bit not null,
  isDepositMovement bit not null,
  primary key (idBaseMovement),
  constraint ck_movementType check (movementType in ('I', 'O', 'T')),
  constraint fk_account foreign key (idAccount) references account (idAccount),
  constraint fk_sourceAccount foreign key (idSourceAccount) references account (idAccount),
  constraint fk_cashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_product foreign key (idProduct) references product (idProduct),
  constraint fk_movementList foreign key (idMovementList) references movementList (idMovementList),
  constraint fk_movementAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_movementMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_movementCurrencyRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate),
  constraint fk_movementExtractionItem foreign key (idExtractionItem) references extractionItem (idExtractionItem),
  constraint fk_movementSourceExtractionItem foreign key (idSourceExtractionItem) references extractionItem (idExtractionItem),
  constraint fk_baseMovementunitDef foreign key (idUnitDef) references unitDef (idUnitDef)
);

create table movementFilter (
  idMovementFilter uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  isTemp bit not null,
  primary key (idMovementFilter)
);

create table accountFilter (
  idMovementFilter uniqueidentifier not null,
  idAccount uniqueidentifier not null,
  constraint fk_accountMovementFilter foreign key (idMovementFilter) references movementFilter (idMovementFilter),
  constraint fk_accountMovementAccount foreign key (idAccount) references account (idAccount)
);

create table cashpointFilter (
  idMovementFilter uniqueidentifier not null,
  idCashpoint uniqueidentifier not null,
  constraint fk_cashpointMovementFilter foreign key (idMovementFilter) references movementFilter (idMovementFilter),
  constraint fk_cashpointMovementCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
);

create table productFilter (
  idMovementFilter uniqueidentifier not null,
  idProduct uniqueidentifier not null,
  constraint fk_productMovementFilter foreign key (idMovementFilter) references movementFilter (idMovementFilter),
  constraint fk_productMovementproduct foreign key (idProduct) references product (idProduct)
);

create table profile (
  idProfile uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  idAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  primary key (idProfile),
  constraint fk_productprofile foreign key (idProduct) references product (idProduct),
  constraint fk_cashpointprofile foreign key (idCashpoint) references cashpoint (idCashpoint),
  constraint fk_accountprofile foreign key (idAccount) references account (idAccount)
);

create table cmanagerParams (
  paramName varchar(40),
  paramValue text
);

create table movementLimit (
  idmovementLimit uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40),
  description varchar(200),
  idmovementFilter uniqueidentifier,
  isActive bit not null,
  boundaryAmount money not null,
  boundaryType varchar(1) not null,
  boundarycondition varchar(2) not null,
  boundaryDays int,
  sumType varchar(1) not null,
  idCurrencyDef uniqueidentifier not null,
  primary key (idMovementLimit),
  constraint ck_boundaryTypelimit check (boundaryType in ('T', 'W', 'M', 'Q', 'H', 'Y', 'D')),
  constraint ck_boundaryConditionlimit check (boundarycondition in ('=', '<', '>', '<=', '>=')),
  constraint ck_sumTypelimit check (sumType in ('I', 'O', 'B')),
  constraint fk_filterlimit foreign key (idmovementFilter) references movementFilter (idmovementFilter),
  constraint fk_limitCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef)
);

create table accountCurrencyRule (
  idaccountCurrencyRule uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  movementType varchar(1) not null,
  rateType varchar(1) not null,
  idAccount uniqueidentifier not null,
  idCashPoint uniqueidentifier,
  useOldRates bit not null,
  primary key (idaccountCurrencyRule),
  constraint ck_accountCurrencymovementType check (movementType in ('I', 'O', 'T')),
  constraint ck_accountCurrencyrateType check (rateType in ('B', 'S', 'A')),
  constraint fk_accountCurrencyaccount foreign key (idAccount) references account (idAccount) on delete cascade,
  constraint fk_accountCurrencycashPoint foreign key (idCashPoint) references cashPoint (idCashPoint) on delete cascade
);

create table reportDef (
  idreportDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  queryText memo not null,
  paramsDefs memo,
  xsltText memo,
  xsltType varchar(1) not null,
  primary key (idreportDef),
  constraint ck_xsltType check (xsltType in ('D', 'S', 'P'))
);

create table instrument (
  idInstrument uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  symbol varchar(40) not null,
  name varchar(40) not null,
  description varchar(200),
  instrumentType varchar(1) not null,
  idCurrencyDef uniqueidentifier,
  idCashpoint uniqueidentifier,
  primary key (idInstrument),
  constraint ck_instrumentType check (instrumentType in ('I', 'S', 'B', 'F', 'R', 'U')),
  constraint uq_instrumentSymbol unique (symbol),
  constraint uq_instrumentName unique (name),
  constraint fk_instrumentCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_instrumentCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
);

create table instrumentValue (
  idInstrumentValue uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  idInstrument uniqueidentifier not null,
  regDateTime datetime not null,
  valueOf money not null,
  primary key (idInstrumentValue),
  constraint fk_instrumentValueInstrument foreign key (idInstrument) references instrument (idInstrument)
);

create table investmentItem (
  idInvestmentItem uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idAccount uniqueidentifier not null,
  idInstrument uniqueidentifier not null,
  quantity float not null,
  primary key (idInvestmentItem),
  constraint fk_investmentItem_Instrument foreign key (idInstrument) references instrument (idInstrument),
  constraint fk_investmentItem_Account foreign key (idAccount) references account (idAccount)
);

create table investmentMovement (
  idInvestmentMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  movementType varchar(1) not null,
  regDateTime datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  idInstrument uniqueidentifier not null,
  idInstrumentCurrencyDef uniqueidentifier not null,
  quantity float not null,
  idInstrumentValue uniqueidentifier,
  valueOf money not null,
  summaryOf money not null,
  idAccount uniqueidentifier not null,  
  idAccountCurrencyDef uniqueidentifier not null,
  valueOfAccount money not null,
  summaryOfAccount money not null,
  idProduct uniqueidentifier,
  idCurrencyRate uniqueidentifier,
  currencyQuantity int,
  currencyRate money null,
  rateDescription varchar(200),
  idBaseMovement uniqueidentifier ,
  primary key (idInvestmentMovement),
  constraint ck_investmentMovementmovementType check (movementType in ('B', 'S')),
  constraint fk_investmentMovementInstrument foreign key (idInstrument) references instrument (idInstrument),
  constraint fk_investmentMovementInstrumentCurrency foreign key (idInstrumentCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_investmentMovementInstrumentValue foreign key (idInstrumentValue) references instrumentValue (idInstrumentValue),
  constraint fk_investmentMovementaccount foreign key (idAccount) references account (idAccount),
  constraint fk_investmentMovementAccountCurrency foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_investmentMovementProduct foreign key (idProduct) references product (idProduct),
  constraint fk_investmentMovementRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate),  
  constraint fk_investmentMovementBaseMovement foreign key (idBaseMovement) references baseMovement (idBaseMovement)
);

insert into cmanagerParams (paramName, paramValue) values ('BaseMovementOut', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementIn', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementTr', 'Transfer z @kontozrodlowe@ do @kontodocelowe@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementPlannedOut', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementPlannedIn', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementPlannedTr', 'Transfer z @kontozrodlowe@ do @kontodocelowe@');
insert into cmanagerParams (paramName, paramValue) values ('MovementListOut', '@kontrahent@');
insert into cmanagerParams (paramName, paramValue) values ('MovementListIn', '@kontrahent@');
insert into cmanagerParams (paramName, paramValue) values ('PlannedMovementOut', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('PlannedMovementIn', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('PlannedMovementTransfer', 'Planowany transfer z @kontozrodlowe@ do @kontodocelowe@');
insert into cmanagerParams (paramName, paramValue) values ('MovementListElement', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('Currencyrate', '@isobazowej@/@isodocelowej@');
insert into cmanagerParams (paramName, paramValue) values ('AccountExctraction', '@konto@ - wyci�g z dnia @datawyciagu@');
insert into cmanagerParams (paramName, paramValue) values ('InstrumentValue', '@instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementBuy', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementSell', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementBuyFree', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementSellFree', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('DepositInvestment', '@operacja@ - @nazwa@');

insert into reportDef (idreportDef, created, modified, name, description, queryText, paramsDefs, xsltText, xsltType) values ('{00000000-0000-0000-0000-000000000001}', #2007-09-02 12:13:53#, #2007-09-03 21:10:41#, 'Lista kont - raport w�asny', 'Jest to przyk�ad definiowalnego raportu z wykorzystaniem prezentacji wynik�w raportu w postaci dokumentu XML', 'eNorTs1JTS5R0FJIK8rPVUhMTs4vzSsBAFJRB6w=', 'eNqzsa/IzVEoSy0qzszPs1Uy1DNQUkjNS85PycxLt1UKz8xLyS8v1jU0MjVQsrfj5bIpSCxKzC12SU0r1gdyAXd2EyU=', '', 'S');
insert into reportDef (idreportDef, created, modified, name, description, queryText, paramsDefs, xsltText, xsltType) values ('{00000000-0000-0000-0000-000000000002}', #2007-09-03 20:31:23#, #2007-09-03 21:10:55#, 'Operacje w/g kategorii - raport w�asny', 'Jest to przyk�adowy raport definiowalny korzystaj�cy z domy�lnego arkusza styli, czyli podstawowej transformacji XSLT, znajduj�cej si� w pliku transform.xml w katalogu instalacyjnym CManager-a.', 'eNptkEsOgkAQRPcm3qEWLNAQ4gXcsXHh5woN0yBmmCbzEfQsns9zyMfIxl5VJV31Ou1Yc+HRpoYaBjmc6NlRgrou49qZoHV80PJ6bxLsEsxyXJsUSisNWisqjB3rFaC59JDg2eImtUHsZkAhwfh4u2QHhLp8k1NNTo6PcueGjcdY9X+6K1uG5Sojz8jZd8wGkSJPZxWBjJpNJhEqK6FF/lhQE78f28WgT5cT9sMLfu4D9JxbcQ==', 'eNqlj7sKwkAQRXsh/zBMH/MAu2zSpBdsBLslMwmLZifuJD7+3sU0CnZ298DlHm7VPMYL3DioE2+w2OYI7Dsh5weDR+dJ7poW5S7Hpk421WSDHbXlXus1xwjejmyQ7Gz3hECsncE2EkjEIcgyGTzZc2CFWEKYn9PaZwSnB74uLjAZTAuEPrzHSsx+Clr5EpD8Jcg+7iSbF/yRVtM=', '', 'D');

create table cmanagerInfo (
  version varchar(20) not null,
  created datetime not null
);

create table movementStatistics (
  movementCount int not null,
  cash money not null,
  movementType varchar(1) not null,
  idAccount uniqueidentifier not null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  idAccountCurrencyDef uniqueidentifier not null,
  idMovementCurrencyDef uniqueidentifier not null,
  movementCash money not null,
  constraint ck_statisticsmovementType check (movementType in ('I', 'O', 'T')),
  constraint fk_statisticsaccount foreign key (idAccount) references account (idAccount),
  constraint fk_statisticssourceAccount foreign key (idSourceAccount) references account (idAccount),
  constraint fk_statisticscashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_statisticsproduct foreign key (idProduct) references product (idProduct),
  constraint fk_statisticsmovementAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_statisticsmovementMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef)
);

create table depositInvestment (
  idDepositInvestment uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  depositState varchar(1) not null,
  name varchar(40) not null,
  description varchar(200),
  idCashPoint uniqueidentifier not null,
  idCurrencyDef uniqueidentifier not null,
  cash money not null,
  interestRate money not null,
  noncapitalizedInterest money not null,
  periodCount int not null,
  periodType varchar(1) not null,
  periodStartDate datetime not null,
  periodEndDate datetime not null,
  periodAction varchar(1) not null,
  dueCount int not null,
  dueType varchar(1) not null,
  dueStartDate datetime not null,
  dueEndDate datetime not null,
  dueAction varchar(1) not null,
  calcTax bit not null,
  taxRate money not null,
  primary key (idDepositInvestment),
  constraint fk_cashPointdepositInvestment foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_currencyDefdepositInvestment foreign key (idCurrencyDef) references currencyDef (idCurrencyDef),
  constraint ck_depositState check (depositState in ('A', 'I', 'C')),
  constraint ck_depositPeriodType check (periodType in ('D', 'W', 'M', 'Y')),
  constraint ck_duePeriodType check (dueType in ('E', 'D', 'W', 'M', 'Y')),
  constraint ck_depositperiodAction check (dueAction in ('A', 'L')),
  constraint ck_depositdueAction check (dueAction in ('A', 'L'))
);

create table depositMovement (
  idDepositMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  movementType varchar(1) not null,
  regDateTime datetime not null,
  regOrder int not null,
  description varchar(200),
  cash money not null,  
  interest money not null,
  depositState varchar(1) not null,
  idDepositInvestment uniqueidentifier not null,
  idAccount uniqueidentifier null,
  idAccountCurrencyDef uniqueidentifier null,
  accountCash money null,
  idCurrencyRate uniqueidentifier,
  currencyQuantity int,
  currencyRate money null,
  rateDescription varchar(200),
  idProduct uniqueidentifier null,
  idBaseMovement uniqueidentifier null,
  primary key (idDepositMovement),
  constraint ck_movementDepositMovementType check (movementType in ('C', 'S', 'I', 'R', 'D', 'A', 'K', 'G')),
  constraint fk_movementDepositInvestment foreign key (idDepositInvestment) references depositInvestment (idDepositInvestment),
  constraint fk_movementDepositAccount foreign key (idAccount) references account (idAccount),
  constraint fk_movementDepositProduct foreign key (idProduct) references product (idProduct),
  constraint fk_movementDepositAccountCurrency foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_movementDepositRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate),
  constraint fk_movementDepositBaseMovement foreign key (idBaseMovement) references baseMovement (idBaseMovement),
  constraint ck_movementDepositdepositState check (depositState in ('A', 'I', 'C'))
);

create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * movementCash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create view investments as select * from (
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, quantity, idAccountCurrencyDef from investmentMovement where movementType = 'B'
 union all
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, (-1) * quantity, idAccountCurrencyDef from investmentMovement where movementType = 'S') as v;

create view filters as
  select m.idMovementFilter, a.idAccount, c.idCashpoint, p.idProduct from (((movementFilter m
    left outer join accountFilter a on a.idMovementFilter = m.idMovementFilter)
    left outer join cashpointFilter c on c.idMovementFilter = m.idMovementFilter)
    left outer join productFilter p on p.idMovementFilter = m.idMovementFilter);

create view StnInstrumentValue as
  select v.*, i.idCurrencyDef, i.instrumentType from instrumentValue v
  left join instrument i on i.idInstrument = v.idInstrument;

create view StnInvestmentPortfolio as
  select v.idInstrument, i.idCurrencyDef, i.name as instrumentName, i.instrumentType, v.idAccount,
         a.name as accountName, idInvestmentItem, v.created, v.modified, v.quantity,
         (select top 1 valueOf from instrumentValue where idInstrument = v.idInstrument order by regDateTime desc) as valueOf
    from ((investmentItem v
      left outer join instrument i on i.idInstrument = v.idInstrument)
      left outer join account a on a.idAccount = v.idAccount);
	  
create view StnDepositMovement as
  select v.*, d.idCurrencyDef from depositMovement v
  left join depositInvestment d on d.idDepositInvestment = v.idDepositInvestment;
  
create view StnBaseMovement as
  select v.*, i.name as accountName, q.name as sourceAccountName from ((baseMovement v
  left outer join account i on i.idAccount = v.idAccount)
  left outer join account q on q.idAccount = v.idSourceAccount);

create view StnMovementList as
  select v.*, i.name as accountName from movementList v
  left outer join account i on i.idAccount = v.idAccount;
  
create index ix_baseMovement_regDate on baseMovement (regDate);
create index ix_movementList_regDate on movementList (regDate);
create index ix_baseMovement_movementType on baseMovement (movementType);
create index ix_plannedDone_triggerDate on plannedDone (triggerDate);
create index ix_cmanagerParams_name on cmanagerParams (paramName);
create index ix_baseMovement_idAccount on baseMovement (idAccount);
create index ix_baseMovement_idSourceAccount on baseMovement (idSourceAccount);
create index ix_baseMovement_idProduct on baseMovement (idProduct);
create index ix_baseMovement_idCashpoint on baseMovement (idCashPoint);
create index ix_baseMovement_idMovementList on baseMovement (idMovementList);
create index ix_instrumentValue_regDatetimeinstrument on instrumentValue (idInstrument, regDateTime);
create index ix_currencyRate_regDatecurrency on currencyRate (idSourceCurrencyDef, idTargetCurrencyDef, bindingDate);
create index ix_investmentMovement_regDatetime on investmentMovement (regDateTime);
create index ix_currencyRate_regDate on currencyRate (bindingDate);
create index ix_instrumentValue_regDatetime on instrumentValue (regDateTime);
create index ix_investmentItemInstrument on investmentItem (idInstrument, idAccount);6J  ,   ��
 S Q L D E F S       0        <?xml version="1.0" encoding="Windows-1250"?>
<defaultdatafile>
  <treeElement description="Kontrahenci" isGroup="1">
    <treeElement description="Tw�j bank" sql="insert into cashPoint (idCashPoint, created, modified, name, description, cashpointType) values ('{F9111277-744E-4E4C-9D97-C8A0E4F3CF82}', #2007-03-14 12:44:48#, #2007-03-14 12:44:48#, 'Tw�j bank', 'Bank, w kt�rym prowadzisz rachunek oszcz�dno�ciowo-rozliczeniowy', 'X');"/>
    <treeElement description="Sklep osiedlowy" sql="insert into cashPoint (idCashPoint, created, modified, name, description, cashpointType) values ('{72976F14-B380-4F40-B9F2-E6A328453DC4}', #2007-03-14 12:45:07#, #2007-03-14 12:45:07#, 'Sklep osiedlowy', 'Sklep na twoim osiedlu', 'O');"/>
    <treeElement description="Tw�j pracodawca" sql="insert into cashPoint (idCashPoint, created, modified, name, description, cashpointType) values ('{4C293552-2331-4336-A73E-A9F36F5CBCED}', #2007-03-14 12:45:26#, #2007-03-14 12:45:26#, 'Tw�j pracodawca', 'Firma, w kt�rej pracujesz', 'I');"/>
    <treeElement description="Poczta Polska" sql="insert into cashPoint (idCashPoint, created, modified, name, description, cashpointType) values ('{2F7760FA-4F2C-4BAC-9943-A573CD720FE1}', #2007-03-14 12:45:41#, #2007-03-14 12:45:41#, 'Poczta Polska', 'Poczta Polska', 'O');"/>
  </treeElement>
  <treeElement description="Konta" isGroup="1">
    <treeElement description="Tw�j portfel" sql="insert into account (idAccount, created, modified, name, description, accountType, cash, initialBalance, accountNumber, idCashPoint, idCurrencyDef, accountState) values ('{3FA611D2-F6D6-4DAA-9EE8-CE8193FEB1B5}', #2007-03-14 12:46:39#, #2007-03-14 12:46:39#, 'Tw�j portfel', 'Tw�j portfel', 'C', 0, 0, '', null, '{00000000-0000-0000-0000-000000000001}', 'A');"/>
    <treeElement description="Twoje konto bankowe" sql="insert into account (idAccount, created, modified, name, description, accountType, cash, initialBalance, accountNumber, idCashPoint, idCurrencyDef, accountState) values ('{360EE776-DCA7-436E-A084-72A7BCEF6440}', #2007-03-14 12:47:14#, #2007-03-14 12:59:17#, 'Twoje konto bankowe', 'Twoje konto bankowe', 'B', 0, 0, '', '{F9111277-744E-4E4C-9D97-C8A0E4F3CF82}', '{00000000-0000-0000-0000-000000000001}', 'A');"/>
  </treeElement>
  <treeElement description="Kategorie przychod�w i rozchod�w" isGroup="1">
    <treeElement description="Twoje przychody" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', #2007-03-14 13:17:50#, #2007-03-14 13:17:50#, 'Twoje przychody', 'Twoje przychody', null, 'I');">
      <treeElement description="Pensja" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{2A5D1B16-4C4A-478C-837B-792F26D436BF}', #2007-03-14 13:17:57#, #2007-03-14 13:17:57#, 'Pensja', 'Pensja', '{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', 'I');"/>
      <treeElement description="Zwrot z Urz�du Skarbowego" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{D4C24555-61EB-4CCA-9067-E4F0430F76FC}', #2007-03-14 13:18:12#, #2007-03-14 13:18:12#, 'Zwrot z Urz�du Skarbowego', 'Zwrot z Urz�du Skarbowego', '{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', 'I');"/>
      <treeElement description="Zlecenia" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{A13042E5-73D8-44CD-BD37-6B0C8662FBDE}', #2007-03-14 13:18:19#, #2007-03-14 13:18:19#, 'Zlecenia', 'Zlecenia', '{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', 'I');"/>
      <treeElement description="Darowizny" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{ED813939-098B-4A63-9664-C987BFBF3CB5}', #2007-03-14 13:18:28#, #2007-03-14 13:18:28#, 'Darowizny', 'Darowizny', '{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', 'I');"/>
    </treeElement>
    <treeElement description="Wydatki na utrzymanie" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{90B679B3-E526-450C-B988-5299EBA608FC}', #2007-03-14 12:58:16#, #2007-03-14 12:58:16#, 'Wydatki na utrzymanie', 'Wydatki na utrzymanie', null, 'O');">
      <treeElement description="�ywno��" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{92800455-2221-4FFE-BBB9-30AB5638B3FB}', #2007-03-14 13:05:12#, #2007-03-14 13:05:28#, '�ywno��', '�ywno��', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');"/>
      <treeElement description="�rodki czysto�ci" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{BA1361BD-BEF0-429A-AC3F-3F802F9CC08D}', #2007-03-14 13:05:19#, #2007-03-14 13:05:24#, '�rodki czysto�ci', '�rodki czysto�ci', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');"/>
      <treeElement description="Higiena osobista" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{8C44A1F0-C2C5-41F7-AF5A-8AEA272EACB6}', #2007-03-14 13:05:41#, #2007-03-14 13:05:41#, 'Higiena osobista', 'Higiena osobista', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');"/>
      <treeElement description="Ubrania" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{2DDA6C5A-E1EA-4574-BFB0-8D1C44753F80}', #2007-03-14 13:06:11#, #2007-03-14 13:06:11#, 'Ubrania', 'Ubrania', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');"/>
      <treeElement description="Jednorazowe bilety komunikacyjne" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{B16941A1-5D87-402F-816D-C86A27F3C92E}', #2007-03-14 13:14:23#, #2007-03-14 13:14:23#, 'Jednorazowe bilety komunikacyjne', 'Jednorazowe bilety komunikacyjne', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');"/>
      <treeElement description="S�odycze" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{A7A315DB-9C49-4815-AD32-7048C88DD913}', #2007-03-14 13:18:57#, #2007-03-14 13:18:57#, 'S�odycze', 'S�odycze', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');"/>
    </treeElement>
    <treeElement description="Op�aty miesi�czne" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0CD020B5-C548-41A5-9286-05F1FE802D5C}', #2007-03-14 13:10:16#, #2007-03-14 13:10:16#, 'Op�aty miesi�czne', 'Op�aty miesi�czne', null, 'O');">
      <treeElement description="Czynsz za mieszkanie" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{B29478DC-CAE2-40BE-8A95-15C94EC57557}', #2007-03-14 13:10:25#, #2007-03-14 13:10:25#, 'Czynsz za mieszkanie', 'Czynsz za mieszkanie', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');"/>
      <treeElement description="Telefon stacjonarny" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0A847942-18B8-47C5-A215-08DD01643984}', #2007-03-14 13:10:44#, #2007-03-14 13:10:44#, 'Telefon stacjonarny', 'Telefon stacjonarny', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');"/>
      <treeElement description="Telefony kom�rkowe" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{39FCFDA8-4C0C-4929-85FB-02D081D2AEA8}', #2007-03-14 13:10:54#, #2007-03-14 13:10:54#, 'Telefony kom�rkowe', 'Telefony kom�rkowe', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');"/>
      <treeElement description="Internet" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{5C1BDF52-F44F-4FFF-A5C1-B98B21455530}', #2007-03-14 13:11:04#, #2007-03-14 13:11:04#, 'Internet', 'Internet', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');"/>
      <treeElement description="Abonament radiowo-telewizyjny" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{E4583674-A827-4D7F-A831-FEAB25795875}', #2007-03-14 13:11:22#, #2007-03-14 13:11:22#, 'Abonament radiowo-telewizyjny', 'Abonament radiowo-telewizyjny', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');"/>
      <treeElement description="Telewizja kablowa" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{2EF81612-BDBF-4375-95A2-865AAD13A956}', #2007-03-14 13:11:34#, #2007-03-14 13:11:34#, 'Telewizja kablowa', 'Telewizja kablowa', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');"/>
      <treeElement description="Bilety miesi�czne" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{DD383739-B641-4070-88A3-50EC7DAD879A}', #2007-03-14 13:14:33#, #2007-03-14 13:14:33#, 'Bilety miesi�czne', 'Bilety miesi�czne', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');"/>
    </treeElement>
    <treeElement description="Rozrywka" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', #2007-03-14 13:12:12#, #2007-03-14 13:12:12#, 'Rozrywka', 'Rozrywka', null, 'O');">
      <treeElement description="Bilety do kina i teatru" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{9FF1CE8B-9C45-4C6C-9920-D1A559DCA83C}', #2007-03-14 13:12:21#, #2007-03-14 13:12:58#, 'Bilety do kina i teatru', 'Kino i teatr', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');"/>
      <treeElement description="Zakupy ksi��ek" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{C8E81F65-E5A2-4860-BE92-2F82078118DB}', #2007-03-14 13:12:28#, #2007-03-14 13:13:32#, 'Zakupy ksi��ek', 'Ksi��ki', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');"/>
      <treeElement description="Wypo�yczalnia kaset i p�yt DVD" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{B1C31053-DD57-496B-AD82-1A9560561837}', #2007-03-14 13:12:46#, #2007-03-14 13:12:46#, 'Wypo�yczalnia kaset i p�yt DVD', 'Wypo�yczalnia kaset i p�yt DVD', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');"/>
      <treeElement description="Zakupy CD, DVD" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{9F823582-8CC6-404B-A6E6-D60C71024CB1}', #2007-03-14 13:13:45#, #2007-03-14 13:13:45#, 'Zakupy CD, DVD', 'Zakupy CD, DVD', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');"/>
      <treeElement description="Gazety i czasopisma" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{E4AB55D5-FBAA-455D-86B3-4581D5B6CF28}', #2007-03-14 13:13:56#, #2007-03-14 13:13:56#, 'Gazety i czasopisma', 'Gazety i czasopisma', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');"/>
      <treeElement description="Restauracje i puby" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{4A1A9F11-0D75-403A-A89C-C2D5AA8F5864}', #2007-03-14 13:14:46#, #2007-03-14 13:14:46#, 'Restauracje i puby', 'Restauracje i puby', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');"/>
    </treeElement>
    <treeElement description="U�ywki" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0B65EFE2-6861-4B4E-917D-A346DC103155}', #2007-03-14 13:14:59#, #2007-03-14 13:14:59#, 'U�ywki', 'U�ywki', null, 'O');">
      <treeElement description="Papierosy" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{573CAE5E-AE4C-4A2C-8B32-3DA883DFAD28}', #2007-03-14 13:15:06#, #2007-03-14 13:15:06#, 'Papierosy', 'Papierosy', '{0B65EFE2-6861-4B4E-917D-A346DC103155}', 'O');"/>
      <treeElement description="Alkohol" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{48CF0575-8DB5-493F-9261-134C54AE625B}', #2007-03-14 13:15:21#, #2007-03-14 13:15:21#, 'Alkohol', 'Piwo, wino, w�dka i inne', '{0B65EFE2-6861-4B4E-917D-A346DC103155}', 'O');"/>
    </treeElement>
    <treeElement description="Samoch�d" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', #2007-03-14 13:16:34#, #2007-03-14 13:16:34#, 'Samoch�d', 'Samoch�d', null, 'O');">
      <treeElement description="Ubezpieczenia" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{80FB0182-F934-4A4C-B155-2BE933AD0FEA}', #2007-03-14 13:16:41#, #2007-03-14 13:16:41#, 'Ubezpieczenia', 'Ubezpieczenia', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');"/>
      <treeElement description="Paliwo" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{D6EE18AF-9283-48CC-B735-DE2FFCF807D0}', #2007-03-14 13:16:48#, #2007-03-14 13:16:48#, 'Paliwo', 'Paliwo', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');"/>
      <treeElement description="Naprawy" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{59123690-CDB3-46AB-81BB-DF032DDD7FDF}', #2007-03-14 13:17:00#, #2007-03-14 13:17:00#, 'Naprawy', 'Naprawy', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');"/>
      <treeElement description="Eksploatacja" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{FAC481D1-68B5-4A72-835A-36FD5D060D3F}', #2007-03-14 13:17:11#, #2007-03-14 13:17:11#, 'Eksploatacja', 'Eksploatacja', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');"/>
      <treeElement description="Mandaty" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{47F62656-87E9-4807-9D11-736546CD44D5}', #2007-03-14 13:20:11#, #2007-03-14 13:20:11#, 'Mandaty', 'Mandaty', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');"/>
      <treeElement description="Wymiana cz�sci" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{A8C61F19-F67E-47D6-907A-544B2E79FDA0}', #2007-03-14 13:20:26#, #2007-03-14 13:20:26#, 'Wymiana cz�sci', 'Wymiana cz�sci', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');"/>
    </treeElement>
    <treeElement description="Prowizje" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{6784F593-412B-40C8-9EC3-81E1DFF3A033}', #2007-03-14 13:19:20#, #2007-03-14 13:19:20#, 'Prowizje', 'Prowizje', null, 'O');">
      <treeElement description="Op�aty pocztowe" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0088B20B-B725-42EB-969E-30D69674E1C2}', #2007-03-14 13:19:39#, #2007-03-14 13:19:39#, 'Op�aty pocztowe', 'Op�aty pocztowe', '{6784F593-412B-40C8-9EC3-81E1DFF3A033}', 'O');"/>
      <treeElement description="Prowizje za wyp�aty w bankomacie" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{558D6510-CADC-4AC3-938E-0EB6BEE25723}', #2007-03-14 13:19:59#, #2007-03-14 13:19:59#, 'Prowizje za wyp�aty w bankomacie', 'Prowizje za wyp�aty w bankomacie', '{6784F593-412B-40C8-9EC3-81E1DFF3A033}', 'O');"/>
    </treeElement>
    <treeElement description="Zdrowie" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', #2007-03-14 13:20:48#, #2007-03-14 13:20:48#, 'Zdrowie', 'Zdrowie', null, 'O');">
      <treeElement description="Lekarze" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0AB7EC5F-1B0E-4BEA-98AC-F5F92E5CE6EF}', #2007-03-14 13:20:58#, #2007-03-14 13:20:58#, 'Lekarze', 'Lekarze', '{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', 'O');"/>
      <treeElement description="Badania" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{5780B536-FC0C-4113-8C33-A119D1242B7D}', #2007-03-14 13:21:24#, #2007-03-14 13:21:24#, 'Badania', 'Badania', '{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', 'O');"/>
      <treeElement description="Leki" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0C17A747-2CDA-4C29-92A3-0D2F262511B2}', #2007-03-14 13:22:04#, #2007-03-14 13:22:04#, 'Leki', 'Leki', '{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', 'O');"/>
      <treeElement description="Rehabilitacja" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{144D22B5-9C46-4FF8-A16C-FAE0CD701DB1}', #2007-03-14 13:22:54#, #2007-03-14 13:22:54#, 'Rehabilitacja', 'Rehabilitacja', '{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', 'O');"/>
    </treeElement>
    <treeElement description="Uroda" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', #2007-03-14 13:23:20#, #2007-03-14 13:23:20#, 'Uroda', 'Uroda', null, 'O');">
      <treeElement description="Kosmetyki" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{7D707B84-E5BA-46CF-8F6E-862B0B121A6F}', #2007-03-14 13:23:26#, #2007-03-14 13:23:26#, 'Kosmetyki', 'Kosmetyki', '{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', 'O');"/>
      <treeElement description="Si�ownia" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0388F87A-3277-43A1-9D8D-40945C90FCCE}', #2007-03-14 13:23:44#, #2007-03-14 13:23:44#, 'Si�ownia', 'Si�ownia', '{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', 'O');"/>
      <treeElement description="Sprz�t sportowy" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{4EB90981-D232-4AAB-B88B-E3088A2A3677}', #2007-03-14 13:23:56#, #2007-03-14 13:23:56#, 'Sprz�t sportowy', 'Sprz�t sportowy', '{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', 'O');"/>
      <treeElement description="Aerobic i fitness" sql="insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{C28FBA7D-33FE-4658-97C4-106B0319B5B0}', #2007-03-14 13:24:57#, #2007-03-14 13:24:57#, 'Aerobic i fitness', 'Aerobic i fitness', '{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', 'O');"/>
    </treeElement>
  </treeElement>
</defaultdatafile>
  �  ,   ��
 C U R D E F S       0        <?xml version="1.0" encoding="Windows-1250"?>
<defaultdatafile>
  <treeElement id="{00000000-0000-0000-0000-000000000001}" description="z�oty polski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000001}', #2007-04-18 10:33:02#, #2007-04-18 10:33:02#, 'z�oty polski', 'z�', 'PLN', 'z�oty polski');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000002}" description="dolar ameryka�ski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000002}', #2008-06-04 10:40:04#, #2008-06-04 10:40:41#, 'dolar ameryka�ski', '$', 'USD', 'dolar ameryka�ski');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000003}" description="dolar australijski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000003}', #2008-06-04 10:40:04#, #2008-06-04 10:40:04#, 'dolar australijski', 'aud', 'AUD', 'dolar australijski');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000004}" description="dolar kanadyjski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000004}', #2008-06-04 10:40:04#, #2008-06-04 10:40:04#, 'dolar kanadyjski', 'cad', 'CAD', 'dolar kanadyjski');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000005}" description="dolar nowozelandzki" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000005}', #2008-06-04 10:40:04#, #2008-06-04 10:40:04#, 'dolar nowozelandzki', 'nzd', 'NZD', 'dolar nowozelandzki');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000006}" description="euro" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000006}', #2008-06-04 10:40:04#, #2008-06-04 10:42:12#, 'euro', '�', 'EUR', 'euro');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000007}" description="forint (W�gry)" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000007}', #2008-06-04 10:40:04#, #2008-06-04 10:40:04#, 'forint (W�gry)', 'huf', 'HUF', 'forint (W�gry)');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000008}" description="frank szwajcarski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000008}', #2008-06-04 10:40:04#, #2008-06-04 10:40:04#, 'frank szwajcarski', 'chf', 'CHF', 'frank szwajcarski');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000009}" description="funt szterling" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000009}', #2008-06-04 10:40:04#, #2008-06-04 10:43:40#, 'funt szterling', '�', 'GBP', 'funt szterling');"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000A}" description="hrywna (Ukraina)" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-00000000000A}', #2008-06-04 10:40:04#, #2008-06-04 10:40:04#, 'hrywna (Ukraina)', 'uah', 'UAH', 'hrywna (Ukraina)');"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000B}" description="korona czeska" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-00000000000B}', #2008-06-04 10:40:04#, #2008-06-04 10:40:04#, 'korona czeska', 'czk', 'CZK', 'korona czeska');"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000C}" description="korona du�ska" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-00000000000C}', #2008-06-04 10:40:04#, #2008-06-04 10:40:04#, 'korona du�ska', 'dkk', 'DKK', 'korona du�ska');"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000D}" description="korona esto�ska" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-00000000000D}', #2008-06-04 10:40:04#, #2008-06-04 10:40:04#, 'korona esto�ska', 'eek', 'EEK', 'korona esto�ska');"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000E}" description="korona islandzka" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-00000000000E}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'korona islandzka', 'isk', 'ISK', 'korona islandzka');"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000F}" description="korona norweska" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-00000000000F}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'korona norweska', 'nok', 'NOK', 'korona norweska');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000010}" description="korona s�owacka" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000010}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'korona s�owacka', 'skk', 'SKK', 'korona s�owacka');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000011}" description="korona szwedzka" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000011}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'korona szwedzka', 'sek', 'SEK', 'korona szwedzka');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000012}" description="kuna chorwacka" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000012}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'kuna chorwacka', 'hrk', 'HRK', 'kuna chorwacka');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000013}" description="lej rumu�ski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000013}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'lej rumu�ski', 'ron', 'RON', 'lej rumu�ski');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000014}" description="lew bu�garski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000014}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'lew bu�garski', 'bgn', 'BGN', 'lew bu�garski');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000015}" description="lira turecka" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000015}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'lira turecka', 'try', 'TRY', 'lira turecka');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000016}" description="lit litewski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000016}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'lit litewski', 'ltl', 'LTL', 'lit litewski');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000017}" description="�at �otewski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000017}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, '�at �otewski', 'lvl', 'LVL', '�at �otewski');"/>
  <treeElement id="{00000000-0000-0000-0000-000000000018}" description="rubel rosyjski" sql="insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description) values ('{00000000-0000-0000-0000-000000000018}', #2008-06-04 10:40:05#, #2008-06-04 10:40:05#, 'rubel rosyjski', 'rub', 'RUB', 'rubel rosyjski');"/>
</defaultdatafile>
     0   ��
 T A B L E D E F S       0        <?xml version="1.0" encoding="Windows-1250"?>
<defaultdatafile>
  <treeElement id="{00000000-0000-0000-0000-000000000001}" description="cashPoint" name="cashPoint"/>
  <treeElement id="{00000000-0000-0000-0000-000000000002}" description="account" name="account"/>
  <treeElement id="{00000000-0000-0000-0000-000000000003}" description="unitDef" name="unitDef"/>
  <treeElement id="{00000000-0000-0000-0000-000000000004}" description="accountExtraction" name="accountExtraction"/>
  <treeElement id="{00000000-0000-0000-0000-000000000005}" description="extractionItem" name="extractionItem"/>
  <treeElement id="{00000000-0000-0000-0000-000000000006}" description="product" name="product" exportOrder="created"/>
  <treeElement id="{00000000-0000-0000-0000-000000000007}" description="plannedMovement" name="plannedMovement"/>
  <treeElement id="{00000000-0000-0000-0000-000000000008}" description="plannedDone" name="plannedDone"/>
  <treeElement id="{00000000-0000-0000-0000-000000000009}" description="movementList" name="movementList"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000A}" description="baseMovement" name="baseMovement"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000B}" description="movementFilter" name="movementFilter"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000C}" description="accountFilter" name="accountFilter"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000D}" description="cashpointFilter" name="cashpointFilter"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000E}" description="productFilter" name="productFilter"/>
  <treeElement id="{00000000-0000-0000-0000-00000000000F}" description="profile" name="profile"/>
  <treeElement id="{00000000-0000-0000-0000-000000000010}" description="cmanagerInfo" name="cmanagerInfo" exportDeletes="1"/>
  <treeElement id="{00000000-0000-0000-0000-000000000011}" description="cmanagerParams" name="cmanagerParams" exportDeletes="1"/>
  <treeElement id="{00000000-0000-0000-0000-000000000012}" description="movementLimit" name="movementLimit"/>
  <treeElement id="{00000000-0000-0000-0000-000000000013}" description="currencyDef" name="currencyDef"/>
  <treeElement id="{00000000-0000-0000-0000-000000000014}" description="currencyRate" name="currencyRate"/>
  <treeElement id="{00000000-0000-0000-0000-000000000015}" description="accountCurrencyRule" name="accountCurrencyRule"/>
  <treeElement id="{00000000-0000-0000-0000-000000000016}" description="reportDef" name="reportDef" exportCondition="idReportDef not in ('{00000000-0000-0000-0000-000000000001}'', ''{00000000-0000-0000-0000-000000000002}')"/>
  <treeElement id="{00000000-0000-0000-0000-000000000017}" description="instrument" name="instrument"/>
  <treeElement id="{00000000-0000-0000-0000-000000000018}" description="instrumentValue" name="instrumentValue"/>
  <treeElement id="{00000000-0000-0000-0000-000000000018}" description="investmentItem" name="investmentItem"/>
  <treeElement id="{00000000-0000-0000-0000-000000000018}" description="investmentMovement" name="investmentMovement"/>
  <treeElement id="{00000000-0000-0000-0000-000000000018}" description="quickPattern" name="quickPattern"/>
  <treeElement id="{00000000-0000-0000-0000-000000000018}" description="depositInvestment" name="depositInvestment"/>
</defaultdatafile>�
  4   ��
 S Q L U P D _ 0 _ 1         0        create table movementList (
  idmovementList uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  idAccount uniqueidentifier not null,
  idCashPoint uniqueidentifier not null,
  regDate datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  movementType varchar(1) not null,  
  cash money not null,
  primary key (idmovementList),
  constraint ck_movementTypemovementList check (movementType in ('I', 'O')),  
  constraint fk_cashpointmovementList foreign key (idCashpoint) references cashpoint (idCashpoint),  
  constraint fk_accountmovementList foreign key (idAccount) references account (idAccount)
);

create table cmanagerParams (
  paramName varchar(40),
  paramValue text
);

insert into cmanagerParams (paramName, paramValue) values ('BaseMovementOut', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementIn', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementTr', 'Transfer z @kontozrodlowe@ do @kontodocelowe@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementPlannedOut', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementPlannedIn', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('MovementListOut', '@kontrahent@');
insert into cmanagerParams (paramName, paramValue) values ('MovementListIn', '@kontrahent@');
insert into cmanagerParams (paramName, paramValue) values ('PlannedMovementOut', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('PlannedMovementIn', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('MovementListElement', '@kategoria@');

alter table baseMovement add idmovementList uniqueidentifier null;
alter table baseMovement add constraint fk_movementList foreign key (idMovementList) references movementList (idMovementList);

alter table cashpoint add cashpointType varchar(1) not null;
update cashpoint set cashpointType = 'W';
alter table cashpoint add constraint ck_cashpointType check (cashpointType in ('I', 'O', 'W', 'X'));


create index ix_baseMovement_movementType on baseMovement (movementType);
create index ix_cmanagerParams_name on cmanagerParams (paramName);
create index ix_movementList_regDate on movementList (regDate);

create index ix_baseMovement_idAccount on baseMovement (idAccount);
create index ix_baseMovement_idSourceAccount on baseMovement (idSourceAccount);
create index ix_baseMovement_idProduct on baseMovement (idProduct);
create index ix_baseMovement_idCashpoint on baseMovement (idCashPoint);
create index ix_baseMovement_idMovementList on baseMovement (idMovementList); ^  4   ��
 S Q L U P D _ 1 _ 2         0        create table movementLimit (
  idmovementLimit uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40),
  description varchar(200),
  idmovementFilter uniqueidentifier,
  isActive bit not null,
  boundaryAmount money not null,
  boundaryType varchar(1) not null,
  boundarycondition varchar(2) not null,
  boundaryDays int,  
  sumType varchar(1) not null,
  primary key (idMovementLimit),
  constraint ck_boundaryTypelimit check (boundaryType in ('T', 'W', 'M', 'Q', 'H', 'Y', 'D')),  
  constraint ck_boundaryConditionlimit check (boundarycondition in ('=', '<', '>', '<=', '>=')),  
  constraint ck_sumTypelimit check (sumType in ('I', 'O', 'B')),  
  constraint fk_filterlimit foreign key (idmovementFilter) references movementFilter (idmovementFilter)
);

create view filters as
  select m.idMovementFilter, a.idAccount, c.idCashpoint, p.idProduct from (((movementFilter m
    left outer join accountFilter a on a.idMovementFilter = m.idMovementFilter)
    left join cashpointFilter c on c.idMovementFilter = m.idMovementFilter)
    left join productFilter p on p.idMovementFilter = m.idMovementFilter);

alter table plannedMovement add freeDays varchar(1) not null;
update plannedMovement set freeDays = 'E';
alter table plannedMovement add constraint ck_freeDays check (freeDays in ('E', 'D', 'I'));  k  4   ��
 S Q L U P D _ 2 _ 3         0        create table currencyDef (
  idcurrencyDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  iso varchar(40),
  description varchar(200),
  isBase bit not null,
  primary key (idcurrencyDef)
);

create table currencyRate (
  idcurrencyRate uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idSourceCurrencyDef uniqueidentifier not null,
  idTargetCurrencyDef uniqueidentifier not null,
  idCashpoint uniqueidentifier not null,
  quantity int not null,
  rate money not null,
  bindingDate datetime not null,
  description varchar(200),
  primary key (idcurrencyRate),
  constraint fk_rateSourceCurrencyDef foreign key (idSourceCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateTargetCurrencyDef foreign key (idTargetCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
);

insert into cmanagerParams (paramName, paramValue) values ('Currencyrate', '@isobazowej@/@isodocelowej@');
insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description, isBase) values ('{00000000-0000-0000-0000-000000000001}', #2007-04-18 10:33:02#, #2007-04-18 10:33:02#, 'z�oty polski', 'z�', 'PLN', 'z�oty polski', 1);
   4   ��
 S Q L U P D _ 3 _ 4         0        alter table currencyRate add rateType varchar(1) not null;
update currencyRate set rateType = 'A';
alter table currencyRate add constraint ck_rateType check (rateType in ('B', 'S', 'A'));

alter table account drop constraint ck_accountType;
alter table account add constraint ck_accountType check (accountType in ('C', 'B', 'I'));
alter table account add idCurrencyDef uniqueidentifier not null;
update account set idCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table account add constraint fk_accountCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef);

alter table baseMovement add idAccountCurrencyDef uniqueidentifier not null;
alter table baseMovement add idMovementCurrencyDef uniqueidentifier not null;
alter table baseMovement add idCurrencyRate uniqueidentifier;
alter table baseMovement add currencyQuantity int;
alter table baseMovement add currencyRate money null;
alter table baseMovement add rateDescription varchar(200);
alter table baseMovement add movementCash money not null;
update baseMovement set idAccountCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
update baseMovement set idMovementCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
update baseMovement set currencyQuantity = 1;
update baseMovement set currencyRate = 1;
update baseMovement set rateDescription = '';
update baseMovement set movementCash = cash;
alter table baseMovement add constraint fk_movementAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef);
alter table baseMovement add constraint fk_movementMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef);
alter table baseMovement add constraint fk_movementCurrencyRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate);

alter table plannedMovement add idMovementCurrencyDef uniqueidentifier not null;
update plannedMovement set idMovementCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table plannedMovement add constraint fk_planndedMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef);

alter table plannedDone add idDoneCurrencyDef uniqueidentifier not null;
update plannedDone set idDoneCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table plannedDone add constraint fk_plannedDoneCurrencyDef foreign key (idDoneCurrencyDef) references currencyDef (idCurrencyDef);

alter table movementList add idAccountCurrencyDef uniqueidentifier not null;
update movementList set idAccountCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table movementList add constraint fk_movementListAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef);
alter table movementLimit add idCurrencyDef uniqueidentifier not null;
update movementLimit set idCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table movementLimit add constraint fk_limitCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef);

create table accountCurrencyRule (
  idaccountCurrencyRule uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  movementType varchar(1) not null,
  rateType varchar(1) not null,
  idAccount uniqueidentifier not null,
  idCashPoint uniqueidentifier,
  primary key (idaccountCurrencyRule),
  constraint ck_accountCurrencymovementType check (movementType in ('I', 'O', 'T')),
  constraint ck_accountCurrencyrateType check (rateType in ('B', 'S', 'A')),
  constraint fk_accountCurrencyaccount foreign key (idAccount) references account (idAccount) on delete cascade,
  constraint fk_accountCurrencycashPoint foreign key (idCashPoint) references cashPoint (idCashPoint) on delete cascade
);

drop  view transactions;
create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * movementCash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'T') as v;

drop view balances;
create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'T') as v;   3   4   ��
 S Q L U P D _ 4 _ 5         0        alter table movementFilter add isTemp bit not null; Y	  4   ��
 S Q L U P D _ 5 _ 6         0        create table accountExtraction (
  idAccountExtraction uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idAccount uniqueidentifier not null,
  state varchar(1) not null,
  startDate datetime not null,
  endDate datetime not null,
  regDate datetime not null,
  description varchar(200),
  primary key (idAccountExtraction),
  constraint ck_accountExtractionState check (state in ('O', 'C', 'S')),
  constraint fk_accountExtractionaccount foreign key (idAccount) references account (idAccount)
);

create table extractionItem (
  idExtractionItem uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  regDate datetime not null,
  accountingDate datetime not null,  
  movementType varchar(1) not null,
  idCurrencyDef uniqueidentifier not null,
  idAccountExtraction uniqueidentifier not null,
  cash money not null,
  primary key (idExtractionItem),
  constraint ck_extractionItemmovementType check (movementType in ('I', 'O')),
  constraint fk_extractionItemaccountExtraction foreign key (idAccountExtraction) references accountExtraction (idAccountExtraction) on delete cascade,
  constraint fk_extractionItemCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef)
);

alter table baseMovement add idExtractionItem uniqueidentifier null;
alter table baseMovement add constraint fk_movementExtractionItem foreign key (idExtractionItem) references extractionItem (idExtractionItem);
alter table baseMovement add isStated bit not null;

alter table baseMovement add idSourceExtractionItem uniqueidentifier null;
alter table baseMovement add constraint fk_movementSourceExtractionItem foreign key (idSourceExtractionItem) references extractionItem (idExtractionItem);
alter table baseMovement add isSourceStated bit not null;

update baseMovement set isStated = 1;
update baseMovement set isSourceStated = 1;

alter table movementList add idExtractionItem uniqueidentifier null;
alter table movementList add constraint fk_movementListExtractionItem foreign key (idExtractionItem) references extractionItem (idExtractionItem);
alter table movementList add isStated bit not null;
update movementList set isStated = 1;

insert into cmanagerParams (paramName, paramValue) values ('AccountExctraction', '@konto@ - wyci�g z dnia @datawyciagu@');
     4   ��
 S Q L U P D _ 6 _ 7         0        create table unitDef (
  idUnitDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  description varchar(200),
  primary key (idUnitDef)
);

alter table product add column idUnitDef uniqueidentifier;
alter table product add constraint fk_productunitDef foreign key (idUnitDef) references unitDef (idUnitDef);
alter table baseMovement add column quantity money not null;
alter table plannedMovement add column quantity money not null;
update baseMovement set quantity = 1;
update plannedMovement set quantity = 1;

alter table baseMovement add column idUnitDef uniqueidentifier;
alter table plannedMovement add column idUnitDef uniqueidentifier;
alter table baseMovement add constraint fk_baseMovementunitDef foreign key (idUnitDef) references unitDef (idUnitDef);
alter table plannedMovement add constraint fk_plannedMovementunitDef foreign key (idUnitDef) references unitDef (idUnitDef);

drop view transactions;
drop view balances;

create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * movementCash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create table reportDef (
  idreportDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),  
  queryText memo not null,
  paramsDefs memo,
  xsltText memo,
  xsltType varchar(1) not null,
  primary key (idreportDef),
  constraint ck_xsltType check (xsltType in ('D', 'S', 'P'))
);

insert into reportDef (idreportDef, created, modified, name, description, queryText, paramsDefs, xsltText, xsltType) values ('{00000000-0000-0000-0000-000000000001}', #2007-09-02 12:13:53#, #2007-09-03 21:10:41#, 'Lista kont - raport w�asny', 'Jest to przyk�ad definiowalnego raportu z wykorzystaniem prezentacji wynik�w raportu w postaci dokumentu XML', 'eNorTs1JTS5R0FJIK8rPVUhMTs4vzSsBAFJRB6w=', 'eNqzsa/IzVEoSy0qzszPs1Uy1DNQUkjNS85PycxLt1UKz8xLyS8v1jU0MjVQsrfj5bIpSCxKzC12SU0r1gdyAXd2EyU=', '', 'S');
insert into reportDef (idreportDef, created, modified, name, description, queryText, paramsDefs, xsltText, xsltType) values ('{00000000-0000-0000-0000-000000000002}', #2007-09-03 20:31:23#, #2007-09-03 21:10:55#, 'Operacje w/g kategorii - raport w�asny', 'Jest to przyk�adowy raport definiowalny korzystaj�cy z domy�lnego arkusza styli, czyli podstawowej transformacji XSLT, znajduj�cej si� w pliku transform.xml w katalogu instalacyjnym CManager-a.', 'eNptkEsOgkAQRPcm3qEWLNAQ4gXcsXHh5woN0yBmmCbzEfQsns9zyMfIxl5VJV31Ou1Yc+HRpoYaBjmc6NlRgrou49qZoHV80PJ6bxLsEsxyXJsUSisNWisqjB3rFaC59JDg2eImtUHsZkAhwfh4u2QHhLp8k1NNTo6PcueGjcdY9X+6K1uG5Sojz8jZd8wGkSJPZxWBjJpNJhEqK6FF/lhQE78f28WgT5cT9sMLfu4D9JxbcQ==', 'eNqlj7sKwkAQRXsh/zBMH/MAu2zSpBdsBLslMwmLZifuJD7+3sU0CnZ298DlHm7VPMYL3DioE2+w2OYI7Dsh5weDR+dJ7poW5S7Hpk421WSDHbXlXus1xwjejmyQ7Gz3hECsncE2EkjEIcgyGTzZc2CFWEKYn9PaZwSnB74uLjAZTAuEPrzHSsx+Clr5EpD8Jcg+7iSbF/yRVtM=', '', 'D');  �  4   ��
 S Q L U P D _ 7 _ 8         0        create table instrument (
  idInstrument uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  symbol varchar(40) not null,
  name varchar(40) not null,
  description varchar(200),
  instrumentType varchar(1) not null,
  idCurrencyDef uniqueidentifier,
  idCashpoint uniqueidentifier,
  primary key (idInstrument),
  constraint ck_instrumentType check (instrumentType in ('I', 'S', 'B', 'F', 'R', 'U')),
  constraint uq_instrumentSymbol unique (symbol),
  constraint uq_instrumentName unique (name),
  constraint fk_instrumentCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_instrumentCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
);

create table instrumentValue (
  idInstrumentValue uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  idInstrument uniqueidentifier not null,
  regDateTime datetime not null,
  valueOf money not null,
  primary key (idInstrumentValue),
  constraint fk_instrumentValueInstrument foreign key (idInstrument) references instrument (idInstrument)
);

create view StnInstrumentValue as
  select v.*, i.idCurrencyDef, i.instrumentType from instrumentValue v
  left join instrument i on i.idInstrument = v.idInstrument;
  
insert into cmanagerParams (paramName, paramValue) values ('InstrumentValue', '@instrument@');
update extractionItem set cash = abs(cash);

create index ix_instrumentValue_regDatetimeinstrument on instrumentValue (idInstrument, regDateTime);
create index ix_currencyRate_regDatecurrency on currencyRate (idSourceCurrencyDef, idTargetCurrencyDef, bindingDate);

alter table accountCurrencyRule add useOldRates bit not null;
update accountCurrencyRule set useOldRates = 0;

create table investmentItem (
  idInvestmentItem uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idAccount uniqueidentifier not null,
  idInstrument uniqueidentifier not null,
  quantity int not null,
  primary key (idInvestmentItem),
  constraint fk_investmentItem_Instrument foreign key (idInstrument) references instrument (idInstrument),
  constraint fk_investmentItem_Account foreign key (idAccount) references account (idAccount)
);

create table investmentMovement (
  idInvestmentMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  movementType varchar(1) not null,
  regDateTime datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  idInstrument uniqueidentifier not null,
  idInstrumentCurrencyDef uniqueidentifier not null,
  quantity integer not null,
  idInstrumentValue uniqueidentifier,
  valueOf money not null,
  summaryOf money not null,
  idAccount uniqueidentifier not null,  
  idAccountCurrencyDef uniqueidentifier not null,
  valueOfAccount money not null,
  summaryOfAccount money not null,
  idProduct uniqueidentifier,
  idCurrencyRate uniqueidentifier,
  currencyQuantity int,
  currencyRate money null,
  rateDescription varchar(200),  
  idBaseMovement uniqueidentifier,  
  primary key (idInvestmentMovement),
  constraint ck_investmentMovementmovementType check (movementType in ('B', 'S')),
  constraint fk_investmentMovementInstrument foreign key (idInstrument) references instrument (idInstrument),
  constraint fk_investmentMovementInstrumentCurrency foreign key (idInstrumentCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_investmentMovementInstrumentValue foreign key (idInstrumentValue) references instrumentValue (idInstrumentValue),
  constraint fk_investmentMovementaccount foreign key (idAccount) references account (idAccount),
  constraint fk_investmentMovementAccountCurrency foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_investmentMovementProduct foreign key (idProduct) references product (idProduct),
  constraint fk_investmentMovementRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate),  
  constraint fk_investmentMovementBaseMovement foreign key (idBaseMovement) references baseMovement (idBaseMovement)
);

create index ix_investmentMovement_regDatetime on investmentMovement (regDateTime);
create index ix_currencyRate_regDate on currencyRate (bindingDate);
create index ix_instrumentValue_regDatetime on instrumentValue (regDateTime);
create index ix_investmentItemInstrument on investmentItem (idInstrument, idAccount);

insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementBuy', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementSell', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementBuyFree', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementSellFree', '@rodzaj@ - @instrument@');

alter table baseMovement add isInvestmentMovement bit not null;
update baseMovement set isInvestmentMovement = 0;

drop view filters;

create view filters as
  select m.idMovementFilter, a.idAccount, c.idCashpoint, p.idProduct from (((movementFilter m
    left outer join accountFilter a on a.idMovementFilter = m.idMovementFilter)
    left outer join cashpointFilter c on c.idMovementFilter = m.idMovementFilter)
    left outer join productFilter p on p.idMovementFilter = m.idMovementFilter);

create view StnInvestmentPortfolio as
  select v.idInstrument, i.idCurrencyDef, i.name as instrumentName, i.instrumentType, v.idAccount,
         a.name as accountName, idInvestmentItem, v.created, v.modified, v.quantity,
         (select top 1 valueOf from instrumentValue where idInstrument = v.idInstrument order by regDateTime desc) as valueOf
    from ((investmentItem v
      left outer join instrument i on i.idInstrument = v.idInstrument)
      left outer join account a on a.idAccount = v.idAccount);

create view investments as select * from (
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, quantity, idAccountCurrencyDef from investmentMovement where movementType = 'B'
 union all
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, (-1) * quantity, idAccountCurrencyDef from investmentMovement where movementType = 'S') as v;

 k	  4   ��
 S Q L U P D _ 8 _ 9         0        create table quickPattern (
  idQuickPattern uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  movementType varchar(1) not null,
  idAccount uniqueidentifier null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  primary key (idQuickPattern),
  constraint ck_movementTypeQuickPattern check (movementType in ('I', 'O', 'T')),
  constraint fk_accountQuickPattern foreign key (idAccount) references account (idAccount),
  constraint fk_sourceAccountQuickPattern foreign key (idSourceAccount) references account (idAccount),
  constraint fk_cashPointQuickPattern foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_productQuickPattern foreign key (idProduct) references product (idProduct)
);

create table movementStatistics (
  movementCount int not null,
  cash money not null,
  movementType varchar(1) not null,
  idAccount uniqueidentifier not null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  idAccountCurrencyDef uniqueidentifier not null,
  idMovementCurrencyDef uniqueidentifier not null,
  movementCash money not null,
  constraint ck_statisticsmovementType check (movementType in ('I', 'O', 'T')),
  constraint fk_statisticsaccount foreign key (idAccount) references account (idAccount),
  constraint fk_statisticssourceAccount foreign key (idSourceAccount) references account (idAccount),
  constraint fk_statisticscashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_statisticsproduct foreign key (idProduct) references product (idProduct),
  constraint fk_statisticsmovementAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_statisticsmovementMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef)
);

insert into movementStatistics
select count(*) as movementCount, sum(cash) as cash, movementType, idAccount, idSourceAccount, idCashPoint, idProduct,
       idAccountCurrencyDef, idMovementCurrencyDef, sum(movementCash) as movementCash
from baseMovement group by movementType, idAccount, idSourceAccount, idCashPoint, idProduct, idAccountCurrencyDef, idMovementCurrencyDef; �  4   ��
 S Q L U P D _ 9 _ 1 0       0        create table depositInvestment (
  idDepositInvestment uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  depositState varchar(1) not null,
  name varchar(40) not null,
  description varchar(200),
  idCashPoint uniqueidentifier not null,
  idCurrencyDef uniqueidentifier not null,
  cash money not null,
  interestRate money not null,
  noncapitalizedInterest money not null,
  periodCount int not null,
  periodType varchar(1) not null,
  periodStartDate datetime not null,
  periodEndDate datetime not null,
  periodAction varchar(1) not null,
  dueCount int not null,
  dueType varchar(1) not null,
  dueStartDate datetime not null,
  dueEndDate datetime not null,
  dueAction varchar(1) not null,
  primary key (idDepositInvestment),
  constraint fk_cashPointdepositInvestment foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_currencyDefdepositInvestment foreign key (idCurrencyDef) references currencyDef (idCurrencyDef),
  constraint ck_depositState check (depositState in ('A', 'I', 'C')),
  constraint ck_depositPeriodType check (periodType in ('D', 'W', 'M', 'Y')),
  constraint ck_duePeriodType check (dueType in ('E', 'D', 'W', 'M', 'Y')),
  constraint ck_depositperiodAction check (dueAction in ('A', 'L')),
  constraint ck_depositdueAction check (dueAction in ('A', 'L'))
);

create table depositMovement (
  idDepositMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  movementType varchar(1) not null,
  regDateTime datetime not null,
  regOrder int not null,
  description varchar(200),
  cash money not null,  
  interest money not null,
  depositState varchar(1) not null,
  idDepositInvestment uniqueidentifier not null,
  idAccount uniqueidentifier null,
  idAccountCurrencyDef uniqueidentifier null,
  accountCash money null,
  idCurrencyRate uniqueidentifier,
  currencyQuantity int,
  currencyRate money null,
  rateDescription varchar(200),
  idProduct uniqueidentifier null,
  idBaseMovement uniqueidentifier null,
  primary key (idDepositMovement),
  constraint ck_movementDepositMovementType check (movementType in ('C', 'S', 'I', 'R', 'D', 'A', 'K', 'G')),
  constraint fk_movementDepositInvestment foreign key (idDepositInvestment) references depositInvestment (idDepositInvestment),
  constraint fk_movementDepositAccount foreign key (idAccount) references account (idAccount),
  constraint fk_movementDepositProduct foreign key (idProduct) references product (idProduct),
  constraint fk_movementDepositAccountCurrency foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_movementDepositRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate),
  constraint fk_movementDepositBaseMovement foreign key (idBaseMovement) references baseMovement (idBaseMovement),
  constraint ck_movementDepositdepositState check (depositState in ('A', 'I', 'C'))
);

insert into cmanagerParams (paramName, paramValue) values ('DepositInvestment', '@operacja@ - @nazwa@');
update baseMovement set isInvestmentMovement = 0 where idBaseMovement not in (select idBaseMovement from investmentMovement where idBaseMovement is not null);
alter table baseMovement add isDepositMovement bit not null;
update baseMovement set isDepositMovement = 0;

create view StnDepositMovement as
  select v.*, d.idCurrencyDef from depositMovement v
  left join depositInvestment d on d.idDepositInvestment = v.idDepositInvestment;
  
 insert into cmanagerParams (paramName, paramValue) values ('PlannedMovementTransfer', 'Planowany transfer z @kontozrodlowe@ do @kontodocelowe@');

alter table plannedMovement drop constraint ck_plannedType;
alter table plannedMovement add constraint ck_plannedType check (movementType in ('I', 'O', 'T'));

alter table plannedMovement add idDestAccount uniqueidentifier;
alter table plannedMovement add constraint fk_plannedMovementDestAccount foreign key (idDestAccount) references account (idAccount);

alter table plannedMovement drop constraint fk_plannedMovementProduct;
alter table plannedMovement add column idProduct_temp uniqueidentifier null;
update plannedMovement set idProduct_temp = idProduct;
alter table plannedMovement drop column idProduct;
alter table plannedMovement add column idProduct uniqueidentifier null;
update plannedMovement set idProduct = idProduct_temp;
alter table plannedMovement drop column idProduct_temp;
alter table plannedMovement add constraint fk_plannedMovementProduct foreign key (idProduct) references product (idProduct);

insert into cmanagerParams (paramName, paramValue) values ('BaseMovementPlannedTr', 'Transfer z @kontozrodlowe@ do @kontodocelowe@');

alter table plannedDone add dueDate datetime not null;
update plannedDone set dueDate = triggerDate;

insert into cmanagerParams (paramName, paramValue) values ('GDefaultCurrencyId', '{00000000-0000-0000-0000-000000000001}');
alter table currencyDef drop column isBase;  /  8   ��
 S Q L U P D _ 1 0 _ 1 1         0        alter table investmentMovement add column quantity_temp int null;
update investmentMovement set quantity_temp = quantity;
alter table investmentMovement drop column quantity;
alter table investmentMovement add column quantity float null;
update investmentMovement set quantity = quantity_temp;
alter table investmentMovement drop column quantity_temp;

alter table investmentItem add column quantity_temp int null;
update investmentItem set quantity_temp = quantity;
alter table investmentItem drop column quantity;
alter table investmentItem add column quantity float null;
update investmentItem set quantity = quantity_temp;
alter table investmentItem drop column quantity_temp;

create view StnBaseMovement as
  select v.*, i.name as accountName, q.name as sourceAccountName from ((baseMovement v
  left outer join account i on i.idAccount = v.idAccount)
  left outer join account q on q.idAccount = v.idSourceAccount);

create view StnMovementList as
  select v.*, i.name as accountName from movementList v
  left outer join account i on i.idAccount = v.idAccount;

alter table plannedMovement add column quantity_temp money null;
update plannedMovement set quantity_temp = quantity;
alter table plannedMovement drop column quantity;
alter table plannedMovement add column quantity float null;
update plannedMovement set quantity = quantity_temp;
alter table plannedMovement drop column quantity_temp;

alter table baseMovement add column quantity_temp money null;
update baseMovement set quantity_temp = quantity;
alter table baseMovement drop column quantity;
alter table baseMovement add column quantity float null;
update baseMovement set quantity = quantity_temp;
alter table baseMovement drop column quantity_temp;


drop view transactions;
drop view balances;
drop view investments;
drop view filters;
drop view StnInstrumentValue;
drop view StnInvestmentPortfolio;
drop view StnDepositMovement;
drop view StnBaseMovement;
drop view StnMovementList;

create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * movementCash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create view investments as select * from (
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, quantity, idAccountCurrencyDef from investmentMovement where movementType = 'B'
 union all
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, (-1) * quantity, idAccountCurrencyDef from investmentMovement where movementType = 'S') as v;

create view filters as
  select m.idMovementFilter, a.idAccount, c.idCashpoint, p.idProduct from (((movementFilter m
    left outer join accountFilter a on a.idMovementFilter = m.idMovementFilter)
    left outer join cashpointFilter c on c.idMovementFilter = m.idMovementFilter)
    left outer join productFilter p on p.idMovementFilter = m.idMovementFilter);

create view StnInstrumentValue as
  select v.*, i.idCurrencyDef, i.instrumentType from instrumentValue v
  left join instrument i on i.idInstrument = v.idInstrument;

create view StnInvestmentPortfolio as
  select v.idInstrument, i.idCurrencyDef, i.name as instrumentName, i.instrumentType, v.idAccount,
         a.name as accountName, idInvestmentItem, v.created, v.modified, v.quantity,
         (select top 1 valueOf from instrumentValue where idInstrument = v.idInstrument order by regDateTime desc) as valueOf
    from ((investmentItem v
      left outer join instrument i on i.idInstrument = v.idInstrument)
      left outer join account a on a.idAccount = v.idAccount);
	  
create view StnDepositMovement as
  select v.*, d.idCurrencyDef from depositMovement v
  left join depositInvestment d on d.idDepositInvestment = v.idDepositInvestment;
  
create view StnBaseMovement as
  select v.*, i.name as accountName, q.name as sourceAccountName from ((baseMovement v
  left outer join account i on i.idAccount = v.idAccount)
  left outer join account q on q.idAccount = v.idSourceAccount);

create view StnMovementList as
  select v.*, i.name as accountName from movementList v
  left outer join account i on i.idAccount = v.idAccount;
 �  8   ��
 S Q L U P D _ 1 1 _ 1 2         0        alter table account add column accountState varchar(1) not null;
alter table account add constraint ck_accountState check (accountState in ('A', 'C'));
update account set accountState = 'A';
alter table depositInvestment add column calcTax bit not null;
alter table depositInvestment add column taxRate money not null;
update depositInvestment set calcTax = 0;
update depositInvestment set taxRate = 0;
  