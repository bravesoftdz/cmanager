inherited CProductsFrame: TCProductsFrame
  inherited List: TCDataList
    CheckImageKind = ckSystemDefault
    Header.MainColumn = 0
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Columns = <
      item
        Position = 0
        Width = 435
        WideText = 'Nazwa'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Jednostka miary'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TCPanel
    inherited CButtonAdd: TCButton
      Width = 136
    end
    inherited CButtonEdit: TCButton
      Left = 288
      Width = 136
    end
    inherited CButtonDelete: TCButton
      Left = 424
      Width = 136
    end
    object CButtonAddSubcategory: TCButton
      Left = 144
      Top = 4
      Width = 145
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAddSubcategory
    end
  end
  inherited ListPopupMenu: TPopupMenu
    object Dodajpodkategori1: TMenuItem [1]
      Action = ActionAddSubcategory
    end
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.CategoryImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj kategori'#281
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj kategori'#281
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' kategori'#281
    end
    object ActionAddSubcategory: TAction
      Caption = 'Dodaj podkategori'#281
      ImageIndex = 0
      OnExecute = ActionAddSubcategoryExecute
    end
  end
end
