object SqlConsoleForm: TSqlConsoleForm
  Left = 242
  Top = 407
  Width = 715
  Height = 358
  Caption = 'Kosola Sql'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCanResize = FormCanResize
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 0
    Top = 145
    Width = 707
    Height = 2
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 707
    Height = 145
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    OnConstrainedResize = Panel1ConstrainedResize
    object RichEditCommand: TRichEdit
      Left = 0
      Top = 34
      Width = 707
      Height = 111
      Align = alClient
      BevelKind = bkTile
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
      OnKeyDown = RichEditCommandKeyDown
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 707
      Height = 34
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object PngSpeedButton1: TPngSpeedButton
        Left = 8
        Top = 4
        Width = 129
        Height = 25
        Action = ActionExecute
        Flat = True
      end
      object PngSpeedButton2: TPngSpeedButton
        Left = 144
        Top = 4
        Width = 129
        Height = 25
        Action = ActionOpen
        Flat = True
      end
      object PngSpeedButton3: TPngSpeedButton
        Left = 280
        Top = 4
        Width = 129
        Height = 25
        Action = ActionSave
        Flat = True
      end
      object PngSpeedButton4: TPngSpeedButton
        Left = 416
        Top = 4
        Width = 129
        Height = 25
        Action = ActionPrint
        Flat = True
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 147
    Width = 707
    Height = 184
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object RichEditResult: TRichEdit
      Left = 0
      Top = 0
      Width = 707
      Height = 184
      Align = alClient
      BevelKind = bkTile
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      PlainText = True
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        ContextItems = <
          item
            Caption = 'Action1'
          end>
      end
      item
        Items = <
          item
            Action = ActionExecute
            ShortCut = 116
          end>
      end>
    Images = PngImageList
    Left = 624
    Top = 8
    StyleName = 'XP Style'
    object ActionExecute: TAction
      Caption = 'Wykonaj'
      ImageIndex = 0
      ShortCut = 116
      OnExecute = ActionExecuteExecute
    end
    object ActionOpen: TAction
      Caption = 'Wczytaj skrypt'
      ImageIndex = 1
      OnExecute = ActionOpenExecute
    end
    object ActionSave: TAction
      Caption = 'Zapisz wynik'
      ImageIndex = 3
      OnExecute = ActionSaveExecute
    end
    object ActionPrint: TAction
      Caption = 'Drukuj wynik'
      ImageIndex = 2
      OnExecute = ActionPrintExecute
    end
  end
  object PngImageList: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1300000B1301009A9C180000012F694343505068
          6F746F73686F70204943432070726F66696C65000078DAAD8EBD4AC3501C47CF
          6D45C121880437E1E2202EE2C7D631694B111C6A1449B235C9A58A36B9DC5C3F
          3AF9123E84838BA3A06F5071109C7C0437411C1C1C22647010C1339DFF19FEFC
          A0B1E275FC6E630E46B93541CF976114CB9947A66902C0202DB5D7EF6F03E445
          AEF8C1FB3302E069D5EBF85DFEC66CAA8D053E81CD4C95298875203BB3DA82B8
          04DCE4485B1057806BF68236883BC019563E019CA4F217C0316114837805DC61
          18C5D0007093CA5DC0B5EADC02B40B3D3687C3032B375AAD96F4B2225172775C
          5A352AE5569E1646176660550654FBAADD9ED6C74A063D9FFF258C6259D9DB0E
          02100B93BAD5A427E6F45B8578F8FDAE7F8CEFC10B60EAB66EFB1F70BD068BCD
          BA2D2FC1FC05DCE82FF1C0503DFA8BE6E6000002BA4944415478DA63644000A6
          F0F070F9952B57DEDFB57DD7B2D68ED689FFFFFFBFF5F9F367D6F3E7CFBF62C0
          0118610C5120D8BFFFC8C5FB0F9F3E95929431FEF1E3CB5D097111DEFAFADAAE
          254B16F6E135A0BCBC3AD9C4C4DC939B5F2298978F8F818B9D0D2CC9C9C5C170
          EDEAB913EFDE7C39959616510714FA88D5001F9FC0C286E6897DEFDEBD056AE2
          6278F9E2F95F3E3E3E2676760E461E6E3E861DDB379EADAECA36032AFD87CD00
          E1AEEE19533475CC220404F81876EDDC76B5B9212FD8D327AAB4A4B436F9E58B
          D70CEFDEBD7EB26CF1B4F863C7F6EEC330404C4CCCBCA165FA5E4949056E1161
          7E86EBD7CE9E494B09372D2EAE6A0C0E4DA97BF5FA0DC3E327CF18E6CCE8A8B8
          78F14427562F5859B9E434B64C9DCCCBCD020C4C2106561686377FFFFEE7FFFC
          F92BEBC7AFBF18162D5A7078F6F4663B9C81E8E21132D5C4C83A2C28D85F4441
          5692E1F7AF3F0CCC2C2C0CBFFFFC6158BA7CCDFBD3A74EDD5BBB7ABAC7D2A52B
          0CA2A3238E585959FD3B76ECD82FE46864E4E2E232A8AE9F795A415E9C514555
          89E9EDEB37FF6EDF7BCAD4DFD35CE4EF6DCF6D6DE7E2AAA9A96DFCE4D9A373B7
          6F5EBB93979B9584920E8040404C4C36F0D5ABC7A73D7C12E6DDBF77FDC8CD6B
          273775754DAE3631B7D232D4D791E2E060052B7CF4E8E99765CB572C68AC2F2D
          6664C00E1480F83310BF6D6CEC599590941E7AF3E6CDEF0B172F38171D1963A2
          A2AACE3E6DDAC435137A1BC2701900068A8A6A361DDDB377CBC9CA739C3E7DF8
          4C5E4EACC59469CB2ECA2B686ADFBB77FB534F5F6D305E0340F9A3B8BCF3A0A3
          A397CD9FDFDFFE7171B23CFDF8E9A7F4BFFF4C4C5BB6ACDAB9787E9F2F410334
          B58DCAC323D3D22D2D6DE4BF7EFDCAC0C2CACA70E9E2F99773E7F4F7DDBF7365
          222103C0405DDDB054484444D5CEDECBEFCC99C3471F3F7E70F9D6F5730DE8B1
          4004E0346560F87E1DC8F8021301006B971BDD563F95D00000000049454E44AE
          426082}
        Name = 'PngImage0'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000003464944415478DAA5935B681C5518C7FF67A7BB89C9EC6A
          6897D5250CA96DC1A2455B5BA5A6566891C4528BED4B1111C460112A587CA9BD
          25B156A822880A3EF85041695F4A7D507CF1D6929426D80B659336DA4DB2B3D9
          C95E92BDCDCCCEEDCCCD6FA32F7DF0C9818FE11CCEF97DE7FB7FFF8F856188FF
          F3B1475FBF83FEAD6B6058217C625D9BACA03FD5446FC283E30016F71FEAEE8A
          9EEEEA8CEE5516B5ED74A4A259C0AA08309E71FF1B908EBBD05477E78675C9B3
          2FBFB47E7B22D1815367C6BFAAD6CDC3BFDC6400C12104607DAF4D9D7B7673B2
          C3FC173031513676A49BEFF5F5E0F0B6A7A5E303BBA4C4039D02380FF0FD4F39
          FDC2C5A9BD57EF46C63C4E10106070540E8FBCD38B9A06181E90BDADC199C997
          860E488F3CBEB107A609B45A7EFB2C6CEE61F8D3EB93E77FA81E0C43616105B0
          EF23593F79541295A500C5E926C4868AFD8312E271E11F0DA85ECE7DB8148B55
          1757AE29F8FCDCF4BBA57CE43C620C6CCF69591F3E2689B77E5EC2A6B887FE1D
          E9FB540E39E5A1ECEF7F2D2393F3904E75E25EB6AE1926BB7E2F53F4D9E088AC
          7F382C89E39775E43255AC5FB71AAEE3C2F37DF82E114898E9AC8A5C5380B449
          42C38E221AA352272A7E6EECD64DF6E2F0BCFEC9689F38F25905C9D0C5EE6DAB
          610B1134AD00AA1EA0D10A490712ACBB1B99857649B437DB0894CBB71902ED2C
          DB7D624E3F7174AD78ECD41CBE3BB916A6E3219A8A62AAC030FD5788593944A1
          1C62B9E4A2A1D4A0658B708AAA8228EF42CC7A8B0D8CCCEBCFBF90126749FD0F
          8EA4706586A35617209704CCCDF950166C141739D47C0DBCDEA02798212CAF80
          8E561D82F32A1B189DD7E30F46C53D5BE2483F91C08D1C909B71C16D0195B28F
          BCEC20FFA706BB46FD746DEA35015A4D1D31ED47B0E00DF6D89B33FAC60D71F1
          D0FE35E849C650AC01E545AABFEEA2A97A90E70D94971CB89603DF68C1310C28
          053DA896D4E388B08F59E7CE3FF4A183BDE2976F3F4C93D1EE1B19C60C483817
          A6C1C90BF4B738F4165F597332D3996F1463F2B7E55720B05F99B0654CBFF4C5
          93E2BEE7E2F7F5DFB57D9A050B2A85A6D9686A26016C18B68B432385ACAA989B
          69A20CB6EAA9DF1B5B9F498ADD1D1150EBC935E43A2F200065232BAE045DF21C
          0E8FB727D4C3B2EC7D0B0F43ED17FF0D3061DF54CC5DAC2F0000000049454E44
          AE426082}
        Name = 'PngImage1'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000002B54944415478DA75935F48536118C69FEFECACFD71A6630D168A8158
          366FB2220D3461B1A4896BA6ADDDD88D417619751F5D49A0DD490A0D4D09C396
          17852C2D1433BD91355844510851D8BA28754BB676FEF77D273726E9031F87F3
          72DEE73DEF737E87A0482E97ABC6E3F1B46017298AA2D9EDF63287C361EFEBEB
          BB434B1AAB93E287DADADAAE4E4F4F87B1876459C6E2E2E217AFD75B4B6FA51D
          064EA7F3E8E0E0E0836030D85CDCA4AA2A72B91C2449D2CFCACACAFBF6F6F613
          FF19343636FA9797979F1342C00E93A6691045513760D3E91A88C562BB1B3434
          34F8E6E65E454B4A6C85B2A64A10056A200A904489BE8D86D8DBF8EE06757575
          2DD1E8CC6B4BA913A24CF4E99A2A42A08D8220E9666623F0E963E29DDFEF3F96
          EF630646EA78A1B3F362E8547320F8618D47F97E2338A2FD0B4EA1A3640D82A4
          D275049CACDA4C3D1C1DBD4FB378333F3F3F4B7A7B7B6F0D0D0D0DB087BFFD54
          F168E62BCC26058AD1429B551A1C4B9F409179384A79DCBC74A010705757D715
          323939F982267F9E15D6D655DC9E58A5CB65C199F6C164E491CD6A486F2AD848
          71385D538E7BD75D05033A788244229197D4E91C2BAC6734DC18FB8C8CB08532
          2B4773003222904A01C91F0A7CC70F62E05AE5364384193C25E3E3E3B3A150A8
          359BCDC26CB6E0FB6F195B3909260381AA73001A2A901380430E13EC5699AE25
          C26AB581721321E17078361008B4663219C4E3716CA5372807DC0E02391A3543
          4356341CAE75A3A2A212168B1923232311323C3C3CD7D1D17136994CA2A7A787
          7E32A140601EA6BC18544D4D4DE8EFEF07CFF3CCE019E9EEEEBEEBF3F92EA7D3
          69C642557575B58151B7971616165294C85F56ABD530353535A673408FADBEBE
          DE1B8D469FE8006D4F35180C3AFFECCA449BB0B4B4B44A413AB34D62BA40A2CD
          663BE276BB3DECB765276F502C6ACCD1D5FE241289C77994FF02F5EA54920998
          1B920000000049454E44AE426082}
        Name = 'PngImage2'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1300000B1301009A9C18000002564944415478DA
          8D92BD4B726118C6AFC7CAD473028974A8A606911C9A243FF2A321706C89FE82
          C8F1150971508486105D0417451AA4A525706BCC459C8402919268E81352B13C
          99E5D77BEE477A79875E7B2F381CCEC373FFCE75DFF7C5CC66B37A6767A7FDFC
          FC8CA7A727B4DB6D6432197C7C7C80CE1E1E1E70777707AD568BC9C9495C5C5C
          40100444A3D15F9797970966B55A85EDED6DA9D168F0CB0448A5521C468052A9
          8442A1808D8D0D2C2F2F239FCF73D0F4F4348E8E8E54CC66B3099B9B9B1C707B
          7B8B4EA783783C8EFBFB7BD4EB757E76767686ADAD2D984C269C9C9C606A6A0A
          0A8502B95C4EE4008FC723BDBCBCE0E6E6865B0F87C3DCCDCCCC0C071C1F1FC3
          EBF5C26834229BCD42A95472C0E9E9A9C8EC76BBE076BBA566B3896AB58A5EAF
          079FCF078D4683F9F97994CB65249349F8FD7E2C2D2DE1F0F090031863D4CE08
          60B158A4CFCF4FFEB77EBF8FD5D555E8F57A0E2117F41E0E87A8542AB8BEBEC6
          C4C40477502C1645B6B6B626ACACAC4883C100DD6E172482D037890ABF4445F4
          D000E97D7E7E3E02180C06890E0281C09FC27F89EEC92BE4F7AEAEAE44E67038
          84C5C54589F64CBDB75AADB100CA40229100CD4CCEC70830373727CDCECE6277
          7797036840DF89DA114511E9741AB4F65AAD2632A7D329C84392640842A110CF
          C138A9542AECEFEF5331856E0490A72AE9743A048341BCBFBF8F75A056AB7170
          70C0532A0F5B642E974B787D7DE5804824C2013F3988C5621C20479A0334F2FA
          DE161616B0B7B7C793F83F2D3C3E3E523E842FAF56B90D41DEC4F0EFBD7F276A
          4FDE0093EDBFADAFAF17D94F053FE937948F2A98536C47700000000049454E44
          AE426082}
        Name = 'PngImage3'
      end>
    Left = 296
    Top = 42
    Bitmap = {}
  end
  object OpenDialog: TOpenDialog
    Filter = 'Skrypty sql|*.sql|Wszystkie pliki |*.*'
    FilterIndex = 0
    Left = 344
    Top = 24
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'Pliki tekstowe|*.txt|Wszystkie pliki |*.*'
    FilterIndex = 0
    Left = 384
    Top = 24
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 456
    Top = 56
  end
end
