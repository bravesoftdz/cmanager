create table depositInvestment (
  idDepositInvestment uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  depositState varchar(1) not null,
  name varchar(40) not null,
  description varchar(200),
  idAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idCurrencyDef uniqueidentifier not null,
  initialCash money not null,
  currentCash money not null,
  interestRate money not null,
  noncapitalizedInterest money not null,
  periodCount int not null,
  periodType varchar(1) not null,
  periodLastDatetime datetime null,
  periodNextDatetime datetime not null,
  periodAction varchar(1) not null,
  dueCount int not null,
  dueType varchar(1) not null,
  dueLastDatetime datetime null,
  dueNextDatetime datetime not null,
  dueAction varchar(1) not null,
  primary key (idDepositInvestment),
  constraint fk_accountdepositInvestment foreign key (idAccount) references account (idAccount),
  constraint fk_cashPointdepositInvestment foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_currencyDefdepositInvestment foreign key (idCurrencyDef) references currencyDef (idCurrencyDef),  
  constraint ck_depositState check (depositState in ('A', 'I', 'C')),
  constraint ck_depositPeriodType check (periodType in ('D', 'W', 'M', 'Y')),
  constraint ck_duePeriodType check (dueType in ('E', 'D', 'W', 'M', 'Y')),
  constraint ck_depositperiodAction check (dueAction in ('A', 'L')),
  constraint ck_depositdueAction check (dueAction in ('A', 'L'))
);