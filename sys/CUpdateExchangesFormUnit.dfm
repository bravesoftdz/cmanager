inherited CUpdateExchangesForm: TCUpdateExchangesForm
  Left = 201
  Top = 177
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tabela notowa'#324
  ClientHeight = 466
  ClientWidth = 656
  PixelsPerInch = 96
  TextHeight = 13
  object PanelButtons: TPanel
    Left = 0
    Top = 425
    Width = 656
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      656
      41)
    object BitBtnOk: TBitBtn
      Left = 479
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Zapisz'
      Default = True
      TabOrder = 0
      OnClick = BitBtnOkClick
    end
    object BitBtnCancel: TBitBtn
      Left = 567
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Anuluj'
      TabOrder = 1
      OnClick = BitBtnCancelClick
    end
  end
  object PanelConfig: TPanel
    Left = 0
    Top = 0
    Width = 656
    Height = 425
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 625
      Height = 401
      Caption = ' Notowania '
      TabOrder = 0
      object Label1: TLabel
        Left = 26
        Top = 32
        Width = 86
        Height = 13
        Alignment = taRightJustify
        Caption = 'Tryb importu walut'
      end
      object Panel1: TPanel
        Left = 24
        Top = 64
        Width = 577
        Height = 313
        BevelOuter = bvLowered
        Caption = 'Panel1'
        TabOrder = 0
        object Bevel1: TBevel
          Left = 1
          Top = 268
          Width = 575
          Height = 2
          Align = alBottom
          Shape = bsBottomLine
        end
        object Panel2: TPanel
          Left = 1
          Top = 270
          Width = 575
          Height = 42
          Align = alBottom
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 0
          object CButtonOut: TCButton
            Left = 293
            Top = 4
            Width = 140
            Height = 33
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = Action1
          end
          object CButtonEdit: TCButton
            Left = 428
            Top = 4
            Width = 141
            Height = 33
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = Action3
          end
        end
        object ExchangesList: TCList
          Left = 1
          Top = 1
          Width = 575
          Height = 267
          Align = alClient
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvRaised
          BevelKind = bkFlat
          BorderStyle = bsNone
          CheckImageKind = ckDarkTick
          DefaultNodeHeight = 24
          Header.AutoSizeIndex = -1
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'MS Sans Serif'
          Header.Font.Style = []
          Header.Height = 21
          Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
          Header.Style = hsFlatButtons
          HintMode = hmHint
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
          TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnGetText = ExchangesListGetText
          OnGetHint = ExchangesListGetHint
          OnGetNodeDataSize = ExchangesListGetNodeDataSize
          OnInitChildren = ExchangesListInitChildren
          OnInitNode = ExchangesListInitNode
          AutoExpand = True
          Columns = <
            item
              Position = 0
              Width = 300
              WideText = #377'r'#243'd'#322'o/Instrument'
            end
            item
              Position = 1
              Width = 150
              WideText = 'Data i czas'
            end
            item
              Alignment = taRightJustify
              Position = 2
              Width = 100
              WideText = 'Warto'#347#263
            end>
          WideDefaultText = ''
        end
      end
      object ComboBoxType: TComboBox
        Left = 120
        Top = 28
        Width = 481
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        MaxLength = 1
        TabOrder = 1
        Text = 'Podczas importu utw'#243'rz instrumenty, kt'#243'rych brak w bazie danych'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          
            'Importuj notowania tylko tych instrument'#243'w, kt'#243're znajduj'#261' si'#281' w' +
            ' bazie danych'
          'Podczas importu utw'#243'rz instrumenty, kt'#243'rych brak w bazie danych')
      end
    end
  end
  object ActionManager1: TActionManager
    Images = CImageLists.OperationsImageList24x24
    Left = 248
    Top = 232
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Zaznacz wszystkie'
      ImageIndex = 0
      OnExecute = Action1Execute
    end
    object Action3: TAction
      Caption = 'Odznacz wszystkie'
      ImageIndex = 2
      OnExecute = Action3Execute
    end
  end
end
