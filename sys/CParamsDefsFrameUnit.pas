unit CParamsDefsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, ExtCtrls,
  VirtualTrees, CComponents, VTHeaderPopup, ActnList, CImageListsUnit, ActiveX;

type
  TCParamsDefsFrame = class(TCBaseFrame)
    ActionListButtons: TActionList;
    ActionAdd: TAction;
    ActionEdit: TAction;
    ActionDelete: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    List: TCDataList;
    ButtonPanel: TCPanel;
    CButtonAdd: TCButton;
    CButtonEdit: TCButton;
    CButtonDelete: TCButton;
    CButtonHistory: TCButton;
    Bevel: TBevel;
    ActionPreview: TAction;
    PopupMenuIcons: TPopupMenu;
    MenuItemBigIcons: TMenuItem;
    MenuItemSmallIcons: TMenuItem;
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ActionPreviewExecute(Sender: TObject);
    procedure ListDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure ListDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure MenuItemBigIconsClick(Sender: TObject);
    procedure MenuItemSmallIconsClick(Sender: TObject);
  private
    FSmallIconsButtonsImageList: TPngImageList;
    FBigIconsButtonsImageList: TPngImageList;
    procedure UpdateIcons;
  protected
    function GetSelectedId: ShortString; override;
    function GetSelectedText: String; override;
  public
    procedure UpdateButtons(AIsSelectedSomething: Boolean); override;
    function GetList: TCList; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    function MustFreeAdditionalData: Boolean; override;
    class function GetPrefname: String; override;
    destructor Destroy; override;
  end;

implementation

uses CReports, CParamDefFormUnit, CConfigFormUnit, CInfoFormUnit,
  CChooseByParamsDefsFormUnit, CMemoFormUnit, CConsts;

{$R *.dfm}

function TCParamsDefsFrame.GetList: TCList;
begin
  Result := List;
end;

procedure TCParamsDefsFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  FSmallIconsButtonsImageList := Nil;
  FBigIconsButtonsImageList := TPngImageList(ActionListButtons.Images);
  CButtonHistory.Width := CButtonHistory.Canvas.TextWidth(ActionPreview.Caption) + CButtonHistory.PicOffset + ActionListButtons.Images.Width + 10;
  CButtonHistory.Left := ButtonPanel.Width - CButtonHistory.Width - 15;
  CButtonHistory.Anchors := [akTop, akRight];
  if List.ViewPref <> Nil then begin
    MenuItemSmallIcons.Checked := List.ViewPref.ButtonSmall;
    UpdateIcons;
  end;
  List.ReloadTree;
  UpdateButtons(List.FocusedNode <> Nil);
end;

function TCParamsDefsFrame.MustFreeAdditionalData: Boolean;
begin
  Result := False;
end;

procedure TCParamsDefsFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xDefs: TReportDialogParamsDefs;
    xCount: Integer;
begin
  xDefs := TReportDialogParamsDefs(AdditionalData);
  for xCount := 0 to xDefs.Count - 1 do begin
    ARootElement.AppendDataElement(TCListDataElement.Create(False, List, xDefs.Items[xCount]));
  end;
end;

procedure TCParamsDefsFrame.ActionAddExecute(Sender: TObject);
var xForm: TCParamDefForm;
    xParam: TReportDialgoParamDef;
begin
  xForm := TCParamDefForm.Create(Nil);
  xParam := TReportDialgoParamDef.Create(TReportDialogParamsDefs(AdditionalData));
  xForm.paramDef := xParam;
  if xForm.ShowConfig(coEdit) then begin
    TReportDialogParamsDefs(AdditionalData).AddParam(xParam);
    List.RootElement.AppendDataElement(TCListDataElement.Create(False, List, xParam));
  end else begin
    xParam.Free;
  end;
  xForm.Free;
end;

procedure TCParamsDefsFrame.ActionEditExecute(Sender: TObject);
var xForm: TCParamDefForm;
    xParam: TReportDialgoParamDef;
begin
  xForm := TCParamDefForm.Create(Nil);
  xParam := TReportDialgoParamDef(List.SelectedElement.Data);
  xForm.paramDef := xParam;
  if xForm.ShowConfig(coEdit) then begin
    List.RepaintNode(List.SelectedElement.Node);
  end;
  xForm.Free;
end;

procedure TCParamsDefsFrame.ActionDeleteExecute(Sender: TObject);
var xParam: TReportDialgoParamDef;
begin
  xParam := TReportDialgoParamDef(List.SelectedElement.Data);
  if ShowInfo(itQuestion, 'Czy chcesz usun�� parametr o nazwie "' + xParam.GetElementText + '" ?', '') then begin
    List.RootElement.DeleteDataElement(xParam.name);
    TReportDialogParamsDefs(AdditionalData).RemoveParam(xParam);
  end;
end;

procedure TCParamsDefsFrame.UpdateButtons(AIsSelectedSomething: Boolean);
begin
  inherited UpdateButtons(AIsSelectedSomething);
  ActionEdit.Enabled := AIsSelectedSomething;
  ActionDelete.Enabled := AIsSelectedSomething;
end;

procedure TCParamsDefsFrame.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  UpdateButtons(Node <> Nil);
end;

procedure TCParamsDefsFrame.ActionPreviewExecute(Sender: TObject);
var xParams: TReportDialogParamsDefs;
    xSql: String;
    xErrorText: String;
begin
  xParams := TReportDialogParamsDefs(AdditionalData);
  if xParams.Count = 0 then begin
    ShowInfo(itInfo, 'Brak zdefiniowanych parametr�w raportu, formatka przyk�adowa nie zostanie wy�wietlona.\nPrzy uruchomieniu ' +
                     'raportu CManager przejdzie od razu do przygotowania i wy�wietlenia raportu.\nU�yte zostanie zapytanie tworz�ce' +
                     ' takie jak zdefiniowano.', '');
  end else begin
    if ChooseByParamsDefs(xParams) then begin
      if ShowInfo(itQuestion, 'Czy chcesz obejrze� uzupe�nione o wybrane parametry zapytanie tworz�ce ?', '') then begin
        xSql := xParams.testSqlStatemenet;
        if xParams.RebuildStringWithParams(xSql, xErrorText) then begin
          ShowReport('Zapytanie tworz�ce', xSql, 500, 400);
        end else begin
          ShowInfo(itError, 'Podczas przygotowania zapytania tworz�cego raport wyst�pi� b��d. Sprawdz definicj� raportu\n' +
                            'pod k�tem poprawno�ci sk�adniowej zapytania oraz definicj� parametr�w i mnemonik�w.', xErrorText);
        end;
      end;
    end;
  end;
end;

procedure TCParamsDefsFrame.ListDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := (Sender = Source);
end;

procedure TCParamsDefsFrame.ListDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var xAttachmode: TVTNodeAttachMode;
    xNodes: TNodeArray;
    xCount: Integer;
    xDefs: TReportDialogParamsDefs;
    xData: TCListDataElement;
    xCurIndex, xNewIndex: Integer;
begin
  if DataObject = Nil then begin
    case Mode of
      dmAbove: xAttachMode := amInsertBefore;
      dmOnNode: xAttachMode := amInsertAfter;
      dmBelow: xAttachMode := amInsertAfter;
      else xAttachMode := amNowhere;
    end;
    xNodes := List.GetSortedSelection(True);
    xDefs := TReportDialogParamsDefs(AdditionalData);
    for xCount := 0 to High(xNodes) do begin
      List.MoveTo(xNodes[xCount], Sender.DropTargetNode, xAttachMode, False);
      xData := TCListDataElement(List.GetNodeData(xNodes[xCount])^);
      xCurIndex := xDefs.IndexOf(xData.Data);
      xNewIndex := xNodes[xCount].Index;
      if (xCurIndex > -1) and (xNewIndex > -1) then begin
        xDefs.Move(xCurIndex, xNewIndex);
      end;
    end;
  end;
end;

class function TCParamsDefsFrame.GetPrefname: String;
begin
  Result := CFontPreferencesParamsDefs;
end;

destructor TCParamsDefsFrame.Destroy;
begin
  if FSmallIconsButtonsImageList <> Nil then begin
    FSmallIconsButtonsImageList.Free;
  end;
  inherited Destroy;
end;

procedure TCParamsDefsFrame.MenuItemBigIconsClick(Sender: TObject);
begin
  if not MenuItemBigIcons.Checked then begin
    MenuItemBigIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := False;
    end;
    UpdateIcons;
  end;
end;

procedure TCParamsDefsFrame.MenuItemSmallIconsClick(Sender: TObject);
begin
  if not MenuItemSmallIcons.Checked then begin
    MenuItemSmallIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := True;
    end;
    UpdateIcons;
  end;
end;

procedure TCParamsDefsFrame.UpdateIcons;
var xDummy: TPngImageList;
begin
  xDummy := Nil;
  UpdatePanelIcons(ButtonPanel,
                   MenuItemBigIcons, MenuItemSmallIcons,
                   FBigIconsButtonsImageList, Nil,
                   ActionListButtons, Nil,
                   FSmallIconsButtonsImageList,
                   xDummy);
end;


function TCParamsDefsFrame.GetSelectedId: ShortString;
begin
  Result := TReportDialgoParamDef(List.SelectedElement.Data).name;
end;

function TCParamsDefsFrame.GetSelectedText: String;
begin
  Result := TReportDialgoParamDef(List.SelectedElement.Data).desc;
end;

end.