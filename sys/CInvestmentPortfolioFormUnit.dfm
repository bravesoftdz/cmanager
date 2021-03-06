inherited CInvestmentPortfolioForm: TCInvestmentPortfolioForm
  Left = 347
  Top = 245
  Caption = 'Inwestycja'
  ClientHeight = 265
  ClientWidth = 509
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 509
    Height = 224
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 473
      Height = 113
      Caption = ' Dane podstawowe '
      Enabled = False
      TabOrder = 0
      object Label4: TLabel
        Left = 28
        Top = 72
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto inwestycji'
      end
      object Label1: TLabel
        Left = 55
        Top = 33
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'Instrument'
      end
      object Label2: TLabel
        Left = 287
        Top = 33
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object CStaticAccount: TCStatic
        Left = 112
        Top = 68
        Width = 337
        Height = 21
        Hint = '<wybierz konto z listy>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto z listy>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto z listy>'
        HotTrack = False
      end
      object CStaticInstrument: TCStatic
        Left = 112
        Top = 29
        Width = 153
        Height = 21
        Hint = '<wybierz z listy>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz z listy>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz z listy>'
        HotTrack = False
      end
      object EditType: TEdit
        Left = 328
        Top = 29
        Width = 121
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 40
        TabOrder = 2
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 144
      Width = 473
      Height = 73
      Caption = ' Aktualny stan '
      Enabled = False
      TabOrder = 1
      object Label15: TLabel
        Left = 30
        Top = 34
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'Posiadana ilo'#347#263
      end
      object Label6: TLabel
        Left = 281
        Top = 34
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Warto'#347#263
      end
      object CCurrEditValue: TCCurrEdit
        Tag = 1
        Left = 328
        Top = 30
        Width = 121
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 1
        Decimals = 4
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditQuantity: TCCurrEdit
        Tag = 1
        Left = 112
        Top = 30
        Width = 153
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 0
        Decimals = 6
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 224
    Width = 509
    inherited BitBtnOk: TBitBtn
      Left = 332
    end
    inherited BitBtnCancel: TBitBtn
      Left = 420
    end
  end
end