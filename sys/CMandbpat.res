        ��  ��                  C"  4   ��
 S Q L P A T T E R N         0        create table cashPoint (
  idCashPoint uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  primary key (idCashPoint)
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
  primary key (idPlannedMovement),
  constraint ck_plannedType check (movementType in ('I', 'O')),
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

create index ix_baseMovement_regDate on baseMovement (regDate);
create index ix_plannedDone_triggerDate on plannedDone (triggerDate);
 *  ,   ��
 S Q L D E F S       0        insert into cashPoint (idCashPoint, created, modified, name, description) values ('{D075846B-BE19-404A-A202-7B8E001AC105}', #2007-03-07 13:47:20#, #2007-03-07 13:47:20#, 'Tw�j bank', 'Bank, kt�ry prowadzi tw�j rachunek');
insert into account (idAccount, created, modified, name, description, accountType, cash, initialBalance, accountNumber, idCashPoint) values ('{EB05613D-449C-4C14-873A-8FEE823BE999}', #2007-03-07 13:46:45#, #2007-03-07 13:46:45#, 'Tw�j portfel', 'Tw�j portfel', 'C', 0, 0, '', null);
insert into account (idAccount, created, modified, name, description, accountType, cash, initialBalance, accountNumber, idCashPoint) values ('{4F5AA4E1-A4AC-43B6-9A67-49637D2429A7}', #2007-03-07 13:47:23#, #2007-03-07 13:47:23#, 'Twoje konto bankowe', 'Twoje konto bankowe', 'B', 0, 0, '', '{D075846B-BE19-404A-A202-7B8E001AC105}');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0BE7D2F9-A945-46E8-869A-A28C6B92EC54}', #2007-03-07 13:47:55#, #2007-03-07 13:47:55#, 'Rozchody', 'Wszystkie twoje wydatki', null, 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{C7D851D4-EE70-4CDC-9C92-DFFC0E63E449}', #2007-03-07 13:48:19#, #2007-03-07 13:48:19#, 'Utrzymanie', 'Wszystkie wydatki zwi�zane z twoim utrzymaniem', '{0BE7D2F9-A945-46E8-869A-A28C6B92EC54}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{5383056C-23C9-453E-8E26-43D9F6446F62}', #2007-03-07 13:48:28#, #2007-03-07 13:48:28#, '�ywno��', '�ywno��', '{C7D851D4-EE70-4CDC-9C92-DFFC0E63E449}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{00215582-0AB6-406A-8227-9AD5667A2DAC}', #2007-03-07 13:49:11#, #2007-03-07 13:49:11#, '�rodki czysto�ci', '�rodki czysto�ci i hiegiena osobista', '{C7D851D4-EE70-4CDC-9C92-DFFC0E63E449}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{CC230E9A-2CB6-4C29-B143-3D96D26AE3B9}', #2007-03-07 13:49:45#, #2007-03-07 13:49:45#, 'U�ywki', 'Alkochol, papierosy i inne u�ywki', '{C7D851D4-EE70-4CDC-9C92-DFFC0E63E449}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{AE0EC15A-76B4-43E0-AF9E-1576D8541B6E}', #2007-03-07 13:50:06#, #2007-03-07 13:50:06#, 'Czynsz', 'Op�ata za mieszkanie', '{C7D851D4-EE70-4CDC-9C92-DFFC0E63E449}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0930942F-FCEC-417C-AFDC-AC3924D3B731}', #2007-03-07 13:50:29#, #2007-03-07 13:50:29#, 'Samoch�d', 'Wszystkie wydatki zwi�zane z samochodem', '{0BE7D2F9-A945-46E8-869A-A28C6B92EC54}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{10BE3D4A-AD2B-4C64-B6A0-86BF3DFE819C}', #2007-03-07 13:50:36#, #2007-03-07 13:50:36#, 'Paliwo', 'Paliwo', '{0930942F-FCEC-417C-AFDC-AC3924D3B731}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{AF44DA5B-7AF8-4F31-9A23-9A95A745280E}', #2007-03-07 13:51:02#, #2007-03-07 13:51:02#, 'Eksploatacja', 'Cz�ci zamienne, naprawy', '{0930942F-FCEC-417C-AFDC-AC3924D3B731}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{9191ADF0-CC52-4510-9AC5-3725CF582265}', #2007-03-07 13:51:19#, #2007-03-07 13:51:19#, 'Przychody', 'Wszystkie twoje przychody', null, 'I');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{D1BAF7B6-1E01-4D54-B8C3-986075D0414C}', #2007-03-07 13:51:44#, #2007-03-07 13:51:44#, 'Wynagrodzenia', 'Wszystkie twoje �r�d�a dochod�w', '{9191ADF0-CC52-4510-9AC5-3725CF582265}', 'I');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{560E8579-2D45-4703-983E-BA0336E39D1F}', #2007-03-07 13:51:58#, #2007-03-07 13:51:58#, 'Twoja pensja', 'Twoja pensja', '{D1BAF7B6-1E01-4D54-B8C3-986075D0414C}', 'I');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{0C8171FF-7BA7-4E02-8A81-7DF04000CFE5}', #2007-03-07 13:52:19#, #2007-03-07 13:52:19#, 'Za zlecenia', 'Za zlecenia', '{D1BAF7B6-1E01-4D54-B8C3-986075D0414C}', 'I');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{226A9914-6A49-4D59-8D7E-0A5B8391A03E}', #2007-03-07 13:52:42#, #2007-03-07 13:52:42#, 'Bilety komunikacyjne', 'Bilety komunikacji miejskiej', '{C7D851D4-EE70-4CDC-9C92-DFFC0E63E449}', 'O');
insert into product (idProduct, created, modified, name, description, idParentProduct, productType) values ('{D5883B38-8921-405E-B6CF-E14363257CB8}', #2007-03-07 13:53:07#, #2007-03-07 13:53:07#, 'Rozrywka', 'Kino, teatr, pub', '{C7D851D4-EE70-4CDC-9C92-DFFC0E63E449}', 'O');
insert into cmanagerInfo (version, created) values ('1.1.4.12', #2007-03-07 13:46:12#);
  �  4   ��
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

alter table baseMovement add idmovementList uniqueidentifier null;
alter table baseMovement add constraint fk_movementList foreign key (idMovementList) references movementList (idMovementList);
  