inherited CAboutForm: TCAboutForm
  Left = 392
  Top = 335
  Caption = 'O programie'
  ClientHeight = 313
  ClientWidth = 377
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 377
    Height = 272
    object Image: TImage
      Left = 16
      Top = 16
      Width = 32
      Height = 32
      AutoSize = True
    end
    object Label1: TLabel
      Left = 56
      Top = 18
      Width = 58
      Height = 13
      Caption = 'CManager'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 56
      Top = 34
      Width = 81
      Height = 13
      Caption = 'wersja 2.2.2.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CButtonMail: TCButton
      Left = 257
      Top = 16
      Width = 97
      Height = 17
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Caption = 'mabaturo@wp.pl'
      OnClick = CButtonMailClick
      Color = clBtnFace
    end
    object CButton1: TCButton
      Left = 184
      Top = 32
      Width = 177
      Height = 17
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Caption = 'http://cmanager.sourceforge.net'
      OnClick = CButton1Click
      Color = clBtnFace
    end
    object RichEditContrib: TRichEdit
      Left = 16
      Top = 64
      Width = 346
      Height = 199
      TabStop = False
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelInner = bvNone
      BevelKind = bkTile
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'RichEditContrib')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  inherited PanelButtons: TPanel
    Top = 272
    Width = 377
    inherited BitBtnOk: TBitBtn
      Left = 200
    end
    inherited BitBtnCancel: TBitBtn
      Left = 288
    end
  end
end
