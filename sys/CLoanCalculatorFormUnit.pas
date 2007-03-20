unit CLoanCalculatorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CLoans,
  CComponents, VirtualTrees;

type
  TCLoanCalculatorForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    CDateTime: TCDateTime;
    ComboBoxType: TComboBox;
    ComboBoxPeriod: TComboBox;
    Label1: TLabel;
    Label4: TLabel;
    CIntEditTimes: TCIntEdit;
    Label2: TLabel;
    CCurrEditTax: TCCurrEdit;
    Label6: TLabel;
    CCurrEditCash: TCCurrEdit;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    RepaymentList: TVirtualStringTree;
    PanelError: TPanel;
    BitBtnPrint: TBitBtn;
    procedure ComboBoxPeriodChange(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CCurrEditCashChange(Sender: TObject);
    procedure CCurrEditTaxChange(Sender: TObject);
    procedure CIntEditTimesChange(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure RepaymentListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure BitBtnOkClick(Sender: TObject);
  private
    Floan: TLoan;
    procedure UpdateLoanData;
  public
    property loan: TLoan read Floan write Floan;
  end;

function ShowLoanCalculator(ACanAccept: Boolean): TLoan;

implementation

uses CDatabase, CReports;

{$R *.dfm}

function ShowLoanCalculator(ACanAccept: Boolean): TLoan;
var xForm: TCLoanCalculatorForm;
    xOperation: TConfigOperation;
begin
  Result := TLoan.Create;
  xForm := TCLoanCalculatorForm.Create(Application);
  xForm.loan := Result;
  if ACanAccept then begin
    xOperation := coAdd;
  end else begin
    xOperation := coNone;
  end;
  xForm.UpdateLoanData;
  if not xForm.ShowConfig(xOperation) then begin
    FreeAndNil(Result);
  end;
  xForm.Free;
end;

procedure TCLoanCalculatorForm.UpdateLoanData;
var xValid: Boolean;
begin
  if not (csLoading in componentState) then begin
    xValid := (CCurrEditCash.Value <> 0) and (CIntEditTimes.Value <> 0) and (CIntEditTimes.Value <> -1);
    if xValid then begin
      with Floan do begin
        periods := CIntEditTimes.Value;
        totalCash := CCurrEditCash.Value;
        taxAmount := CCurrEditTax.Value;
        firstDay := CDateTime.Value;
        if ComboBoxType.ItemIndex = 0 then begin
          paymentType := lptTotal;
        end else begin
          paymentType := lptPrincipal;
        end;
        if ComboBoxPeriod.ItemIndex = 0 then begin
          paymentPeriod := lppMonthly;
        end else begin
          paymentPeriod := lppWeekly;
        end;
      end;
      xValid := Floan.CalculateRepayments;
    end;
    if xValid then begin
      PanelError.Visible := False;
      with RepaymentList do begin
        BeginUpdate;
        RootNodeCount := Floan.Count;
        EndUpdate;
        if Floan.firstDay <> 0 then begin
          Header.Columns.Items[1].Options := Header.Columns.Items[1].Options + [coVisible];
        end else begin
          Header.Columns.Items[1].Options := Header.Columns.Items[1].Options - [coVisible];
        end;
        Header.Options := Header.Options + [hoVisible];
      end;
    end else begin
      PanelError.Visible := True;
      with RepaymentList do begin
        BeginUpdate;
        RootNodeCount := 0;
        EndUpdate;
        Header.Options := Header.Options - [hoVisible];
      end;
    end;
    BitBtnPrint.Enabled := xValid;
  end;
end;

procedure TCLoanCalculatorForm.ComboBoxPeriodChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.ComboBoxTypeChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.CCurrEditCashChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.CCurrEditTaxChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.CIntEditTimesChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.RepaymentListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xObj: TLoanRepayment;
begin
  xObj := Floan.Items[Node.Index];
  if Column = 0 then begin
    CellText := xObj.caption;
  end else if Column = 1 then begin
    if Floan.IsSumObject(Floan.IndexOf(xObj)) then begin
      CellText := DateToStr(xObj.date);
    end else begin
      CellText := '';
    end;
  end else if Column = 2 then begin
    CellText := CurrencyToString(xObj.payment);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xObj.principal);
  end else if Column = 4 then begin
    CellText := CurrencyToString(xObj.tax);
  end else if Column = 5 then begin
    if Floan.IsSumObject(Floan.IndexOf(xObj)) then begin
      CellText := CurrencyToString(xObj.left);
    end else begin
      CellText := '';
    end;
  end;
end;

procedure TCLoanCalculatorForm.BitBtnOkClick(Sender: TObject);
var xParams: TLoanReportParams;
    xReport: TLoanReport;
begin
  xParams := TLoanReportParams.Create(Floan);
  xReport := TLoanReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

end.
