inherited CCashpointsFrame: TCCashpointsFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 443
        WideText = 'Nazwa'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TCPanel
    inherited CButtonAdd: TCButton
      Width = 137
    end
    inherited CButtonEdit: TCButton
      Left = 144
      Width = 137
    end
    inherited CButtonDelete: TCButton
      Left = 280
      Width = 137
    end
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.CashpointImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj kontrahenta'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj kontrahenta'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' kontrahenta'
    end
  end
end