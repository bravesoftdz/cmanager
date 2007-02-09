inherited CPreferencesForm: TCPreferencesForm
  Left = 298
  Top = 289
  Caption = 'Preferencje'
  ClientWidth = 604
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 604
    object PanelMain: TPanel
      Left = 0
      Top = 0
      Width = 604
      Height = 398
      Align = alClient
      BevelOuter = bvNone
      Caption = 'PanelMain'
      TabOrder = 0
      object PanelShortcuts: TPanel
        Left = 129
        Top = 0
        Width = 475
        Height = 398
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 0
        object PanelShortcutsTitle: TPanel
          Left = 1
          Top = 1
          Width = 473
          Height = 21
          Align = alTop
          Alignment = taLeftJustify
          Caption = '  Kategorie'
          Color = clActiveCaption
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindow
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object PageControl: TPageControl
          Left = 1
          Top = 22
          Width = 473
          Height = 375
          ActivePage = TabSheetAutostart
          Align = alClient
          Style = tsFlatButtons
          TabOrder = 1
          object TabSheetBase: TTabSheet
            Caption = 'TabSheetBase'
            TabVisible = False
            object GroupBox1: TGroupBox
              Left = 8
              Top = 8
              Width = 449
              Height = 121
              Caption = ' Przy starcie systemu '
              TabOrder = 0
              object RadioButtonLast: TRadioButton
                Left = 16
                Top = 32
                Width = 209
                Height = 17
                Caption = 'Otwieraj ostatnio u'#380'ywany plik danych'
                Checked = True
                TabOrder = 0
                TabStop = True
                OnClick = RadioButtonLastClick
              end
              object RadioButtonNever: TRadioButton
                Left = 16
                Top = 80
                Width = 193
                Height = 17
                Caption = 'Nie otwieraj '#380'adnego pliku danych'
                TabOrder = 2
                OnClick = RadioButtonNeverClick
              end
              object RadioButtonThis: TRadioButton
                Left = 16
                Top = 56
                Width = 161
                Height = 17
                Caption = 'Otwieraj wybrany plik danych'
                TabOrder = 1
                OnClick = RadioButtonThisClick
              end
              object CStaticFileName: TCStatic
                Left = 192
                Top = 54
                Width = 241
                Height = 21
                AutoSize = False
                BevelKind = bkTile
                Caption = '<kliknij tutaj aby wybra'#263' plik danych>'
                Color = clWindow
                ParentColor = False
                TabOrder = 3
                TabStop = True
                Transparent = False
                TextOnEmpty = '<kliknij tutaj aby wybra'#263' plik danych>'
                OnGetDataId = CStaticFileNameGetDataId
                HotTrack = True
              end
            end
          end
          object TabSheetView: TTabSheet
            Caption = 'TabSheetView'
            ImageIndex = 1
            TabVisible = False
            object GroupBox2: TGroupBox
              Left = 8
              Top = 8
              Width = 449
              Height = 97
              Caption = ' Okno g'#322#243'wne '
              TabOrder = 0
              object CheckBoxShortcutVisible: TCheckBox
                Left = 16
                Top = 32
                Width = 145
                Height = 17
                Caption = 'Pasek skr'#243't'#243'w widoczny'
                TabOrder = 0
              end
              object CheckBoxStatusVisible: TCheckBox
                Left = 16
                Top = 56
                Width = 145
                Height = 17
                Caption = 'Pasek statusu widoczny'
                TabOrder = 1
              end
            end
          end
          object TabSheetAutostart: TTabSheet
            Caption = 'TabSheetAutostart'
            ImageIndex = 2
            TabVisible = False
            object GroupBox3: TGroupBox
              Left = 8
              Top = 8
              Width = 449
              Height = 233
              Caption = ' Powiadomienia o operacjach  '
              TabOrder = 0
              object Label4: TLabel
                Left = 265
                Top = 66
                Width = 39
                Height = 13
                Alignment = taRightJustify
                Caption = 'Ilo'#347#263' dni'
              end
              object Label1: TLabel
                Left = 352
                Top = 66
                Width = 78
                Height = 13
                Caption = '(w'#322#261'cznie z dzi'#347')'
              end
              object CheckBoxAutostartOperations: TCheckBox
                Left = 16
                Top = 32
                Width = 242
                Height = 17
                Caption = 'Powiadamiaj przy starcie systemu o planach na'
                TabOrder = 0
                OnClick = CheckBoxAutostartOperationsClick
              end
              object ComboBoxDays: TComboBox
                Left = 264
                Top = 28
                Width = 169
                Height = 21
                BevelInner = bvNone
                BevelKind = bkTile
                Style = csDropDownList
                ItemHeight = 13
                ItemIndex = 0
                TabOrder = 1
                Text = 'Dzi'#347
                OnChange = ComboBoxDaysChange
                Items.Strings = (
                  'Dzi'#347
                  'Jutro'
                  'Ten tydzie'#324
                  'Przysz'#322'y tydzie'#324
                  'Ten miesi'#261'c'
                  'Przysz'#322'y miesi'#261'c'
                  'Okre'#347'lon'#261' ilo'#347#263' kolejnych dni')
              end
              object CIntEditDays: TCIntEdit
                Left = 312
                Top = 62
                Width = 33
                Height = 21
                BevelKind = bkTile
                BorderStyle = bsNone
                TabOrder = 2
                Text = '0'
              end
              object CheckBoxAutoIn: TCheckBox
                Left = 16
                Top = 104
                Width = 313
                Height = 17
                Caption = 'Powiadamiaj o zaplanowanych operacjach przychodowych'
                TabOrder = 3
              end
              object CheckBoxAutoOut: TCheckBox
                Left = 16
                Top = 152
                Width = 313
                Height = 17
                Caption = 'Powiadamiaj o zaplanowanych operacjach rozchodowych'
                TabOrder = 5
              end
              object CheckBoxAutoAlways: TCheckBox
                Left = 16
                Top = 200
                Width = 417
                Height = 17
                Caption = 
                  'Wy'#347'wietlaj okno powiadomienia nawet gdy nie ma '#380'adnych informacj' +
                  'i'
                TabOrder = 7
              end
              object CheckBoxAutoOldIn: TCheckBox
                Left = 16
                Top = 128
                Width = 313
                Height = 17
                Caption = 'Powiadamiaj o zaleg'#322'ych operacjach przychodowych'
                TabOrder = 4
              end
              object CheckBoxAutoOldOut: TCheckBox
                Left = 16
                Top = 176
                Width = 313
                Height = 17
                Caption = 'Powiadamiaj o zaleg'#322'ych operacjach rozchodowych'
                TabOrder = 6
              end
            end
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 129
        Height = 398
        Align = alLeft
        BevelOuter = bvLowered
        Color = clWindow
        TabOrder = 1
        object CButton1: TCButton
          Left = 16
          Top = 40
          Width = 100
          Height = 57
          Cursor = crHandPoint
          PicPosition = ppTop
          PicOffset = 10
          TxtOffset = 15
          Framed = False
          Action = Action1
        end
        object CButton2: TCButton
          Left = 16
          Top = 112
          Width = 100
          Height = 57
          Cursor = crHandPoint
          PicPosition = ppTop
          PicOffset = 10
          TxtOffset = 15
          Framed = False
          Action = Action2
        end
        object CButton3: TCButton
          Left = 16
          Top = 184
          Width = 100
          Height = 57
          Cursor = crHandPoint
          PicPosition = ppTop
          PicOffset = 10
          TxtOffset = 15
          Framed = False
          Action = Action3
        end
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 127
          Height = 21
          Align = alTop
          Alignment = taLeftJustify
          Caption = '  Kategorie'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  inherited PanelButtons: TPanel
    Width = 604
    inherited BitBtnOk: TBitBtn
      Left = 427
    end
    inherited BitBtnCancel: TBitBtn
      Left = 515
    end
  end
  object ActionManager1: TActionManager
    Images = CategoryImageList
    Left = 225
    Top = 272
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Podstawowe'
      ImageIndex = 0
    end
    object Action2: TAction
      Caption = 'Widok'
      ImageIndex = 1
    end
    object Action3: TAction
      Caption = 'Powiadamianie'
      ImageIndex = 2
    end
  end
  object CategoryImageList: TPngImageList
    Height = 24
    Width = 24
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000067649
          44415478DA95557B7054D519FFCED9BB77EFDDBBCF244B24244202A80331C81F
          11B5545A02033EAA829D38A330D3A93823A0526C6DF9033A3E98A96D07C73A3A
          8EE323BEEAA3A90E0F03541443789820C484900412B27927FBCADEDDBB8F7BF7
          3ECEE95908290CA8F49B39735EDFF7FDBE73CEEF3B1F82ABC8238DB46494C20D
          39676EBAAD474B1E59EBDB5BF30EB5650AA18A6BA7A64960A8F9599C846B1074
          B5C5D59FD1AD912A78212800148473A6EF5F43B504B923CAEAC05BA98C0DBBD5
          DC111AD45FEA7CD2D379CD008F1EA66E19419D63185E8A4553F7F14BF8CDFB0B
          1C3C6703B849CE851D1652FA9CDCCC04607E8646403A786673F753F35FBE2680
          87BFA0D7F7155A3BBF9F635B5816D789F7FB740C2DF5FB4EE6109FD7E0750A36
          83526A016808A30266E36E8A243C843C91327C2BB109239916F5D5F0A705A357
          05786837DD305E4EFE3658849D83065BC3173685B441DD5D32728D67A9DD2094
          0042EA341159650574C2674745119D66DD3CB2A54C08F493FAE8D7EAB6F8C7FE
          B357003CB88BAE773B8DBF9B1211DB67F2D061222C1826BDFEC018158232064A
          81E63509056C630389A7DC0D01E364798007ED82A305B9DC68FF8E8EF5CA97D5
          0D79CD2980073EA00E13CC3F8982F634E741F6130B24B1979DA2A22B6DCEE856
          82C425854C4D69C3766701C6788695532AA96505A86E001790C8A992EB70C6C6
          41E0F381EF52CD476BD5936B86995F6B0A60F9D7E457B2D37C41C9A825C8C7E1
          F075CEC204DB58D4669CC567DA1E6DFEE3EDED94583A5B321D45A5B87A47F32A
          4E703C4E4CFD17C834B1E196AC76C18F254A74E974EACBF4A0AD29DA633B085F
          B95ACF03DCDD485EEB9D031BFAD96D9964129BBDC11D41683CF64BB49CCDE8A5
          11553CB205CA6B9F998939EB0DC06805C7EEAF9F78A157E7916011D03354AF48
          5B07CEBE79FCB7D0F6F308FAF517D6B1F87CBAA893C38029420ABB9E0C73579E
          A3DFCE3938B4F2C0A659CA0F51F0FED64C070BA652C881F169D0693F1F0A0BD2
          A1E572F6FDC3DBD24DCFEF40AB3ED13B3028372508A19297C79159123D81388E
          4513BF7150DB74F25EE9C31F02589BA4358646F6883A11DF6DE418010066EB19
          90477286DE2BBF9EDCFBCC1674579D7A58190E2F4E2826F80322AD5E5668EC14
          1DDC900E78B606037333B0AAA106B55D0D601DA5159A02EF8959BAF8CD7D8CDD
          0E8079E782834387427B9591A6F780D10A2D792DF5A212921F332D2A94CE710B
          3E09517D9E0B7F96E510B088E667C12854AD5B9B567057803C46A9A0CBF42FB1
          6EBAB1A11BDBF3FAC5A198063D034F86BBC4DDD052194177BE61961AA9CC3243
          D55D2E0F7D7EE62D2E6F934740FD2A42E79F96DD6BA94E07FC1EF4EECD0EA8FF
          6801EABA08B0B18D96F565C9DBCD03687922C3F2C3BC9059C56066D58EC8C7CA
          77F1AD17FFA27C4F97FE2334ECBF775AE9AE08639431992EE68526310D96CA9D
          B32588961602E418787F3F786349A84AEB60C36C7E47094030061067B6AED170
          57B4FEE89AA9CFAE6ABBB1A2480CBFECABF64F3B2288BE0ACB82B96389CCAC00
          6FFF4877E1A48EF9983A09684CF69327CC8F6FF5EB96D5DC677A8A841C9A1570
          0D77CAFFEC7D7BEBD40960FEB6C4FB4585EA1A0706ADA052B252C7E36257BF86
          45AF1DDD5EE592C74AFCC2BE985DCC3B9B66678D3DA89BE54B4F1460220D5053
          A8D2C18341128AE8592D8D062C25F82C3DF1E07FFE07F09CB64DE222EB31679B
          5EEE02737FD304299E21E8BCD3E12A7383665F18D076C6451FCFA2FE994B9569
          CF84483503B91694EAFB06EDEEE92E46A9F0F0F8B17D9188259F7A02BAFFD00B
          863C7159C199BD39FE8A5B4ADF65646959349CAA3734E39CC5714BFFBCB664D1
          69A753FF2424B87DCCA2321523A79A4268C93C275A748B57DFA3F86D6306C278
          44D6B56F5B360CEEBEFBDFCC9D7259C1C94BD9E3235E04E47E4353CBA23BEFAB
          33136763704F70EB8BEBA42D4984E9714D3003454E94ED0AE9071A4264436DB1
          9703428A2ABCD6E1E349ADA7436D3C73E89DED30FCD7D68B3FEA1525D339B716
          A9030D1C35F2BC031D3F107D68E33D5A5D4BAF26A634CBE0394E97FB22F543E7
          063EBF6DF1C20F57DEE9F31C6A9553DF1CD54EC3F8AE4D30B4FD0C502B75593D
          F83171AC8ECDF3F3A3754874546204283EAEB6A8A3EDDBE1D46F0EF3CBBB9612
          A23E6D6A68144EAF7B0E92AD13CC2475A9FD4F02E405D774DE464C5A6D03B9D8
          CAE93168AE799F2D2761D91807E1DD1EE8FC9D0144CB93373B49DCFF0F604A2A
          7E2F41780F824C8F369909177D20B8A48A5D2AFF0546223617F50AA343000000
          0049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B1200
          000B1201D2DD7EFC0000000774494D45000000000000000973942E000002BD49
          44415478DAB5957948146118C69FD9ACF558512A5D6FC948C4D074B5BC30C242
          3484288B2893C48AA2880E108910F5DF88A2F08F02C9400AA2C334DD95525B88
          2C330F8A2C520B49DD5557D43CD6D963BEBE996FCBDDE80099FDE065DE993FDE
          87E7797F33C3C1CD8773BB80CFE19A047F6FE5557F6F4F59074F2F2CD2E2CF71
          C9A54DA4604BC2B2072DF076F0560205CD627CC60AC3A4055BE3FC60B513DCED
          EC051773BA896842D7FFCA8A38E5F6BF5EA0CDD4AC0D69B1BE30F3022C54A867
          600E3525D168E99EC6656D17B8A0E20612A18A58B603410042D6AC4278801226
          EA606CCA8AE46815BD5AF07CE0333875711D498D0A464CA4122B14F2ECDC4EAD
          7D1AE2F1FA8B015CF0913A52BE3709C773C26519FEF3DC6CFE86CA0734A2B063
          8FA9800647B3E515A87E2A0A74838B3C514F2AF23528DA1186D9513DBEB61E80
          6057511AC2109F5504537F1594BE26B65941F4EF28DB6F6565D70F8346E45F31
          E376CB302A1E5281A893A240120AB342313BA4C7F7BE6BF0A4EF44C75B233651
          012F7F2356AF6B6643795A0BB4161D35EFB837D39A63BDB6BB173B2F4DA1B66D
          840AD088369C6A90222AD8168AF17E3DDA6FEDA6C316A154A722222E07831D55
          58E935BCE4C0E670E0DC3B39A2AF010EDD20B8A31F6111C59C69901CECCF0C91
          7507F75E8C32071BCF3E9128DA97112CABC0FD97064651FCF94629A23D69F20A
          3C7A65601125963491721AD1AE1435A3A8CD4191E90F1491BF10243EB3B85254
          DF31864A31A2E4522D15D0206FB39A51F49151F4A6D32809B8506471A2C8ECA0
          C8EC4A91AEAB17B994A2C64E51803A48B9A0951CE426052E5124508A02FF4191
          E0E4C4EEDA4FF28C225DD73873907E512709642706C8BA83673D138CA2CCB266
          69C9DBE3E515687D37C1969C51A62585E9B130CDCFC1267E7B65381E0A05D6FA
          A850DBDE07CEE360F5F5203F9F3877FC328D33F3EFDDFFD377B7C00F81D76846
          E8A838D60000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000005E549
          44415478DAB5557B50547514FE7EF7B5BBDCDD855D4044791468B4016ABE7214
          490DD18629B39934B1B4981E9AA958A395CF4A9BD422682AC73F444D7174344A
          6D281531C812B5C047884F141F88222CCBEEB2ECEE7DF5BB6A9AAF9A66ECCC9C
          7FEE9C73BEF3F87EDF25B84FC6463FCA114660E5867D81BF7F27F70B60D0B839
          232CA1E162E9D68DDB948B7B7DF711C01E92F1DADCECB75F7F7E4EB3CB2717AD
          DB94BB7DE57B25FF08608943F89333D2F32D21A166689AC6100286053975F644
          53D9C2E3D36988BE06A67FF6A2017DFAF47D27FDB1D49116030403CF636F6D43
          D3EAC2C29175655F1EA431DA5D011ECC343F3B33EFDDE2302E1CB436585A5D81
          848DBF7CEDFB2E67FF03B0A5047A3F3D39AB7FEF947989F15D1C461EE058029E
          21301A04ECDC5B5BBA63FB8FD32FEE2A387A37002663BE237FEC9809D3884213
          09439359B4069AB176FB5AE7A1CF230627674D7BD591FCC8B828BB394AE06861
          8EA54EC031349E82C88A162CDD5DB5FEA71F36CFBA03C094C0C4BDB8F4896F52
          127AF603540A400BB01CEA5A6BB0794BF549C9F995FA40B7B824D108D8CC3C04
          81838167E89484EE5B435052517BAE0D87CF78E0395EBEE40E80A4B1D6E15939
          830BA36C91B17A92DE913EFE1F8DFBD56D459E3D6E69451AC34A888EB1E2E144
          3B38DA364BA7941415DE0E09F5E75D6838EF81CAF0089CA9D87A3B0019F159D4
          D49E7D933EB618CD217A4F3CCB8061541CACAB7697AF747FD470FC9904D6C0DB
          7B8C7E6958547C7C38C35E2B21C92AFC0105C776EFBE78E5C0CE72CA0A169E73
          1584EFDCCB943A306B745464441A212A2F74750F0A89240EDE7604298E567A38
          1E6EF522AA7FABAFAEDAE2C93EBF553DEE18333BA37BD6A442A3D91CA74FA09B
          2CC970367BB59AE2E59F5E2A5DFCCE75866AA473DAA4C4ACAC516BFAF57C78A0
          1ECB6880BF83C1C6539F2039B3884E40E0F505B4BA4A69C3FE7C795A7B93AD75
          C4C2E2A9518E3E8BCCA251D4011455BBDAFDE92327DD47BE5F9BD354B6B4F8C6
          4A1E9B583074E0A0F44DDDE23A85EB47D257D2D8AC6043D53CF591216B247A02
          04FDC457FF333E3CB84C5DD63535534C7FEBD3FC98EEC913C24318C2B340870C
          3479341CAAF8E57075F1AAF19EAA553537001E9FBCFC83E1A3C6CF371BF44379
          29EFBD38D5E8C78665B38A4CBE1D5B6808B95C136C5065D4D27857E6DCD5C98E
          B4B4F58E87125363C46B45AE50613876C9AFFD5A525AB4A7E08D5CD57BC179F3
          A8B92B360E1BF5C2730C65C1E5603EC22CCD50140E8AB7E1B43584BD1C605C28
          5C5432FBF44EB55C4F189BB7F9E91EE943D775EB2C9AE343E93AE95BB9D0061C
          AC777A776DD8B4A07AF9942FF49BDF00E83F69F556C790ECA7021D2D888D7913
          03127A42A087157801022BC0A59D45EE8B79D967CBB4F57A42C2E8C593637B0F
          FFCA162690300B0F5E60F5678C36B7FB5CE59A25AF9CFF797DE92DB4EC3E72DA
          CCF85E992360F83DA657E6B7490E5B7F88820881A30F88E3D112A843E11725F3
          62BB99AA3515A8ABB1F472B9BA64311C6FE0058197FD9CDBEFB4D54A7EB9F65C
          65C95A48EDCE5B00A887EADE6706BB2075347222F84EE862894584291A21BC05
          AA16C495B6C6004338CA150D2A3D8622CB9AA21004148DD41CABAB3B50D63CB1
          B648ABB9BE1AED76009822D129238FFD263A41196CE44027E01066B22254E802
          33170D910FA7526000A1DAA8683224B5037ED943F5C9898ACA9367AB2ABCCFD6
          AF52AAEF269C5701BA8FE13206BCAC14DAED8813299B448187854E62E26D3030
          567A0B110C61E93432EDDA4369D98A76A5092DED2E946FD37EAF2961C7BB774B
          27EE05407ACC60739286212FD216126A358AB01AECB019A361162260E6A9DE10
          13A570103EC90D77A0051EEA6DC16634381BB57D3BFCEB4EAE5373954B5ACB3D
          01625F61A784F55017DB2339D16AE560117998AF2B254B382A030C7C1D0A3C1E
          19AD2E092E974C5D426B8BEC433D79DFB9452A40F02635EF00B0A7B143C4446D
          92498485FE2FC01B40694A65E39ACCD07741AF47D3A520E5BD9FFECEE8FF2CD0
          0112EC20978247B582F613EA21DCC3FE5253C37536B1F86FA677EDD2B5EEDF00
          FE37FB138923613760AC8B400000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    Left = 529
    Top = 200
    Bitmap = {}
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'dat'
    Filter = 'Pliki danych|*.dat|Wszystkie pliki|*.*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 8
    Top = 85
  end
end
