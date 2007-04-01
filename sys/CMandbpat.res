        ��  ��                  2.  4   ��
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
  primary key (idAccount),
  constraint ck_accountType check (accountType in ('C', 'B')),
  constraint fk_accountCashPoint foreign key (idCashPoint) references cashPoint (idCashPoint)
);

create table product (
  idProduct uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  idParentProduct uniqueidentifier,
  productType varchar(1) not null,
  primary key (idProduct),
  constraint fk_parentProduct foreign key (idParentProduct) references product (idProduct),
  constraint ck_productType check (productType in ('I', 'O'))
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
  idProduct uniqueidentifier not null,
  scheduleType varchar(1) not null,
  scheduleDate datetime not null,
  endCondition varchar(1) not null,
  endCount int,
  endDate datetime,
  triggerType varchar(1) not null,
  triggerDay int not null,
  freeDays varchar(1) not null,
  primary key (idPlannedMovement),
  constraint ck_plannedType check (movementType in ('I', 'O')),
  constraint ck_freeDays check (freeDays in ('E', 'D', 'I')),
  constraint fk_plannedMovementAccount foreign key (idAccount) references account (idAccount),
  constraint fk_plannedMovementCashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_plannedMovementProduct foreign key (idProduct) references product (idProduct),
  constraint ck_scheduleType check (scheduleType in ('O', 'C')),
  constraint ck_endCondition check (endCondition in ('T', 'D', 'N')),
  constraint ck_endConditionCountDate check ((endCount is not null) or (endDate is not null)),
  constraint ck_triggerType check (triggerType in ('W', 'M'))
);

create table plannedDone (
  idPlannedDone uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  triggerDate datetime not null,
  doneDate datetime not null,
  doneState varchar(1) not null,
  idPlannedMovement uniqueidentifier not null,
  description varchar(200),
  cash money not null,
  primary key (idPlannedDone),
  constraint fk_plannedMovement foreign key (idPlannedMovement) references plannedMovement (idPlannedMovement),
  constraint ck_doneState check (doneState in ('O', 'D', 'A'))
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
  primary key (idmovementList),
  constraint ck_movementTypemovementList check (movementType in ('I', 'O')),  
  constraint fk_cashpointmovementList foreign key (idCashpoint) references cashpoint (idCashpoint),  
  constraint fk_accountmovementList foreign key (idAccount) references account (idAccount)
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
  primary key (idBaseMovement),
  constraint ck_movementType check (movementType in ('I', 'O', 'T')),
  constraint fk_account foreign key (idAccount) references account (idAccount),
  constraint fk_sourceAccount foreign key (idSourceAccount) references account (idAccount),
  constraint fk_cashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_product foreign key (idProduct) references product (idProduct),
  constraint fk_movementList foreign key (idMovementList) references movementList (idMovementList)
);

create table movementFilter (
  idMovementFilter uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
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
  primary key (idMovementLimit),
  constraint ck_boundaryTypelimit check (boundaryType in ('T', 'W', 'M', 'Q', 'H', 'Y', 'D')),  
  constraint ck_boundaryConditionlimit check (boundarycondition in ('=', '<', '>', '<=', '>=')),  
  constraint ck_sumTypelimit check (sumType in ('I', 'O', 'B')),  
  constraint fk_filterlimit foreign key (idmovementFilter) references movementFilter (idmovementFilter)
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

create table cmanagerInfo (
  version varchar(20) not null,
  created datetime not null
);

create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash from baseMovement where movementType = 'T') as v;

create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense from baseMovement where movementType = 'T') as v;
 
create view filters as
  select m.idMovementFilter, a.idAccount, c.idCashpoint, p.idProduct from (((movementFilter m
    left outer join accountFilter a on a.idMovementFilter = m.idMovementFilter)
    left join cashpointFilter c on c.idMovementFilter = m.idMovementFilter)
    left join productFilter p on p.idMovementFilter = m.idMovementFilter);

create index ix_baseMovement_regDate on baseMovement (regDate);
create index ix_movementList_regDate on movementList (regDate);
create index ix_baseMovement_movementType on baseMovement (movementType);
create index ix_plannedDone_triggerDate on plannedDone (triggerDate);
create index ix_cmanagerParams_name on cmanagerParams (paramName);
create index ix_baseMovement_idAccount on baseMovement (idAccount);
create index ix_baseMovement_idSourceAccount on baseMovement (idSourceAccount);
create index ix_baseMovement_idProduct on baseMovement (idProduct);
create index ix_baseMovement_idCashpoint on baseMovement (idCashPoint);
create index ix_baseMovement_idMovementList on baseMovement (idMovementList);  =  ,   ��
 S Q L D E F S       0        insert into cashPoint (idCashPoint, created, modified, name, description, cashpointType) values ('{F9111277-744E-4E4C-9D97-C8A0E4F3CF82}', #2007-03-14 12:44:48#, #2007-03-14 12:44:48#, 'Tw�j bank', 'Bank, w kt�rym prowadzisz rachunek oszcz�dno�ciowo-rozliczeniowy', 'X');
insert into cashPoint (idCashPoint, created, modified, name, description, cashpointType) values ('{72976F14-B380-4F40-B9F2-E6A328453DC4}', #2007-03-14 12:45:07#, #2007-03-14 12:45:07#, 'Sklep osiedlowy', 'Sklep na twoim osiedlu', 'O');
insert into cashPoint (idCashPoint, created, modified, name, description, cashpointType) values ('{4C293552-2331-4336-A73E-A9F36F5CBCED}', #2007-03-14 12:45:26#, #2007-03-14 12:45:26#, 'Tw�j pracodawca', 'Firma, w kt�rej pracujesz', 'I');
insert into cashPoint (idCashPoint, created, modified, name, description, cashpointType) values ('{2F7760FA-4F2C-4BAC-9943-A573CD720FE1}', #2007-03-14 12:45:41#, #2007-03-14 12:45:41#, 'Poczta Polska', 'Poczta Polska', 'O');
insert into account (idAccount, created, modified, name, description, accountType, cash, initialBalance, accountNumber, idCashPoint) values ('{3FA611D2-F6D6-4DAA-9EE8-CE8193FEB1B5}', #2007-03-14 12:46:39#, #2007-03-14 12:46:39#, 'Tw�j portfel', 'Tw�j portfel', 'C', 0, 0, '', null);
insert into account (idAccount, created, modified, name, description, accountType, cash, initialBalance, accountNumber, idCashPoint) values ('{360EE776-DCA7-436E-A084-72A7BCEF6440}', #2007-03-14 12:47:14#, #2007-03-14 12:59:17#, 'Twoje konto bankowe', 'Twoje konto bankowe', 'B', 0, 0, '', '{F9111277-744E-4E4C-9D97-C8A0E4F3CF82}');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{90B679B3-E526-450C-B988-5299EBA608FC}', #2007-03-14 12:58:16#, #2007-03-14 12:58:16#, 'Wydatki na utrzymanie', 'Wydatki na utrzymanie', null, 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{92800455-2221-4FFE-BBB9-30AB5638B3FB}', #2007-03-14 13:05:12#, #2007-03-14 13:05:28#, '�ywno��', '�ywno��', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{BA1361BD-BEF0-429A-AC3F-3F802F9CC08D}', #2007-03-14 13:05:19#, #2007-03-14 13:05:24#, '�rodki czysto�ci', '�rodki czysto�ci', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{8C44A1F0-C2C5-41F7-AF5A-8AEA272EACB6}', #2007-03-14 13:05:41#, #2007-03-14 13:05:41#, 'Higiena osobista', 'Higiena osobista', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{2DDA6C5A-E1EA-4574-BFB0-8D1C44753F80}', #2007-03-14 13:06:11#, #2007-03-14 13:06:11#, 'Ubrania', 'Ubrania', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0CD020B5-C548-41A5-9286-05F1FE802D5C}', #2007-03-14 13:10:16#, #2007-03-14 13:10:16#, 'Op�aty miesi�czne', 'Op�aty miesi�czne', null, 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{B29478DC-CAE2-40BE-8A95-15C94EC57557}', #2007-03-14 13:10:25#, #2007-03-14 13:10:25#, 'Czynsz za mieszkanie', 'Czynsz za mieszkanie', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0A847942-18B8-47C5-A215-08DD01643984}', #2007-03-14 13:10:44#, #2007-03-14 13:10:44#, 'Telefon stacjonarny', 'Telefon stacjonarny', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{39FCFDA8-4C0C-4929-85FB-02D081D2AEA8}', #2007-03-14 13:10:54#, #2007-03-14 13:10:54#, 'Telefony kom�rkowe', 'Telefony kom�rkowe', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{5C1BDF52-F44F-4FFF-A5C1-B98B21455530}', #2007-03-14 13:11:04#, #2007-03-14 13:11:04#, 'Internet', 'Internet', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{E4583674-A827-4D7F-A831-FEAB25795875}', #2007-03-14 13:11:22#, #2007-03-14 13:11:22#, 'Abonament radiowo-telewizyjny', 'Abonament radiowo-telewizyjny', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{2EF81612-BDBF-4375-95A2-865AAD13A956}', #2007-03-14 13:11:34#, #2007-03-14 13:11:34#, 'Telewizja kablowa', 'Telewizja kablowa', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', #2007-03-14 13:12:12#, #2007-03-14 13:12:12#, 'Rozrywka', 'Rozrywka', null, 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{9FF1CE8B-9C45-4C6C-9920-D1A559DCA83C}', #2007-03-14 13:12:21#, #2007-03-14 13:12:58#, 'Bilety do kina i teatru', 'Kino i teatr', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{C8E81F65-E5A2-4860-BE92-2F82078118DB}', #2007-03-14 13:12:28#, #2007-03-14 13:13:32#, 'Zakupy ksi��ek', 'Ksi��ki', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{B1C31053-DD57-496B-AD82-1A9560561837}', #2007-03-14 13:12:46#, #2007-03-14 13:12:46#, 'Wypo�yczalnia kaset i p�yt DVD', 'Wypo�yczalnia kaset i p�yt DVD', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{9F823582-8CC6-404B-A6E6-D60C71024CB1}', #2007-03-14 13:13:45#, #2007-03-14 13:13:45#, 'Zakupy CD, DVD', 'Zakupy CD, DVD', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{E4AB55D5-FBAA-455D-86B3-4581D5B6CF28}', #2007-03-14 13:13:56#, #2007-03-14 13:13:56#, 'Gazety i czasopisma', 'Gazety i czasopisma', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{B16941A1-5D87-402F-816D-C86A27F3C92E}', #2007-03-14 13:14:23#, #2007-03-14 13:14:23#, 'Jednorazowe bilety komunikacyjne', 'Jednorazowe bilety komunikacyjne', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{DD383739-B641-4070-88A3-50EC7DAD879A}', #2007-03-14 13:14:33#, #2007-03-14 13:14:33#, 'Bilety miesi�czne', 'Bilety miesi�czne', '{0CD020B5-C548-41A5-9286-05F1FE802D5C}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{4A1A9F11-0D75-403A-A89C-C2D5AA8F5864}', #2007-03-14 13:14:46#, #2007-03-14 13:14:46#, 'Restauracje i puby', 'Restauracje i puby', '{BE66D43A-0B42-4CB3-BCC4-8BAE4DFDAB04}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0B65EFE2-6861-4B4E-917D-A346DC103155}', #2007-03-14 13:14:59#, #2007-03-14 13:14:59#, 'U�ywki', 'U�ywki', null, 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{573CAE5E-AE4C-4A2C-8B32-3DA883DFAD28}', #2007-03-14 13:15:06#, #2007-03-14 13:15:06#, 'Papierosy', 'Papierosy', '{0B65EFE2-6861-4B4E-917D-A346DC103155}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{48CF0575-8DB5-493F-9261-134C54AE625B}', #2007-03-14 13:15:21#, #2007-03-14 13:15:21#, 'Alkohol', 'Piwo, wino, w�dka i inne', '{0B65EFE2-6861-4B4E-917D-A346DC103155}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', #2007-03-14 13:16:34#, #2007-03-14 13:16:34#, 'Samoch�d', 'Samoch�d', null, 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{80FB0182-F934-4A4C-B155-2BE933AD0FEA}', #2007-03-14 13:16:41#, #2007-03-14 13:16:41#, 'Ubezpieczenia', 'Ubezpieczenia', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{D6EE18AF-9283-48CC-B735-DE2FFCF807D0}', #2007-03-14 13:16:48#, #2007-03-14 13:16:48#, 'Paliwo', 'Paliwo', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{59123690-CDB3-46AB-81BB-DF032DDD7FDF}', #2007-03-14 13:17:00#, #2007-03-14 13:17:00#, 'Naprawy', 'Naprawy', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{FAC481D1-68B5-4A72-835A-36FD5D060D3F}', #2007-03-14 13:17:11#, #2007-03-14 13:17:11#, 'Eksploatacja', 'Eksploatacja', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', #2007-03-14 13:17:50#, #2007-03-14 13:17:50#, 'Twoje przychody', 'Twoje przychody', null, 'I');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{2A5D1B16-4C4A-478C-837B-792F26D436BF}', #2007-03-14 13:17:57#, #2007-03-14 13:17:57#, 'Pensja', 'Pensja', '{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', 'I');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{D4C24555-61EB-4CCA-9067-E4F0430F76FC}', #2007-03-14 13:18:12#, #2007-03-14 13:18:12#, 'Zwrot z Urz�du Skarbowego', 'Zwrot z Urz�du Skarbowego', '{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', 'I');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{A13042E5-73D8-44CD-BD37-6B0C8662FBDE}', #2007-03-14 13:18:19#, #2007-03-14 13:18:19#, 'Zlecenia', 'Zlecenia', '{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', 'I');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{ED813939-098B-4A63-9664-C987BFBF3CB5}', #2007-03-14 13:18:28#, #2007-03-14 13:18:28#, 'Darowizny', 'Darowizny', '{4CBABD0C-FAA9-4CE8-9F6D-B35B97012C3E}', 'I');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{A7A315DB-9C49-4815-AD32-7048C88DD913}', #2007-03-14 13:18:57#, #2007-03-14 13:18:57#, 'S�odycze', 'S�odycze', '{90B679B3-E526-450C-B988-5299EBA608FC}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{6784F593-412B-40C8-9EC3-81E1DFF3A033}', #2007-03-14 13:19:20#, #2007-03-14 13:19:20#, 'Prowizje', 'Prowizje', null, 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0088B20B-B725-42EB-969E-30D69674E1C2}', #2007-03-14 13:19:39#, #2007-03-14 13:19:39#, 'Op�aty pocztowe', 'Op�aty pocztowe', '{6784F593-412B-40C8-9EC3-81E1DFF3A033}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{558D6510-CADC-4AC3-938E-0EB6BEE25723}', #2007-03-14 13:19:59#, #2007-03-14 13:19:59#, 'Prowizje za wyp�aty w bankomacie', 'Prowizje za wyp�aty w bankomacie', '{6784F593-412B-40C8-9EC3-81E1DFF3A033}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{47F62656-87E9-4807-9D11-736546CD44D5}', #2007-03-14 13:20:11#, #2007-03-14 13:20:11#, 'Mandaty', 'Mandaty', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{A8C61F19-F67E-47D6-907A-544B2E79FDA0}', #2007-03-14 13:20:26#, #2007-03-14 13:20:26#, 'Wymiana cz�sci', 'Wymiana cz�sci', '{D56721FE-DBE2-4674-B91E-ADC1C3950A59}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', #2007-03-14 13:20:48#, #2007-03-14 13:20:48#, 'Zdrowie', 'Zdrowie', null, 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0AB7EC5F-1B0E-4BEA-98AC-F5F92E5CE6EF}', #2007-03-14 13:20:58#, #2007-03-14 13:20:58#, 'Lekarze', 'Lekarze', '{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{5780B536-FC0C-4113-8C33-A119D1242B7D}', #2007-03-14 13:21:24#, #2007-03-14 13:21:24#, 'Badania', 'Badania', '{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0C17A747-2CDA-4C29-92A3-0D2F262511B2}', #2007-03-14 13:22:04#, #2007-03-14 13:22:04#, 'Leki', 'Leki', '{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{144D22B5-9C46-4FF8-A16C-FAE0CD701DB1}', #2007-03-14 13:22:54#, #2007-03-14 13:22:54#, 'Rehabilitacja', 'Rehabilitacja', '{6B204CBE-A702-41CA-966B-2F69C7A37D0A}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', #2007-03-14 13:23:20#, #2007-03-14 13:23:20#, 'Uroda', 'Uroda', null, 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{7D707B84-E5BA-46CF-8F6E-862B0B121A6F}', #2007-03-14 13:23:26#, #2007-03-14 13:23:26#, 'Kosmetyki', 'Kosmetyki', '{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0388F87A-3277-43A1-9D8D-40945C90FCCE}', #2007-03-14 13:23:44#, #2007-03-14 13:23:44#, 'Si�ownia', 'Si�ownia', '{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{4EB90981-D232-4AAB-B88B-E3088A2A3677}', #2007-03-14 13:23:56#, #2007-03-14 13:23:56#, 'Sprz�t sportowy', 'Sprz�t sportowy', '{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{C28FBA7D-33FE-4658-97C4-106B0319B5B0}', #2007-03-14 13:24:57#, #2007-03-14 13:24:57#, 'Aerobic i fittness', 'Aerobic i fittness', '{2B13288A-8C31-4088-916C-7BA6DA8EBB5B}', 'O');
insert into profile (idProfile, created, modified, name, description, idAccount, idCashPoint, idProduct) values ('{4C0569FA-82C8-426C-A6DD-C76C873F5EF3}', #2007-03-14 13:26:01#, #2007-03-14 13:26:01#, 'Zakupy w sklepie osiedlowym', 'Zakupy w sklepie osiedlowym', '{3FA611D2-F6D6-4DAA-9EE8-CE8193FEB1B5}', '{72976F14-B380-4F40-B9F2-E6A328453DC4}', null);�
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
alter table plannedMovement add constraint ck_freeDays check (freeDays in ('E', 'D', 'I'));  