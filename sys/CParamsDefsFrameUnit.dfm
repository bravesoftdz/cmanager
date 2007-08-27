inherited CParamsDefsFrame: TCParamsDefsFrame
  object Bevel: TBevel [0]
    Left = 0
    Top = 234
    Width = 443
    Height = 3
    Align = alBottom
    Shape = bsBottomLine
  end
  object List: TCDataList [1]
    Left = 0
    Top = 0
    Width = 443
    Height = 234
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkFlat
    BorderStyle = bsNone
    ButtonStyle = bsTriangle
    DefaultNodeHeight = 24
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Height = 21
    Header.MainColumn = -1
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.PopupMenu = VTHeaderPopupMenu
    Header.Style = hsFlatButtons
    HintMode = hmHint
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OddColor = 12437200
    AutoExpand = True
    Columns = <>
    WideDefaultText = ''
  end
  object ButtonPanel: TPanel [2]
    Left = 0
    Top = 237
    Width = 443
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 1
    object CButtonAdd: TCButton
      Left = 13
      Top = 4
      Width = 124
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAdd
    end
    object CButtonEdit: TCButton
      Left = 133
      Top = 4
      Width = 124
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionEdit
    end
    object CButtonDelete: TCButton
      Left = 253
      Top = 4
      Width = 116
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDelete
    end
    object CButtonHistory: TCButton
      Left = 325
      Top = 4
      Width = 132
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionPreview
    end
  end
  object ActionListButtons: TActionList
    Images = CImageLists.ParamsDefsImageList
    Left = 16
    Top = 160
    object ActionAdd: TAction
      Caption = 'Dodaj parametr'
      ImageIndex = 0
    end
    object ActionEdit: TAction
      Caption = 'Edytuj parametr'
      ImageIndex = 1
    end
    object ActionDelete: TAction
      Caption = 'Usu'#324' parametr'
      ImageIndex = 2
    end
    object ActionPreview: TAction
      Caption = 'Podgl'#261'd dialogu'
      ImageIndex = 3
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 168
    Top = 80
  end
end
