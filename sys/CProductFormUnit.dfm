inherited CProductForm: TCProductForm
  Caption = 'Kategoria'
  ClientHeight = 360
  ClientWidth = 372
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 372
    Height = 319
    object GroupBox2: TGroupBox
      Left = 16
      Top = 104
      Width = 337
      Height = 209
      Caption = ' Dane kategorii '
      TabOrder = 0
      object Label1: TLabel
        Left = 15
        Top = 32
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object Label2: TLabel
        Left = 27
        Top = 68
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opis'
      end
      object Label5: TLabel
        Left = 60
        Top = 172
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Jednostka miary'
      end
      object EditName: TEdit
        Left = 56
        Top = 28
        Width = 257
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 0
      end
      object RichEditDesc: TCRichedit
        Left = 56
        Top = 64
        Width = 257
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
      end
      object CStaticUnitdef: TCStatic
        Left = 144
        Top = 168
        Width = 169
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<bez jednostki miary>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<bez jednostki miary>'
        OnGetDataId = CStaticUnitdefGetDataId
        HotTrack = True
      end
    end
    object GroupBoxAccountType: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 73
      Caption = ' Rodzaj kategorii '
      TabOrder = 1
      object ComboBoxType: TComboBox
        Left = 24
        Top = 31
        Width = 289
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Rozch'#243'd'
        Items.Strings = (
          'Rozch'#243'd'
          'Przych'#243'd')
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 319
    Width = 372
    inherited BitBtnOk: TBitBtn
      Left = 195
    end
    inherited BitBtnCancel: TBitBtn
      Left = 283
    end
  end
end
