inherited CCheckDatafileFormUnit: TCCheckDatafileFormUnit
  Left = 319
  Top = 289
  Caption = 'Sprawdzanie pliku danych'
  ClientHeight = 139
  ClientWidth = 456
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButtons: TPanel
    Top = 98
    Width = 456
    inherited BitBtnOk: TBitBtn
      Left = 279
    end
    inherited BitBtnCancel: TBitBtn
      Left = 367
    end
  end
  inherited PanelConfig: TPanel
    Width = 456
    Height = 98
    inherited PageControl: TPageControl
      Width = 456
      Height = 98
      ActivePage = TabSheetStart
      inherited TabSheetStart: TTabSheet
        inherited CImageStart: TCImage
          ImageIndex = 3
        end
        object Label1: TLabel
          Left = 64
          Top = 24
          Width = 234
          Height = 13
          Caption = 'Wybierz plik danych, kt'#243'ry ma zosta'#263' sprawdzony'
        end
        object CStaticName: TCStatic
          Left = 64
          Top = 58
          Width = 353
          Height = 21
          AutoSize = False
          BevelKind = bkTile
          Caption = '<kliknij tutaj aby wybra'#263' plik danych>'
          Color = clWindow
          ParentColor = False
          TabOrder = 0
          TabStop = True
          Transparent = False
          TextOnEmpty = '<kliknij tutaj aby wybra'#263' plik danych>'
          OnGetDataId = CStaticNameGetDataId
          HotTrack = True
        end
      end
      inherited TabSheetWork: TTabSheet
        inherited CImageWork: TCImage
          ImageIndex = 3
        end
        object Label2: TLabel [1]
          Left = 64
          Top = 24
          Width = 234
          Height = 13
          Caption = 'Trwa sprawdzanie pliku danych. Prosz'#281' czeka'#263'...'
        end
        inherited StaticText: TStaticText
          Left = 64
          Top = 56
        end
        inherited ProgressBar: TProgressBar
          Left = 64
          Top = 56
        end
      end
      inherited TabSheetEnd: TTabSheet
        ImageIndex = -1
        inherited CImageEnd: TCImage
          ImageIndex = 0
        end
      end
    end
  end
  inherited PngImageList: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000006244944415478DAED56795013571CFE360721070612E3180C8A28DEB4
          14108180B51EE30562ABD6B153D1328E8E9D7AD5D66AB5B6D66B1C6B6B3D3A5E
          9DF19869B56A6774B4B56251110451122C82A0222AA7060C31C96ECE4DDF6EBC
          07CFAAFDC75FE6CD26EF7DBBDFF73B3714FE67A35E0B781524CA78A95EE085D7
          5CC414BC7201AAFEB2F17D2644FCCCB8686FC9AF0D139BB2E95DAF4C806E9C72
          F6DBEF45AF5C327033D560A9C182ECA9ECF9837533EBF65AD7BE7401919921CB
          878C499EFB59C22AB46BD591100970BAF60456E47F8EE2839796546D377FF5B2
          048863BED06C183E6C70E6A437164219A886C3C3F05432B10C971A4BB1DEB018
          45C78C9B8ABFBF31EB450B08EEBB4CBB236DC088D4D19133102094C2E575003E
          3F8D8F7C5A4954C8BF76189BCA16A164FBF5292D096895F88D7683CFE9B5142C
          BF318DFCF63C0DB3528730FDFCB09DA909639206EA3EE4F73C3EEF0398008114
          E52603F694AF43657D038C5B4D0B1F14D01EA17D3FD1ED1A923C38D9E26AC0A9
          3CC3BE63F3EB33C8C9ADC791AB7BA2E7A079E17B07478FEBDA5B93060FEB06EB
          6389CB9CCF5CF02988851294DE28C01F9737A2EA0A8D8B554E5872ACF3EE0A50
          7445D7C499617B87C68CEC99A44D03EDB620BB6E078A8B8DB9792BABC79AAFA1
          AE25F2F001D29441D374BBFA7519A7EDA6D4C3CDBAFCE47CC8C1179F9012A1BC
          B10039B5BFA0F2B20365150ED01798425B962D9317D026569A90323DECB77E3D
          52C37AA812E1659D100A44E4416E9C69DA8F739567CE1F5E5635DA740E65F793
          478D54BC3B705AF8B604DDE8209DAC17DC1E27FC3EDF23E75659E309949AB370
          BE9C41C97907ECA5F623740E3D8B40CE51DA3E927E499F86FE1EA1EA1292A21B
          054A4081653D20170804023E7C15D6E328ABC9AF3DBEB67EEC85234C1E479034
          2564CADBE323D6C5B44913A9C51D88E7CEDBD47E135242BE064A4D7FA396398B
          921206674B09B9D1BE872EA4E710481587A37A8D57FD9494D17AAAC3C642236F
          87EEAD13102C6943C84122E0E545880442D430C5B8D874D292BDA63E43DD41DA
          6DC084C8155D14032017AA49C4DCF798292299903B3D342E359F80D95D85A222
          1A867F68D80A6D9B9D25CE8504D57017AE48946D4C9ED87A7264442068A78F54
          2AD056D1095A456728028221128A78207735392EE1AAAD104112352282F49050
          32787D1E4248F1A1E602EF621998991A989CE560291A274EDA6030D8BDF67CFB
          2AE745E772026ABE3F8D94B887784170DFE0C5BDA3A488228B71FA03291602B2
          80102825ADA110AB2011C9C85E201CDE66F25D0E3125014B3A9413C0FA5C64FF
          1629DC9BB0B96FC047DE3C81941C878E36C15864A66D79B66FDDD7DCDCF8A51F
          2E62AE08B5D268E972599C6C427CB41CF17172302E96F7077C1D907CF269A0C8
          0A20C345E21F9F1457E95EBE50C98B8ECF3FE93A48C414245E2DF6FC558BE2D3
          75372D3996B930612B3976A305BBD3866A4957C90279A27C467CAC9C7A47AF84
          DDE5E51F28240821898680845920F083B902A56E2F7FDA2982F541161808B123
          025B0F54A0A4E04AB535D73A1B66EC2510F65133E4FE41A410878B6705F50FFA
          52DF5B1D3848AF81CDD34C3A82E45F80DB5D01BE4B7801F73D8125425B499508
          607A61CB814218F32ACBAD87ADD3E144169E600F8F6289381493DA8E502F8D8F
          0B550E4DEA002B5B0D8FD74D8A90E2C13CB9C01F112E029C6B21522D84B762B0
          E57016CE1EAB2C34EDB74C27DBA79E44DE9200BE85C56D3136629466556C9FF6
          6D87F5E9013B5541DE68765EC41DEF7972B2B4F2EE60CD6F614BF66E180F5DCC
          AA3F60E3064CE9D3903F4A803F140A0CEF3251B33A2E39A2736A5C02ECA2B3B0
          BB1BFDE9202ABCE4CE70991E2E732F6C3EB61986FD9777571FB47203E6CAD392
          3F56006F52A4C4646AD6C4F5EF149D1E33040E89016657155F0B91F254D89B3A
          614BEE0F38B5E3EAC6EAA3B6AFC91DD79F85FCC902FCF666EC24D5EAC4F4C87E
          E951EF4320AB4090B8231A1B43B03D6F95277763EDCA9A7C7A05C1599E95FC69
          0570D6293643F55DCA07ED47A677FF185697053BF3D6DB8FFE787D51BD915947
          CE99E7217F16019C85C68C0959923C59F351739DCBFCE7D2DA39A60BEE6D78C4
          8079190238D3E8A2A5E39BAF33576CF5D8076E14FE477B9EFF84A2DBC4BEE7B8
          F7850878A1F65AC0BF52A764D8829EA55F0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000008C64944415478DAC5570B5054E715FE762FCB4B100596C74280556090
          8A18454D68448356B1963CA89989D6464C8C898FFA184DD35A1BA33125319331
          DA6A1433EA88C662ADCF68A2687CA4A8513B3E88854815E40DB2B03C658165FB
          9D7BC1218434B57126FFEC3F7777EFFDFF73CE77BEF39DFFEAF0230FDD832E08
          014CA140A81908E80F783BB8471350730BA8E42C2C064A1FBA038F038F3E0DA4
          C41B8D3F33C7C646F9444579B9F8FB43EFE9C91D7470D4D7C35659094B5E5EFD
          EDEBD7F3CE55559D380AEC3B0BFCF30739301E78623EF0BB84F1E393FA27272B
          18360C080C04DCDC0027A76F3EDCDE0EDCBB471C2A81AB575177E850C79963C7
          8E6D02D67C0A9C7E50073CFE0CA44D1F366C6EBF79F3F418350AE8D307686B03
          2A2A803B77B46B5D9D8A00BCBC9890002686C921323018802626E6F265346CDC
          E8D871F1E2E6B781DF9703D6EF7560003F1F01BB9F4C4D1D8959B398656FA0A5
          856012CDB36735C312301168B7D9D47B0AAF0679C6D515888C2474C42E3A5A73
          BAB111D8BE1DD9E9E9575E029EFF1AB8F99D0E88F14CE0B3B8C58B2330752AA0
          28404101F0F1C7407333EA4D26D4F2DA5C5C8CB6F272D80572BB9D8F2930D098
          C1D91901025F7E3EB06205306E9C7A1FFC1F7BF7E2CA9A3585DC75627727BA3B
          E099057C3E7EE6CC38BCF8A206ED952BC08E1D688A8A42596D2D6AB3B351595B
          DBCA049490EAA5560D52475FA09F54C4134663C4307F7F17F7C44460F26440AF
          E75D8716888B8BBAD799F4F4EB638131E84CC77D0756016BFF3872E422BCF186
          06654E0E9091811A1ABFF3C517C8292EAE38021C65128E3309FFE2926A4EE28E
          0E4EFBDCE8E8C5EFBABA2EF39830C1558D5CD223C685AC829410577EAF5E8DF7
          CF9DDBB4149873DF8141C0901306C325535A9A3306F15735F75EBF1E56429E73
          FA34321A1AF66E01C84B5CE66CEEC99B4D8F3DB6F8159D2E0D1327BA202E4EE3
          8C0C09E4C205E0F06160E1428DA04CCFDDD75F6F9F60B3C55F052EA90EAC01D2
          5F8B8F7F198B1669B0EDD983B6D2525CC8CBB3AFB258D69C00DEE763965EAAC5
          70283EFE83649D6E2E92938188082D5AD9432AE1CC1958366F462DAB273C2505
          98364D4364C306ACCBCACAA0B517C401EF4BC075122F482D3761F9B66D28EAE8
          C0829C9CF507A9037CE65E4FCB9146A3EFCEC8C8ED239C9C26ABC6A50C257231
          20FC397204150CA45048C239B87F7F78BEF51635B38635B61BD77273EF0E0562
          749496B1598A72CA7BC102A8427389EE1C3B860D151517E7D7D53DC5B595DF12
          A89090A8EDA1A1BB835C5D8762D224D2D753D308219B08D2810328CACA42159F
          CDE57A42D73005080F96F4DEBCA956461D9F9D68B727E99E0566652ACA168378
          3E7CB87AB3895E8ECBCF9FF9252BB8A7F157C3C313DF0B0CCCF008083061F468
          2D62312AC6097F07232F3A750AAC7E30945B846F212BC4770F711DD28DF4763E
          9F6AB7FF46F72A21FE5051D2D47AED1C37CCE6D2C105053FE5D73BDD8DAF0C0F
          4F5D1E1ABA513F70A01B6263C9FF0E6DCA5A1A6F3B791265AC9856A241DA5D5C
          0E2C61EEFEC1A5810715E5C253CECE212A4764D08157ECF63FE85EA6446E5694
          3FE9BA1C2079CE1A8DE7C7949549ADB67519DF3668D09BA981812B60B56AF9EE
          1A526EEEEEB051F12C647C2B0DA40387D234EEE4763EA57CE4E676FC254FCF44
          582CAAC30E3A305B1CA0D82EDBA8286F1BBA1C60BD96FAFA160417173FCA5F75
          F2CFE7D1D11F3E6932CDC0DDBBE81E813A58AA2D8CB891DC69BC77CF419A6DDE
          AACA0ACABBA39761341E9AEEE9998C72ED6F1BD7CF696C5CAE6371CCDBAA287F
          F1EA72401A8B9F9F23293F7F2C197CE3EFD1D17B7E12129288AA2A0D6E91D5AE
          327BE411B4B06AEC84BDA4ADAD7909F00EC56A1D77A9EFC99DB34387668F6E6E
          8E5783A02A5AB8D79CAAAA253AD2EE177B0D86C361221A422631306000AE9797
          677BF9F8F4090D0D1DAA0A939496C8A9444EC8111202DB8D1B30B04151502AD9
          6896F1BA93B65A7B1A1FE5E313737AD4A873AEF9F91E2A82FDFA21B7AC0C336A
          6A7EA963010DFC847A151F1CECEBD4DAAAC9A5AF2F60366BDFD903D468C5B830
          5EBA233960A7C828EC90EC1FB9D381A5C4E7D3CE92EF397497A64C391A67B526
          A9F0738F160670F2FC79EBF33CEB485938913099F3BDBD533C18952A14A2DBE2
          84382086E5B7442E871149D1C1836A3D6750EB5E005ED32AAEF7B1F3B9E7D6FE
          AA6FDF4522C12A61E97CD9B56BD8525878E44DE059B52E638067F6B36106C5C4
          28AE12A1305D609629C6252D41411A12FBF7C3C153CF3B365BE632B298CB6FF5
          663898AEA6CF9BB7769287C74C557C047A1F1F58C9997F9F3CE920F9A75E63E0
          5DC2E0BE9A445D6C30A4382524C059944D9CF0F0D01A8A202388ECDC898AE2E2
          BA050D0DEBFE06BCC7758DBDD8765B396DDA33B3E3E29607343545ABA727314E
          296EE2D9D1929989AD36DB272BE980ACBFAF4C8C3596E271608C8B4B189292A0
          08DC920E490117AB9D8CDFBFACACCCDB5550F0EEED9292CB1D0E47A3C3E1D019
          0C86BED1616103869BCD090911113FF7D7EB23C166A6F247884D549B8B8A50BF
          6B172E363616A7F2805BAB75D66F9D889EDEC7CE18AB287E0E1EAB742346681B
          0839250D921EA351E381B37307674BA71EB8922F7A355231CA48D5DE40F41CAC
          9E2612B6958D29CF6EAFA5F1D964C3DEFB0CED891F1B6A0A6B69ED487905183C
          583BD98485696528433440D222DCE8AA0CB92784159D90D1790869E7A1A68586
          F55F7D059E0A4A7902F92DD9F057688798DE1D50B50848E00160C50C4AA793C8
          6E4C8CD629A534050521A7189729C414A744C8E4005A52A21E423A8E1F879E0E
          882231A033D4E5550DC0A99EA5FADFDE0B82C71B0CD3960605FD3AD1641A6C20
          83A9905A298A53E284AAA92C2DD177A971613BC5091419FE2B2F03791F90DC9F
          690255D49B91EF7B336268887CDCC363C214B379C218B379C8409329A09F9F9F
          41CDBDBC1748CE85ACBC5AABABDB6F5757579CB658AEEDB3DB4F6443740A799C
          F6EF32F020EF868400E63077F788087FFF30FF3E7DFCBC9C9CDCF424A8B5BEBE
          A5A2B9B9EAEB8686C2A2B636720CB7396BD0BB32FEDF0EF45C27EF669D2D518D
          B0FD7F31F8B01C7868E33FC7DB6ACCC251B6D50000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000072A4944415478DAD5977B7054D519C07F77F7DE7D64B3D93C36402821
          497906120B41620DA0401E1D2846B1E561F18550FCA38316C48E1868551E0A8A
          4060546C2763AD9DA9AD60A4102B840C213C42428840045393DAF28849800021
          8F7D64F7F6BBBBC1613AAD632DD0F1CE7C7BCEDE3DE77CBFEF75CE5985FFF3A3
          7CAB01164C64A2AA6279AD945DB71CA0E03EEDE1952B7E5684DD6D5EBFBAF0E9
          C545ADAFDC32807189A496FCF6C1F2A8D18FC5831DDF99DD5D0F3CF262DEB6DA
          EE03B702C05EB369E49F33662DCD6E3A1B4120A89238C441C3EE5FD74E5F589E
          5DF7C517976E2AC0AAD93CF1ECAA5F6DF4EA43A939A663B646705B7A14F6C876
          8A562D5D3DEFD5FA829B06909E40F29ED7B32BE26F9F31E0E427C66C0B0E5714
          BAD945728A4A476349DBCC0545933EFCF8E2F19B0160AE782971DBF859F3F35B
          9A9CD4FF4D615CA605B3DDC9A9CF5DC4C769B8FBFB39565CB86FD4637B7E20E3
          3D3714E0C599DA93CF2C7B708397411CA80A923A4423D2A9D1A344A0A8D19C3B
          6F6350B28ECDDACAE6179E7F6EE196E6E76F18C094A18CD9B66942992D292BEA
          C8111DCDAA1217A3525EA561D26C8C4A7712151D4947B7C2B0A12AFE966ACFCC
          C75FC92BAEA6E2460028152B633F187FFFF47B2E36DB3974D44CDE648D4F1B55
          0ED598B13BAC2425457267969BC6330E12DC3D44F7F1515BFC5A59C6E387F264
          7EE07F0228B897792B7F91FD9BA02589B20A85C4811AC346ABD4566B54D5A8D8
          22349252A29898DD97CB1DB1B49C0F30684017AA7E9A352B362C7AE6ADD60DDF
          18202B91117F593FA4DCF9DDEFB98F1D55387F556372AEB8DDA1517B583C50A9
          61B36B0C1C1C45764E3F298A68FEFE0FD07D5DA4A404E83E73A83D5FAAA2B48E
          A3DF04C056B3D655923171CCA4D6261BFB0E9BC8BD47C315AF82D542CD419583
          15022021481914C9E4A909982C2E7C1E85FA53411262AEE2FE4E804F4A8A2AD3
          16D4E5CA7A1DFF15C0C68759FEC4FCF417FCBE1876969A189AA13262AC26E609
          80B8BDA65C657FA9261B90000C8F213B5F00CC7132D3CFC5739D349CF292915C
          8F76B998A2ED975E9AF7064BBF3640463F06EF2F8CABB6270C8C3E51AB52DFA4
          72FFA32A26C97EDDACA2382C54978A073ED2642372909C1AC7E4FBFA6052A224
          E57A44AEB26FE75994863F3021EB12DE2E3A27FE92EF573650F77500D48AE7B4
          ADE3EF1E907FE5828DE25D6672676AF44FD5D011EB350D254292708F46D9BBB2
          13C6B81879673FC64FB3A30483E8FE208AFF0CCD4777F34E61333FB917FAA740
          F5714A330B9826EB7BBF1260ED6C163FFD48EC3A5D8F60EB0E953E52D777FD58
          5CAF98D1358B0088072C2A9E4E8D13072DF87D518CB8C34D74BC0DDD2361EEFE
          0CE5D211F14217074A9031307F8E58E590B0FE89829FBFCDEAFF08307504995B
          97994B6D3191CE2355668E9F567968898AE6B2887281B0191E30A348BFF38A85
          DA0F2D047D366ECBB113DDB713BDF333E83A271240113B835DF0D62618E8821C
          49439F87EED9EBC87BBF8AFDFF0E40AD5BCBDE91A9E671ED174CBCFE8EC6AC27
          35926F97B8AB86724344B96A9759D194BF1DA4FA3D3F3D7E2F09C35A79E8E536
          4CB2E5E89DF2D12DAB8972C50F2DF5B0E555B93D3D00FD92E0AF0D540F5BC484
          6BA1F81260593E3F5D3197378DFE7BEFCBAF4E337316AB21C5BA643D76135864
          DF57FAC808377BDE6CA26CD3497ABC0186666BCCDDECC4646A1380B0F21080D1
          F7C1F6DF41DB6978542090A556FE9E85CBFFC8E62F01EE1E4CDA8EE5EC8D8C25
          EEE43199500E0B5780238990D5384CA1D88B0D220345FAD271D942E5BB8DF83A
          3D64CE88C19D7855DE378AB485013A7B2B5FFA810B502817B6AC34B8234B5EB5
          73F9876B98B4F7041F1B00F6C32BF8207314B9575AE1E53760F45D3036275CF2
          26491EB3C338FA23302B8962657F917854CD85AA1A50DD04F536FC9E66B91D9D
          45D79B8CFC23D8199680882295F9690D947E044F2D10FC44A8ABE740FA12A62A
          B96964ED5A2E4921D5552667577925C4C58A5241B348D2DB2264E373845B8BD5
          8ED56693D6269BA1552A522A42C6F5F803F87C5EBC5E43BA45BA90068F8078C5
          0B5E23218370F1328C112F4CCB0D877DC63AA62B53D299B27D193B54059357AE
          10E26CA977796402E27D252EE4711481C2325842912615395C7E93F898DD46EE
          CA58717FF01C7A8F84A0E7A4C809F47679271ED55B0927A52C6CC0066571AB35
          FC7DCE7AE62AB9A94C2979969D6ABCE483662831143B43992EF5079131E0941D
          2E42949993459FEC2AA6C4B072C5115E4917D302527E013989FC02116810B3E5
          7B87BCBF7A455CD16EB8299490A17B92D10ADF9C8D0230B63F132A9F629FC979
          ED0832B2E25AD909AA550B1D3EA1D62626584D61484D5C640A865D6598E517F1
          05C3E211F14AE03DA2D42BDA3C463F104ECEEE5E174B58A66EE1474612BA0B72
          5893379C498A2EE648D963EDF584F53AB1FC8B6861E34375645C397A7A2DEBB9
          CE4A5F6FB57BAFEBFB648609BDEA738E2ED9C1A26BFB8011CCA470D4C3297013
          1FA537C3CE8AB47CBBFF9CDE88E79FB1937DECF02355840000000049454E44AE
          426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000077F4944415478DAC5967B4C54E919C69F99E1CE0CF73B8B8208C25016
          94DB6AF0421DB4969A9034E936D94BB5B6C936D966FDC7A44D36AEB57FD4A69B
          AC23295593B671B3D2C6CD564C6B752BF1C2BA0AC5C256596E23D7E18EC86580
          B931439FF7D06388C88275937EC9977366E69CEFFD7DCFFBBECF371AFC9F8766
          B5076A6A6A0C5EAFF7958080806D7E7E7E19A1A1A1D1BC6ADD6EB777767676D4
          E170B4CDCFCFDFE5E73A93C964FBDA001A1A1AE2838383DF090B0B7B3D3C3C3C
          D1DFDF1F1ACDE2E30B0B0B4FEE090797CB85A9A9A981F1F1F10F0962CECDCD1D
          7921808E8E8EEF337805771BE5E3E3A30491B9D2D06AB50A90C7E31190D1E9E9
          E9B73333333FFE9F007A7A7A7EE2EBEB5B191414A4ECF4B925250853039BCDF6
          1621CE3C1780D56A2DE0CB9F190C06FFE78EFCD4989C9C74F0529C9595F5AF35
          01F4F5F5C550BA5FF3F6406060E0B2DD7F951A6A3D2CFD6CB7DB65FEB1A0A0E0
          876B02B87FFFFE8EB1B1B1532CB81CC9FBD2A0EA551656A77CA7CEA510EA959D
          01AEF7EFBD7BF76E96255605A8AAAA2AE562E6A8A8A84C9D4E07D681B2981498
          00B1F594AB5A7012580A53024917C8552D567682F2FBE0E0606B5B5B5BCE8913
          27DCAB02D4D6D69A3A3B3BCD94DF2841640808EB017ABD1EF401054ABE5B0A20
          C1E90598999991C2533A4155627878B8E5D2A54BB9F492D5014646464CF5F5F5
          668BC5628C8C8C54761A1212A24CE908F181A7012498EC5C0024E702C0E253C0
          E44A0F693D7BF66CEE9D3B775CAB02305FBBB88B53E7CE9DCB961DC7C5C52122
          224251809EA0A440009E4E81C82D2ACCCDCD290013131322BDF299F97F40F9B7
          5CBC78717E5580CACACADDC5C5C5A7F8A2F1CA952B4849495120044014580940
          14703A9D4F14A0ECE8EEEE464949893CDB72FEFCF9CDA74F9F5E5D81E3C78F9B
          D6AD5B67DEB76F9F912D2986A4045601D414A8F521632980988FD48180242626
          22262646CE91D6C6C6C6DC35013057262E68E68BC6FCFC7C6531595482AA1DF1
          E4A5FF2AA0DE7BA185D3A3613A3CF0F7F5810F67D317F731F668A4E5B39A2B39
          6B4A414B4B8B89856366D51AE95E90A91A8AB49F9893A8A02AA00426C3D4DC3C
          E627071032FD25225C5D08D44EC13E6743A7751C7E09DB7AFF5A6FD9F6CBDF5E
          185C15E0F2E5CB26A3D168BE7EFDBAB1B9B919696969484A4A52DA4F94E021A3
          4CBAA5A24EA03E14BEEC88225D3DF2826B101A3B054473A1604EF131D9F338E0
          19C198CE810AE8F0BEE610EC2B021C3D7AD444DB34E7E5E519AF5DBBA604956E
          909D4BEB49B5AB6D3634F2083E0B2E1C88FE1419295F02C93C3A42B3681CA95C
          318CAB51250DFF1A2C7401F666A07F86070D6EF387EF6A7E8CD167029C3C79D2
          4489CD5BB76E35D20D952294E212C955875B3CE9E6D03F348652F747487BE906
          B0BE10D07F93BB8E25004174DAC565E7991F8F5B9100EE5A1A0D671FAE621265
          9AC3F02E03A8ABABDBC33F14E6A6A6A68C3D7BF6888928524B50D50505C2D233
          00C3C8E7D8AE7D17C828054276303883F96BE19EF36266CAC145B53084054317
          A0035CEE4598B97B54A25AD2F203CD9BF87019C08D1B370AD93E15D5D5D58592
          E7A2A2228812E272622A52F552903DFD8FB03FF0CFD8641C02E2CAB9630660A0
          B6C62134DCB240CB74793D0B1442836DA52F2339238A104E2A4198C754A1F7EE
          DF35AFA26C19C0C68D1B838F1D3BF62ECDE867172E5C50761C1B1BABF880EC5C
          A03A3BBBD0F9B01BEF157F8AD4E2AD801FAB2EC88B51E6F84F9575D8B97F0BB2
          0AD2F9BC0E9F5F6D4257730F5E7B7B270283A9808B55E9640DF67EF25053664F
          5B0620A3B4B474031DF116F3FE527B7BBBE2F5AAF3C91C1C1CC2407F3F7EF472
          35E28DC9DCBD9F52F5DDADE3E878308DDDAFE6D303F4840A46574337FEF6FB9B
          78ED9D2244C6FA020EAAE0627B0CDFB46A4A06D73D1340C6C18307CB8E1C39F2
          11F31E26152F00EA2164B5F663706010DF49F8001171ECB1A0F540600095E0F4
          258997407E4118B6D870F5FC17483586617B59126B805DE0980666C68089AE3E
          CD2EE7FA150164949797971C3A74E8035A738EB4A31C367216B048D1671DC5B7
          93CE2039F99F2C3CE695368D00B69E8EE9F08B414FB30BFFA8EA40A12912B93B
          F9BD83A04ED68B9DD7592E6E438366070ABF1240467A7A7A1453F2066DF90D1E
          C9D96C499FA121165A633BF6663EC081EFDD5D349C404E7FCAEE93C89B7854BD
          DF85840D21D8F53A8166AD6C41EB62118A05CD714EE1B8A618EFAD0AA00EAA60
          A02BE6F264CCE7A1943E3AFE3856E79ED3541CBEBD25E11B36E63292F25351DF
          58FEEF0A474FAB1DE17181088B6677B8E9C01E9A918B0A908110DD18C32B0418
          5D33C04AE3CDFD2939E65F8C5D0EDB989A084F8A62441E8F0117CFDE466A763C
          369B987B7B3F013875ED708C4C4D9DF9437CF9E15F0DDD7CA6133EE7D02665E6
          256C59E7FCD6CFDFD2FDB4687B56364233B9562C06DB266088F081218E66E7ED
          21441B1EDCB3587EF33B7DC5CDBAE0BF58AD0DC37CDFF3C20AF0E08A98D70624
          EB3CDE0DC5F99ACDBB8B13F237656E4A898E8BD77B3D4E4C3EEEB35B3ABB7B6B
          EF8CDDBB55A76BA0873DD4E9ECBD3C751F7F1D0A3C19D9D9D901C3C34E7D68A8
          BFDECFCF63E0BF37294B9E19B0BB5C3ADBF4B4CB363ADACE3E54AA60D9786180
          171DFF01ABF1A84E6B9ADADF0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    Left = 124
    Top = 72
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
