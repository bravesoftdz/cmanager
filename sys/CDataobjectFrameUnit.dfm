inherited CDataobjectFrame: TCDataobjectFrame
  object Bevel: TBevel [0]
    Left = 0
    Top = 234
    Width = 443
    Height = 3
    Align = alBottom
    Shape = bsBottomLine
  end
  object FilterPanel: TPanel [1]
    Left = 0
    Top = 0
    Width = 443
    Height = 21
    Align = alTop
    Alignment = taLeftJustify
    TabOrder = 2
    object Label2: TLabel
      Left = 11
      Top = 4
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = 'Poka'#380':'
    end
    object CStaticFilter: TCStatic
      Left = 49
      Top = 4
      Width = 136
      Height = 15
      Cursor = crHandPoint
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<wszystkie elementy>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      TabStop = True
      Transparent = False
      DataId = '0'
      TextOnEmpty = '<wszystkie elementy>'
      OnGetDataId = CStaticFilterGetDataId
      OnChanged = CStaticFilterChanged
      HotTrack = True
    end
  end
  object List: TCDataList [2]
    Left = 0
    Top = 21
    Width = 443
    Height = 213
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
    OnCompareNodes = ListCompareNodes
    OnDblClick = ListDblClick
    OnFocusChanged = ListFocusChanged
    OddColor = 12437200
    OnCDataListReloadTree = ListCDataListReloadTree
    Columns = <>
    WideDefaultText = ''
  end
  object ButtonPanel: TPanel [3]
    Left = 0
    Top = 237
    Width = 443
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 1
    object CButtonAdd: TCButton
      Left = 8
      Top = 8
      Width = 100
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAdd
    end
    object CButtonEdit: TCButton
      Left = 128
      Top = 8
      Width = 100
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionEdit
    end
    object CButtonDelete: TCButton
      Left = 256
      Top = 8
      Width = 100
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDelete
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 168
    Top = 80
  end
  object ActionListButtons: TActionList
    Left = 16
    Top = 160
    object ActionAdd: TAction
      Caption = 'Dodaj'
      ImageIndex = 0
      OnExecute = ActionAddExecute
    end
    object ActionEdit: TAction
      Caption = 'Edytuj'
      ImageIndex = 1
      OnExecute = ActionEditExecute
    end
    object ActionDelete: TAction
      Caption = 'Usu'#324
      ImageIndex = 2
      OnExecute = ActionDeleteExecute
    end
  end
end