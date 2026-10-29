// Сгенерировано из tools/pixel-art (node build.js && node gen-swift.js) — те же рисунки, что в макете.
// Руками не править: перерисовать там и сгенерировать заново.

extension PixelCity {
    /// Материалы: символ рисунка → цвет днём и как он ведёт себя вечером и ночью.
    static let materials: [Character: Material] = [
        "1": Material(0x8C8FAD),
        "2": Material(0x6A6C8A),
        "3": Material(0xB0B6CC),
        "V": Material(0xFFFFFF),
        "W": Material(0xF1EDE4),
        "w": Material(0xD3CCBE),
        "G": Material(0xB4BAC4),
        "g": Material(0x878E9A),
        "D": Material(0x575E6C),
        "K": Material(0x2B2F3A),
        "S": Material(0xE6D0A2),
        "s": Material(0xC6AA77),
        "A": Material(0xDDB47A),
        "a": Material(0xB98E55),
        "C": Material(0xF3E2C0),
        "c": Material(0xD6C095),
        "R": Material(0xC4473B),
        "r": Material(0x8F3029),
        "E": Material(0xDD7448),
        "e": Material(0xAE4E2E),
        "P": Material(0xEC8FA6),
        "p": Material(0xB9607A),
        "T": Material(0x3CBBCB),
        "t": Material(0x23899B),
        "U": Material(0x2F62B5),
        "u": Material(0x214689),
        "L": Material(0x95A5BA),
        "l": Material(0x6C7D95),
        "M": Material(0x8DB4D6),
        "m": Material(0x6189B0),
        "N": Material(0x57A86F),
        "n": Material(0x347A4F),
        "F": Material(0x6DAF55),
        "f": Material(0x478A3C),
        "H": Material(0x9ACF70),
        "I": Material(0x3F7A5B),
        "i": Material(0x2A5942),
        "J": Material(0x9CC46A),
        "j": Material(0x77A04D),
        "B": Material(0x9A6A44),
        "b": Material(0x6E4A2E),
        "X": Material(0x6B4B33),
        "Q": Material(0xEEEAE2),
        "q": Material(0x3D3A38),
        "Y": Material(0xF5C342),
        "y": Material(0xC28E23),
        "O": Material(0xFF9F43),
        "o": Material(0x86A9C8, .window),
        "Z": Material(0xC9C5BA, .lamp),
        "*": Material(0xE5333F, .glow),
        "+": Material(0xFFC23D, .glow),
    ]

    /// Облака: h — светлый верх, x — облако, s — тень снизу.
    static let clouds: [String] = [
        """
        .......hhhh.......
        ....hhhxxxxh......
        ...hxxxxxxxxhhh...
        .hhxxxxxxxxxxxxhh.
        hxxxxxxxxxxxxxxxxh
        .sssxxxxxxxxxxsss.
        """,
        """
        ..........hhhh............
        .......hhhxxxxhh..........
        ......hxxxxxxxxxh..hhh....
        ...hhhxxxxxxxxxxxhhxxxh...
        ..hxxxxxxxxxxxxxxxxxxxxhh.
        .hxxxxxxxxxxxxxxxxxxxxxxxh
        ..sssssxxxxxxxxxxxxsssss..
        """,
        """
        ...hhh....
        .hhxxxhhh.
        hxxxxxxxxh
        .ssssssss.
        """,
        """
        .....hhhh...........
        ..hhhxxxxhhhhhh.....
        .hxxxxxxxxxxxxxhhh..
        ssssssssssssssssss..
        """,
    ]

    /// Рисунки: каждая строка — ряд точек, «.» — пусто.
    static let sprites: [String: String] = [
        "ist.mosque": """
        ......Y.....................Y......
        ......y.....................y......
        ......L.....................L......
        ......L.....................L......
        ......L.....................L......
        .....LLl...................LLl.....
        .Y...LLl...................LLl...Y.
        .y...LLl...................LLl...y.
        .L...WWw...................WWw...L.
        .L..Wwwww.................Wwwww..L.
        .L...ggg.........Y.........ggg...L.
        LLl..WWw.........Y.........WWw..LLl
        LLl..WWw.........y.........WWw..LLl
        LLl..WWw......VVLLLLl......WWw..LLl
        WWw..WWw.....VVVLLLLll.....WWw..WWw
        WWw..WWw.Y..VVVVLLLLlll..Y.WWw..WWw
        WWw.WwwwwL.VVVVVLLLLllll.LWwwww.WWw
        wwww.ggg.W.LLLLLLLLLllll.w.ggg.Wwww
        ggg..WWw.WLLLLLLLLLLlllllw.WWw..ggg
        WWw..WWw.WLLLLLLLLLLlllllw.WWw..WWw
        WWw..WWw.W.WoWoWoWoWoWoW.w.WWw..WWw
        WWw..WWw.WVLLlwwwwwwwVLLlw.WWw..WWw
        WWw..WWw.VVLLll.....VVLLll.WWw..WWw
        WWw.WwwwwlLLLlll...LLLLLlLWwwww.WWw
        WWw..gggLlLLLlll...LLLLLlLLggg..WWw
        wwww.WWwwwwwwwwwwwwwwwwwwwwWWw.Wwww
        ggg..WWwWWWWWWWWWWWWWWWWWWwWWw..ggg
        WWw..WWwWWWWWWWWWWWWWWWWWWwWWw..WWw
        WWw..WWwWoWoWoWoWWWoWoWoWowWWw..WWw
        WWw..WWwWoWoWoWoWWWoWoWoWowWWw..WWw
        WWwwwWWwWWWWWWWWWWWWWWWWWWwWWwwwWWw
        WWwWWWWwWWWWWWWWWWWWWWWWWWwWWwWWWWw
        WWwWWWWwWoWoWoWoWWWoWoWoWowWWwWWWWw
        WWwWDWWwWoWoWoWoWDWoWoWoWowWWwDWWWw
        WWwWDWWwWWWWWWWWDDDWWWWWWWwWWwDWWWw
        WWwWDWWwWWWWWWWWDDDWWWWWWWwWWwDWWWw
        WWwWWWWwWWWWWWWWDDDWWWWWWWwWWwWWWWw
        WWwWWWWwWWWWWWWWDDDWWWWWWWwWWwWWWWw
        """,
        "ist.maiden": """
        ....Y....
        ....L....
        ...LLl...
        ...LLl...
        ..WWWWw..
        ..WoWWw..
        ..WWWWw..
        .wWWWWWw.
        .WWoWoWw.
        .WWWWWWw.
        GGGGGGGgg
        .gGGGGgg.
        """,
        "ist.ferry": """
        ..........KK......
        ..........WW......
        ....WWWWWWWWWWW...
        ...WoWoWoWoWoWoW..
        ..WWWWWWWWWWWWWWW.
        .WWoWoWoWoWoWoWoWW
        KKKKKKKKKKKKKKKKKK
        .DDDDDDDDDDDDDDDD.
        """,
        "ist.farHills": """
        ................................................................................................
        .........................................33333333...............................................
        ................33333333333333333333333333333333333333...............................33333333333
        ............333333333333333333333333333333333333333333333.......................3333333333333333
        .........333333333333333333333333333333333333333333333333333................33333333333333333333
        .....33333333333333333333333333333333333333333333333333333333333........333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        """,
        "ist.shore": """
        ...................1.1.....1..1...1..................1....1.
        ............1111111o1o111..1.1111.1...........1.....1o1111o1
        .1...1111111oo1111o11o1111111o11o.1.....1...11o1111111111111
        1o111o1111111111111111111111111o11111111o111o1111111111oo1o1
        11o11111111111111111111111111oo11111o1111111111oo11111111111
        11111o1111111111111111111111111111o1111111111111111111111111
        """,
        "ist.bridge": """
        ........G.G............................G.G........
        ........GGG............................GGG........
        ......GGGwGGG........................GGG.GGG......
        .....Gw.GwG.wG......................G..G.Gw.G.....
        ....G.w.GwG.w.GG..................GGw..G.Gw..G....
        ...G..w.GGG.w..wGGG............GGG..w..GGGw..wG...
        .GGw..w.GwG.w..w..wGGGGGGGGGGGG..w..w..G.Gw..w.GG.
        G..w..w.GwG.w..w..w..w..w..w..w..w..w..G.Gw..w..wG
        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        gggggggggggggggggggggggggggggggggggggggggggggggggg
        ........G.G............................G.G........
        ........G.G............................G.G........
        """,
        "ist.hill": """
        .....................I...............I............I.....
        ................jJJJjIJJJJJJJJJJJJJJIIiJjJJJjJJJJJIJJJjJ
        ..............JJJJJJIIiJjJJJJjjJJjJJIIiJjJJJJJJjjIIiJJJJ
        ............JJJJJJJjIIiejEEEEeJJjJJJIIiJJJJJJEEEEIIiJJJJ
        ..........JJJjjJJJJJIIiCJSSSSSJJJEEEIIiEEEEeJWWWWIIiEEeJ
        ......I.JJjJJJEEEeJJCXCCJSoSSSjJJWWWWXJWWWWWJWoWWWXCCCCj
        ......IJjJJjJJSSSSjJCCCCJSSSSSjJJWoWWJJWoWWWJWWWWWJCoCCJ
        .....IIiEEEeJJSoSSJJjJjJJJJJJJJJJWWWWJJWWWWWJWWWWWJCCCCJ
        ...JjIIiCCCCJjSSSSJJJjjJJJjjJjJjJJjJJJJWWWWWJJJJJJjCCCCJ
        .JjJJIIiCoCCJjJJJjjJJJJjjJJjjJJJjjjjJJjJjJJJJJJjJJJJjJJJ
        GGGEEIIiGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        ggggggXggggggggggggggggggggggggggggggggggggggggggggggggg
        """,
        "quay": """
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
        D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..
        D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..
        D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..D..
        WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        gGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGG
        GGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGG
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        GGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGG
        gGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGG
        GGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGG
        """,
        "lamp": """
        DDD
        ZZZ
        ZZZ
        DDD
        .D.
        .D.
        .D.
        .D.
        .D.
        .D.
        DDD
        """,
        "cap.mesas": """
        ................................................................................................
        ................................................................................................
        ................................................................................................
        .................................................3333333333333333333333333333...................
        ...333333333333333333333333.....................333333333333333333333333333333..................
        ..33333333333333333333333333...................3333333333333333333333333333333333333333333333...
        .333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333..
        33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333.
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        """,
        "cap.chimneys": """
        ..................................................
        ..........................XXXXX...................
        .........................bbbbbbb..................
        ...........................CSs....................
        ..........XXXXX............CSs....................
        .........bbbbbbb...........CSs.............XXXXX..
        ...........CSs.............CDs............bbbbbbb.
        ...........CSs............CSDss.............CSs...
        ...........CSs............CSSss.............CSs...
        ...........CDs............CSSss....XXXXX....CSs...
        ..........CSDss...........CSSss...bbbbbbb..CSDss..
        ..XXXXX...CSSss...........CSSss.....CSs....CSoss..
        .bbbbbbb..CSSss...........CDSss.....CSs....CSSss..
        ...CSs....CSSss...........CDSss.....CSs....CSSss..
        ...CSs....CSSss...........CSSss.....CDs....CSSss..
        ...CSs....CDSss....XXXX..CSSSsss....CDs....CSSss..
        ...CSs....CDSss...bbbbbb.CSSDsss....CSs....CSDss..
        ...CSs...CSSSsss....Cs...CSSosss...CSSss..CSSDsss.
        ..CSSss..CSSSsss....Cs...CSSSsss...CSSss..CSSSsss.
        ..CSSss..CSSDsss....Cs...CSSSsss...CSSss..CSSSsss.
        ..CSSss..CSSosss...CSDs..CSSSsss...CDSss..CSSSsss.
        ..CSDss..CSSSsss...CSDs..CSSSsss...CoSss..CSSDsss.
        ..CSoss..CSSSsss...CSss..CSSDsss...CSSss..CSSosss.
        ..CSSss..CSSSsss...CSSs..CSSDsss...CSSss..CSSSsss.
        ..CSSss..CSSSsss...CSSs..CSSSsss...CDSss..CSSSsss.
        ..CSSss.CSSSDSsss..CSSs.CSSSSSsss.CSDSsssCSSSSSsss
        .CSDSsssCSSSDSsss.CSDSssCSSSDSsss.CSSSsssCSSDSSsss
        ACSDSsssCSSSSSsssACSoSssCSSSDSsssACSSSsssCSSoSSsss
        ACSSSsssCSSSSSsssACSSSssCSSSSSsssACSSSsssCSSSSSsss
        ACSSSsssCSSSSSsssACSSSssCSSSSSsssACSSSsssCSSSSSsss
        """,
        "cap.small": """
        ..XXX..
        .bbbbb.
        ...C...
        ..CSs..
        ..CSs..
        ..CSs..
        ..CDs..
        ..CDs..
        ..CSs..
        ..CSs..
        .CDSss.
        .CoSss.
        .CSSss.
        .CSSss.
        """,
        "cap.valley": """
        ............J.....................................................AjjA..........................
        ..........J.jAAAAAAAAAAAAAAAaAAA...................J.J.....J.AAAAAAAAAAAAA......................
        ....J.JAaAjAAAAaAAAAAAAAAAAAAAAAAAAA.JJ...J..J...AAjAjAAAAAjAAAAAAAAAAAAAAAAAA.J...J......JJ...J
        JJ.AjAjAAaAAAAAAAaAAAAaAAAAAAaAAAAAaAjjAaAjAajAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAjAAAjAAAAAAjjAAAj
        jjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAaAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAaAAAAAaAaAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAaAAAAAAAAAAAAAAAAAaAAAAAaAa
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAaAAAAAAAAAaAAAAaAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAaaAAAAAAAAAAAAAaAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAaAAaAAAAAAAAAAAAAAAAAAAaAAAaAAaAAAAAaAAAAAAAAAAA
        aAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAaAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAaAaAA
        AAAAAAAaAAAaAAAAAAAAAAAAAAAAAAAAAaAAAAAaAAAAAAAAAAAAAAAAAAAaAAAAAAAAaAAAAAAAAAAAAAAaAAAAAAAAAAAA
        AAaAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAaAAAAaAAAaAaAAAAAAAAAAAAAaAAAaAAAAaAAA
        AAaAAAAAAAAAAAAaAAAAAAAAAAAAaAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAaAAAaAAaAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAaAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAaAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAaAAAAAAAAAAAAAAAAAaAAAAaAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAA
        """,
        "cap.b1": """
        ...YRY...
        .VYYRYYR.
        .VYYRYYR.
        VVYYRYYRR
        RRYYRYYRR
        RRYYRYYRR
        RRYYRYYRR
        .RYYRYYR.
        .RYYRYYR.
        ..YYRYY..
        ..YYRYY..
        ...YRY...
        ...DD....
        ...bb....
        ...bb....
        """,
        "cap.b2": """
        ..WWU..
        .VWWUW.
        VVWWUWW
        VVWWUWW
        UUWWUWW
        UUWWUWW
        .UWWUW.
        .UWWUW.
        ..WWU..
        ..WWU..
        ..DD...
        ..bb...
        ..bb...
        """,
        "cap.b3": """
        ..YYN..
        .VYYNU.
        VVYYNUP
        ROYYNUP
        ROYYNUP
        ROYYNUP
        .OYYNU.
        ..YYN..
        ..YYN..
        ..DD...
        ..bb...
        ..bb...
        """,
        "cap.b4": """
        .NYN.
        VNYNN
        VNYNN
        NNYNN
        NNYNN
        .NYN.
        .NYN.
        .DD..
        .bb..
        .bb..
        """,
        "cap.b5": """
        .PW.
        VPWW
        PPWW
        PPWW
        .PW.
        .PW.
        .DD.
        .bb.
        .bb.
        """,
        "uz.registan": """
        ................Y.......................Y.........
        ................T.......................T.........
        ...............TTt.....................TTt........
        ..............TTTTT...................TTTTT.......
        ..............SDSDs...................SDSDs.......
        ..............SSSSs...................SSSSs.......
        ...............SSsSSSSSSSSSSSSSSSSSSSSsSSs........
        ...............SSsSTTTTTTTTTTTTTTTTTTtsSSs........
        ...............SSsSTSSSSSSSSSSSSSSSSStsSSs........
        ...............SSsSTUWUWUWUWUWUWUWUWUtsSSs........
        ...............TTtSTSSSSSSSSSSSSSSSSStsTTt........
        ...............SSsSTSSSSSSSSSSSSSSSSStsSSs........
        ...............UUuSTUSSSSSSSUSSSSSSSUtsUUu........
        ...............SSsSTSSSSSSSUUUSSSSSSStsSSs........
        ...............SSsSTSSSSSUUUUUUUSSSSStsSSs........
        ...............TTtSTSSuSUUUUUUUUUSuSStsTTt........
        ...............SSsSTUSuUUUUUUUUUUUuSUtsSSs...Y....
        .......Y.......UUuSTSSuUUUUUUUUUUUuSStsUUu........
        .......t.......SSsSTSSuTUTUTUTUTUTuSStsSSs.tVtTt..
        ....VtTtTtt....SSsSTSSuUUUUUUUUUUUuSStsSSsVtVtTtt.
        ...tVtTtTttt...TTtSTUSuUUUUUUUUUUUuSUtsTTtTtTtTtt.
        ..VtVtTtTtttt..SSsSTSSuUTUTUTUTUTUuSStsSStTtTtTttt
        .tTtTtTtTttttt.UUuSTSSuUUUUUUUUUUUuSStsUUUWUWUWUWU
        .tTtTtTtTttttt.SSsSTSSuUUUUUUUUUUUuSStsSSTTTTTTTTT
        .tTTTTTTTTTTTTTSSsSTUSuTUTUTUTUTUTuSUtsSSSTTTTTTTT
        .UWSSSSSSSSSSSSTTtSTSSuUUUUUUUUUUUuSStsTTSSSSSSSSS
        .TTSSSSSSSSSSSSSSsSTSSuUUUUUoUUUUUuSStsSSsSSSSSSSS
        .SSSSUSSSUSSSUSUUuSTSSuUTUToToTUTUuSStsUUuSSUSSSUS
        .SUSUUUSUUUSUUUSSsSTUSuUUUUUUUUUUUuSUtsSSsSUUUSUUU
        .SUSUUUSUUUSUUUSSsSTSSuUUUUUUUUUUUuSStsSSsSUUUSUUU
        .SUSUoUSUuUSUuUTTtSTSSuTUTUTUTUTUTuSStsTTtSUoUSUoU
        .SUSUUUSUUUSUUUSSsSTSSuUUUUDDDUUUUuSStsSSsSUUUSUUU
        .SUSSSSSSSSSSSSUUuSTUSuUUUDDDDDUUUuSUtsUUuSSSSSSSS
        .SSSSSSSSSSSSSSSSsSTSSuUTUDDDDDUTUuSStsSSsSSSSSSSS
        ...SSUSSSUSSSUSSSsSTSSuUUUDDDDDUUUuSStsSSsSSUSSSUS
        ...SUUUSUUUSUUUTTtSTSSuUUUDDDDDUUUuSStsTTtSUUUSUUU
        ...SUUUSUUUSUUUSSsSTUSuTUTDDDDDTUTuSUtsSSsSUUUSUUU
        ...SUUUSUUUSUUSUUuSTSSuUUUDDDDDUUUuSStSUUuSUUUSUUU
        ...SUoUSUoUSUuSSSsSTSSuUUUDDDDDUUUuSStSSSsSUuUSUuU
        ...SUUUSUUUSUUSSSsSTSSuUUUDDDDDUUUuSStSSSsSUUUSUUU
        """,
        "uz.farMosque": """
        ........................................
        ........................................
        ............1..............1............
        ............1.............1111..........
        ............1...........11111111...1....
        ............1...........11111111...1....
        ............1.33333333.1111111111..1....
        ............1.33333333.1111111111..1....
        ............1.33111133.11111111111.1....
        ............1.33111133.11111111111.1....
        .33..3.3...31.33111133.11111111111.1.3..
        .333.3.3.333133311113331111111111131.33.
        3333333333331333111133311111111111313333
        3333333333331333111133311111111111313333
        """,
        "uz.mountains": """
        ................................................................................................
        ................................................................................................
        ......................................................................V.........................
        ............V.......................................................VVVww.......................
        ..........VVwww...................................................V1VVVwwww.................V...
        .......11111V2ww22......................V......................VV11111222ww22w............VVwww.
        .....1111111w2ww22w2..................VVVww....................1111111222222222..........V1VV2w2
        .....1111111222222222...............V11VVw2ww..............11111111111122222222222....V1V11V2222
        ..1111111111122222222222..........1V1111V22222w2...........111111111112222222222222..11111111222
        11111111111122222222222222....111111111122222222222......111111111111122222222222221111111111222
        111111111111222222222222222211111111111112222222222222.11111111111111222222222222211111111111222
        111111111112222222222222221111111111111112222222222221111111111111111122222222211111111111112222
        """,
        "uz.plaza": """
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        """,
        "uz.poplar": """
        ..F..
        .HFf.
        .FFf.
        .FFf.
        FHFff
        FHFff
        FFFff
        HFFff
        HHFff
        HFFff
        .FFf.
        .HFf.
        .FFf.
        ..F..
        ..X..
        ..X..
        """,
        "khv.minaret": """
        ....Y....
        ....Y....
        ....T....
        ...TTt...
        .TTTTTTT.
        .ADADADa.
        .AAAAAAa.
        .TTTTTTT.
        ..AAAaa..
        ..WWWww..
        ..AAAaa..
        ..AAAaa..
        ..TTTtt..
        ..AAAaa..
        ..AAAaa..
        ..WWWww..
        ..AAAaa..
        ..AAAaa..
        ..TTTtt..
        ..AAAaa..
        ..AAAaa..
        ..WWWww..
        .AAAAaaa.
        .AAAAaaa.
        .TTTTttt.
        .AAAAaaa.
        .AAAAaaa.
        .WWWWwww.
        .AAAAaaa.
        .AAAAaaa.
        .TTTTttt.
        .AAAAaaa.
        .AAAAaaa.
        .WWWWwww.
        .AAAAAaa.
        .AAAAAaa.
        .TTTTTtt.
        AAAAAAaaa
        AAAAAAaaa
        WWWWWWwww
        AAAAAAaaa
        AAAAAAaaa
        TTTTTTttt
        AAAAAAaaa
        """,
        "khv.kalta": """
        ..TTTTTTTTTTT..
        ..WWWWWWWwwww..
        ..UUTUUTUutuu..
        ..UTUUTUUtuut..
        ..TTTTTTTtttt..
        ..TTTTTTTtttt..
        .WWWWWWWWwwwww.
        .NNNNNNNNnnnnn.
        .NNNNNNNNNnnnn.
        .UUTUUTUUTuutu.
        .UTUUTUUTUutuu.
        .WWWWWWWWWwwww.
        .TTTTTTTTTtttt.
        .TTTTTTTTTtttt.
        .NNNNNNNNNnnnn.
        .UUTUUTUUTuutu.
        .UTUUTUUTUutuu.
        WWWWWWWWWWwwwww
        TTTTTTTTTTttttt
        TTTTTTTDTTttttt
        UTUUTUUDUUtuutu
        TUUTUUTDUTuutuu
        """,
        "khv.town": """
        ............................................................
        ..............Y.............................................
        ..............Y.............................................
        ............nNnNn...........................................
        ...........HnNnNnn..........................................
        ..........nHnNnNnnn.........................................
        .........NnNnNnNnnnn........................................
        .........NnNnNnNnnnn........................................
        .........NnNnNnNnnnn........................................
        ........TTTTTTTTTTTTT.......................................
        ........AAAAAAAAAAAAa.......................................
        ........AAAAAAAAAAAAa........VtT.............VtT............
        ........AAAAAAAAAAAAa.......tTtTt...........tTtTt...........
        ........AAAAAAAAAAAAa......TtTtTtt.........TtTtTtt..........
        ........AAAAAAAAAAAAa......AAAAAAA.........AAAAAAA..........
        .....SSSAAAAAAAAAAAAa......AAAAAAA.........AAAAAAA..........
        SSSSSAAAAAAAAAAAAAAAa......AAAAAAA.........AAAAAAA...SSSSSS.
        AAAAaAoAAAAAAAAAAAAAaS.....AAAAAAASSS......AAAAAAASSSAAAAAa.
        AAAAaAAAAAAAAAAAAAAAaaSSSSSAAAAAAAAAaSSSSSSAAAAAAAAAaAAAAAaS
        AAAAaAAAAAAAAAAAAAAAaaAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAaAAAAAaA
        AAAAaAAAAAAAAAAAAAAAaaAoAAAAAAAAAAAAaAAAAAAAAAAAAAAAaAAAAAaA
        AAAAaAAAAAAAAAAAAAAAaaAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAaAAAAAaA
        """,
        "khv.wall": """
        ................................................................................................
        .......A.A.A.a...............A.A.A.a...............A.A.A.a...............A.A.A.a...........A.A.A
        .......SSAAAaa...............SSAAAaa...............SSAAAaa...............SSAAAaa...........SSAAA
        .......SSAAAaa...............SSAAAaa...............SSAAAaa...............SSAAAaa...........SSAAA
        A..A..ASSAAAaa.A..A..A..A..A.SSAAAaaA..A..A..A..A..SSAAAaa..A..A..A..A..ASSAAAaa.A..A..A..ASSAAA
        AA.AA.ASSAAAaa.AA.AA.AA.AA.AASSAAAaaAA.AA.AA.AA.AA.SSAAAaaA.AA.AA.AA.AA.ASSAAAaa.AA.AA.AA.ASSAAA
        aaaaaaaSSAAAaaaaaaaaaaaaaaaaaSSAAAaaaaaaaaaaaaaaaaaSSAAAaaaaaaaaaaaaaaaaaSSAAAaaaaaaaaaaaaaSSAAA
        AAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAASSAAA
        AAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAASSAAA
        AAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAaAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAaAAAAaAASSAAA
        AAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAaAAAAAAAAAAASSAAAaaaAAAAAAAAAASSAAA
        AAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAaAaAAAAASSAAAaaaAAAAAAAAAASSAAA
        AAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAASSAAA
        AAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAaAAAAAASSAAA
        AAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAAAAAASSAAAaaaAAAAAAAAAASSAAA
        aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        """,
        "khv.ground": """
        aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        SSSSSSsSSsSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSssSSSSSSSSSsSSSSSsSSSSSSSSSSSSSSSSS
        SSSSSSssSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSsSSSSSSSSSSS
        SSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSS
        SSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSsSSSSSSSsSSSSSSSsSSSSS
        SSSSSSSSSSSsSSSSSSSSsSsSSSSSsSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
        SSSSsSsSSSSSSSSSSSSSSSSsSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSsSSSSsS
        SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSssSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
        SSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSS
        SSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSS
        SSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSS
        SSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSsSSS
        SSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSssSSSSSSSSSSSSSSS
        SSSSSSSSSSSSsSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSS
        SsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSsSSsSSSSSSSSSSSSSSSSSSSSSSSSSS
        SSSSSsSSSSSSSSSSSSSSSSSSSSSSSsSSSSSsSSSSSSSSSSsSSSSSSsSSSSSsSsSSSSSssSSSSSSSSSSsSSsSSSSSSSSSSssS
        """,
        "dxb.skyline": """
        ............................................
        ............................................
        ..................*.........................
        ..................G.........................
        ..................G.........................
        ..................G.........................
        ..................G.........................
        ..................G.........................
        ..................G.........................
        ..................G.........................
        ..................G.........................
        ..................G.........................
        .................MGm........................
        .................oGm........................
        .................MGo........................
        .................MGm........................
        .................MGm........................
        .................MGo........................
        ................MMGmm.......................
        ................MMGmo.......................
        ................oMGom.......................
        ................MMGmm.......................
        ................MoGmm.........g.............
        ................oMGom........Gg.............
        ...G............MMGmm.......oGg.............
        ...G...........MMoGmom.....GGGg.............
        ...G...........MoMGmmm....GooGg.............
        ...G...........oMMGmmm....GGGGg.............
        mmmmmm.........MMMGmom....Gooog....g........
        mmmmmm.........MMMGmmm....GGGGg...Gg........
        mooomm.........oMMGmmm....Gooog..GGg........
        mmmmmm.........MMoGmom....GGGGg.GGGg..MMMM..
        moooom.........MoMGomm....GooGg.Goog..MMMM..
        mmmmmm........MMMMGmmmm...GGGGg.GGGg.MMMMMm.
        moomom........oMMMGmmmm...Gooog.GGGg.Moooom.
        mmmmmm........MMoMGmmmo...GGGGg.GGGg.MMMMMm.
        moooom.SSSSs..MMMMGmmom...Gooog.Goog.MoooMm.
        mmmmmm.SSSSs..MMMoGmomm...GGGGg.GGGg.MMMMMm.
        moooom.SSSos..MMoMGommm...GoGog.GoGg.MMooMm.
        mmmmmm.SSSSs..MMMMGmmmm...GGGGg.GGGg.MMMMMm.
        mmmomm.SSoos..oMMoGmmmm...GGGGg.GoGg.MooWWWw
        mmmmmm.SSSSs..MMMMGommm...GGGGg.GGGg.MMMWWWw
        momomm.SooSs.MMoMMGmmomm..GooGg.GoGg.MMoWWow
        mmmmmm.SSSSs.MoMMoGmmmmm..GGGGg.GGGg.MMMWWWw
        moomom.Sooos.MMMMMGmmmmm..GGoog.Goog.MooWoow
        mmmmmm.SSSSs.MMoMMGmmomm..GGGGg.GGGg.MMMWWWw
        mmmoom.Sooos.MoMMoGmmmmm..GGoog.GoGg.MoMWoow
        mmmmmm.SSSSs.MMMoMGommom..GGGGg.GGGg.MMMWWWw
        mmoommwSSoSswMMoMMGmmmmmwwGooogwGGogwMMoWoow
        mmmmmmWSSSSsWMoMMoGmommoWWGGGGgWGGGgWMMMWWWw
        WoWWoWWoWWoWWoWWoWWoWWoWWoWWoWWoWWoWWoWWoWWo
        WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
        """,
        "dxb.arab": """
        ..G.........
        ..G.........
        ..Gw........
        ..GWw.......
        GGGWww......
        D.GwWw......
        .gGWWWw.....
        .gGWWwWw....
        .gGWwWWw....
        .gGwWWWww...
        .gGWWWwWWw..
        .gGWWwWWWw..
        .gGWwWWWwWw.
        .gGwWWWwWWw.
        .gGWWWwWWWw.
        .gGWWwWWWww.
        .gGWwWWWwWw.
        .gGwWWWwWWw.
        .gGWWWwWWWw.
        .gGWWwWWWww.
        .gGWwWWWwWw.
        .gGwWWWwWWw.
        .gGWWWwWWWw.
        GGGGGGGGGGGG
        """,
        "dxb.dhow": """
        .....B.........
        .....BWW.......
        ....BWWWW......
        ....BWWWWW.....
        ...BWWWWWWW....
        ...BWWWWWWWW...
        ..BbbbbbbbbbbB.
        ......B........
        BB....B......BB
        .BBBBBBBBBBBBB.
        ..bbbbbbbbbbb..
        """,
        "dxb.far": """
        ..................................................
        .............33...........................333.....
        .........333.33...........................333.3333
        .........333.3o.....3333..................3o3.3333
        .........3o3.33.....3333....33.3333.......333.3o33
        ....3333.333.333333.3o33....33.3333.......333.3333
        ....3333.333.333333.3333....3o.3o33....333333.3333
        ....3o33.333.333o33.3333....33.3333.33.333333.3333
        33333333.333.333333.3333....33.3333.33.333333.3333
        33333333.333.333333.3333.33333.3333.33.333333.3333
        33333333.333.333333.3333.33333.3333.33.333333.3333
        33333333.333.333333.3333.33333.3333.33.333333.3333
        """,
        "dxb.beach": """
        WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
        AAAAAAAAAAAAAAAAAAAAAAAAaAAaAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAaAAAAAAAAAAaAAAAAAAAAaAAAAAAAAaAAAaaAAaaAAAAAAAA
        AAAAAAAAAAAaAAAAaAAAAAAAaAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAa
        AAAAAaAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAaAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaAAAAAAAAAAAAAAAAAAAaAAAAAAAAA
        AAAAaAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAaAaAAAAAAAAAAAAAAAAaAAA
        AAAAAAAAAAAAAAAAAAAAaaAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAaA
        AAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAaAAAAAAAAAAaAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAaAaAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAaAAAaAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAaAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAaAAAaAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAaAAAAAaAAAAAAa
        AAAAAAAAAAAAAAAAAAAAAAAaAAAAAAaAAAAAAAAAAAAAAAaAAAaAaAAAAAaAAAAAAAAAAAAAaAAAAAAAAAAaaAAAAAAaAAAA
        AAAAAaAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAaAaAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAA
        """,
        "palm.big": """
        ......HH.HH.....
        ....HHFFHFFHH...
        ..HHFFf.F.fFFHH.
        .HFFf..bXb..fFFH
        HFf...FbXbF...fF
        Ff...Ff.X.fF...f
        f...Ff..X..fF...
        ...Ff...X...fF..
        ...f....X....f..
        ........b.......
        .......X........
        .......X........
        .......b........
        .......X........
        ......X.........
        ......b.........
        ......X.........
        ......X.........
        ......b.........
        .....X..........
        .....X..........
        .....b..........
        .....X..........
        .....Xb.........
        .....bb.........
        """,
        "palm.mid": """
        ......HH.HH......
        ....HHFFHFFHH....
        ..HHFFf.F.fFFHH..
        .HFFf..bXb..fFFH.
        HFf...FbXbF...fFH
        Ff...Ff.X.fF...fF
        f...Ff..X..fF...f
        ...Ff...X...fF...
        ...f....X....f...
        ........b........
        ........X........
        ........X........
        ........b........
        .........X.......
        .........X.......
        .........b.......
        .........X.......
        ..........X......
        ..........b......
        ..........X......
        ..........Xb.....
        ..........bb.....
        """,
        "palm.small": """
        ....H.H....
        ..HHFHFHH..
        .HFf.F.fFH.
        HFf.bXb.fFH
        Ff.Ff.fF.fF
        f.Ff.X.fF.f
        ..f..X..f..
        .....X.....
        .....X.....
        .....b.....
        .....X.....
        .....X.....
        .....b.....
        .....X.....
        .....Xb....
        .....bb....
        """,
        "des.far": """
        ........................................AAAAA...................................................
        ....................................AAAAAAAAAaa.................................................
        ........AAAAA....................AAAAAAAAAAAAaaaa...............................................
        .....AAAAAAAAaa...............AAAAAAAaAAAAAAAAaaaaaa.....................AAAAAA................A
        ..AAAAAAAAAAAaaaa..........AAAAAAAAAAAAAAAAAAAaaaaaaaa...............AAAAAAAAAAaaa..........AAAA
        AAAAAAAAAAAAAAaaaaaa....AAAAAAAAAAAaAAAAAAAAAAAaaaaaaaaaaa........AAAAAAAAAAAAAaaaaaa.....AAAAAA
        AAAAAAAAAAAAAAaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaAAAAAAAAaAAAAAAAAAAaaaaaaaAAAAAAAaA
        AAAAAAAAAAAAAAAaAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAaaAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaAAAAAAAAAaAAAAaAAAAAAAAAAAAAaAAAAAAaAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAA
        """,
        "des.mid": """
        ................................................................................................
        .........................................................AAAA...................................
        ......................................................AAAAAAA...................................
        .....................................................AAAAAAAAa..................................
        .......................AAAA........................AAAAAAAAAAAa.................................
        .....................AAAAAA......................AAAAAAAAAAAAAaa................................
        ...................AAAAAAAAa....................AAAAAAAAAAAAAAAaa.............................AA
        .................AAAAAAAAAAAa..................AAAAAAAAAAAAAAAAaaa..........................AAAA
        AAAAAAAAAAAAAAAAAAAAaAAAAAAAaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAaaaaaAAAAAAAAAAAAAAAAAAAAAAAaAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAaAAAAAAAAAAAaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaAAAAAAAAAAAAAAAAAAAaAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaAAAAAAAaAAAAAAAAAAAAAAAAAAAAAaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaAAAAAAAAAAAAaAAaAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaAAAAAAAAAAAAAaAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaAAAAAAAAAAAAAAAAA
        AAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaAAAAAAAAAAAAAAAAAAAA
        AAaAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaAAAAaAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaAAAaAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaAAAAAAAAAAAAAAAAAAAA
        """,
        "des.near": """
        ................................................................................................
        ................................................................................................
        ................................................................................................
        ................................................................................................
        ............................................................................................AAAA
        .........................................................................................AAAAAAA
        ...................................AAAAAA..............................................AAAAAAAAA
        ..............................AAAAAAAAAAAaa.........................................AAAAAAAAAAAA
        ...........................AAAAAAAAAAAAAAaaaa.....................................AAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAaAAAAaAAAAAAAAAAAAAaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAaAAAaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaaAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        """,
        "des.tent": """
        ......bb......
        ....bbBBbb....
        ..bbBBBBBBbb..
        bbBBBBBBBBBBbb
        .BBRRBBBBRRBB.
        .BBBBBDDBBBBB.
        .BBBBBDDBBBBB.
        .bbbbbDDbbbbb.
        """,
        "camel.0": """
        ....bb......
        ...bBBb.....
        ..bBBBBb..BB
        .bBBBBBBb.Bb
        bBBBBBBBBBB.
        .BBBBBBBBB..
        .B.B....B.B.
        .B.B....B.B.
        .b.b....b.b.
        """,
        "camel.1": """
        ....bb......
        ...bBBb.....
        ..bBBBBb..BB
        .bBBBBBBb.Bb
        bBBBBBBBBBB.
        .BBBBBBBBB..
        ..BB...BB...
        ..B.B..B.B..
        ..b..b.b..b.
        """,
        "msk.spasskaya": """
        .............
        ......*......
        .....***.....
        .....*.*.....
        ......Y......
        ......N......
        ......N......
        .....NNn.....
        .....NNn.....
        .....YNY.....
        .....NNn.....
        .....NNn.....
        ....NNNnn....
        ....YNNnY....
        ....NNNnn....
        ....WWWWw....
        ....WDWDw....
        ....WWWWw....
        ...WWWWWWW...
        ...RDRDRDr...
        ..YRDRDRDrY..
        ..WRDRDRDrW..
        ..WRRRRRRrW..
        ..WWWWWWWWW..
        ..RRRYYYRrr..
        ..RRYVKVYrr..
        .YRRYVKKYrrY.
        .WRRYVVVYrrW.
        .WRRRYYYRrrW.
        .WRRRRRRRrrW.
        .WWWWWWWWWWW.
        .RRRRRRRRRrr.
        .RRRRRRRRRrr.
        .RRoRRRRRorr.
        .RRoRRRRRorr.
        .RRRRRRRRRrr.
        .WWWWWWWWWWW.
        .RRRRRRRRRrr.
        .RRRRRDRRRrr.
        .RRRRDDDRRrr.
        .RRRRDDDRRrr.
        .RRRRDDDRRrr.
        .RRRRDDDRRrr.
        .RRRRDDDRRrr.
        """,
        "msk.basil": """
        ..............................
        ..............................
        ..............................
        ..............................
        ..............................
        ..............................
        ..............................
        ...............Y..............
        ...............Y..............
        .....Y.........Y.........Y....
        .....Y........YYy........Y....
        .....N........YYy........W....
        .....R.........Y.........U....
        ....RRn........R........UUw...
        ...RRNnr..Y....W....Y..UUWwu..
        ...RNNRr..Y...RRr...Y..UWWUu..
        ..RNNRRnn.Y...WRW...Y.UWWUUww.
        .RNNRRNnrrY...RRr...YUWWUUWwuu
        ..NRRNNrrYNn..RWr..YTtWUUWWuu.
        ...RNNRrYNNyy.RRr.YTTyyUWWUu..
        ...NNRrnNNYYnRWRWrTTYYtWWUuw..
        ...RRRRNNYYNnyRRrTTYYTtyRRRR..
        ...WWWWwYYNnyWRWrWYYTtyWWWWw..
        ...WWWWw.NNy.RRRrr.TTy.WWWWw..
        ...WWoWwRRRRRRWRWrRRRRRWWoWw..
        ...WWoWwWWWWwRRRrrWWWWwWWoWw..
        ...WWWWwWWoWwWRWrWWWoWwWWWWw..
        ...WWWWwWWoWwRRRrrWWoWwWWWWw..
        ...WWWWwWWWWwRWRWrWWWWwWWWWw..
        ........WWWWwWWWWWWWWWw.......
        .WWWWWWWWWWWwWWWWWWWWWwWWWWWW.
        .RRRRRRRRRRRRRRRRRRRRRRRRrrrr.
        .RRDRRDRRDRRDRRDRRDRRDRRDrrrr.
        .RRDRRDRRDRRDRRDRRDRRDRRDrrrr.
        .RRDRRDRRDRRDRRDRRDRRDRRDrrrr.
        .WWWWWWWWWWWWWWWWWWWWWWWWWWWW.
        .RRRRRRRRRRRRRRRRRRRRRRRRrrrr.
        .RRDRRDRRDRRDRRDRRDRRDRRDrrrr.
        .RRDRRDRRDRRDRRDRRDRRDRRDrrrr.
        .RRDRRDRRDRRDRRDRRDRRDRRDrrrr.
        """,
        "msk.wall": """
        ................................................................................................
        R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.
        RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.RRR.
        RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
        rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
        RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
        RRRRRRRRRrRRRRRrRRRRRRRRRRRRRRRRRRRRRRRRRRRRrRRRRrRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRrRRRRRRRRRRRRR
        RRRRRRRRRRRRRRRRrRRRrRRRRRRRRRRRRRrRRRRRRRRRRRrRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRrRRRRRRRRRRRRRRR
        RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRrRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
        RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRrRRRRRRRRRRR
        RrRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRrRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRrRRRRRR
        RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
        rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
        RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
        """,
        "msk.tower": """
        ...*...
        ...Y...
        ...N...
        ..NNn..
        ..NNn..
        ..NNn..
        ..NNn..
        .NNNnn.
        .NNNnn.
        WWWWWWW
        RRRRRRr
        RRRRRRr
        RRRoRRr
        RRRRRRr
        RRRRRRr
        RRRRRRr
        RRRRRRr
        """,
        "msk.inside": """
        .................................Y....Y....Y....
        .................................Y...YYy...Y....
        .............Y...................Y..YYYyy..Y....
        .............N..................YYy.YYYYy.YYy...
        ...........NNNnn...............YYYyYYYYYyYYYyy..
        ...........NNNnn...............YYYyyYYYyyYYYyy..
        .nnnnnnnnnnnnnnnnnnnnnnnnn......YYy..YYy..YYy...
        NNNNNNNNNNNNNNNNNNNNNNNNNNN.....WWW..WWW..WWW...
        CCCCCCCCCCCCCCCCCCCCCCCCCCC.....WWW..WWW..WWW...
        CCCCCCCCCCCCCCCCCCCCCCCCCCC...WWWWWWWWWWWWWWWw..
        CCoCCoCCoCCoCCoCCoCCoCCoCCC...WWWWWWWWWWWWWWWw..
        CCCCCCCCCCCCCCCCCCCCCCCCCCC...WWoWWoWWoWWoWWow..
        CCCCCCCCCCCCCCCCCCCCCCCCCCC...WWWWWWWWWWWWWWWw..
        CCCCCCCCCCCCCCCCCCCCCCCCCCC...WWWWWWWWWWWWWWWw..
        CCCCCCCCCCCCCCCCCCCCCCCCCCC...WWWWWWWWWWWWWWWw..
        CCCCCCCCCCCCCCCCCCCCCCCCCCC...WWWWWWWWWWWWWWWw..
        """,
        "msk.farCity": """
        .........................................M..................
        ........................................MMMm................
        ........................................MMMm................
        ........................................MoMm................
        ........................................MMMm..MoMm..........
        ........................................MoMm..MMMm..........
        ........................................MMMm..MoMm..........
        ........................................MoMm..MMMm..........
        ........................................MMMm..MoMm......333.
        33333...................................MoMm.3MMMm3.....3o3.
        3o3o3..333.....................333333...MMMm.3MoMm3.....333.
        33333..3o3.....................3o3o33...MoMm.3MMMm3..3333o3.
        3o3o3..333...............33333.333333...MMMm.3MoMm3..3o3333.
        33333..3o3...............3o3o3.3o3o33...MoMm.3MMMm3..3333o3.
        3o3o3..333.333333333333..33333.333333..3MMMm.3MoMm3..3o3333.
        33333..3o3.3o3o333o3o33..3o3o3.3o3o33..3MoMm.3MMMm3..3333o3.
        3o3o3..333.333333333333..33333.333333..3MMMm.3MoMm3..3o3333.
        33333..3o3.3o3o333o3o33..3o3o3.3o3o33..3MoMm.3MMMm3..3333o3.
        """,
        "msk.cobbles": """
        gGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGG
        gGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGG
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        GGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGG
        GGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGG
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        gGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGG
        gGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGG
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        GGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGG
        GGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGG
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        gGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGG
        gGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGG
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        GGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGG
        GGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGGGGGgGG
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        """,
        "msk.spruce": """
        ...I...
        ...I...
        ..IIi..
        ...I...
        ..IIi..
        .IIIii.
        ..IIi..
        ..IIi..
        .IIIii.
        ..IIi..
        .IIIii.
        ...X...
        """,
        "vil.forest": """
        ................................................................................................
        .........................I.................................................................I....
        ................I.....IiII..I.II..I...i....I..........................I...i...I....i...I..II....
        .......I....I...I.I.i.IiII..I.IIi.I...i..i.I.....I..I.................I...i..iI..IIiI.iI..II..I.
        ..i....I..I.IIi.I.IIiIIiII..I.IIiII..IiI.i.I....IIi.I..I...i.Ii......IIiIIiIIiII.IIiIIiIIiII.II.
        ..i.I..I..IiIIiII.IIiIIiIIiIIiIIiIIiIIiIIi.I.I..IIi.I.II...iIIi.I...iIIiIIiIIiIIiIIiIIiIIiIIiIIi
        .IiII.II..IiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiII.IIiIIiIIiIIiIIiIIi.IiIIiIIiIIiIIiIIiIIiIIiIIiIIi
        .IiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIi
        IIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIi
        IIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIi
        IIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIi
        IIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIiIIi
        """,
        "vil.hills": """
        ................................................................................................
        ...........................................................................................JJJJJ
        .........JJJJJJJJJJJJJJJ...............................................................JJJJJJJJJ
        ....JJJJJJJJJJJJJJJJJJJJJJJjj.......................................................JJJJJJJJJJJJ
        JJJJJJJJJJJJJJJJJJJJJJJJJJJjjjjjj..................JJJJJJJJJJJJJJJJJJJ............JJJJJJJJJJJJJJ
        JJJJJJJJJJJJJJJJJJJJJJJJJJJjjjjjjjjj........JJJJJJJJJJJJJJJJJJJJJJJJJJJJjjjjj...JJJJJJJJJJJJJJJJ
        JJJJJJJJJJJJJJJJJJJJJJJJJJJjjjjjjjjjjjjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjjjjjjJJJJJJJJJJJJJJJJJJ
        JJJJJJJJJJJJJJJJJJJJJJJJJJJjjjjjjjjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjjjjJJJJJJJJJJJJJJJJJJJJ
        JJJJJJJJJJJJJJJJJJJJJJJJJJJjjjjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjjjJJJJJJJJJJJJJJJJJJJJJ
        JJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJ
        """,
        "vil.izba": """
        ......ee......
        .....eEEe.....
        ....eEEEEe....
        ...eEEWoEEe...
        ..eEEEEEEEEe..
        .eEEEEEEEEEEe.
        eeeeeeeeeeeeee
        .BBBBBBBBBBBb.
        .bbbbbbbbbbbb.
        .BWWWBBBBWWWb.
        .bWoWbbbbWoWb.
        .BWoWBBBBWoWb.
        .bWWWbbbbWWWb.
        .BBBBBBBBBBBb.
        """,
        "vil.izbaGreen": """
        ......nn......
        .....nNNn.....
        ....nNNNNn....
        ...nNNWoNNn...
        ..nNNNNNNNNn..
        .nNNNNNNNNNNn.
        nnnnnnnnnnnnnn
        .BBBBBBBBBBBb.
        .bbbbbbbbbbbb.
        .BWWWBBBBWWWb.
        .bWoWbbbbWoWb.
        .BWoWBBBBWoWb.
        .bWWWbbbbWWWb.
        .BBBBBBBBBBBb.
        """,
        "vil.izbaGrey": """
        ......gg......
        .....gGGg.....
        ....gGGGGg....
        ...gGGWoGGg...
        ..gGGGGGGGGg..
        .gGGGGGGGGGGg.
        gggggggggggggg
        .BBBBBBBBBBBb.
        .bbbbbbbbbbbb.
        .BWWWBBBBWWWb.
        .bWoWbbbbWoWb.
        .BWoWBBBBWoWb.
        .bWWWbbbbWWWb.
        .BBBBBBBBBBBb.
        """,
        "vil.mill.0": """
        ...................
        ...................
        ...................
        .........Bw........
        .........BW........
        .........Bw........
        .........BW........
        .........Bw........
        .........BW........
        .........b.........
        ........bbBb.......
        .BBBBBBbbbbbBBBBBB.
        .wWwWwWBBbBBWwWwWw.
        .......BBbBBb......
        .......BBBWBb......
        .......BBBwBb......
        ......BBBBWBBb.....
        ......BBBBwBBb.....
        ......BBBBWBBb.....
        """,
        "vil.mill.1": """
        ...................
        ...................
        ...................
        ...................
        ...................
        ...Bw..........Bw..
        ....BW........BW...
        .....Bw......Bw....
        ......BW....BW.....
        .......b...b.......
        ........bBbb.......
        .......bBbBBb......
        ......bBbBbBBb.....
        .......bBBBbb......
        ......BWBoBBBW.....
        .....BwBBBBBbBw....
        ....BWBBBBBBBbBW...
        ...Bw.BBBDBBBb.Bw..
        ......BBBDBBBb.....
        """,
        "vil.birch": """
        ..HHH..
        .HHHHF.
        .HHHFF.
        HHHHHFF
        HHHHFFF
        HHFFHFF
        HHHHHFF
        HFFHHFF
        HHHQHFF
        .HFqHF.
        .HQQHF.
        ..FQH..
        ...q...
        ...Q...
        ...Q...
        ...q...
        ...Q...
        ...Q...
        """,
        "vil.birchSmall": """
        ..HHH..
        .HHHHF.
        HHHHFFF
        HHHFHFF
        HHHHHFF
        HHHHHFF
        .FHqHF.
        .HQQHF.
        ...Q...
        ...q...
        ...Q...
        ...Q...
        ...q...
        """,
        "vil.hay": """
        ..yYy..
        .yYYYy.
        yYYYYYy
        YYYYYYy
        YYYYYyy
        """,
        "vil.fence": """
        B.B.B.B.B.B.B.B.B.B.B.B.B.
        BBBBBBBBBBBBBBBBBBBBBBBBBB
        b.b.b.b.b.b.b.b.b.b.b.b.b.
        b.b.b.b.b.b.b.b.b.b.b.b.b.
        """,
        "vil.meadow": """
        JJJJJJJWJJJJJJWWJJJJJJjJJJJJJJJJJjJJjJJJJJJJJJJJYJJJJJJJJJJjJJJJJjjJJJJJJjJJJJJJjJYJjjJJJYJJJJJJ
        JJjJJJYJjJJJWJJJJJJJjJjJJJJJJJJJJJJJJJJJJJJJYJJJJJJJJJJjJJWYJJJJJJjJJYJJjJJJJYJJJJjJJJJjJJJJJJJJ
        JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJYjJJjJJJJJJJJJJJJJJJJJJjJJJJjYJJJJJJJJJJJJJWJjJJJJjJJJJjJJJJ
        JJJjJJJjJJJJJJjJJJjJjJJJJJJYJjJjJJJJJJJJWJJJJjJJJJJJJJJJJJJJJJJJJjJjjJJjJJJjJYJJWJJJjjJJJJJjjjJJ
        jJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJjJJjJJJJJJJJJJJJJJJJjjJJjJJWjjjJJJJJJJJJJJJJJJJjJJjJJJJJJJJJJjj
        JJYJJJJJJJWJJJJJJJJjJJJJJJJjJJJJjJjJJJJJJJjJJJJJJJJJJJJJJJJjJJJYJjJJJJJYJJJjJJJJJJJJJJJJjJJJJJjJ
        JJJJJJJJJJjJjJjJjjJJjWJJjJJJJJJJJJjJJJJJjJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJjJJJjJJjJJJjJjJJJWJJWJ
        JJjJYJJJJYJJjJJJJJJJJJJYJJJjJJJJJJJWJJJJJjJjJJJJjJJJJJJJjJJjWJjJJJJJJJJJJJJJJJJJJJJJJJjJjJJjJJJj
        JJJJJjJJJJJJJJJJJYJJJJJjJJJJJjjJJJJJjJjJJJJJJJJJJjJJJJJJJJJJJJJWJJJJjJJJJJJjJJJJJJJJJJJJJjWJJJJJ
        JJJJJJJJJJJJjJJJJJJjJJJJJJJWJJJJJJJJJJjJJYJJJWJJJJJJjJJJJJJJJJjJJjjJjJJWJjJJJYJJJJJjJJJJJjJJjJJJ
        jJJJjJJJJjJJJJJJJJJJJJJJJJJJjjJJjjjJJjJJJJJjJJJJJJYJJJJJJJJJJJJJJjYjJJjJJjJJJJjJJjJWJJJJWJJjJJjJ
        JJJJJJJJJJJJJWjJJJJJJJJJJYJJJJjJJjJJJJJJJJJJJWJJJJJJJJJJJJJJJJJJJJJJJJJJJJYJJJJJJJJJJJJJYJJJJJJJ
        JJJJJJJJjJJJJjJJJJJJJJJJJJJJJjJjJJYJjJJJJJJJJjJJjjjWjYJjJJJJJJJJJJJJJJJJJJjjjJjJWJjYJJJjJJJJJJJJ
        JJJJJJJJJjJjJYJJJJJJJJJJJJjJjJJJJJJJJJJJJYJJJjJJYJWjJJJjJJJJjJJJJJJJjJJJJjjJjJJJJJJJJjJYJJJJJJJJ
        JJJJJjJJJJjJJjjYJJJJJJJJJJJJJJJJJjJJJJJJJJJjJJJJJJJJJJJJJJJJJJJYjJjJJJJJjJJJJjJJJJJJJjJJJJJJJJJJ
        JJJjJJJJJJjJjJJJJJJJJjJjYjJJJJJJJJJJJJJJJJJJjjJJJJJJJJJjJYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJ
        JJJJJJJJWJJJJJJJJJjJjJJJJjJJJJJJJJWJJJJJWJJJJJJJJJJJJJWJJJJJjJJJJJJYJJJJJjJJjJjJJJjJJJJJYJJJJJJJ
        JJJJJWJJJJJJJJJJjJJJJJJJJjJJjJJJJJJJJJJJWJJjJJJJjjJJjJJJJJJJJJWJjjWJjWJJJJjJJJJJJJjJWJJJJJJJJJJJ
        """,
        "vil.boat": """
        ...b......
        BBBBBBBBBB
        .bbbbbbbb.
        """,
        "par.eiffel": """
        .............Gb............
        .............Gb............
        .............Gb............
        ............BBB............
        ............bbb............
        ............BBb............
        ............BBb............
        ............BBb............
        ............BBb............
        ............BBBb...........
        ...........BBBBb...........
        ...........BBBBb...........
        ...........BBBBb...........
        ...........BB.Bb...........
        ...........BB.Bb...........
        ...........B.B.b...........
        ...........BB.Bb...........
        ...........BB.BBb..........
        ..........B..B..b..........
        ..........BBB.BBb..........
        ..........BBB.BBb..........
        ........BBBBBBBBBBB........
        .........bbbbbbbbb.........
        .........B.BB.BB.b.........
        .........BB..B..Bb.........
        ........BB.BB.BB.Bb........
        ........BB.BB.BB.Bb........
        ........B.B..B..B.b........
        .......BBB.BB.BB.BBb.......
        .......BBB.BB.BB.BBb.......
        .......B..B..B..B..b.......
        .......BBB.BB.BB.BBb.......
        ......B.BB.BB.BB.BB.b......
        ....BBBBBBBBBBBBBBBBBBB....
        .....bbbbbbbbbbbbbbbbb.....
        .....BB.BB.BB.BB.BB.Bb.....
        ....B..B..B.....B..B..b....
        ....BBB.BB.......BB.BBb....
        ...B.BB.BB.......BB.BB.b...
        ...BB..B...........B..Bb...
        ..BB.BB.B.........B.BB.Bb..
        .BBB.BB.............BB.BBb.
        .B..B..B...........B..B..b.
        B.BB.BB.............BB.BB.b
        """,
        "par.houses": """
        ................................................................
        ................................................................
        ................................................................
        ................................................................
        ................................................................
        ................................................................
        ........E........................E...........E..........E.......
        .LLLLLLLLL..............LLLLLLLLLLL..LLLLLLLLLL..LLLLLLLLL......
        LLoLLoLLoLL............LLoLLoLLoLLLLLLoLLoLLoLLLLLoLLoLLoLL.....
        lllllllllll.........E..llllllllllllllllllllllllllllllllllll.....
        CCCCCCCCCCC.LLLLLLLLLL.CCCCCCCCCCCCCSSSSSSSSSSSSCCCCCCCCCCC.LLLL
        CoCoCoCoCoCLLoLLoLLoLLLCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoCLLoLL
        CoCoCoCoCoCllllllllllllCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoClllll
        CCCCCCCCCCCWWWWWWWWWWWWCCCCCCCCCCCCCSSSSSSSSSSSSCCCCCCCCCCCWWWWW
        CoCoCoCoCoCWoWoWoWoWoWWCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoCWoWoW
        CoCoCoCoCoCWoWoWoWoWoWWCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoCWoWoW
        CDCDCDCDCDCWWWWWWWWWWWWCDCDCDCDCDCDCSDSDSDSDSDSSCDCDCDCDCDCWWWWW
        CoCoCoCoCoCWoWoWoWoWoWWCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoCWoWoW
        CoCoCoCoCoCWoWoWoWoWoWWCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoCWoWoW
        CDCDCDCDCDCWDWDWDWDWDWWCDCDCDCDCDCDCSDSDSDSDSDSSCDCDCDCDCDCWDWDW
        CoCoCoCoCoCWoWoWoWoWoWWCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoCWoWoW
        CoCoCoCoCoCWoWoWoWoWoWWCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoCWoWoW
        CDCDCDCDCDCWDWDWDWDWDWWCDCDCDCDCDCDCSDSDSDSDSDSSCDCDCDCDCDCWDWDW
        CoCoCoCoCoCWoWoWoWoWoWWCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoCWoWoW
        CoCoCoCoCoCWoWoWoWoWoWWCoCoCoCoCoCoCSoSoSoSoSoSSCoCoCoCoCoCWoWoW
        CDCDCDCDCDCWDWDWDWDWDWWCDCDCDCDCDCDCSDSDSDSDSDSSCDCDCDCDCDCWDWDW
        """,
        "par.far": """
        ..............................333333............................................................
        ..............................333333............................................................
        .333..33333..........3333333..3333333...................3333333..........................33333..
        333333333333........333333333333333333.................333333333.33333..........3333333.3333333.
        333333333333.333333.333333333333333333.33333333..33333.3333333333333333........3333333333333333.
        33333333333333333333333333333333333333333333333333333333333333333333333.333333.33333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        """,
        "par.avenue": """
        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        sSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSS
        SSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        SSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSS
        sSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        sSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSS
        SSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        SSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSS
        sSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        sSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSS
        SSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSSSSSSsSSS
        """,
        "tree.round": """
        ..HHHHF..
        .HHHHfFF.
        HHHHFFFff
        HHHfFFfff
        HHffFFfff
        HffFFffff
        .FFFffff.
        .FFfffff.
        ...fXf...
        ....X....
        """,
        "tree.roundSmall": """
        .HHHFF.
        HHHfFFf
        HHFffFf
        HFfFFff
        fFFFfff
        .FFfff.
        ..fXf..
        ...X...
        """,
        "cst.town": """
        ............................................UU..
        ...........................................UUUu.
        ...........................................WWWw.
        ....................................P......WWWwb
        ................................WWWWWw.WWWWWDWwa
        ................................WoWWWwaWoWWWDWwa
        ...............................bWWWWWYbWWWWWWWwa
        ..............................bbWWWWVUUWWWoWWWwa
        ............................aabbWWoVVUUubWWWWWwb
        ...........................babbbaWWUUUUubWWWWWwb
        .........................WWWWwbaaWWWWWWWwWWWWWwb
        .........................WoWWwbaaWWWWWWWwaaaWWWW
        ........................YWWWUwaaaaWWWWWWwaabWoWW
        .......................aaWWWUwaaabWWWWWWwaabWWWU
        .....................PVVUUuWWWwaaaWWWWWWwWWWWwWU
        ..................WWWUUUUUuuWWwaaaabbbabaWoWWwba
        ..................WoWUUUUUuuUWwaaaWWWWWwaWWWWwaa
        ..................WWWWWWWWWwWWWwaaWoWWWwaWWWUwaa
        ................bbWWWWWWWWWwWWWwaaWWWUWwaWWWWWWW
        ..............abbbWWPWWWWWWwWWWwabWWWUWwaabbWoWW
        ...........WWWWWwWWWWWWWWWWwoWWwbbbaWWWWWwbbWWWW
        ...........WoWWWwWoWWWWWWWWwWWWwbbbaWoWWWwbbWWWU
        ..........aWWYUWwWWWWwabbaaWWWUwbbbbWWWUWwbaWWWU
        ........abaWWUUWwWWWUPbbbaaWWWWWWwaWWWWWwwbbWWWW
        .......aaaaVVUuubWWWWWwbaaaaWoWWWwaWoWWWwbaaWoWW
        ....WWWWWwaUUUuuaWoWWWwbaaaaWWWUWwaWWWUWwbaaWWWU
        ....WoWWWWWWWWWWwWWWWWwaaaaaWWWUWwaWWWUWwaaaWWWU
        ....WWWWWWWWWWWWwWWWWWWWwabaabbbaaaababbbaaaaaab
        ...bWWWUWWWWWWWWwWWWWoWWwaaaabbaaaaaabbbbaaabbab
        ..bbWWWUWWWWWWWWwaabWWWUwbaabbbaaaababbbaaaaaabb
        .bbaababaaWWWWWWwaabWWWUwbaabbbaaaabbbbaaaaaaabb
        bbbaabaaabbbaaaaaabbbaaaaaabbbaaababbbbababaabbb
        bbbaaaaaabbaaaaaaabbaaaaaaabbaaaaaaabbaabaaabbba
        bbabaaaabbbaaaababbbaaaaaabbbbaaaaabbbaabaaabbbb
        """,
        "cst.mill": """
        ..w.....w..
        ...w...w...
        ....wAw....
        ....AAa....
        ...WAAaW...
        ..w.WWw.w..
        .w..WWw..w.
        ....WDw....
        ....WWw....
        ...WWWww...
        """,
        "cst.islands": """
        ................................................................................................
        ...............................................................33333333333333333333333333.......
        ....33333333333333333333......................................3333333333333333333333333333......
        ...3333333333333333333333......33333333......................333333333333333333333333333333.....
        ..333333333333333333333333....3333333333....................33333333333333333333333333333333....
        """,
        "cst.rocks": """
        ....................
        ....................
        .......a............
        ......aaaa..........
        ..aaaaaaaabbbb......
        ..aaaaaaaabbbbbbb...
        aaaaaaaaaabbbbbbbb..
        aaaaaaaaaabbbbbbbbbb
        """,
        "yacht": """
        ....W.....
        ....WW....
        ....WWW...
        ...wWWWW..
        ...wWWWWW.
        ...wWWWWWW
        ....D.....
        RRRRRRRRRR
        .WWWWWWWW.
        """,
        "alp.peaks": """
        ......................................................................V.........................
        .....................................................................Vww........................
        ....................................................................VVwww.......................
        ....................................................................VVVwww......................
        ...................................................................VVVVwww......................
        ...................................................................VVVwwww......................
        ...................................................................VVVVwww......................
        ..................................................................VVVVwwwwww....................
        .................................................................VVVVwwwwwww..............V.....
        ................................................................VVVV1w2w2www2w...........VVw....
        ...............................................................1V1V1112222222w...........VVw....
        ..............................................................11111111222222222..........VVw....
        ..............................................V................111111122222222.........VVVVwww..
        .............................................Vww..............111111112222222222........VVwwww..
        .............................................Vww.............11111112222222222222.....VVVVVwwww.
        ............................................VVwww............11111112222222222222.....VVVVwwwww.
        ..........................................VVVVVwwww.........1111111112222222222222...VVVVVwwwwww
        ..........................................VVVVVwwwww........1111111122222222222222..V1VV12wwwww2
        ......................V..................VVVVVwwwwww......1111111111122222222222222211VV122ww2w2
        .....................VVw................VVVVVVwwwwwww....111111111111222222222222222111111222222
        ....................VVVww..............VVVVVVVwwwwwwww...111111111112222222222222221111112222222
        ...................VVVVwww............11VVV11V22www2222.1111111111112222222222222221111112222222
        ..................VVVVVwwww...........111VV11222w222222..111111111122222222222222211111122222222
        .................VVVVVwwwwwww........11111111222222222211111111111112222222222221111111122222222
        ...............VVVVVVVVwwwwwww.......11111111222222222211111111111122222222222221111111122222222
        ...............VVVVVVVwwwwwwww.......11111111222222222211111111111112222222222221111111112222222
        .............VVVVVVVVwwwwwwwwwwww...111111112222222222111111111111122222222222211111111122222222
        ............11111VV11Vwww222w2w2ww11111111111222222222111111111111122222222222211111111122222221
        ............1111111111ww2222w222w211111111111222222221111111111111122222222222111111111112222221
        .........111111111111222222222221111111111111222222211111111111111222222222221111111111122222211
        ........1111111111111122222222221111111111111222221111111111111111222222222211111111111222222111
        .......11111111111111122222222221111111111111222222111111111111111122222222211111111111222222111
        ......111111111111111222222222211111111111111222221111111111111111222222222211111111111222221111
        ......111111111111112222222221111111111111122222211111111111111111222222221111111111111122221111
        ....11111111111111112222222222111111111111112222211111111111111112222222221111111111111122111111
        ...111111111111111111222222211111111111111112221111111111111111112222222221111111111111222111111
        ..1111111111111111112222222211111111111111122222111111111111111112222222211111111111112221111111
        ..1111111111111111112222222111111111111111122211111111111111111111222222111111111111112211111111
        """,
        "alp.forest": """
        ................................................................................................
        ................................................................................................
        ...............................................................................IIIIIIIIIIf......
        .....IIIIIIIIIII...........................................................IIIIIIIIIIIIIfffIII..
        .IIIIIIfIIfIIfIIIIfI....................................................IIfIIIfIIIIIIIIIIfIffIif
        IIIIIIIIIIIIIIIffIIIiii..............IIIIIIIIIIIIfIf.................IIIIIIIfIIIfIffIIIIIfIIIfif
        fIIIIIIfIIIIfIIIIIIfiiiii.......IffIIIIIfIfIIIIIIIIIfIIii..........IffIIIIIIIIIIIIIIIIIIfIIIIffi
        IIIfIIIIIIIfffIIIIIIfiiifii..fIIIfIffIIIIIIIfIIfIfIIIIIfiifi......IIIIIIIIIIfIIIfIIIIIIfIIIIIIii
        IfIIfIIIIIIIIIIIIffIfiiifiIIIIfIIIfIIfIIIIIffIIIIIIIIIIiffiiiif.IIIIfIIIIIIfIIfIIIIIIIIIfIIIIIif
        IIIIIfIIIIIIIIIIIIIfiifIIIfIIIIIIfIIfIIIIIIIIIIIfIIffIIiiiiiiffIIIIIIfIIfIIIfIIIIIIIIIIIIIIIIIfi
        IIIfIIIIIIIIIIIIIIfIifIIIIIIfIIIIIIIIIIIIIIIIIIIfIIIIIIiiiiffIIffIIIIIIfIIIIIIIfIIfIIIIfIIIfIfii
        IIIIIIIIIIIIfIIffIfIIIIIIIIIIIfIIIIIIIfIIIIfIIfIIIIfIffiiiiiIIIIIIffIIfIIIIfIIffIIIIfIIIIIIIIIfi
        IIIIIIIIfIIIfIIfIIIIIIIIIIIIIIffIIIIfIIIIIIIffIIIIIIfIIifiIfIIIIIIIIIffIffIIIIfIfIIIIIIIIIIIIIii
        IIIfffIfIIIIfIIIIIIfIIIIIIIIIIIIIIIIffIIIIIIIIIIIIIIfIIiiIIIIfIIIIIIIIIIIfIfIIIfIfIIffIfIfIIfIif
        """,
        "alp.chalet": """
        ....eEEe....
        ..eEEEEEEe..
        eEEEEEEEEEEe
        .bBBoBBoBBb.
        .bBBBBBBBBb.
        .WWoWWWWoWw.
        .WWWWWDWWWw.
        .WWWWWDWWWw.
        """,
        "alp.church": """
        ..........NN.
        ..........NN.
        ..........Nn.
        ..........Nn.
        .........NNNN
        .........nnnn
        .........WWWw
        .........WWWw
        .........WYWw
        .........YKYw
        ...eeee..WYWw
        ..EEEEEE.WWWw
        .EEEEEEEEWWWw
        EEEEEEEEEWDDw
        WWWWWWWWWWWWw
        WWWWWWWWWWWWw
        WWWWWWWWWWWWw
        WWoWWWoWWWWWw
        WWoWWWoWWWWWw
        WWWWWWWWWWWWw
        WWWWWWWWWWWWw
        WWWWWWWWWWWWw
        """,
        "alp.meadow": """
        JjJJJJJjJjJJjjjjJjJYjJjJPjJWJJjJJJJJPJJYJJJJJJJJJjJJJJJJJJJJJJjJJJJJJJJJJJjJJJjJJJJJJJJJjWJjjJJj
        JJJJJJJJJJJJJWYJJYJPJJJJJJJJjjJJJJJJJJYJJJjJJJJJJJjJjJJJWjJJJjJJJJJJJJJJJJjJJJJJJJjJJJJJJJJYJJJJ
        jJWJJJjJJjJJYJJJJJjYJJJJPjJjJWJJjJWJYjJJJJJJJJJJJJJJJPJJJjJJJjPJJJJjjJJjJJJJJJjJJJWjJJJJJJJJJJJJ
        JJJJJJJJJJJJjJJJJJJJjJJJJJYjJJjJJJJJJJJjJJJJJYJJJJYJJJJJJJJJJJjJJJjJYJJJJJjJJJJJJJJjjJYJjJJJJJJJ
        JJJWJJJJJjJJJJjjJJJjPWJJJjJPJJJJJJjJjYJjJJWJPJWJJJJJJJjJJJJJJjJJJJJJJjjJjJJJjJJJJJJJPJJJJJJJjJJP
        JJJjJJJJJJJJJjJjYjJJJJJJJJJJJJWJJJJJJJJjJJJjJJJJWjJJJJJJJJJWjJJJJJJPJJJJJJJWJJJJjJJJJJJJjjJJJJJJ
        JWJJjJjJWJJJJJjJJPJjJJjJJJjjJJjJJjJjJJJjJjJJJJJWJjJJJJjJJYJWJjJjjJJPJJJJJJJJJjJJJJJJJJJJJJJJjjYJ
        JJYJJJJJJJJJJJjJJjYJjJjJJJJjjJJJJJJjJJJjJJJJJjJJJJJJjJjJJJJJJJJWjYJJJJJJJJJJJJJjJJjJjJJYJJJJJJJJ
        JJJJJJJjJJJJjJJJjJJjJJJJJJYJJJJjJjJJJjJJJJJJjJJJJJJjjJJJJJjJJJWJJJJJJJjJjJJJJJJJJJJjJJJJPjJJJJJJ
        JJJJJJJWJJJJJJJJJJJJJJPJJJJJjWJJJJJJJJJJJJJjPJJJJJJjJJYJJJJJjJJJJJJYJJJjjJJJPJJJPJjJJJJjJJJJjJJj
        JJJPJWJjjJJJYjJJJJJJJJJWjJJJJJJJJJJJJjJJjJJJJJJJJJPJJJJjJJjJJJJJJjJJJJJJJJJJJJJJJJJJJJWJjJJYjJJJ
        JJJJJJJJJJWJYJJJjJJJJJJWWjJJjJPJJjJJJWJJJJjJJJJjJJJJJJJjJJJJJJJYJjJJJJJJJJJJjJPJJJJJJJJJJJJjJJJj
        JjjJJJJJJJJPJJJWJjJJWJJJJJJJjJJJJJJjJJJJjJjJJjJJJjJJJYJJJJJjJJJJJYJJJjJJJJJJJJJJJJJJJJJjJJJJJPJJ
        JjJJJJJJJJJJPjJJJJJJJJJjjJJJJJPjWJjJjjJJJJJJJjJJJJjJJJJJJJJJJJJJJJJJJJjYjJJJjJJJJJJJJJYjJJJjJPJJ
        JJJjjjJJJJJJJJjJJPJJjJJjYJJJJJJJJJjJjJJJJjjJJJWJPJJjjJJJJJJJjJjJJJJJJJJjJJjJJJJjJJJJWJjJPJJJJPJJ
        JJWJJJJJJJJJJJJJJJJjJJJjJjJjJJJJJJJjJJJJJJjPjJJJJjJJJJjJJJJJJJJJjJJJJjjYJjJJJJJPJJJJJJJJjJJJJJJJ
        """,
        "alp.pine": """
        ...I...
        ...I...
        ..IIi..
        ...I...
        ..IIi..
        .IIIii.
        ..IIi..
        .IIIii.
        .IIIii.
        .IIIii.
        ...X...
        """,
        "ny.skyline": """
        ..................................................
        ..................................................
        ..................................................
        ..............G...................................
        ..............G...................................
        ..............G...................................
        ..............G.......*................V..........
        ..............G.......G................V..........
        ..............G.......G................V..........
        ..............G.......G................V..........
        ............MMomm.....G...............oVo.........
        ............MoMmm....GGg..............VVw.........
        ............oMMmm....GGg..............oVo.........
        ............MMMmm....GGg..............VVw.........
        ............MMomm...oGoGg.............VVw.........
        ............MoMmm...oGoGg............ooVoo........
        ............oMMmm...oGoGg............VVVww........
        ............MMMmm..GoGoGgg...........ooVoo........
        .....GGGGGGMMMommm.GoGoGgg.b.........VVVww........
        .....GGGGGGMMoMmmm.GoGoGgg.bb........VVVww........
        .....GGGoGoMoMMmmm.GoGoGgg.bb.......oooVooo.......
        .....GGGGGGoMMMmmm.GoGoGgg.DD.......VVVVwww.......
        .b...GoGoGGMMMommmoGoGoGoggCCCCc....GGGGGGg.......
        .bb..GGGGGGMMoMmmmoGoGoGoggCCCCc....GGGGGGg.......
        .bb..GoGoGGMoMMmmmoGoGoGoggoCoCc....GoGoGog.SSSSSs
        .DD..GGGGGGoMMMmmmoGoGoGoggCCCCc....GGGGGGg.SSSSSs
        SSSSSGoGGGGMMMommmoGoGoGoggCCoCcb...GoGoGog.SoSoSs
        SSSSSGGGGGGMMoMmmmoGoGoGoggCCCCcbb..GGGGGGg.SSSSSs
        SSSoSGGGGGoMoMMmmmoGoGoGoggoCoCcbb..GoGoGog.SSSoSs
        SSSSSGGGGGGoMMMmmmoGoGoGoggCCCCcDD..GGGGGGg.SSSSSs
        SoSoSGoGoGGMMMommmoGoGoGoggCCoCRRRRrGoGoGog.SSSoSs
        SSSSSGGGGGGMMoMmmmoGoGoGoggCCCCRRRRrGGGGGGg.SSSSSs
        SoSoSGoGoGoMoMMmmmoGoGoGoggoCCCRoRorGoGoGog.SoSSSs
        SSSSSGGGGGMoMMMmmmoGoGoGoggCCCCRRRRrGGGGGGg.SSSSSs
        SSSSSGoGoGoMMMommmoGoGoGoggCCCCRRRorGoGoGog.SoSSSs
        SSSSSGGGGGMMMoMmmmoGoGoGoggCCCCRRRRrGGGGGGg.SSSSSs
        SoSoSGoGoGMMoMMmmGoGoGoGogggCCCRoRorGoGoGog.SoSoSs
        SSSSSGGGGGMoMMMmmGoGoGoGogggCCCRRRRrGGGGGGg.SSSSSs
        SoSoSGGGoGoMMMommGoGoGoGogggCoCRoRorGoGoGog.SoSSSs
        SSSSSGGGGGMMMoMmmGoGoGoGogggCCCRRRRrGGGGGGg.SSSSSs
        SoSSSGoGoGMMoMMmmGoGoGoGogggCoCRoRorGoGoGog.SoSoSs
        SSSSSGGGGGMoMMMmmGoGoGoGogggCCCRRRRrGGGGGGg.SSSSSs
        SSSoSGoGoGoMMMommGoGoGoGogggCoCRRRorGoGoGog.SSSSSs
        SSSSSGGGGGMMMoMmmGoGoGoGogggCCCRRRRrGGGGGGg.SSSSSs
        SoSSSGoGoGMMoMMmmGoGoGoGogggCoCRoRorGoGoGog.SoSoSs
        SSSSSGGGGGMoMMMmmGoGoGoGogggCCCRRRRrGGGGGGg.SSSSSs
        SoSoSGoGoGoMMMommGoGoGoGogggCoCRoRorGoGoGog.SSSoSs
        SSSSSGGGGGMMMoMmmGoGoGoGogggCCCRRRRrGGGGGGg.SSSSSs
        """,
        "ny.liberty": """
        +......
        N......
        N.N.N..
        NNNNN..
        .NNNn..
        .NNNn..
        .NNNnn.
        ..NNn..
        .NNNnn.
        .NNNnn.
        .NNNnn.
        .SSSss.
        .SoSss.
        .SSSss.
        SSSSsss
        SSSSsss
        GGGGGGG
        """,
        "ny.far": """
        ................................................................................................
        ..........................................333...................................................
        .........333333...................333.....333...................................................
        .........333333...................333.....333...................................................
        .........333333...................333.....333...................................................
        333......333333...................333.....333............333.............................333....
        333333333333333...................33333333333............333....333......................333....
        3333333333333333333........333....33333333333............333....333......................333....
        333333333333333333333333333333....33333333333............33333333333333333333............3333333
        333333333333333333333333333333....3333333333333333333....33333333333333333333......3333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        """,
        "ny.ferry": """
        .....WW.......
        ...OOOOOOOO...
        ..OoOoOoOoOO..
        OOOOOOOOOOOOOO
        .DDDDDDDDDDDD.
        """,
        "mnt.peaks": """
        ....................................................................................V...........
        ...................................................................................Vww..........
        ..............................................................V.....................ww..........
        .............................................................VVw..................VVwww.........
        .............................................................Vww..................VVwww.........
        ............................................................VVVwww...............VVVVwww........
        ...........................................................VVVwwww...............VVVwwww........
        ...........................................................VVVwwww..............VVVwwwwww.......
        ..........................................................VVVVwwwww.............VVVwwwwww.......
        .........................................................VVVVVwwwwww............VVVwwwwwww......
        .........................................................VVVVVwwwwww..........VVVVVVwwwwwww.....
        ........................................................VVVVVwwwwwwww..........1V1V1w2w22ww.....
        ........................................................VVVVVVwwwwwww........V1111V2222222w2w...
        ......................................................V1VVV1V122ww2wwww.....11111112222222222...
        ....................................V.................11V11112222w2w2ww.....111111122222222222..
        ...................................VVw...............1111111122222222222...1111111222222222222..
        ..................................VVVww..............1111111222222222222...1111111122222222222..
        .................................VVVwwww............1111111122222222222222.11111111222222222222.
        ................................VVVVVwwww...........111111111222222222222.111111112222222222222.
        ................................VVVVwwwww...........1111111122222222222222111111112222222222222.
        ..........V.....................VVVVVwwww..........111111111122222222222221111111112222222222222
        .........Vww...................VVVVVwwwwww........1111111111122222222222111111111122222222222222
        ........VVwww.................VVVVVwwwwwwww......11111111111222222222222211111111122222222222222
        ......VVVVwwwww...............VVVVVVwwwwwwww.....11111111112222222222222111111111222222222222222
        ......VVVVwwwww.............VVVVVVVwwwwwwwwwww...11111111111222222222221111111111222222222222222
        .....VVVVVVwwwww............1V1V1V1122w2w2w22w.1111111111111222222222211111111111122222222222222
        ...VVVVVVVwwwwwwww........111V111112222222w22221111111111112222222222211111111111122222222222221
        ..VVVVVVVVwwwwwwwwww.......111111111222222222211111111111111222222222211111111112222222222222211
        .VVVVVVVVVwwwwwwwwwww.....1111111112222222222211111111111112222222222111111111112222222222222211
        VVVVVVVVVVwwwwwwwwwwww...11111111112222222222111111111111112222222221111111111111222222222222211
        VVVVVVVVVVwwwwwwwwwwwww.111111111122222222222111111111111112222222221111111111112222222222222211
        V11VVVVV1ww2wwwwwwwww2w1111111111112222222221111111111111122222222221111111111112222222222222111
        1111VVVV12w2ww22w222w221111111111122222222211111111111111122222222111111111111111222222222221111
        111111111122222222222111111111111112222222111111111111111122222221111111111111111222222222221111
        111111112222222222221111111111111122222221111111111111111112222221111111111111112222222222211111
        111111111222222222211111111111111122222221111111111111111122222221111111111111122222222222111111
        111111111222222222211111111111111122222211111111111111111222222221111111111111122222222222111111
        111111111222222222111111111111111222222211111111111111111122222211111111111111122222222222111111
        111111112222222222111111111111111222222111111111111111111122222111111111111111122222222211111111
        111111112222222221111111111111111122222111111111111111111122222111111111111111112222222211111111
        """,
        "mnt.foothills": """
        ................................................................................................
        ................................................................................................
        ...................................jjjjjjjjjjj..................................................
        ...............................jjjjjjjjjjjjjjjjjjj..............................................
        .jjjjjjjjjjj.................jjjjjjjjjjjjjjjjjjjjjff.........................................jjj
        jjjjjjjjjjjjjjjf..........jjjjjjjjjjjjjjjjjjjjjjjjfffff...............jjjjjjjjjjjjj........jjjjj
        jjjjjjjjjjjjjjjfff.......jjjjjjjjjjjjjjjjjjjjjjjjjffffff.........jjjjjjjjjjjjjjjjjjjjjff.jjjjjjj
        jjjjjjjjjjjjjjjffffff..jjjjjjjjjjjjjjjjjjjjjjjjjjjffffffff....jjjjjjjjjjjjjjjjjjjjjjjjffjjjjjjjj
        jjjjjjjjjjjjjjjffffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjfffffffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjfffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjfffffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjfffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjfffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        """,
        "mnt.spruce": """
        ...I...
        ...I...
        ..IIi..
        ...I...
        ..IIi..
        .IIIii.
        ..IIi..
        ..IIi..
        .IIIii.
        ..IIi..
        .IIIii.
        IIIIiii
        ...X...
        """,
        "mnt.spruceSmall": """
        ..I..
        ..I..
        .IIi.
        ..I..
        .IIi.
        IIIii
        .IIi.
        .IIi.
        ..X..
        """,
        "mnt.yurt": """
        ...WWW...
        .WWWWWWw.
        WWWWWWWww
        RYRYRYRYr
        WWWDDWWww
        WWWDDWWww
        """,
        "mnt.horse": """
        bBBBBb..
        .BBBBBBb
        .B..B..B
        .b..b...
        """,
        "mnt.apple": """
        .HHHfF.
        HHHFRFF
        HRFFFFf
        HFFFFff
        FfRFfRf
        .Fffff.
        ..fXf..
        ...X...
        """,
        "mnt.meadow": """
        JJJjJjJJJJjJJJJjJJJJJJYJJJJJJJJJJJJJJJJJJJjJJJJJJjJJJJJJJJJJJJJJJjJJJJJJJjJJJJJJjJJJJJJJJJJJJJJj
        JJjJJJJJJJJJJJJJJJJJJJJJJJJYJJJJJjJYJJJJJJJJJJJjJJJJYJjjJJJJJJJJJjJYJJjJJJJJJJJJJJJJJjJJJJJJJJJJ
        JJYJJJJJJjJJJJJJJJJJJJJJJJJJJJJjJjJJJJJJJjJJJJJjJJJJJjJJJjJJYJJJjJJJJJJJJJJYJJJJJjjjJJJJJJJJJJJY
        JJjjJJjJJJJJJJJJJJjJJJJJJJJJJJJJJJJjJJJJjjJJJJjJJJJJJJJJJjjJJJJJJJJJJJJJJJJJJjJJjJYjJJJJJJJjJJJJ
        JJJJJJJJJJJJJJJJJJJJJJJJJjJJJJYJJJJJJJJYJJJJJYJJJJJjJJJJJJJjJJJJJJJJJJjJJJJYJJJJJJJJJJJJjJJJJJYJ
        JJYJJJJJJJJJJJjJjJJJYJJJJJJJJJJJJJJjJjJJJJJJJJJJJJJJJJjJJJJJJJJjJJJYJJJJJJJjjJJJJJJJJjJJJJJJJJJJ
        JJjJJJJJJYJYJJJjJJYJJJjJJJjJYJJJJjJYJJJJJJJJJJJJjjJJJJJJJJJJJJJjJJJjJJJJjJJJJJJjJJJJJJJJJJJJJYJJ
        JJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJjJJJYjJJJJjJJJJJJJJJJJJjJJJJJJJjjJJJJJJYJJJJJJJJYJJJJJJJJJJJJJJJJ
        JJJJjJJJjJJJjJJJJJYJJJYJJjJJYJJJJjjJJJJJJJJJjJJJjJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJjJJJJJJjJ
        JJJJJJJJJJjJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJYjJJJJJJJJJJJJJJJJJJJjJJJJJJJJjJJJJJJjJYJjJJJJJJJJJJJJ
        JJJJJJJJJJJJJJJJJJjJJJJJJjJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJYJJJJJJJJJJJJJJJJJJJJJJJ
        JJjJJJJJJJJJJJJjJJYJJJJJJJJJJYJJJJJjJJJJJJJJJJJJJYJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
        JJjJJJJJJJjJJJJJJJJjJJJJJJJJJYJjjJJJJJJJJJJJJJjJJJJJJJJJJYJJJJJJJJJJJJJJJYJJJJJJJJJJJJJJJJJJJjJj
        jJJjjYJjJJJjYJJJJJJjjJjJJJJJJJJJJJJjjJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJYJJJJJJJJJJJJJJJjJJJJ
        JJJJJJJJJjJYJJJJJJjJJJJJJJJJjJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJjJJJJJJJjJjJJJJJJJJJ
        JjJJJJJJJJJJjJJJJJJJYJYJJJJJJJJJJJJJJJYJJJJJYJJJJJJJJJJJjJJJJJjJjJJJJJJJJjJJJJJJjJJJJJJJJJJYJJJJ
        JJjJJJJJJJJJJJJjJJJJJJYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJjJJjJjJJJJJJJJJJjJJJJ
        JJJJJJJJJjJJJjJJJJjJJJJJJJJJJJJJJJJjJJJJJJJJJJJJjJJJJJJJJYJJJJJJYJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJ
        """,
        "trp.k1": """
        ...FFFFff...
        ...FFFFff...
        ..FFFFFfff..
        ..GFFFGfff..
        .FGFFFGfggf.
        .FFFGGGgggg.
        .GGGFGGgfgg.
        .GGGGGFgggg.
        .GFGGGGgggf.
        .GGGFFGfggf.
        .GFGGGGgggg.
        .GFFGGGggfg.
        .GFGGFGgggg.
        .GGGGGGgggf.
        GFGGGGGGgggg
        GFGFGFGGggfg
        GGGGGGGGgggg
        GGGGGGGGgggg
        GGGGGGGGgggg
        GGGGGGGGgggg
        GGGGGGGGgggg
        GGGGGGGGgggg
        """,
        "trp.k2": """
        ...FFf...
        ..FFFff..
        .FFFFfff.
        .GFFGfff.
        .GFFGggg.
        .GGFGgfg.
        .GGFGGgg.
        .GGGGFfg.
        GGGGGGggg
        FGGFGFggg
        GGFGFGggg
        GGGGGGggg
        GGGGGGggg
        GGGGGGggg
        GGGGGGggg
        """,
        "trp.k3": """
        ....FFFFFfff....
        ....FFFFFfff....
        ..FFFFFFFFffff..
        ..FFGFFGFGfggf..
        ..GFFFFGFFfggf..
        ..GGGGGFGGgggg..
        ..GFGGGFGFgfgg..
        ..GGGGGGGGgfgf..
        .GGFGGFGGGggggg.
        .GFGGGGGGGgggff.
        .GFFGGGGGGggfgg.
        .GGGGGGGGGggggg.
        .GGGFGGGGGgfggg.
        .GGGGGGGGGgfgff.
        .FGGGFFGFGggggg.
        .GGGGGGGGGffffg.
        .GGGGGGGGGggggg.
        .GGGGFGFFGgffgf.
        .GGGGGGGGGggggg.
        GGGGGGGGGGgggggg
        GGGGGGGGGGgggggg
        GGGGGGGGGGgggggg
        GGGGGGGGGGgggggg
        GGGGGGGGGGgggggg
        GGGGGGGGGGgggggg
        GGGGGGGGGGgggggg
        """,
        "trp.k4": """
        ..FFf..
        ..FFf..
        .FFFff.
        .FFFff.
        GGGFfgg
        GGGGggg
        GGGGggg
        GGGGggg
        GGGGggg
        GGGGggg
        """,
        "trp.boat": """
        ..............RY
        .............YBN
        b...........BB..
        BBBBBBBBBBBBBB..
        .bbbbbbbbbbbb...
        """,
        "trp.beach": """
        VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
        CCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCC
        CSCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCSCCCCCCCCCCCCCCCSCCCCC
        CSCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCSCSCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCC
        CCCCSSCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCS
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCSCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCSCC
        CCCCCCCCCCSCCCCSCCCCCSCCSCCCSCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCSCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCSSCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCSCSCCC
        SCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCSCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCSCCCSCCCCCCCCSCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCSCCCCCCSCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCC
        CCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCCCCCCSCCCCCCCC
        CCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCSCCCCCCCCCCCSCCCCCCCCCCCCCCCCCCCCSCCCCCSCCCCCCSCCCCCCCCCSCCCCCCC
        """,
        "palm.lean": """
        ...HH.HH......
        .HHFFHFFHH....
        HFFf.F.fFFHH..
        Ff..bXb..fFFH.
        ...FbXbF...fFH
        ..Ff.X.fF...fF
        .Ff..X..fF...f
        Ff...X...fF...
        f....X....f...
        .....b........
        ......X.......
        ......X.......
        .......b......
        .......X......
        ........X.....
        ........b.....
        .........X....
        .........X....
        .........b....
        ..........X...
        ..........X...
        ..........bb..
        ..........Xb..
        """,
        "cty.hills": """
        ..................................................3333333333333.................................
        ............................................3333333333333333333333333...........................
        ........3333333333333....................3333333333333333333333333333333........................
        ...33333333333333333333333............3333333333333333333333333333333333333...............333333
        33333333333333333333333333333.......33333333333333333333333333333333333333333.........3333333333
        33333333333333333333333333333333.33333333333333333333333333333333333333333333333...3333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
        """,
        "cty.tower": """
        .....Y.....
        .....N.....
        ....NNn....
        ....NNn....
        ...NNNnn...
        ...NNNnn...
        ..NNNNnnn..
        ..NNNNnnn..
        .NNNNNnnnn.
        .NNNNNnnnn.
        sssssssssss
        .SSSSSSSSs.
        .SSDSDSDSs.
        .SSDSDSDSs.
        .SSDSDSDSs.
        .SSSSSSSSs.
        sssssssssss
        .SSSYYYSSs.
        .SSYWKWYSs.
        .SSYWKKYSs.
        .SSYWWWYSs.
        .SSSYYYSSs.
        .SSoSSSoSs.
        .SSoSSSoSs.
        .SSSSSSSSs.
        .SSSSSSSSs.
        .SSSSSSSSs.
        .SSoSSSoSs.
        .SSoSSSoSs.
        .SSSSSSSSs.
        .SSSSSSSSs.
        .SSSSSSSSs.
        .SSoSSSoSs.
        .SSoSSSoSs.
        .SSSSSSSSs.
        .SSSSSSSSs.
        .SSSSSSSSs.
        .SSoSSSoSs.
        .SSoDDDoSs.
        .SSSDDDSSs.
        .SSSDDDSSs.
        .SSSDDDSSs.
        """,
        "cty.town": """
        ........................................................
        .....E..............E........E...............E..........
        .EEEEEE.........EEEEEE..EEEEEEE...........EEEEE.........
        eeeeeeee.......eeeeeeeeeeeeeeeee.........eeeeeee........
        PPPPPPPP....E..TTTTTTTTOOOOOOOOO......E..SSSSSSS.....E..
        PoPoPoPP.EEEEE.ToToToTTOoOoOoOoO.EEEEEEE.SoSoSoS.EEEEEE.
        PoPoPoPPeeeeeeeToToToTTOoOoOoOoOeeeeeeeeeSoSoSoSeeeeeeee
        PPPPPPPPCCCCCCCTTTTTTTTOOOOOOOOOWWWWWWWWWSSSSSSSPPPPPPPP
        PoPoPoPPCoCoCoCToToToTTOoOoOoOoOWoWoWoWoWSoSoSoSPoPoPoPP
        PoPoPoPPCoCoCoCToToToTTOoOoOoOoOWoWoWoWoWSoSoSoSPoPoPoPP
        PPPPPPPPCCCCCCCTTTTTTTTOOOOOOOOOWWWWWWWWWSSSSSSSPPPPPPPP
        PoPoPoPPCoCoCoCToToToTTOoOoOoOoOWoWoWoWoWSoSoSoSPoPoPoPP
        PoPoPoPPCoCoCoCToToToTTOoOoOoOoOWoWoWoWoWSoSoSoSPoPoPoPP
        PPPPPPPPCCCCCCCTTTTTTTTOOOOOOOOOWWWWWWWWWSSSSSSSPPPPPPPP
        PoPoPoPPCoCoCoCToToToTTOoOoOoOoOWoWoWoWoWSoSoSoSPoPoPoPP
        PoPoPoPPCoCoCoCToToToTTOoOoOoOoOWoWoWoWoWSoSoSoSPoPoPoPP
        PPPPPPPPCCCCCCCTTTTTTTTOOOOOOOOOWWWWWWWWWSSSSSSSPPPPPPPP
        PoPoPoPPCoCoCoCToToToTTOoOoOoOoOWoWoWoWoWSoSoSoSPoPoPoPP
        PoPoPoPPCoCoCoCToToToTTOoOoOoOoOWoWoWoWoWSoSoSoSPoPoPoPP
        PPPPPPPPCCCCCCCTTTTTTTTOOOOOOOOOWWWWWWWWWSSSSSSSPPPPPPPP
        """,
        "cty.bridge": """
        WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
        gGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgGgG
        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        gggggggggggggggGGGgggggggggggggggggGGGgggggggggggggggggGGGgg
        ................GGg.................GGg.................GGg.
        .................Gg..................Gg..................Gg.
        .................Gg..................Gg..................Gg.
        .................Gg..................Gg..................Gg.
        """,
    ]

    /// Места: небо до горизонта, ряды облаков и что рисовать — по порядку, от дальнего к ближнему.
    static let scenes: [String: Scene] = [
        "istanbul": Scene(horizon: 56, clouds: [9, 22, 34], ops: [
            .sprite("ist.farHills", x: 0, bottom: 56, depth: 4, flags: 0),
            .sprite("ist.bridge", x: 8, bottom: 57, depth: 3, flags: 0),
            .sprite("ist.shore", x: 0, bottom: 57, depth: 3, flags: 0),
            .water(top: 56, bottom: 76),
            .sprite("ist.maiden", x: 34, bottom: 63, depth: 2, flags: 2),
            .sprite("ist.hill", x: 40, bottom: 72, depth: 1, flags: 0),
            .sprite("ist.mosque", x: 59, bottom: 65, depth: 1, flags: 2),
            .birds(row: 46, count: 4, speed: 2.2),
            .boat(["ist.ferry"], bottom: 75, speed: -1.1, offset: 30, depth: 1),
            .sprite("quay", x: 0, bottom: 86, depth: 0, flags: 0),
            .sprite("lamp", x: 30, bottom: 75, depth: 0, flags: 0),
            .sprite("lamp", x: 86, bottom: 75, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 75, depth: 0),
        ]),
        "cappadocia": Scene(horizon: 62, clouds: [12, 30], ops: [
            .sprite("cap.mesas", x: 0, bottom: 62, depth: 4, flags: 0),
            .bob("cap.b5", x: 40, bottom: 21, depth: 3, amp: 2, period: 3),
            .bob("cap.b4", x: 22, bottom: 22, depth: 2, amp: 2, period: 4),
            .sprite("cap.chimneys", x: 46, bottom: 70, depth: 1, flags: 2),
            .sprite("cap.small", x: 30, bottom: 66, depth: 2, flags: 2),
            .sprite("cap.small", x: 38, bottom: 68, depth: 1, flags: 2),
            .bob("cap.b3", x: 50, bottom: 24, depth: 2, amp: 3, period: 2.5),
            .bob("cap.b2", x: 86, bottom: 40, depth: 1, amp: 2, period: 3.5),
            .bob("cap.b1", x: 66, bottom: 44, depth: 1, amp: 3, period: 3),
            .sprite("cap.valley", x: 0, bottom: 86, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 70, depth: 0),
        ]),
        "samarkand": Scene(horizon: 62, clouds: [10, 21, 33], ops: [
            .sprite("uz.mountains", x: 0, bottom: 62, depth: 4, flags: 0),
            .sprite("uz.farMosque", x: 4, bottom: 63, depth: 3, flags: 0),
            .sprite("uz.registan", x: 50, bottom: 68, depth: 1, flags: 2),
            .sprite("uz.poplar", x: 26, bottom: 68, depth: 1, flags: 0),
            .sprite("uz.poplar", x: 34, bottom: 68, depth: 1, flags: 0),
            .sprite("uz.poplar", x: 42, bottom: 68, depth: 1, flags: 0),
            .birds(row: 45, count: 3, speed: 1.6),
            .sprite("uz.plaza", x: 0, bottom: 86, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 70, depth: 0),
        ]),
        "khiva": Scene(horizon: 62, clouds: [10, 23], ops: [
            .sprite("khv.town", x: 36, bottom: 60, depth: 2, flags: 2),
            .sprite("khv.minaret", x: 62, bottom: 60, depth: 2, flags: 2),
            .sprite("khv.kalta", x: 78, bottom: 60, depth: 1, flags: 2),
            .sprite("khv.wall", x: 0, bottom: 70, depth: 1, flags: 0),
            .sprite("uz.poplar", x: 22, bottom: 70, depth: 1, flags: 0),
            .sprite("uz.poplar", x: 28, bottom: 70, depth: 1, flags: 0),
            .birds(row: 45, count: 3, speed: 1.5),
            .sprite("khv.ground", x: 0, bottom: 86, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 70, depth: 0),
        ]),
        "dubai": Scene(horizon: 62, clouds: [11, 26], ops: [
            .sprite("dxb.far", x: 46, bottom: 63, depth: 3, flags: 0),
            .water(top: 62, bottom: 74),
            .sprite("dxb.arab", x: 40, bottom: 66, depth: 2, flags: 2),
            .sprite("dxb.skyline", x: 52, bottom: 66, depth: 1, flags: 2),
            .boat(["dxb.dhow"], bottom: 71, speed: 0.9, offset: 10, depth: 1),
            .birds(row: 47, count: 3, speed: 1.5),
            .sprite("dxb.beach", x: 0, bottom: 86, depth: 0, flags: 0),
            .sprite("palm.big", x: 20, bottom: 72, depth: 0, flags: 0),
            .sprite("palm.small", x: 33, bottom: 72, depth: 0, flags: 0),
            .sprite("palm.mid", x: 84, bottom: 72, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 72, depth: 0),
        ]),
        "desert": Scene(horizon: 62, clouds: [12], ops: [
            .sprite("des.far", x: 0, bottom: 62, depth: 3, flags: 0),
            .sprite("des.mid", x: 0, bottom: 78, depth: 2, flags: 0),
            .water(top: 64, bottom: 68, from: 66, to: 92),
            .sprite("palm.mid", x: 62, bottom: 66, depth: 1, flags: 0),
            .sprite("palm.big", x: 74, bottom: 66, depth: 1, flags: 0),
            .sprite("palm.small", x: 86, bottom: 66, depth: 1, flags: 0),
            .boat(["camel.0", "camel.1"], bottom: 66, speed: 0.6, offset: 20, depth: 1, fps: 2),
            .boat(["camel.1", "camel.0"], bottom: 66, speed: 0.6, offset: 34, depth: 1, fps: 2),
            .boat(["camel.0", "camel.1"], bottom: 66, speed: 0.6, offset: 48, depth: 1, fps: 2),
            .sprite("des.near", x: 0, bottom: 86, depth: 0, flags: 0),
            .sprite("des.tent", x: 12, bottom: 72, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 72, depth: 0),
        ]),
        "moscow": Scene(horizon: 62, clouds: [9, 20, 31], ops: [
            .sprite("msk.farCity", x: 0, bottom: 58, depth: 4, flags: 0),
            .sprite("msk.inside", x: 6, bottom: 60, depth: 2, flags: 2),
            .sprite("msk.wall", x: 0, bottom: 68, depth: 1, flags: 0),
            .sprite("msk.tower", x: 2, bottom: 56, depth: 2, flags: 2),
            .sprite("msk.tower", x: 40, bottom: 56, depth: 2, flags: 2),
            .sprite("msk.basil", x: 69, bottom: 68, depth: 1, flags: 2),
            .sprite("msk.spasskaya", x: 56, bottom: 68, depth: 1, flags: 2),
            .sprite("msk.spruce", x: 13, bottom: 68, depth: 1, flags: 0),
            .sprite("msk.spruce", x: 29, bottom: 68, depth: 1, flags: 0),
            .sprite("msk.spruce", x: 47, bottom: 68, depth: 1, flags: 0),
            .birds(row: 44, count: 3, speed: 1.8),
            .sprite("msk.cobbles", x: 0, bottom: 86, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 70, depth: 0),
        ]),
        "village": Scene(horizon: 60, clouds: [9, 20, 32], ops: [
            .sprite("vil.forest", x: 0, bottom: 58, depth: 3, flags: 0),
            .sprite("vil.hills", x: 0, bottom: 64, depth: 2, flags: 0),
            .anim(["vil.mill.0", "vil.mill.1"], x: 44, bottom: 62, depth: 2, fps: 1),
            .sprite("vil.izbaGrey", x: 58, bottom: 64, depth: 1, flags: 0),
            .sprite("vil.izba", x: 72, bottom: 65, depth: 1, flags: 0),
            .sprite("vil.izbaGreen", x: 84, bottom: 66, depth: 1, flags: 0),
            .sprite("vil.hay", x: 30, bottom: 63, depth: 2, flags: 0),
            .sprite("vil.fence", x: 60, bottom: 67, depth: 1, flags: 0),
            .water(top: 66, bottom: 74),
            .boat(["vil.boat"], bottom: 71, speed: 0.5, offset: 10, depth: 0),
            .sprite("vil.birch", x: 22, bottom: 66, depth: 1, flags: 0),
            .sprite("vil.birchSmall", x: 52, bottom: 66, depth: 1, flags: 0),
            .birds(row: 48, count: 4, speed: 1.8),
            .sprite("vil.meadow", x: 0, bottom: 88, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 74, depth: 0),
        ]),
        "paris": Scene(horizon: 62, clouds: [10, 22, 34], ops: [
            .sprite("par.far", x: 0, bottom: 62, depth: 3, flags: 0),
            .sprite("par.eiffel", x: 61, bottom: 66, depth: 1, flags: 2),
            .sparkle("par.eiffel", x: 61, bottom: 66),
            .sprite("par.houses", x: 0, bottom: 70, depth: 1, flags: 0),
            .sprite("tree.round", x: 56, bottom: 70, depth: 0, flags: 0),
            .sprite("tree.round", x: 86, bottom: 70, depth: 0, flags: 0),
            .sprite("tree.roundSmall", x: 47, bottom: 70, depth: 0, flags: 0),
            .sprite("lamp", x: 80, bottom: 71, depth: 0, flags: 0),
            .birds(row: 44, count: 3, speed: 1.6),
            .sprite("par.avenue", x: 0, bottom: 86, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 70, depth: 0),
        ]),
        "coast": Scene(horizon: 58, clouds: [10, 24, 35], ops: [
            .sprite("cst.islands", x: 0, bottom: 58, depth: 4, flags: 0),
            .water(top: 58, bottom: 80),
            .boat(["yacht"], bottom: 70, speed: 0.6, offset: 30, depth: 1),
            .sprite("cst.town", x: 48, bottom: 74, depth: 1, flags: 2),
            .sprite("cst.mill", x: 76, bottom: 45, depth: 1, flags: 0),
            .sprite("cst.mill", x: 86, bottom: 42, depth: 1, flags: 0),
            .birds(row: 44, count: 3, speed: 2),
            .sprite("cst.rocks", x: 0, bottom: 78, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 72, depth: 0),
        ]),
        "alps": Scene(horizon: 62, clouds: [10, 21, 36], ops: [
            .sprite("alp.peaks", x: 0, bottom: 62, depth: 3, flags: 0),
            .sprite("alp.forest", x: 0, bottom: 66, depth: 2, flags: 0),
            .water(top: 64, bottom: 72),
            .sprite("alp.church", x: 64, bottom: 66, depth: 1, flags: 2),
            .sprite("alp.chalet", x: 78, bottom: 66, depth: 1, flags: 0),
            .sprite("alp.chalet", x: 50, bottom: 66, depth: 1, flags: 0),
            .sprite("alp.pine", x: 90, bottom: 67, depth: 1, flags: 0),
            .sprite("alp.pine", x: 40, bottom: 67, depth: 1, flags: 0),
            .birds(row: 46, count: 3, speed: 1.6),
            .sprite("alp.meadow", x: 0, bottom: 86, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 72, depth: 0),
        ]),
        "newyork": Scene(horizon: 62, clouds: [9, 21, 33], ops: [
            .sprite("ny.far", x: 0, bottom: 62, depth: 3, flags: 0),
            .sprite("ny.skyline", x: 46, bottom: 66, depth: 1, flags: 2),
            .water(top: 62, bottom: 78),
            .sprite("ny.liberty", x: 30, bottom: 64, depth: 2, flags: 2),
            .boat(["ny.ferry"], bottom: 72, speed: 0.8, offset: 50, depth: 1),
            .birds(row: 46, count: 3, speed: 2),
            .sprite("quay", x: 0, bottom: 88, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 77, depth: 0),
        ]),
        "mountains": Scene(horizon: 62, clouds: [10, 22, 34], ops: [
            .sprite("mnt.peaks", x: 0, bottom: 62, depth: 3, flags: 0),
            .sprite("mnt.foothills", x: 0, bottom: 66, depth: 2, flags: 0),
            .sprite("mnt.spruce", x: 58, bottom: 64, depth: 2, flags: 0),
            .sprite("mnt.spruceSmall", x: 66, bottom: 64, depth: 2, flags: 0),
            .sprite("mnt.spruce", x: 88, bottom: 65, depth: 2, flags: 0),
            .water(top: 64, bottom: 69, from: 30, to: 96, lagoon: true),
            .sprite("mnt.meadow", x: 0, bottom: 87, depth: 1, flags: 0),
            .sprite("mnt.yurt", x: 60, bottom: 75, depth: 1, flags: 0),
            .sprite("mnt.yurt", x: 74, bottom: 74, depth: 1, flags: 0),
            .sprite("mnt.horse", x: 40, bottom: 75, depth: 1, flags: 0),
            .sprite("mnt.horse", x: 86, bottom: 77, depth: 0, flags: 1),
            .sprite("mnt.apple", x: 24, bottom: 74, depth: 1, flags: 0),
            .birds(row: 46, count: 3, speed: 1.4),
            .flag(x: 5, top: 50, bottom: 76, depth: 0),
        ]),
        "tropic": Scene(horizon: 58, clouds: [10, 22, 33], ops: [
            .water(top: 58, bottom: 80, lagoon: true),
            .sprite("trp.k4", x: 30, bottom: 60, depth: 3, flags: 0),
            .sprite("trp.k2", x: 44, bottom: 61, depth: 3, flags: 0),
            .sprite("trp.k1", x: 58, bottom: 63, depth: 2, flags: 0),
            .sprite("trp.k3", x: 72, bottom: 64, depth: 2, flags: 0),
            .boat(["trp.boat"], bottom: 70, speed: 0.9, offset: 20, depth: 1),
            .birds(row: 44, count: 3, speed: 2),
            .sprite("trp.beach", x: 0, bottom: 88, depth: 0, flags: 0),
            .sprite("palm.lean", x: 80, bottom: 76, depth: 0, flags: 0),
            .sprite("palm.big", x: 88, bottom: 76, depth: 0, flags: 0),
            .sprite("palm.small", x: 26, bottom: 76, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 76, depth: 0),
        ]),
        "city": Scene(horizon: 62, clouds: [9, 21, 33], ops: [
            .sprite("cty.hills", x: 0, bottom: 62, depth: 4, flags: 0),
            .sprite("cty.town", x: 40, bottom: 64, depth: 2, flags: 0),
            .sprite("cty.tower", x: 66, bottom: 64, depth: 1, flags: 2),
            .water(top: 64, bottom: 78),
            .sprite("cty.bridge", x: 20, bottom: 72, depth: 1, flags: 0),
            .sprite("tree.round", x: 86, bottom: 66, depth: 1, flags: 0),
            .sprite("tree.roundSmall", x: 34, bottom: 65, depth: 1, flags: 0),
            .birds(row: 46, count: 3, speed: 1.8),
            .sprite("quay", x: 0, bottom: 88, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 77, depth: 0),
        ]),
    ]

    /// Места каждой страны — сменяются по дням. Пустой код — для остальных стран.
    static let places: [String: [String]] = [
        "TR": ["istanbul", "cappadocia"],
        "UZ": ["samarkand", "khiva"],
        "AE": ["dubai", "desert"],
        "RU": ["moscow", "village"],
        "EU": ["paris", "coast", "alps"],
        "US": ["newyork"],
        "KZ": ["mountains"],
        "KG": ["mountains"],
        "TJ": ["mountains"],
        "MN": ["mountains"],
        "AZ": ["mountains"],
        "GE": ["mountains"],
        "AM": ["mountains"],
        "CA": ["mountains"],
        "TM": ["desert"],
        "FR": ["paris"],
        "DE": ["city", "alps"],
        "AT": ["alps"],
        "CH": ["alps"],
        "SI": ["alps"],
        "IT": ["coast"],
        "ES": ["coast"],
        "PT": ["coast"],
        "GR": ["coast"],
        "CY": ["coast"],
        "HR": ["coast"],
        "ME": ["coast"],
        "MT": ["coast"],
        "IL": ["desert"],
        "EG": ["desert"],
        "JO": ["desert"],
        "QA": ["desert"],
        "SA": ["desert"],
        "OM": ["desert"],
        "BH": ["desert"],
        "KW": ["desert"],
        "MA": ["desert"],
        "TN": ["desert"],
        "IN": ["tropic"],
        "LK": ["tropic"],
        "MV": ["tropic"],
        "TH": ["tropic"],
        "VN": ["tropic"],
        "ID": ["tropic"],
        "MY": ["tropic"],
        "SG": ["tropic"],
        "": ["city"],
    ]

    /// Флаги 15×10, нарисованные вручную.
    static let flags: [String: Flag] = [
        "TR": Flag(colors: ["r": 0xE30A17, "w": 0xFFFFFF], rows: """
        rrrrrrrrrrrrrrr
        rrrrwwwrrrrrrrr
        rrrwwrrrrrrrrrr
        rrwwrrrrrrwrrrr
        rrwwrrrrrwwwrrr
        rrwwrrrrrwrwrrr
        rrrwwrrrrrrrrrr
        rrrrwwwrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "RU": Flag(colors: ["w": 0xFFFFFF, "b": 0x0039A6, "r": 0xD52B1E], rows: """
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "UZ": Flag(colors: ["b": 0x0099B5, "w": 0xFFFFFF, "g": 0x1EB53A, "r": 0xCE1126], rows: """
        bwwbbbbwbwbbbbb
        wbbbbbwbwbwbbbb
        bwwbbwbwbwbbbbb
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        rrrrrrrrrrrrrrr
        ggggggggggggggg
        ggggggggggggggg
        ggggggggggggggg
        """),
        "AE": Flag(colors: ["r": 0xEF3340, "g": 0x009739, "w": 0xFFFFFF, "k": 0x000000], rows: """
        rrrrggggggggggg
        rrrrggggggggggg
        rrrrggggggggggg
        rrrrwwwwwwwwwww
        rrrrwwwwwwwwwww
        rrrrwwwwwwwwwww
        rrrrwwwwwwwwwww
        rrrrkkkkkkkkkkk
        rrrrkkkkkkkkkkk
        rrrrkkkkkkkkkkk
        """),
        "EU": Flag(colors: ["b": 0x003399, "y": 0xFFCC00], rows: """
        bbbbbbbbbbbbbbb
        bbbbbybybybbbbb
        bbbybbbbbbbybbb
        bbbbbbbbbbbbbbb
        bbybbbbbbbbbybb
        bbbbbbbbbbbbbbb
        bbbybbbbbbbybbb
        bbbbbybybybbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        """),
        "US": Flag(colors: ["r": 0xB22234, "w": 0xFFFFFF, "n": 0x3C3B6E], rows: """
        nwnwnwrrrrrrrrr
        nnwnwnwwwwwwwww
        nwnwnwrrrrrrrrr
        nnwnwnwwwwwwwww
        nwnwnwrrrrrrrrr
        wwwwwwwwwwwwwww
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        """),
        "KZ": Flag(colors: ["b": 0x00AFCA, "y": 0xFEC50C], rows: """
        bybbbbbbybbbbbb
        bbbbbybbbbbybbb
        bybbbbbyyybbbbb
        bbbbbbyyyyybbbb
        bybbbbbyyybbbbb
        bbbbbybbbbbybbb
        bybbyybbybbyybb
        bbbbbyyyyyyybbb
        bybbbbbbybbbbbb
        bbbbbbbbbbbbbbb
        """),
        "KG": Flag(colors: ["r": 0xE8112D, "y": 0xFFEF00], rows: """
        rrrrrrrrrrrrrrr
        rrrrryrryrryrrr
        rrrrrryyyyyrrrr
        rrrryyrrrrryyrr
        rrrrryryryrrrrr
        rrrryyrrrrryyrr
        rrrrrryyyyyrrrr
        rrrrryrryrryrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "TJ": Flag(colors: ["r": 0xCC0000, "w": 0xFFFFFF, "g": 0x006600, "y": 0xF8C300], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwywywywwwww
        wwwwywwwwwywwww
        wwwwwywywywwwww
        wwwwwyyyyywwwww
        ggggggggggggggg
        ggggggggggggggg
        ggggggggggggggg
        """),
        "TM": Flag(colors: ["g": 0x00843D, "r": 0xD22630, "w": 0xFFFFFF, "y": 0xFFC72C], rows: """
        gryrgwgwgwggggg
        grwrggwgggggggg
        gryrgwgwggggggg
        grwrggggggggggg
        gryrggggggggggg
        grwrggggggggggg
        gryrggggggggggg
        grwrggggggggggg
        gryrggggggggggg
        grwrggggggggggg
        """),
        "AZ": Flag(colors: ["b": 0x00B5E2, "r": 0xEF3340, "g": 0x509E2F, "w": 0xFFFFFF], rows: """
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        rrrrrrwwrrrrrrr
        rrrrrwrrrwrrrrr
        rrrrrwrrwwwrrrr
        rrrrrrwwrwrrrrr
        ggggggggggggggg
        ggggggggggggggg
        ggggggggggggggg
        """),
        "GE": Flag(colors: ["w": 0xFFFFFF, "r": 0xFF0000], rows: """
        wwwwwwrrrwwwwww
        wwrwwwrrrwwwrww
        wrrrwwrrrwwrrrw
        wwrwwwrrrwwwrww
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwrwwwrrrwwwrww
        wrrrwwrrrwwrrrw
        wwrwwwrrrwwwrww
        wwwwwwrrrwwwwww
        """),
        "AM": Flag(colors: ["r": 0xD90012, "b": 0x0033A0, "o": 0xF2A800], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        ooooooooooooooo
        ooooooooooooooo
        ooooooooooooooo
        """),
        "BY": Flag(colors: ["r": 0xC8313E, "g": 0x4AA657, "w": 0xFFFFFF], rows: """
        wrwrrrrrrrrrrrr
        rwrrrrrrrrrrrrr
        wrwrrrrrrrrrrrr
        rwrrrrrrrrrrrrr
        wrwrrrrrrrrrrrr
        rwrrrrrrrrrrrrr
        wrwrrrrrrrrrrrr
        rwrgggggggggggg
        wrwgggggggggggg
        rwrgggggggggggg
        """),
        "UA": Flag(colors: ["b": 0x0057B7, "y": 0xFFD700], rows: """
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        yyyyyyyyyyyyyyy
        yyyyyyyyyyyyyyy
        yyyyyyyyyyyyyyy
        yyyyyyyyyyyyyyy
        yyyyyyyyyyyyyyy
        """),
        "MD": Flag(colors: ["b": 0x0046AE, "y": 0xFFD200, "r": 0xCC092F, "e": 0xA05A2C], rows: """
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbeyeyerrrrr
        bbbbbeeeeerrrrr
        bbbbbyeyeyrrrrr
        bbbbbyyeyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        """),
        "DE": Flag(colors: ["k": 0x000000, "r": 0xDD0000, "y": 0xFFCE00], rows: """
        kkkkkkkkkkkkkkk
        kkkkkkkkkkkkkkk
        kkkkkkkkkkkkkkk
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        yyyyyyyyyyyyyyy
        yyyyyyyyyyyyyyy
        yyyyyyyyyyyyyyy
        """),
        "FR": Flag(colors: ["b": 0x0055A4, "w": 0xFFFFFF, "r": 0xEF4135], rows: """
        bbbbbwwwwwrrrrr
        bbbbbwwwwwrrrrr
        bbbbbwwwwwrrrrr
        bbbbbwwwwwrrrrr
        bbbbbwwwwwrrrrr
        bbbbbwwwwwrrrrr
        bbbbbwwwwwrrrrr
        bbbbbwwwwwrrrrr
        bbbbbwwwwwrrrrr
        bbbbbwwwwwrrrrr
        """),
        "IT": Flag(colors: ["g": 0x009246, "w": 0xFFFFFF, "r": 0xCE2B37], rows: """
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        """),
        "ES": Flag(colors: ["r": 0xAA151B, "y": 0xF1BF00, "e": 0xC8102E, "o": 0xAD1519], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        yyyyyyyyyyyyyyy
        yyyoyoyyyyyyyyy
        yyyeyeyyyyyyyyy
        yyyoooyyyyyyyyy
        yyyyoyyyyyyyyyy
        yyyyyyyyyyyyyyy
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "PT": Flag(colors: ["g": 0x006600, "r": 0xFF0000, "y": 0xFFE000, "w": 0xFFFFFF, "b": 0x003399], rows: """
        ggggggrrrrrrrrr
        ggggggrrrrrrrrr
        gggggyyyrrrrrrr
        ggggyrwryrrrrrr
        ggggywbwyrrrrrr
        ggggyrwryrrrrrr
        gggggyyyrrrrrrr
        ggggggrrrrrrrrr
        ggggggrrrrrrrrr
        ggggggrrrrrrrrr
        """),
        "GR": Flag(colors: ["b": 0x0D5EAF, "w": 0xFFFFFF], rows: """
        bbwbbbbbbbbbbbb
        bbwbbwwwwwwwwww
        wwwwwbbbbbbbbbb
        bbwbbwwwwwwwwww
        bbwbbbbbbbbbbbb
        wwwwwwwwwwwwwww
        bbbbbbbbbbbbbbb
        wwwwwwwwwwwwwww
        bbbbbbbbbbbbbbb
        wwwwwwwwwwwwwww
        """),
        "CY": Flag(colors: ["w": 0xFFFFFF, "o": 0xD57800, "g": 0x4E5B31], rows: """
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwoooowww
        wwwwwooooooooww
        wwwwoooooooowww
        wwwwwwooowwwwww
        wwwwwgwwwwwgwww
        wwwwwwgggggwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        """),
        "AT": Flag(colors: ["r": 0xED2939, "w": 0xFFFFFF], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "NL": Flag(colors: ["r": 0xAE1C28, "w": 0xFFFFFF, "b": 0x21468B], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        """),
        "BE": Flag(colors: ["k": 0x000000, "y": 0xFAE042, "r": 0xED2939], rows: """
        kkkkkyyyyyrrrrr
        kkkkkyyyyyrrrrr
        kkkkkyyyyyrrrrr
        kkkkkyyyyyrrrrr
        kkkkkyyyyyrrrrr
        kkkkkyyyyyrrrrr
        kkkkkyyyyyrrrrr
        kkkkkyyyyyrrrrr
        kkkkkyyyyyrrrrr
        kkkkkyyyyyrrrrr
        """),
        "IE": Flag(colors: ["g": 0x169B62, "w": 0xFFFFFF, "o": 0xFF883E], rows: """
        gggggwwwwwooooo
        gggggwwwwwooooo
        gggggwwwwwooooo
        gggggwwwwwooooo
        gggggwwwwwooooo
        gggggwwwwwooooo
        gggggwwwwwooooo
        gggggwwwwwooooo
        gggggwwwwwooooo
        gggggwwwwwooooo
        """),
        "FI": Flag(colors: ["w": 0xFFFFFF, "b": 0x003580], rows: """
        wwwwbbwwwwwwwww
        wwwwbbwwwwwwwww
        wwwwbbwwwwwwwww
        wwwwbbwwwwwwwww
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        wwwwbbwwwwwwwww
        wwwwbbwwwwwwwww
        wwwwbbwwwwwwwww
        wwwwbbwwwwwwwww
        """),
        "SE": Flag(colors: ["b": 0x006AA7, "y": 0xFECC00], rows: """
        bbbbyybbbbbbbbb
        bbbbyybbbbbbbbb
        bbbbyybbbbbbbbb
        bbbbyybbbbbbbbb
        yyyyyyyyyyyyyyy
        yyyyyyyyyyyyyyy
        bbbbyybbbbbbbbb
        bbbbyybbbbbbbbb
        bbbbyybbbbbbbbb
        bbbbyybbbbbbbbb
        """),
        "DK": Flag(colors: ["r": 0xC8102E, "w": 0xFFFFFF], rows: """
        rrrrwwrrrrrrrrr
        rrrrwwrrrrrrrrr
        rrrrwwrrrrrrrrr
        rrrrwwrrrrrrrrr
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        rrrrwwrrrrrrrrr
        rrrrwwrrrrrrrrr
        rrrrwwrrrrrrrrr
        rrrrwwrrrrrrrrr
        """),
        "NO": Flag(colors: ["r": 0xBA0C2F, "w": 0xFFFFFF, "b": 0x00205B], rows: """
        rrrrwbbwrrrrrrr
        rrrrwbbwrrrrrrr
        rrrrwbbwrrrrrrr
        wwwwwbbwwwwwwww
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        wwwwwbbwwwwwwww
        rrrrwbbwrrrrrrr
        rrrrwbbwrrrrrrr
        rrrrwbbwrrrrrrr
        """),
        "EE": Flag(colors: ["b": 0x0072CE, "k": 0x000000, "w": 0xFFFFFF], rows: """
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        kkkkkkkkkkkkkkk
        kkkkkkkkkkkkkkk
        kkkkkkkkkkkkkkk
        kkkkkkkkkkkkkkk
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        """),
        "LV": Flag(colors: ["r": 0x9E3039, "w": 0xFFFFFF], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "LT": Flag(colors: ["y": 0xFDB913, "g": 0x006A44, "r": 0xC1272D], rows: """
        yyyyyyyyyyyyyyy
        yyyyyyyyyyyyyyy
        yyyyyyyyyyyyyyy
        ggggggggggggggg
        ggggggggggggggg
        ggggggggggggggg
        ggggggggggggggg
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "SK": Flag(colors: ["w": 0xFFFFFF, "b": 0x0B4EA2, "r": 0xEE1C25], rows: """
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwrwrwwwwwwwww
        bbwwwwwbbbbbbbb
        bbwrwrwbbbbbbbb
        bbwbbbwbbbbbbbb
        bbwbbbwbbbbbbbb
        rrrwwwrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "SI": Flag(colors: ["w": 0xFFFFFF, "b": 0x005DA4, "r": 0xED1C24, "y": 0xFFDD00], rows: """
        wwwwwwwwwwwwwww
        wwryyrwwwwwwwww
        wwrbbrwwwwwwwww
        bbrwbrbbbbbbbbb
        bbwwwrbbbbbbbbb
        bbbrrbbbbbbbbbb
        bbbbbbbbbbbbbbb
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "HR": Flag(colors: ["r": 0xFF0000, "w": 0xFFFFFF, "b": 0x171796], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrbbbbbrrrrr
        wwwwwrwrwrwwwww
        wwwwwwrwrwwwwww
        wwwwwrwrwrwwwww
        wwwwwwrwrwwwwww
        bbbbbbrwrbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        """),
        "ME": Flag(colors: ["r": 0xC40308, "y": 0xD4AF37], rows: """
        yyyyyyyyyyyyyyy
        yrrrrrrrrrrrrry
        yrrrryryryrrrry
        yrrrryyyyyrrrry
        yrrrrryyyrrrrry
        yrrrryyyyyrrrry
        yrrrrryryrrrrry
        yrrrrrrrrrrrrry
        yrrrrrrrrrrrrry
        yyyyyyyyyyyyyyy
        """),
        "MT": Flag(colors: ["w": 0xFFFFFF, "r": 0xCF142B, "g": 0x9EA2A2], rows: """
        wwwwwwwrrrrrrrr
        wwgwwwwrrrrrrrr
        wgggwwwrrrrrrrr
        wwgwwwwrrrrrrrr
        wwwwwwwrrrrrrrr
        wwwwwwwrrrrrrrr
        wwwwwwwrrrrrrrr
        wwwwwwwrrrrrrrr
        wwwwwwwrrrrrrrr
        wwwwwwwrrrrrrrr
        """),
        "GB": Flag(colors: ["b": 0x012169, "w": 0xFFFFFF, "r": 0xC8102E], rows: """
        rwbbbbwrwbbbbwr
        wrwwbbwrwbbwwrw
        bbwrwbwrwbwrwbb
        wwwwwwwrwwwwwww
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwwwrwwwwwww
        bbwrwbwrwbwrwbb
        wrwwbbwrwbbwwrw
        rwbbbbwrwbbbbwr
        """),
        "CH": Flag(colors: ["r": 0xDA291C, "w": 0xFFFFFF], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrwwwrrrrrr
        rrrrrrwwwrrrrrr
        rrrrwwwwwwwrrrr
        rrrrwwwwwwwrrrr
        rrrrrrwwwrrrrrr
        rrrrrrwwwrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "CZ": Flag(colors: ["w": 0xFFFFFF, "r": 0xD7141A, "b": 0x11457E], rows: """
        bbwwwwwwwwwwwww
        bbbwwwwwwwwwwww
        bbbbbwwwwwwwwww
        bbbbbbwwwwwwwww
        bbbbbbbwwwwwwww
        bbbbbbbrrrrrrrr
        bbbbbbrrrrrrrrr
        bbbbbrrrrrrrrrr
        bbbrrrrrrrrrrrr
        bbrrrrrrrrrrrrr
        """),
        "PL": Flag(colors: ["w": 0xFFFFFF, "r": 0xDC143C], rows: """
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "HU": Flag(colors: ["r": 0xCE2939, "w": 0xFFFFFF, "g": 0x477050], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        ggggggggggggggg
        ggggggggggggggg
        ggggggggggggggg
        """),
        "RS": Flag(colors: ["r": 0xC6363C, "b": 0x0C4076, "w": 0xFFFFFF, "y": 0xEDB92E], rows: """
        rrrrrrrrrrrrrrr
        rrrryyyrrrrrrrr
        rrrryyyrrrrrrrr
        bbbrwrwrbbbbbbb
        bbbrwwwrbbbbbbb
        bbbrrwrrbbbbbbb
        bbbbrrrbbbbbbbb
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        """),
        "BG": Flag(colors: ["w": 0xFFFFFF, "g": 0x00966E, "r": 0xD62612], rows: """
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        ggggggggggggggg
        ggggggggggggggg
        ggggggggggggggg
        ggggggggggggggg
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "RO": Flag(colors: ["b": 0x002B7F, "y": 0xFCD116, "r": 0xCE1126], rows: """
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        bbbbbyyyyyrrrrr
        """),
        "IL": Flag(colors: ["w": 0xFFFFFF, "b": 0x0038B8], rows: """
        wwwwwwwwwwwwwww
        bbbbbbbbbbbbbbb
        wwwwwwwwwwwwwww
        wwwwwwwbwwwwwww
        wwwwwbbbbbwwwww
        wwwwwwbwbwwwwww
        wwwwwbbbbbwwwww
        wwwwwwwbwwwwwww
        bbbbbbbbbbbbbbb
        wwwwwwwwwwwwwww
        """),
        "EG": Flag(colors: ["r": 0xCE1126, "w": 0xFFFFFF, "k": 0x000000, "y": 0xC09300], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        wwwwwwywywwwwww
        wwwwwwyyywwwwww
        wwwwwwwwwwwwwww
        kkkkkkkkkkkkkkk
        kkkkkkkkkkkkkkk
        kkkkkkkkkkkkkkk
        """),
        "JO": Flag(colors: ["k": 0x000000, "w": 0xFFFFFF, "g": 0x007A3D, "r": 0xCE1126], rows: """
        rrkkkkkkkkkkkkk
        rrrkkkkkkkkkkkk
        rrrrkkkkkkkkkkk
        rrrrrwwwwwwwwww
        rwrrrrwwwwwwwww
        rwrrrrwwwwwwwww
        rrrrrwwwwwwwwww
        rrrrggggggggggg
        rrrgggggggggggg
        rrggggggggggggg
        """),
        "QA": Flag(colors: ["w": 0xFFFFFF, "m": 0x8A1538], rows: """
        wwwwwmmmmmmmmmm
        wwwwmmmmmmmmmmm
        wwwwwmmmmmmmmmm
        wwwwmmmmmmmmmmm
        wwwwwmmmmmmmmmm
        wwwwmmmmmmmmmmm
        wwwwwmmmmmmmmmm
        wwwwmmmmmmmmmmm
        wwwwwmmmmmmmmmm
        wwwwmmmmmmmmmmm
        """),
        "SA": Flag(colors: ["g": 0x006C35, "w": 0xFFFFFF], rows: """
        ggggggggggggggg
        ggggggggggggggg
        gggwgwwgwgwwwgg
        gggwwwwwwwwwggg
        ggggggggggggggg
        ggggggggggggggg
        gggwwwwwwwwwggg
        ggggwgggggggggg
        ggggggggggggggg
        ggggggggggggggg
        """),
        "OM": Flag(colors: ["r": 0xDB161B, "w": 0xFFFFFF, "g": 0x008000], rows: """
        rrrrwwwwwwwwwww
        rwrwwwwwwwwwwww
        rrwrwwwwwwwwwww
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrggggggggggg
        rrrrggggggggggg
        rrrrggggggggggg
        """),
        "BH": Flag(colors: ["w": 0xFFFFFF, "r": 0xCE1126], rows: """
        wwwwwrrrrrrrrrr
        wwwwrrrrrrrrrrr
        wwwwwrrrrrrrrrr
        wwwwrrrrrrrrrrr
        wwwwwrrrrrrrrrr
        wwwwrrrrrrrrrrr
        wwwwwrrrrrrrrrr
        wwwwrrrrrrrrrrr
        wwwwwrrrrrrrrrr
        wwwwrrrrrrrrrrr
        """),
        "KW": Flag(colors: ["g": 0x007A3D, "w": 0xFFFFFF, "r": 0xCE1126, "k": 0x000000], rows: """
        kkggggggggggggg
        kkkgggggggggggg
        kkkkggggggggggg
        kkkkkwwwwwwwwww
        kkkkkwwwwwwwwww
        kkkkkwwwwwwwwww
        kkkkkwwwwwwwwww
        kkkkrrrrrrrrrrr
        kkkrrrrrrrrrrrr
        kkrrrrrrrrrrrrr
        """),
        "IN": Flag(colors: ["o": 0xFF9933, "w": 0xFFFFFF, "g": 0x138808, "n": 0x000080], rows: """
        ooooooooooooooo
        ooooooooooooooo
        ooooooooooooooo
        wwwwwwnnnwwwwww
        wwwwwwnwnwwwwww
        wwwwwwnnnwwwwww
        wwwwwwwwwwwwwww
        ggggggggggggggg
        ggggggggggggggg
        ggggggggggggggg
        """),
        "LK": Flag(colors: ["y": 0xFFBE29, "g": 0x00534E, "o": 0xEB7400, "m": 0x8D153A], rows: """
        yyyyyyyyyyyyyyy
        yggooymmmmmmmmy
        yggooymmmmmmmmy
        yggooymmyymymmy
        yggooymmyyyymmy
        yggooymmmyymmmy
        yggooymmymmymmy
        yggooymmmmmmmmy
        yggooymmmmmmmmy
        yyyyyyyyyyyyyyy
        """),
        "MV": Flag(colors: ["r": 0xD21034, "g": 0x007E3A, "w": 0xFFFFFF], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrgggggggggrrr
        rrrggggwwgggrrr
        rrrgggwgggggrrr
        rrrgggwgggggrrr
        rrrggggwwgggrrr
        rrrgggggggggrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "TH": Flag(colors: ["r": 0xA51931, "w": 0xF4F5F8, "b": 0x2D2A4A], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbb
        wwwwwwwwwwwwwww
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "VN": Flag(colors: ["r": 0xDA251D, "y": 0xFFFF00], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrryrrrrrrr
        rrrrryyyyyrrrrr
        rrrrrryyyrrrrrr
        rrrrrryryrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "ID": Flag(colors: ["r": 0xFF0000, "w": 0xFFFFFF], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        """),
        "MY": Flag(colors: ["r": 0xCC0001, "w": 0xFFFFFF, "n": 0x010066, "y": 0xFFCC00], rows: """
        nnnnnnnrrrrrrrr
        nnyynnnwwwwwwww
        nynnnynrrrrrrrr
        nynnyynwwwwwwww
        nnyynnnrrrrrrrr
        nnnnnnnwwwwwwww
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        """),
        "SG": Flag(colors: ["r": 0xEF3340, "w": 0xFFFFFF], rows: """
        rrrrrrrrrrrrrrr
        rrwwrwrrrrrrrrr
        rwrrrwwrrrrrrrr
        rrwwrwrrrrrrrrr
        rrrrrrrrrrrrrrr
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        """),
        "CN": Flag(colors: ["r": 0xEE1C25, "y": 0xFFFF00], rows: """
        rrrrrrrrrrrrrrr
        rryrryrrrrrrrrr
        ryyyrrrrrrrrrrr
        rryrryrrrrrrrrr
        ryryryrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "JP": Flag(colors: ["w": 0xFFFFFF, "r": 0xBC002D], rows: """
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwrrrwwwwww
        wwwwwrrrrrwwwww
        wwwwwrrrrrwwwww
        wwwwwrrrrrwwwww
        wwwwwwrrrwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        wwwwwwwwwwwwwww
        """),
        "KR": Flag(colors: ["w": 0xFFFFFF, "r": 0xCD2E3A, "b": 0x0047A0, "k": 0x000000], rows: """
        wwwwwwwwwwwwwww
        wkkwwwwwwwwwkkw
        wkwwwwwwwwwwwkw
        wwkwwwrrrwwwkww
        wwwwwrrrrbwwwww
        wwwwwrbbbbwwwww
        wwkwwwbbbwwwkww
        wkwwwwwwwwwwwkw
        wkkwwwwwwwwwkkw
        wwwwwwwwwwwwwww
        """),
        "MN": Flag(colors: ["r": 0xC4272F, "b": 0x015197, "y": 0xF9CF02], rows: """
        rrrrrbbbbbrrrrr
        rryrrbbbbbrrrrr
        rryrrbbbbbrrrrr
        ryyyrbbbbbrrrrr
        rryrrbbbbbrrrrr
        ryyyrbbbbbrrrrr
        rryrrbbbbbrrrrr
        rryrrbbbbbrrrrr
        rryrrbbbbbrrrrr
        rrrrrbbbbbrrrrr
        """),
        "CA": Flag(colors: ["r": 0xFF0000, "w": 0xFFFFFF], rows: """
        rrrrwwwwwwwrrrr
        rrrrwwwwwwwrrrr
        rrrrwwwrwwwrrrr
        rrrrwrwrwrwrrrr
        rrrrwrrrrrwrrrr
        rrrrwwrrrwwrrrr
        rrrrwrrrrrwrrrr
        rrrrwwwrwwwrrrr
        rrrrwwwwwwwrrrr
        rrrrwwwwwwwrrrr
        """),
        "MX": Flag(colors: ["g": 0x006847, "w": 0xFFFFFF, "r": 0xCE1126, "b": 0x8C5A2B], rows: """
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwbwwrrrrr
        gggggwbbbwrrrrr
        gggggwgbgwrrrrr
        gggggwwgwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        gggggwwwwwrrrrr
        """),
        "MA": Flag(colors: ["r": 0xC1272D, "g": 0x006233], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrgrrrrrrr
        rrrrrgggggrrrrr
        rrrrrrgrgrrrrrr
        rrrrrrgggrrrrrr
        rrrrrgrrrgrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
        "TN": Flag(colors: ["r": 0xE70013, "w": 0xFFFFFF], rows: """
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrwwwrrrrrr
        rrrrrwwrrwrrrrr
        rrrrrwrwwrrrrrr
        rrrrrwwrrwrrrrr
        rrrrrrwwwrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        rrrrrrrrrrrrrrr
        """),
    ]
}
