inherited CPlannedFrame: TCPlannedFrame
  object PanelFrameButtons: TCPanel [0]
    Left = 0
    Top = 227
    Width = 435
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    PopupMenu = PopupMenuIcons
    TabOrder = 0
    IsFlatButton = False
    object CButtonDel: TCButton
      Left = 220
      Top = 4
      Width = 110
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDelMovement
    end
    object CButtonEdit: TCButton
      Left = 108
      Top = 4
      Width = 110
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionEditMovement
    end
    object CButtonOut: TCButton
      Left = 13
      Top = 4
      Width = 116
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionMovement
    end
  end
  object PlannedList: TCList [1]
    Left = 0
    Top = 0
    Width = 435
    Height = 227
    Align = alClient
    BevelEdges = [beBottom]
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkFlat
    BorderStyle = bsNone
    DefaultNodeHeight = 24
    Header.AutoSizeIndex = 1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Height = 21
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.PopupMenu = VTHeaderPopupMenu
    Header.Style = hsFlatButtons
    HintMode = hmHint
    Images = CImageLists.PlannedImageList16x16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnCompareNodes = PlannedListCompareNodes
    OnDblClick = PlannedListDblClick
    OnFocusChanged = PlannedListFocusChanged
    OnGetText = PlannedListGetText
    OnGetImageIndex = PlannedListGetImageIndex
    OnGetHint = PlannedListGetHint
    OnGetNodeDataSize = PlannedListGetNodeDataSize
    OnInitNode = PlannedListInitNode
    AutoExpand = True
    OnGetRowPreferencesName = PlannedListGetRowPreferencesName
    Columns = <
      item
        Alignment = taRightJustify
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        WideText = 'Lp'
      end
      item
        Position = 1
        Width = 185
        WideText = 'Opis'
        WideHint = 'Opis'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 2
        Width = 150
        WideText = 'Rodzaj'
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 150
        WideText = 'Kwota'
      end
      item
        Position = 4
        WideText = 'Waluta'
      end>
    WideDefaultText = ''
  end
  inherited ImageList: TPngImageList
    Top = 144
  end
  object ActionList: TActionList
    Images = CImageLists.CyclicImageList24x24
    Left = 200
    Top = 112
    object ActionMovement: TAction
      Caption = 'Dodaj plan'
      ImageIndex = 0
      OnExecute = ActionMovementExecute
    end
    object ActionEditMovement: TAction
      Caption = 'Edytuj plan'
      ImageIndex = 1
      OnExecute = ActionEditMovementExecute
    end
    object ActionDelMovement: TAction
      Caption = 'Usu'#324' plan'
      ImageIndex = 2
      OnExecute = ActionDelMovementExecute
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 80
    Top = 120
  end
  object PopupMenuIcons: TPopupMenu
    Left = 256
    Top = 168
    object MenuItemBigIcons: TMenuItem
      Caption = 'Du'#380'e ikony'
      Checked = True
      RadioItem = True
      OnClick = MenuItemBigIconsClick
    end
    object MenuItemSmallIcons: TMenuItem
      Caption = 'Ma'#322'e ikony'
      RadioItem = True
      OnClick = MenuItemSmallIconsClick
    end
  end
end
