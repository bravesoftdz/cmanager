inherited CStartupInfoForm: TCStartupInfoForm
  Width = 603
  Height = 427
  Caption = 'CManager - Informacje'
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 4
    Top = 4
    Width = 587
    Height = 392
    BevelOuter = bvLowered
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 352
      Width = 585
      Height = 39
      Align = alBottom
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 0
      object CButton1: TCButton
        Left = 448
        Top = 8
        Width = 121
        Height = 27
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action1
      end
      object CButton2: TCButton
        Left = 8
        Top = 8
        Width = 161
        Height = 27
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action2
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 585
      Height = 351
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 1
      object RepaymentList: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 585
        Height = 351
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
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag]
        Header.Style = hsFlatButtons
        HintMode = hmHint
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        Columns = <>
      end
      object PanelError: TPanel
        Left = 128
        Top = 56
        Width = 321
        Height = 89
        BevelOuter = bvNone
        Caption = 'Brak danych do utworzenia harmonogramu'
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object ActionManager1: TActionManager
    Images = PngImageList1
    Left = 469
    Top = 205
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Zamknij to okno'
      ImageIndex = 1
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Przejd'#378' do CManager-a'
      ImageIndex = 0
      OnExecute = Action2Execute
    end
  end
  object PngImageList1: TPngImageList
    Height = 24
    Width = 24
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B0D00
          000B0D01ED07C02C0000000774494D45000000000000000973942E0000055A49
          44415478DA95566B6C145514FEEECCECCEEE761F6577BB5DFAD8DA17A540295D
          50A228095179C71834E107C65F5650235143D41F44EB1FF0AF100C8A8F184592
          428824221840015BB148BBB4145A29140A2D7D6FBBAFEE6B66AE777668B74BEB
          83939C9DBBF79E73BE7BBE73EE9D21F80FF1BED6AA07941C80DA40291B53C2A6
          13A04A9028B1212FBE8DAB76070E1C98D59FFC4B60337B3CA9A9E205211E10C1
          9CF251121150F92E1BB710AA341AA8BF61013D1A6020F47F01B0E0052CE02E36
          5C05C1E426A25DB01A814A57180641C26DBF0977C64528D11109C9D01020DDE4
          E4899D3538F83BF391A667431E08CC28C07A16FC13BDC1E229CC73604D9584A7
          2AF570DB45F05CDA3C1091D0782D84DF3A81D61B630887C2015E89EC71E0FABE
          42FAC7E024C88300CF83F0BBB32C96F96B1FB5635D35459E43044754330ADF2D
          29655753AC039D06D4D029E1C8B9010C8C8423BC1CDCB3841EFC902D25551092
          0E7E99D1C2359ACC36CF0B2B6C585D2DC028F253E0577A24D82DBAD4D81F4AA2
          AA48985A93158AA6CE097CF7EB18864682415DBC77E562E1C7AB2A5D440BDEC2
          8A47BED61BAD2FAE792C07EBAB0151C7A59CE9FD3473ED8CA6391A4063471CFD
          FE24CADD64CA86B29FE69B097CFFCB308201FFB15CD9B73D9FF87A35806DCD6B
          D9EE0F94977A0A5E5A416133EB6614BEC825C2C3745254901BFD3194B8D22C27
          920A8E374771AEB97F48AF8CBE5B450FD713EFB64B6A613F80CEF6DEE6951661
          9147C76A3CB3B90C7A0E4BCBCDB09AD2B49D6B8FA1E36E14454E2D8389988CDB
          031338D41097497CE8CBDC64539D0A90AF9E13C15AB4EEF5A715E80582709C30
          5EC93482D2646D589E8D42279F91C9F9B671B4F71BD013B0A5E662113F68A0EB
          825DE9785B0558C0E8A977CFCD5FF89C574138C6C1ED34C16CE4319B382D1C56
          548A19732AC8FBF5E25467C9F13012FECE5B0EDAF9A60AB004BCE1878A227B51
          CD230A2A0AB3F04C8D0D26F11F0FF9AC52DF04EC3DA9E5A924A388FB6F0C3A59
          A155801A15C093EFF294B924ACF65AF06C8DF9A182ABE2EB01B67FA3D54203E8
          1ACC917D6FA9000B194587AD39C5952E9B808A7C1DDE58AB47AEEDE132D8750C
          38D1CAAAC4DCA45818F1D1CEDB2EA56D07F16EBD58C866BFE0ACA5ABB36DD694
          B1DA7A59864900EDA9504DCB72D94ED76406DFF33370E422C013CD3C1C1C8732
          DE79D1ADB4EC244B6BCF8B9437D6413F6787C35D22CCD2A19014B5AB5460E0AB
          57D3F3117651EF3B4571E232A05E5302AF51343AD02D73D1DE4385F2D98F496D
          6D2D69E15ED948896E7F4E7E699E354B98D19AB12487F90502DE59CFC39D9D06
          F8EC540C67DA950CFB20BB9B86FBBA46CC72CFEE0A9CAC5701708D6CCA8E728E
          FD668B6D73B9C7C9CEC28C6B1D1B9699981AA7FE1FBD10C1E9D658864D82DD3C
          5D7746100D0C9E2E56CED4D9C8BDAB2968350B1FB69452C17CB620D79CAFB6AA
          5EE0329CBD6526AC5BA6D5E8C4A5205A6E4E00747A70057FDD8DA07730346C8E
          B66E9DA76BFA934D0F4C31CE40381F79790B2798EA8ADCC692AA120B0441C800
          A92ED13268ED8E66D6489270A53B849E8148AF2ED1F7F90272BC9E4DF7329D98
          0E803B586E1925F3368137ED9AEB30E42D2AB1C265D369BD379BB08A0E059268
          EF0EA27F343A2C26FBF616A3E127230974B1D5B0DA7C199E2A08137D9BB4B152
          D2BB3EE278DDE30E9BE8A82CE0798B394D9B4A47281C4147AF2C8F8EC7C62047
          2F9B12D73F65B45C63CBFD4C4393EFE7195B53EBC11E7C1FADC9F37365AB9230
          3D41212CE679CE6D3270298ED8AD1995656588A3F1EB268CFADCB4AD8915949D
          658C318DB2E0CA64BC5973BF9F89BA5DB14F9A9F9DE0ED1EC2094EF639914540
          3942E5244763415119BEE7E4FB02F7E9505556899BFED2FF1B38613B1EF22F23
          EA0000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B0D00
          000B0D01ED07C02C0000000774494D45000000000000000973942E0000056A49
          44415478DA95566B6C145514FEEECCEC6E77BB8FBADB6E976EBBA52D055A5A4A
          8B48788841125E4163D004236AA2B1014D249A10FD43B4460326C61F62344454
          24802485108D40FC214AA10805DBA55460A53CFA66BBED6EBBEFD7CC5CEFCCD2
          170FC19B9CCC9D33F79EEF9CEF7C7BEF123C64D4BDD9AE05E43C805A40299B53
          C2DC29503944E484AF0EFB92CABADDBB77DF773FF98FC046F6589A31B90E84B8
          4004A3BA474E4541A55E366F23543E934503CD95F4489081D0470260C10B59C0
          ED6CBA1C82C1417456C1AC072AEC11640922BA0206F48CEA20C78745A4C33E40
          BCC149B16DB538F027DB234EAE86DC15985180B52CF817DA2C93ABA8C08655D5
          229EACD0C261D581E7269607A322CE5C09E3B40768BF3E82483812E4E5E84E1B
          AE7D5544CF0D8E81DC0DF01C08BF23DB649ABD7A81156B6A280A6C3A70445946
          A72CA793809A3D220E3779E11D8E447929B4731E3DF021FB945640C844F08B8C
          16EE8CC168713DBFC482953502F43AFE611A50872453B47862D8FFC7087CC3A1
          9026D9B76CAE70F4B24217C9046F63CD237BB47AF30BAB9EC8C3DA1A40A7E1D4
          CDD1A40C49CAE46BC8E220309A9269CA4C567DCA3AAD86308101AD3752F8F1F7
          218482819FF325F7162771F7650036B7AE66D9EF2E2F7315BEBC84C262D48C67
          A7E109C89D3A4506C492557BC17363D9672A50468A811E6B8DA3A9F5B64F2BFB
          DFABA6871A49DDE6BF94C67E008DE5FD0DCB4C42954BC3024E70BD70B6095693
          A0CE5B3C6104C222661464A1DCA9577D9DFD715C1F48A815C41212BABC311C6C
          4E4A24E9FB2E3FDDD2A0003895DF89602E5EF3D60A195A61AA7257D4E5C09E93
          A9E8847B14BE9134AA4AB2515D62507D1DB76238D93E82735D4674072DAA2F11
          0D80063BCF5AE5ABEF2A00958C9E46C734E79C67EBE4A96261F36716599992B4
          EAEB2F67031808A4F078B911F3671A555F53470C472F8470AED731AE2C291941
          2AE0B965A39EB7158079E0B37E9A556C2DAE9D9E699C56E03026F9F54B6D70E6
          66008E34FB71CB9BC0E24A3316559A54DFBED332F6374B88A5356A420A889C8E
          2319B83E98CB1AAD00D42A002EA7DD35C32EAA9BCC7A028135372D7378E5E91C
          94E46728FAF8700CEE2E56D502035E7B2A93C09E26E0FBA6094A955E64003A07
          F324F73B0AC01C46D121735E4985DD224CE15FC9EA9317B5A829CE94B3652FE0
          EE065E67C11F04A0E8434C4490F47BBAECF2A5ADA46ED3F922E6FD963397ADCC
          B198A70050D68CCF37720C000F055002F324D3BF486814F2A8E7BC436EDB46E6
          D79FD2515EDF00ED635B6D8E5281DC75FC7DF612C15CD78301F69EA2F8E114D4
          9E097C8622BFF7A6C4C5FB0E1649273F25F5F5F5A48D7B631D259A5D79CEB202
          73B63045462BAA38E45B32EFC72F02DE51A0767AC65499F65074F4D2F1F52176
          360DF5770E1BA5EE1DB3F06BA302802B647D4E9CB3ED329A2C1BCA5DB94C45F7
          1CEB8F3452ECE4E9EC19463C38F85B897CA2C142062EABA92955B8B1B18C0AC6
          9385F946E7ACA26C55AAFF2FB88C7F7AA3E81B0C0F19E3ED9B666A5A2E30B777
          9C7106C2B9C9AB1B39C1D050ECD09756979A2008C223051745111D37C3E8F646
          FB34A9FE6F2AC9B146E6EE53843819003D5868F29399EBC11BB64FB365155495
          9A61B76800F2809B9575D4174CE3EF9B21DCF6C78774E9FE2F4BD07C5C4F829D
          EC6B84993C65A702C286F692B8AE42D4DA3FE278CD229B4567AB28E479937182
          36858E70248AAB7D92E41F4D8C408A5F34A4AE7DCD68B9C23EDF66161EBB9FEF
          494DE9077BF0FDB4B620C0CD589E866131853097E73907BB0FD423949D9A7149
          927D1C4D5E33C0EF76D04B2DACA14CC018611667C1E5B178F7ADFD4E254ABABA
          7E71764E8AB7BA0827E4B2BF13D9EC6AE10895D21C4D8474F2D0402EDF1FBC43
          87629242DCE44BFF5F4042521E681AF81B0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end>
    Left = 213
    Top = 237
    Bitmap = {}
  end
end
