inherited CInvestmentMovementForm: TCInvestmentMovementForm
  Left = 224
  Top = 103
  Caption = 'Inwestycja'
  ClientHeight = 689
  ClientWidth = 555
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 555
    Height = 648
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 521
      Height = 65
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label5: TLabel
        Left = 263
        Top = 28
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object Label3: TLabel
        Left = 35
        Top = 28
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data i czas'
      end
      object ComboBoxType: TComboBox
        Left = 304
        Top = 24
        Width = 193
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Zakup'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Zakup'
          'Sprzeda'#380
          'Przyj'#281'cie do portfela'
          'Wydanie z portfela')
      end
      object CDateTime: TCDateTime
        Left = 96
        Top = 24
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'  i czas>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        OnChanged = CDateTimeChanged
        HotTrack = True
        Withtime = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 472
      Width = 521
      Height = 169
      Caption = ' Opis '
      TabOrder = 2
      object CButton1: TCButton
        Left = 254
        Top = 126
        Width = 115
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionAdd
        Color = clBtnFace
      end
      object CButton2: TCButton
        Left = 372
        Top = 126
        Width = 129
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionTemplate
        Color = clBtnFace
      end
      object RichEditDesc: TCRichedit
        Left = 24
        Top = 28
        Width = 473
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
      end
      object ComboBoxTemplate: TComboBox
        Left = 24
        Top = 128
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 1
        Text = 'W/g szablonu'
        Items.Strings = (
          'W'#322'asny'
          'W/g szablonu')
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 96
      Width = 521
      Height = 361
      Caption = ' Szczeg'#243#322'y operacji '
      TabOrder = 1
      object Label4: TLabel
        Left = 12
        Top = 105
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto inwestycji'
      end
      object Label1: TLabel
        Left = 39
        Top = 69
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'Instrument'
      end
      object Label15: TLabel
        Left = 322
        Top = 141
        Width = 22
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ilo'#347#263
      end
      object Label2: TLabel
        Left = 14
        Top = 141
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'W/g notowania'
      end
      object Label6: TLabel
        Left = 242
        Top = 177
        Width = 103
        Height = 13
        Alignment = taRightJustify
        Caption = 'Warto'#347#263' jednostkowa'
      end
      object Label9: TLabel
        Left = 256
        Top = 214
        Width = 88
        Height = 13
        Alignment = taRightJustify
        Caption = 'Warto'#347#263' transakcji'
      end
      object Label8: TLabel
        Left = 43
        Top = 321
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria'
      end
      object Label20: TLabel
        Left = 266
        Top = 69
        Width = 78
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta notowa'#324
      end
      object Label22: TLabel
        Left = 38
        Top = 249
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = 'Przelicznik'
      end
      object Label17: TLabel
        Left = 280
        Top = 105
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta konta'
      end
      object Label21: TLabel
        Left = 264
        Top = 285
        Width = 80
        Height = 13
        Alignment = taRightJustify
        Caption = 'W walucie konta'
      end
      object Label7: TLabel
        Left = 26
        Top = 33
        Width = 62
        Height = 13
        Alignment = taRightJustify
        Caption = 'Szybki wyb'#243'r'
      end
      object CStaticAccount: TCStatic
        Left = 96
        Top = 101
        Width = 153
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 3
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto z listy>'
        OnGetDataId = CStaticAccountGetDataId
        OnChanged = CStaticAccountChanged
        HotTrack = True
      end
      object CStaticInstrument: TCStatic
        Left = 96
        Top = 65
        Width = 153
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz z listy>'
        OnGetDataId = CStaticInstrumentGetDataId
        OnChanged = CStaticInstrumentChanged
        HotTrack = True
      end
      object CStaticInstrumentValue: TCStatic
        Left = 96
        Top = 137
        Width = 153
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 6
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz z listy>'
        OnGetDataId = CStaticInstrumentValueGetDataId
        OnChanged = CStaticInstrumentValueChanged
        HotTrack = True
      end
      object CCurrEditValue: TCCurrEdit
        Tag = 1
        Left = 352
        Top = 173
        Width = 145
        Height = 21
        BorderStyle = bsNone
        TabOrder = 7
        OnChange = CCurrEditValueChange
        Decimals = 4
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrMovement: TCCurrEdit
        Left = 352
        Top = 209
        Width = 145
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 8
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CStaticCategory: TCStatic
        Left = 96
        Top = 317
        Width = 401
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kategori'#281' z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 11
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kategori'#281' z listy>'
        OnGetDataId = CStaticCategoryGetDataId
        OnChanged = CStaticCategoryChanged
        HotTrack = True
      end
      object CStaticInstrumentCurrency: TCStatic
        Left = 352
        Top = 65
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<brak instrumentu>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<brak instrumentu>'
        OnChanged = CStaticInstrumentCurrencyChanged
        HotTrack = True
      end
      object CStaticCurrencyRate: TCStatic
        Left = 96
        Top = 245
        Width = 401
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz przelicznik kursu z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 9
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz przelicznik kursu z listy>'
        OnGetDataId = CStaticCurrencyRateGetDataId
        OnChanged = CStaticCurrencyRateChanged
        HotTrack = True
      end
      object CStaticAccountCurrency: TCStatic
        Left = 352
        Top = 101
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<brak konta>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        TabOrder = 4
        TabStop = True
        Transparent = False
        TextOnEmpty = '<brak konta>'
        OnChanged = CStaticAccountCurrencyChanged
        HotTrack = False
      end
      object CCurrEditAccount: TCCurrEdit
        Left = 352
        Top = 281
        Width = 145
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 10
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CStaticPortfolio: TCStatic
        Left = 96
        Top = 29
        Width = 401
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz z portfela inwestycyjnego>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz z portfela inwestycyjnego>'
        OnGetDataId = CStaticPortfolioGetDataId
        OnChanged = CStaticPortfolioChanged
        HotTrack = True
      end
      object CIntQuantity: TCIntEdit
        Left = 352
        Top = 136
        Width = 145
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 5
        Text = '1'
        OnChange = CCurrEditQuantityChange
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 648
    Width = 555
    inherited BitBtnOk: TBitBtn
      Left = 378
    end
    inherited BitBtnCancel: TBitBtn
      Left = 466
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 48
    Top = 424
    StyleName = 'XP Style'
    object ActionAdd: TAction
      Caption = 'Wstaw mnemonik'
      ImageIndex = 0
      OnExecute = ActionAddExecute
    end
    object ActionTemplate: TAction
      Caption = 'Konfiguruj szablony'
      ImageIndex = 1
      OnExecute = ActionTemplateExecute
    end
  end
end
