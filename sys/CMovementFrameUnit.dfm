inherited CMovementFrame: TCMovementFrame
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 86
    Width = 443
    Height = 2
    Cursor = crVSplit
    Align = alBottom
  end
  object PanelFrameButtons: TPanel [1]
    Left = 0
    Top = 88
    Width = 443
    Height = 189
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 0
    object Bevel: TBevel
      Left = 0
      Top = 146
      Width = 443
      Height = 3
      Align = alBottom
      Shape = bsBottomLine
    end
    object Panel1: TPanel
      Left = 0
      Top = 149
      Width = 443
      Height = 40
      Align = alBottom
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 0
      object CButtonOut: TCButton
        Left = 13
        Top = 4
        Width = 124
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionMovement
      end
      object CButtonEdit: TCButton
        Left = 260
        Top = 4
        Width = 77
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionEditMovement
      end
      object CButtonDel: TCButton
        Left = 348
        Top = 4
        Width = 77
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionDelMovement
      end
      object CButton1: TCButton
        Left = 133
        Top = 4
        Width = 124
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionAddList
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 443
      Height = 21
      Align = alTop
      Alignment = taLeftJustify
      Caption = '  Sumy przychod'#243'w/rozchod'#243'w w wybranym okresie'
      TabOrder = 1
    end
    object SumList: TCList
      Left = 0
      Top = 21
      Width = 443
      Height = 125
      Align = alClient
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvRaised
      BevelKind = bkFlat
      BorderStyle = bsNone
      DefaultNodeHeight = 24
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Height = 21
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      Header.PopupMenu = VTHeaderPopupMenu
      Header.Style = hsFlatButtons
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TabStop = False
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnCompareNodes = SumListCompareNodes
      OnGetText = SumListGetText
      OnGetHint = TodayListGetHint
      OnGetNodeDataSize = SumListGetNodeDataSize
      OnInitChildren = SumListInitChildren
      OnInitNode = SumListInitNode
      AutoExpand = True
      Columns = <
        item
          Position = 0
          Width = 200
          WideText = 'Konto'
          WideHint = 'Nazwa kontrahenta'
        end
        item
          Alignment = taRightJustify
          Position = 1
          Width = 130
          WideText = 'Rozch'#243'd'
        end
        item
          Alignment = taRightJustify
          Position = 2
          Width = 130
          WideText = 'Przych'#243'd'
        end
        item
          Alignment = taRightJustify
          Position = 3
          Width = 130
          WideText = 'Saldo'
        end
        item
          Position = 4
          Width = 10
          WideText = 'Waluta'
        end>
      WideDefaultText = ''
    end
  end
  object TodayList: TCList [2]
    Left = 0
    Top = 21
    Width = 443
    Height = 65
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkFlat
    BorderStyle = bsNone
    ButtonStyle = bsTriangle
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
    Images = CImageLists.MovementIcons16x16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnBeforeItemErase = TodayListBeforeItemErase
    OnCompareNodes = TodayListCompareNodes
    OnDblClick = TodayListDblClick
    OnFocusChanged = TodayListFocusChanged
    OnGetText = TodayListGetText
    OnPaintText = TodayListPaintText
    OnGetImageIndex = TodayListGetImageIndex
    OnGetHint = TodayListGetHint
    OnGetNodeDataSize = TodayListGetNodeDataSize
    OnInitChildren = TodayListInitChildren
    OnInitNode = TodayListInitNode
    AutoExpand = True
    Columns = <
      item
        Alignment = taRightJustify
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        WideText = 'Lp'
      end
      item
        Position = 1
        Width = 143
        WideText = 'Opis'
        WideHint = 'Nazwa kontrahenta'
      end
      item
        Position = 2
        Width = 100
        WideText = 'Data'
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 100
        WideText = 'Kwota'
      end
      item
        Position = 4
        WideText = 'Waluta'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 5
        Width = 150
        WideText = 'Rodzaj'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 6
        WideText = 'Status'
      end>
    WideDefaultText = ''
  end
  object Panel: TPanel [3]
    Left = 0
    Top = 0
    Width = 443
    Height = 21
    Align = alTop
    Alignment = taLeftJustify
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 4
      Width = 61
      Height = 13
      Caption = 'Typ operacji:'
    end
    object Label1: TLabel
      Left = 146
      Top = 4
      Width = 85
      Height = 13
      Caption = 'Okres wykonania:'
    end
    object Label3: TLabel
      Left = 417
      Top = 4
      Width = 15
      Height = 13
      Caption = '(od'
    end
    object Label4: TLabel
      Left = 490
      Top = 4
      Width = 12
      Height = 13
      Caption = 'do'
    end
    object Label5: TLabel
      Left = 558
      Top = 4
      Width = 3
      Height = 13
      Caption = ')'
    end
    object Label6: TLabel
      Left = 288
      Top = 4
      Width = 32
      Height = 13
      Caption = 'Kwoty:'
    end
    object CStaticPeriod: TCStatic
      Left = 211
      Top = 4
      Width = 90
      Height = 15
      Cursor = crHandPoint
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<tylko dzi'#347'>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      TabStop = True
      Transparent = False
      DataId = '1'
      TextOnEmpty = '<tylko dzi'#347'>'
      OnGetDataId = CStaticPeriodGetDataId
      OnChanged = CStaticFilterChanged
      HotTrack = True
    end
    object CStaticFilter: TCStatic
      Left = 73
      Top = 4
      Width = 74
      Height = 15
      Cursor = crHandPoint
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<dowolny typ>'
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
      DataId = '@'
      TextOnEmpty = '<dowolny typ>'
      OnGetDataId = CStaticFilterGetDataId
      OnChanged = CStaticFilterChanged
      HotTrack = True
    end
    object CDateTimePerStart: TCDateTime
      Left = 434
      Top = 4
      Width = 56
      Height = 14
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<wybierz dat'#281'  i czas>'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
      Withtime = True
    end
    object CDateTimePerEnd: TCDateTime
      Left = 504
      Top = 4
      Width = 55
      Height = 14
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<wybierz dat'#281'  i czas>'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
      Withtime = True
    end
    object CStaticViewCurrency: TCStatic
      Left = 321
      Top = 4
      Width = 88
      Height = 15
      Cursor = crHandPoint
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<waluta operacji>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 4
      TabStop = True
      Transparent = False
      DataId = 'M'
      TextOnEmpty = '<dowolny typ>'
      OnGetDataId = CStaticViewCurrencyGetDataId
      OnChanged = CStaticViewCurrencyChanged
      HotTrack = True
    end
  end
  inherited ImageList: TPngImageList
    Top = 144
  end
  object ActionList: TActionList
    Images = CImageLists.OperationsImageList24x24
    Left = 200
    Top = 112
    object ActionMovement: TAction
      Caption = 'Dodaj operacj'#281
      ImageIndex = 0
      OnExecute = ActionMovementExecute
    end
    object ActionEditMovement: TAction
      Caption = 'Edytuj'
      ImageIndex = 1
      OnExecute = ActionEditMovementExecute
    end
    object ActionDelMovement: TAction
      Caption = 'Usu'#324
      ImageIndex = 2
      OnExecute = ActionDelMovementExecute
    end
    object ActionAddList: TAction
      Caption = 'Dodaj list'#281
      ImageIndex = 0
      OnExecute = ActionAddListExecute
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 80
    Top = 120
  end
end
