inherited CCurrencyRateFrame: TCCurrencyRateFrame
  inherited FilterPanel: TPanel
    object Label4: TLabel [1]
      Left = 362
      Top = 4
      Width = 12
      Height = 13
      Caption = 'do'
    end
    object Label5: TLabel [2]
      Left = 430
      Top = 4
      Width = 3
      Height = 13
      Caption = ')'
    end
    object Label3: TLabel [3]
      Left = 289
      Top = 4
      Width = 15
      Height = 13
      Caption = '(od'
    end
    inherited CStaticFilter: TCStatic
      Caption = '<wa'#380'ne dzi'#347'>'
    end
    object CDateTimePerStart: TCDateTime
      Left = 306
      Top = 4
      Width = 56
      Height = 14
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '2006-01-01'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
    end
    object CDateTimePerEnd: TCDateTime
      Left = 376
      Top = 4
      Width = 55
      Height = 14
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '2006-01-01'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerEndChanged
      HotTrack = True
    end
  end
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 100
        WideText = 'Data wa'#380'no'#347'ci'
      end
      item
        Position = 1
        Width = 250
        WideText = 'Opis'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 93
        WideText = 'Kurs'
      end>
    WideDefaultText = ''
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 112
    Top = 88
  end
end
