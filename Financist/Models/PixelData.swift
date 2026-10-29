// Сгенерировано из tools/pixel-art (node build.js && node gen-swift.js) — те же рисунки, что в макете.
// Руками не править: перерисовать там и сгенерировать заново.

extension PixelCity {
    /// Материалы: символ рисунка → цвет днём и как он ведёт себя вечером и ночью.
    static let materials: [Character: Material] = [
        "1": Material(0x8C8FAD),
        "2": Material(0x6A6C8A),
        "3": Material(0xB0B6CC),
        "4": Material(0xA6E3E9),
        "5": Material(0x63CBD6),
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
        "gal.tower": """
        ......LYl......
        ......LLl......
        .....LLLll.....
        .....LLLll.....
        ....LLLLlll....
        ....LLLLlll....
        ...LLLLLllll...
        ...LLLLLllll...
        ..LLLLLLlllll..
        ..LLLLLLlllll..
        .WWWWWWWWWWWWW.
        ..SSSSSSSSsss..
        ..SoSoSoSosos..
        ..SoSoSoSosos..
        ..SSSSSSSSsss..
        .SSSSSSSSSSSSS.
        ..sssssssssss..
        ..CCSSSSSSsss..
        ..CCSSSSSSsss..
        ..CCSoSSSSsss..
        ..CCSoSSSosss..
        ..CCSSSSSosss..
        ..CCSSSSSSsss..
        ..sssssssssss..
        ..CCSSSSSSsss..
        ..CCSSSSSSsss..
        ..CCSoSSSSsss..
        ..CCSoSSSosss..
        ..CCSSSSSosss..
        ..CCSSSSSSsss..
        ..sssssssssss..
        ..CCSSSSSSsss..
        ..CCSSSSSSsss..
        ..CCSoSSSSsss..
        ..CCSoSSSosss..
        ..CCSSSSSosss..
        ..CCSSSSSSsss..
        ..sssssssssss..
        ..CCSSSSSSsss..
        ..CCSSSSSSsss..
        ..CCSSSSSSsss..
        .CCCSSSDSSssss.
        .CCCSSDDDSssss.
        .CCCSSDDDSssss.
        .CCCSSDDDSssss.
        .CCCSSDDDSssss.
        """,
        "gal.far": """
        ..........................................................
        .........................3..........3.....................
        .........................3..........3.....................
        .........................3..33333...3.....................
        .....................3...3.3333333..3...3.................
        .....................3...3333333333.3...3.................
        ......3........3.....3...3333333333.3...3.................
        ......3........3.....33..3333333333.3.3.3.................
        ......3..333...3....333333333333333333333.................
        ..33..3.333333.33333333333333333333333333....3.333333...33
        ..33..3.333333.33333.33333333333333333333.3333.333333...33
        3333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333
        """,
        "gal.back": """
        ................................................................................................
        ................................................................................................
        ................................................................................................
        .......................................................................gggggggg...........gggggg
        .gggggg..ggggggg......................................................wwwwwwwwww.ggggggg.wwwwwww
        wwwwwwwwwwwwwwwww.....................................ggggggg.........AAAAAAAAAawwwwwwwwwPPPPPPP
        WWWWWWWwPPPPPPPPp.gggggg.............................wwwwwwwww.gggggg.AoAoAoAoAaWWWWWWWWwPoPoPoP
        WoWoWoWwPoPoPoPPpwwwwwwww.gggggggg..gggggggg..gggggg.WWWWWWWWwwwwwwwwwAoAoAoAoAaWoWoWoWWwPoPoPoP
        WoWoWoWwPoPoPoPPpAAAAAAAawwwwwwwwwwwwwwwwwwwwwwwwwwwwWoWoWoWWwPPPPPPPpAAaaaaaaAaWoWoWoWWwPPPPPPP
        WWWWWWWwPPpppppPpAoAoAoAaWWWWWWWWWwPPPPPPPPPpAAAAAAAaWoWoWoWWwPoPoPoPpAoaoaaoaAaWWwwwwwWwPoPoPoP
        WoWoWoWwPopopopPpAoAoAoAaWoWoWoWoWwPoPoPoPoPpAoAoAoAaWWwwwwwWwPoPoPoPpAoaaaaaaAaWowowowWwPoPoPoP
        WoWoWoWwPopppppPpAAAAAAAaWoWoWoWoWwPoPoPoPoPpAoAoAoAaWowowowWwPPPPPPPpAAAAAAAAAaWowwwwwWwPPPPPPP
        WWWWWWWwPPPPPPPPpAoAoAoAaWWwwwwwwWwPPppppppPpAAAAAAAaWowwwwwWwPoPoPoPpAoAoAoAoAaWWWWWWWWwPoPoPoP
        WoWoWoWwPoPoPoPPpAoAoAoAaWowowwowWwPopoppopPpAoAoAoAaWWWWWWWWwPoPoPoPpAoAoAoAoAaWoWoWoWWwPoPoPoP
        WoWoWoWwPoPoPoPPpAAAAAAAaWowwwwwwWwPoppppppPpAoAoAoAaWoWoWoWWwPPPPPPPpAAAAAAAAAaWoWoWoWWwPPPPPPP
        WWWWWWWwPPPPPPPPpAoAoAoAaWWWWWWWWWwPPPPPPPPPpAAAAAAAaWoWoWoWWwPoPoPoPpAoAoAoAoAaWWWWWWWWwPoPoPoP
        WoWoWoWwPoPoPoPPpAoAoAoAaWoWoWoWoWwPoPoPoPoPpAoAoAoAaWWWWWWWWwPoPoPoPpAoAoAoAoAaWoWoWoWWwPoPoPoP
        WoWoWoWwPoPoPoPPpAAAAAAAaWoWoWoWoWwPoPoPoPoPpAoAoAoAaWoWoWoWWwPPPPPPPpAAAAAAAAAaWoWoWoWWwPPPPPPP
        WWWWWWWwPPPPPPPPpAAAAAAAaWWWWWWWWWwPPPPPPPPPpAAAAAAAaWoWoWoWWwPPPPPPPpAAAAAAAAAaWWWWWWWWwPPPPPPP
        EEEEEEEERRRRRRRRRNNNNNNNNUUUUUUUUUUEEEEEEEEEERRRRRRRRNNNNNNNNNUUUUUUUUEEEEEEEEEERRRRRRRRRNNNNNNN
        WoooooowPooooooopAooooooaWoooooooowPoooooooopAooooooaWooooooowPoooooopAooooooooaWooooooowPoooooo
        WoooooowPooooooopAooooooaWoooooooowPoooooooopAooooooaWooooooowPoooooopAooooooooaWooooooowPoooooo
        """,
        "gal.left": """
        ............................................
        ............................................
        ............................................
        ............................................
        .ggggg.........gggggg..........ggggg........
        wwwwwww.......wwwwwwww........wwwwwww.......
        AAAAAAa.ggggg.PPPPPPPp.gggggg.WWWWWWw.gggggg
        AoAoAAawwwwwwwPoPoPoPpwwwwwwwwWoWoWWwwwwwwww
        AoAoAAaWWWWWWwPoPoPoPpAAAAAAAaWoWoWWwPPPPPPP
        AAAAAAaWoWoWWwPPPPPPPpAoAoAoAaWWWWWWwPoPoPoP
        AoAoAAaWoWoWWwPoPoPoPpAoAoAoAaWoWoWWwPoPoPoP
        AoAoAAaWWWWWWwPoPoPoPpAAAAAAAaWoWoWWwPPppppp
        AAAAAAaWoWoWWwPPPPPPPpAoAoAoAaWWWWWWwPopoppo
        AoAoAAaWoWoWWwPoPoPoPpAoAoAoAaWoWoWWwPoppppp
        AoAoAAaWWWWWWwPoPoPoPpAAAAAAAaWoWoWWwPPPPPPP
        AAAAAAaWoWoWWwPPPPPPPpAoAoAoAaWWWWWWwPoPoPoP
        AoAoAAaWoWoWWwPoPoPoPpAoAoAoAaWoWoWWwPoPoPoP
        AoAoAAaWWWWWWwPoPoPoPpAAAAAAAaWoWoWWwPPPPPPP
        AAAAAAaWoWoWWwPPPPPPPpAoAoAoAaWWWWWWwPoPoPoP
        AoAoAAaWoWoWWwPoPoPoPpAoAoAoAaWoWoWWwPoPoPoP
        AoAoAAaWWWWWWwPoPoPoPpAAAAAAAaWoWoWWwPPPPPPP
        NNNNNNNUUUUUUUEEEEEEEERRRRRRRRNNNNNNNUUUUUUU
        AoooooaWooooowPoooooopAooooooaWooooowPoooooo
        AoooooaWooooowPoooooopAooooooaWooooowPoooooo
        """,
        "gal.right": """
        ..................
        ..................
        ..................
        ...........ggggg..
        ..........wwwwwww.
        .gggggggg.AAAAAAa.
        wwwwwwwwwwAoAoAAa.
        PPPPPPPPPpAoAoAAaw
        PoPoPoPoPpAAAAAAaW
        PoPoPoPoPpAoAoAAaW
        PPppppppPpAoAoAAaW
        PopoppopPpAAAAAAaW
        PoppppppPpAoAoAAaW
        PPPPPPPPPpAoAoAAaW
        PoPoPoPoPpAAAAAAaW
        PoPoPoPoPpAoAoAAaW
        PPPPPPPPPpAoAoAAaW
        PoPoPoPoPpAAAAAAaW
        PoPoPoPoPpAoAoAAaW
        PPPPPPPPPpAoAoAAaW
        PoPoPoPoPpAAAAAAaW
        PoPoPoPoPpAoAoAAaW
        PPPPPPPPPpAoAoAAaW
        EEEEEEEEEERRRRRRRN
        PoooooooopAoooooaW
        PoooooooopAoooooaW
        """,
        "gal.tram": """
        ..........D.........
        ...........D........
        ............D.......
        ..WWWWWWWWWWWWWWWW..
        .RCCCCCCCCCCCCCCCCR.
        .RooRooRooRooRooRoR.
        .RooRooRooRooRooRoR.
        .RRRRRRRRRRRRRRRRRR.
        .RRDRRRRRRRRRRRRRRR.
        .rrrrrrrrrrrrrrrrrr.
        ..KK............KK..
        """,
        "gal.street": """
        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        gGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGG
        GGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgG
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        GGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgG
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        gGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGG
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        GGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgG
        gGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGG
        gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
        gGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGG
        GGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgGGGgG
        """,
        "pam.hills": """
        ................................................................................................
        ................................................................................................
        ................................................................................................
        ............................................V...................................................
        .........................................11VV22w................................................
        ..............V........................11111122222............................................11
        ...........1V1122w..................11111111222222222.....................V..................111
        .......111111112222222...........111111111112222222222222.............V1VV1222w..........1111111
        .....11111111122222222222......111111111111112222222222222........11111111222222222....111111111
        .11111111111111222222222222211111111111111112222222222222222221111111111111222222222221111111111
        111111111111111222222222221111111111111111122222222222222221111111111111111222222221111111111111
        111111111111112222222211111111111111111111112222222222221111111111111111112222222221111111111111
        """,
        "pam.terraces": """
        ................................................................................................
        ................................................................................................
        ................................................................................................
        ............................................................WWWW.W..WWWW.WWW.....W.WWW.WWWW..WW.
        ..........................................................WwWwwWWWWWWWWWWWWWWWwWWWWWWWWWWWWWWWWw
        .........................................................4444VWV444444VWV444444VWV444444VWV44444
        .......................................................WW4445VWV544445VWV544445VWV544445VWV54444
        ......................................................WwW555VwWwV5555VWWwV5555VWWWV5555VwWWV5555
        ....................................................WWWWWVVVwWWWwVVVVwWWWWVVVVwWWWwVVVVWWWWwVVVV
        ...................................................444444VV444444VwV4444444VV4444444VV4444444VV4
        .................................................WW444445VV544445VWV5444445VV5444445VV5444445VV5
        ................................................WWW55555VwWV5555VWWWV55555VWwV55555VwwV55555VwWV
        ..............................................WWWWwVVVVVwWWWVVVVwWWwwVVVVVwWWwVVVVVwWWWVVVVVwWWW
        .............................................V4444444VV4444444VV4444444VV4444444VV444444VwV44444
        ...........................................WWV5444445VV5444445VV5444445VV5444445VV544445VWV54444
        ..........................................WWWwV55555VwwV55555VwwV55555VwwV55555VwwV5555VwwWV5555
        ........................................WWWWWwWVVVVVwWWwVVVVVWWwwVVVVVwWWwVVVVVwWWwVVVVwWwWWVVVV
        ......................................VWV444444VwV4444444VV4444444VV4444444VV444444VWV4444444VV4
        .....................................WVWV544445VWV5444445VV5444445VV5444445VV544445VWV5444445VV5
        ...................................WWWwWwV5555VwWwV55555VWwV55555VWWV55555VWwV5555VWWwV55555VwwV
        ..................................WwWWWWWwVVVVwWWWWVVVVVwWwwVVVVVwWWwVVVVVwWwwVVVVwwWWwVVVVVwWWw
        ................................44VWV4444444VV444444VwV444444VwV4444444VV444444VWV444444VwV44444
        ...............................w45VWV5444445VV544445VWV544445VWV5444445VV544445VWV544445VWV54444
        .............................wWW5VWWWV55555VWwV5555VwWWV5555VWWwV55555VwwV5555VWwwV5555VwWwV5555
        ............................WWWWVWWWWwVVVVVwWWwVVVVwWWWWVVVVwWWWwVVVVVWWWWVVVVWWWWwVVVVWWWWwVVVV
        ..........................4444VV4444444VV444444VwV444444VwV444444VwV4444444VV444444VwV4444444VV4
        .........................W4445VV5444445VV544445VWV544445VWV544445VWV5444445VV544445VWV5444445VV5
        .......................WWW555VWwV55555VWwV5555VwWwV5555VWWwV5555VwWWV55555VwWV5555VwWwV55555VwwV
        ......................WWWWVVVWWWwVVVVVwWWwVVVVwWWWwVVVVwWWWwVVVVwWWWwVVVVVwWWwVVVVwWWWwVVVVVWWWW
        ....................44444VwV4444444VV444444VwV444444VwV4444444VV444444VwV444444VwV444444VwV44444
        ...................W44445VWV5444445VV544445VWV544445VWV5444445VV544445VWV544445VWV544445VWV54444
        .................WWW5555VwWwV55555VWwV5555VWWwV5555VWWwV55555VwWV5555VwWwV5555VWWWV5555VwWWV5555
        ................WWWwVVVVwWWWwVVVVVWWWwVVVVWWWWwVVVVwWWWwVVVVVwWWwVVVVwWWWwVVVVwWWWwVVVVwWWwwVVVV
        ................WWWWWwwwWWWWWWWWWwWWWWwWWWWwWWWwwwwWWWWWwWwWwWWWWWwwwWWWWWwwwWWWwWWwwWwwWWWWwwww
        """,
        "pam.ground": """
        JjJJjJJJJJJJJJjJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJjJJjJjJJJJJJJJJJ
        JJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJjJJJjJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJjjJJJJJJJJJJJJJJJJ
        jjJJJJJJJJJJJjjjJJJJJJJJJJJJJJJJSSSSSSSSjJJJJJJJSSSSSSSSJJJJJJJJSSSSSSSSJJjJJJJJSSSSSSSSJJJjJJJJ
        JJJjJjJJJJJJJjJJJJJJJJJjJJJJJJSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
        JJJjJjJJJJJJJJJJJJJJJjJJJJJJJJSSJJJJJJJJSSSSSSSSjJJJJJJJSSSSSSSSJJJJJJJJSSSSSSSSJJJJJJJJSSSSSSSS
        JJJjJJJJJjJJJJJJJJJJJJJJJJJJJjJJJJjJJJJJJjJJjJjJJJjJJJJJJJjJJjJJJJJJJJJJJJJjJJJJJJJJJJjJJJJJJJJJ
        JJJJJJJJjJJJJJJJJJJJJJJJjJJJJJJJJJjJJJJJjJJJJjJJJJJJJJJJJJjJjJJJJJjJJJJJJJJJJJJJJJJJJjJJJJJJJJJJ
        JJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJjJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJjJJJ
        JJJjJJjJJJJJJjJJJJJJJJJJjJJJjJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJjJJJJjJJJJJJJJjJJJJJJJjJj
        JJJjJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJjJJJJjJJJJJJJJJJJJJjjJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJj
        JjJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJjJJJJJJJJjJJJJJJJJJJjJJJJJJJJJJJjjJjJJJjJJJJjjJjJJJJJJJjJJJjJJ
        JJJJJJJJJJJjJJJJjJjJjJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJjJJJJJJjJJJjJJJJjjjJjJjJJJJJJJJJJJ
        JJJJJJjJJJJJjJJJJJJJJJJJJJJJJjJJjjJJJjJjJJJJJJJJJJJJJJJjJJJJJJJjjJJJJJJJJjJJJJJJJJJJjJJJjJjJJJjJ
        JJJJJjJJJJJJJJJJJJJJJjJJJJJjJJJJJJJJJJJJJJJJjJJJJJjJJJJJJjJJjJJJJJJJJJJjJJjJJJJJJJJJJJJJJJJJJjJj
        """,
        "pam.ruins": """
        ..........................
        ....SSSSSSSSSSS...........
        ....sssssssssss...........
        SSs..S...S...S............
        .S...S...S...S.........SSs
        .S...S...S...S.....SSs..S.
        .S...S...S...S...SSSSSS.S.
        .S...S...S...S...SS..SS.S.
        .S...S...S...S...SS..SS.S.
        .S...S...S...S...SS..SS.S.
        .S...S...S...S...SS..SS.S.
        .Ss..Ss..Ss..Ss..SS..SS.Ss
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
        "olu.mountain": """
        ................................................................................1...............
        ...............................................................................122..............
        ..............................................................................11222.............
        .............................................................................1112222............
        ............................................................................111112222...........
        ...........................................................................11111122222..........
        ..........................................................................1111112222222.........
        .........................................................................I11I112i2222if2........
        .......................................................................III1II1I2i2222fi2if......
        ......................................................................IIIFFIIFIiiiiiiifiiiii....
        .....................................................................IIIIIIIIFIiifiiiiifiiii....
        ....................................................................IIIIIFIIIIIFfiiiififiiiii...
        ...................................................................FIIIFIIIFFIIFiiiiiifiiiiiii..
        ..................................................................FFIIIIIIIIIFIfiiiiiififiiiiiii
        .................................................................IIIIIIIIIIIIIfiiffifiiifiiififf
        ................................................................IIFIIIIIIIIFIIiifiiiiiiifiiiiifi
        ....................................................1..........IIIFIIIIIIFIIIIiifffiiiiifiiiiiif
        ...................................................122........IIIIIIIIIIIFIIIIiiiiiiiiiiiiifffii
        .................................................1111222....IIIIIIIFFIIIIFIIIIIiiifiiiiiiffiiifi
        ................................................111122222..IFFIIIIFIFIIIIIFIIIFiiiffiifiiiiiifii
        ...............................................11111122222.IIIFFIFIIIIIIIFIIIIIiiiifiiifiiiififi
        .............................................111111112222222FIIIIIIIIFFIFIFIIfiifiiiifiiiiiiifif
        ............................................11111111222222222IIFIIIIFFIIFIIIFIiiiiiiiiiiiiiiiiii
        ...........................................1I11111I2iii22i2ii22FIIFIIIIIIFIFIIifiiiiiiiiiiiiiiiI
        .........................................IIFFI1IIFIIiiii2i2iii22iIIFIIIIIIIIIiiiifiiiiiifiifiiiI
        .......................................IIFIIIIIFIIIiiiiiifiiiiifiiIIIFFIIIIIIFfifiiiifiifififIFF
        .......................................IIFIIIIFIIFIIfiiifiiiiiififIIIIFIIIIIIFifiiiifiiiiiiiIIFI
        .....................................IIIFIIIIIFFIFIifiiiiifffiiiiiiifIIIFIFIiififiififfifififIII
        ....................................IIIIIFIIIIIIIFFIifffifiiiiiffiiiiiIFIIFIfiiiiiiiiiiffiiIIFII
        ..................................IIIIIIIIIFIIIIIIFIiiiiifiiiifiiiifiiiiFFIFiifiiiiiiiiiifIIIIIF
        ..................................FIIIFIIIIIIIIIIFIfiiiiiiifiiiiififiiiiIIIIIiffiiiiiiiiiiIIFFII
        ................................IIIIIIIFIIIIIFFIIFIiiifiiiiiifififfiiiififIIFiiiiiifiiiiiIIIIIII
        ...............................IIIIIIIFIIIIIIIFIIIFiiiiiiiiiiiiifffiiiiiiiiFIifiifiiifiiFIIIFIII
        ..............................FFIIIIIIFIIIIFIIIIIIFiiiffffiiiifiiiiffiiiifiiIiiiiifiifIIIIIFIIII
        """,
        "olu.lagoon": """
        CCCCCCCCCCCCCCCCCCCCCCCCICCCCCCICCCCCCCCCCCCCCCCCC..............
        CCCCCCCCCCCCCCCCCICCCCCCIiCCCCCIiCCCCCICCCCCCICCCC..............
        CCCCCCCCCCICCccccIiccc................IicccccIiCCC..............
        CCCCCCCcccIi....................................ccc.............
        CCCIccc.........................................................
        cccIi...........................................................
        cc........................................................ccccCC
        ............................................................cccC
        ............................................................cccc
        ............................................................cccC
        cc........................................................ccccCC
        cccc....................................................ccccCCCC
        CCCcccc..............................................ccccCCCCCCC
        cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        """,
        "olu.g1": """
        ..RYRYRYR..
        .RYRYRYRYR.
        RY.......YR
        D.........D
        .D.......D.
        ..D.....D..
        ...D...D...
        ....DKD....
        .....K.....
        """,
        "olu.g2": """
        ..UWUWUWU..
        .UWUWUWUWU.
        UW.......WU
        D.........D
        .D.......D.
        ..D.....D..
        ...D...D...
        ....DKD....
        .....K.....
        """,
        "olu.g3": """
        ..OYOYOYO..
        .OYOYOYOYO.
        OY.......YO
        D.........D
        .D.......D.
        ..D.....D..
        ...D...D...
        ....DKD....
        .....K.....
        """,
        "olu.g4": """
        ..PWPWPWP..
        .PWPWPWPWP.
        PW.......WP
        D.........D
        .D.......D.
        ..D.....D..
        ...D...D...
        ....DKD....
        .....K.....
        """,
        "olu.gulet": """
        .....D.....D......
        .....D.....D......
        .....DW....DW.....
        .....DW....DWW....
        .....D.....D......
        b..BBBBBBBBBBBBB..
        BBBBWWWWWWWWWWWBBB
        .BBBBBBBBBBBBBBBB.
        ..bbbbbbbbbbbbbb..
        """,
        "olu.pine": """
        ....I....
        ....I....
        ...IIi...
        ....I....
        ...IIi...
        ..IIIii..
        ...IIi...
        ..IIIii..
        ..IIIii..
        ..IIIii..
        ..IIIii..
        .IIIIiii.
        ..IIIii..
        ....X....
        """,
        "olu.pineSmall": """
        ...I...
        ...I...
        ..IIi..
        ...I...
        ..IIi..
        .IIIii.
        ..IIi..
        .IIIii.
        IIIIiii
        ...X...
        """,
        "eph.celsus": """
        ................W.................
        .......WWWWW..WWWWW...WWWWW.......
        ......WWWWWWWWWWWWWWWWWWWWWW......
        ....CCCCVCVCCCCVCCVCCCCVCVCCCC....
        ....CCCCWCWCoCCWCCWCCoCWCWCCCC....
        ....CCCCWCWCCCCWCCWCCCCWCWCCCC....
        ....CCCCWCWCCCCWCCWCCCCWCWCCCC....
        ....CCCCWCWCCCCWCCWCCCCWCWCCCC....
        ....CCCCWCWCCCCWCCWCCCCWCWCCCC....
        ....CCCCWCWCCCCWCCWCCCCWCWCCCC....
        ....CCCCWCWCCCCWCCWCCCCWCWCCCC....
        ....CCCCWCWCoCCWCCWCCoCWCWCCCC....
        .WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW.
        ..wwwwwCCCwwwwwCCCCwwwwwCCCwwwww..
        ..WWWWW...WWWWW....WWWWW...WWWWW..
        .ccVcVcccccVcVccccccVcVcccccVcVcc.
        .CCWCWCCCCCWCWCCCCCCWCWCCCCCWCWCC.
        .CCWCWCCCCCWCWWWWWWWWCWCCCCCWCWCC.
        .CCWCWCCCCCWCWCDDDDCWCWCCCCCWCWCC.
        .ccWcWWWWWWWcWcDDDDcWcWWWWWWWcWcc.
        .CCWCWCDDDCWCWCDDDDCWCWCDDDCWCWCC.
        .CCWCWCDDDCWCWCDDDDCWCWCDDDCWCWCC.
        .CCWsWCDDDCWsWCDDDDCWsWCDDDCWsWCC.
        .ccWSWcDDDcWSWcDDDDcWSWcDDDcWSWcc.
        .CCWSWCDDDCWSWCDDDDCWSWCDDDCWSWCC.
        .CCWsWCDDDCWsWCDDDDCWsWCDDDCWsWCC.
        .CCWCWCDDDCWCWCDDDDCWCWCDDDCWCWCC.
        .ccWcWcDDDcWcWcDDDDcWcWcDDDcWcWcc.
        WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
        wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
        """,
        "eph.street": """
        wWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWW
        wWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWW
        wWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWW
        wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        WWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWw
        WWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWw
        WWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWw
        wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        wWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWW
        wWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWW
        wWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWW
        wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        WWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWw
        WWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWwWWWWWWWWWw
        """,
        "eph.fragments": """
        ..................................................
        VVV.....VVVV.................VVVV.................
        Ww.......Ww...................Ww..................
        Ww.......Ww.....VVVV..WWWWWW..Ww........VVVV......
        Ww.......Ww......Ww..wWWWWWWw.Ww.........Ww.......
        Ww.......Ww......Ww...wwwwww..Ww.........Ww.......
        """,
        "eph.hills": """
        ................................................................................................
        .........................................jjjjjjjjjjj............................................
        ....................................jjjjjjjjjjjjjjjjjjjjj.......................................
        .....jjjjjjjjjjj.................jjjjjjjjjjjjjjjjjjjjjjjjfff....................................
        .jjjjjjjjjjjjjjjjjjj...........jjjjjjjjjjjjjjjjjjjjjjjjjjfffff...................jjjjjjjjjjj....
        jjjjjjjjjjjjjjjjjjjjfff......jjjjjjjjjjjjjjjjjjjjjjjjjjjjfffffff............jjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjjjjjjfffff..jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjfffffffff........jjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjjjjjjfffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjfffffffffff...jjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjjjjjjffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjffffffffffffjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjjjjjjffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjffffffffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjjjjjjfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjfffffffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjfffffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjffffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjffffjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
        """,
        "cypress.tall": """
        .I.
        .I.
        IIi
        IIi
        IIi
        IIi
        IIi
        IIi
        IIi
        IIi
        IIi
        IIi
        IIi
        .X.
        """,
        "cypress.mid": """
        .I.
        .I.
        IIi
        IIi
        IIi
        IIi
        IIi
        IIi
        IIi
        IIi
        .X.
        """,
        "uzg.mountains": """
        ......................................................................I.........................
        .....................................................................Ifi........................
        .....................................................................IIf........................
        ....................................................................IIifi.......................
        ...................................................................IIIIifi......................
        ...................................................................FIIIiii......................
        ..................................................................IIIIfiiii.....................
        .................................................................IFIIiiiffii...................f
        ................................................................IIIIIfiiifiii..................I
        ................................................................IIIIIIiiiiiii.................IF
        ...............................................................FIIIIIFiiifiiif...............III
        ..............................................................IIIIIIFiifiiiiffif............IFIF
        ............................................................IIFIIFIIIIiifiiiiiiff..........IIFIF
        ............................................................IIIIIIIFFIiifffifffiif.........IFIII
        ............................................................FIIIFFIIIiififiiifiiii.........IIFIi
        ..........................................................IIFIIIFIIIiifififfiiiiiii.......FIIIIi
        ...........................................................IIIFFIIFIffiiiiiiiiiiiii.....IFFIIIII
        ..........................................................FIIFFIIIIIiiifffiiifffffii....IIIIIIIF
        ........................................................IIIIFFIIIIFFIiiiiiiiiiiiiifiii..FIIIIIIF
        .......................................................IIIFIIIFIFFFIIiiiiiiiiiifiiiiiiiFIIIIFIFf
        ......f................................................IIIFFIIIIIIIIIiifffiiiiifiiiffiFFIIIIIIii
        .....ffi...............................................IIIFIIIIIIIIfiiififiiifiiiiiffIIIIFFIFIii
        ....FIiii.............................................IFIIIFFIIFIIIiiiiiiififiiiiiifiIIFIIFIIIIi
        ..IFIIiiiii.........................................FFIFFIIIFIIFIIFfiiiiiiiffffiiifiiIFIIIFIIIii
        ..FIIIIiifi.......................f.................FIIIIIIIIIIIIFFIfiiififfffiiiiiIFFIFFFFIFIIi
        IFIFIIiiiiiifi...................Iii...............FIFIIFFIFIFIFFIFiiiiiiiiiiifiiiIIIIIIIFIFFIIf
        IIFIIIfiifiiifi................FIIIifi.............IIIIIIIFIIIIIIIIIiffiiiififiifIIIFIIIIIIIFIFi
        IIIIIIiiiffiiif...............FFIIffiif...........IIFIIIIFIFIIIIFIIiiifiiiiiffifiIIIIIIIIIIIIIii
        IIIIIFiifiifiiiif............IFIIFFiiifi........IIIFIIIIIIIFIIFIIIfiiifiifiifiiiFFIIIIIIIIFIIIfi
        IFFIIfifiifiifiiii.........IIIIIIFifiifiiii......IIFIIIIIFIIIIIFIIIifiiffiiiiiiIIFIFIIIIIFIIIfif
        IIIIFFiififfiiiiiiif......IIIFIIIIIfffiiiifi...IIFIIIIIIIIFIIIIIIIiififfiiiiiiiiIFIFIIIIIIIIFFii
        IIFIFIiiiiiiiiifiiiii....IIIIIFFFIiifffiiiiii..IIIIIIFIIFIIIIFIIIFiiiiiiifiiiffFIFIIFIIIFFIIIIfi
        IIIIFIffiiiiiifififfff..IIIFIIIIIifiifiifiifff.IIIIFIIIFIFIFIIIIIIIifiiiiiiiiIFIFIIIIIIIIIIIIifi
        IFIIIIiiiiiiffiiiifiiiFFIIIIIIIIIIffiiiifiiifIFIIIIIFIIIFIIIIIFIIIIfiiiffiiiiiIIIIIIIIIFIIIFFiii
        IIIIIiiiiiifiiffiiffiIFIIFIIIIIIIfiifiiiiiiiiIFIFIIIIFIIFFIFIIFFIiiiiffiiiiiIIIIIFIIIFFIIIIFIifi
        IIIIiiiiiiiiiffiiiiIIFFIIFIIIFFIIfiiiififiiiIIIIIFIIIIIIIIIFIFFIFIiiiffiiiiFIFFFIIIIIFIFIIIIiffi
        IIFIIfifffiiifiifFIFIIFIIFIIIIFIIiiifiiiiiiiIIFFIIIIIIFIIIIIIIFIIiiiifiiifiFIIIIIIIIIIIIIFIFIiii
        IIIIifiiiifiifiiiIFFFIIIIIFIIIIIIIfiiififiFIIIIIIIIIIFIIIIIIIIFIFIiifiifiiIIIIIIIIIIIIIFIIIIiffi
        IIFIifiiiiiiiffIIFIIIFIIIIIIIIFIiiifiiffiIIIIIIFIIIIFIFFIIFIIFIIFfifiiiiiIIIFIIIIFIIIIFIIIIIfiii
        FIFIfffiiiiifIIIIIIIIIFIFIFFIFFIiiiiiiifiIIIFIIIFIIIFIIIIIIFIIIFIiiffiffFFIFIIIFIFIIIIIIIIIFfiif
        """,
        "uzg.mosque": """
        ..........................
        ..........................
        ..Y....................Y..
        ..y....................y..
        ..L....................L..
        ..L....................L..
        ..L....................L..
        .LLl..................LLl.
        .LLl..................LLl.
        .LLl..................LLl.
        .WWw........Y.........WWw.
        Wwwww......LLLl......Wwwww
        .ggg.......LLLl.......ggg.
        .WWw....DDDDDDDDDD....WWw.
        .WWw...KKKKKKKKKKKK...WWw.
        .WWw..KKKKKKKKKKKKKK..WWw.
        .WWw.KKKKKKKKKKKKKKKK.WWw.
        WwwwwKKKKKKKKKKKKKKKKWwwww
        .gggKKKKKKKKKKKKKKKKKKggg.
        .WWwWWWWWWWWWWWWWWWWWwWWw.
        .WWwWWWWWWWWWWWWWWWWWwWWw.
        .WWwWWWWWWWWWWWWWWWWWwWWw.
        .WWwWWWWWWWWWWWWWWWWWwWWw.
        .WWwWWoWWoWWoWWoWWoWWwWWw.
        .WWwWWoWWoWWoWWoWWoWWwWWw.
        .WWwWWWWWWWWWWWWWWWWWwWWw.
        .WWwWWWWWWWWWWWWWWWWWwWWw.
        .WWwWWoWWoWWDDDoWWoWWwWWw.
        .WWwWWoWWoWWDDDoWWoWWwWWw.
        .WWwWWWWWWWWDDDWWWWWWwWWw.
        .WWwWWWWWWWWDDDWWWWWWwWWw.
        .WWwWWWWWWWWDDDWWWWWWwWWw.
        """,
        "uzg.house": """
        ...GGGG...
        .GGGGGGGG.
        GGGGGGGGGG
        .BBoBBoBB.
        .BBBBBBBb.
        .BBoBBDBb.
        """,
        "uzg.pier": """
        BBBBBBBBBBBBBB
        b..b...b...b..
        b..b...b...b..
        """,
        "uzg.pine": """
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
        "uzg.pineSmall": """
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
        "bkh.minaret": """
        ....aaaa....
        ...AAAAAA...
        .AAAAAAAAAA.
        SSSSSSSSSSSS
        .AAAAAAAaaa.
        .ADADADADaa.
        .ADADADADaa.
        .AoAoAoAoaa.
        .ADADADADaa.
        .AAAAAAAaaa.
        .ssssssssss.
        SSSSSSSSSSSS
        ..TTTTTTTT..
        ..tttttttt..
        ..SAAASaaa..
        ..AAASAaas..
        ..AASAAasa..
        ..ASAAAsaa..
        ..SSSSSsss..
        ..AAASAaas..
        ..AASAAasa..
        ..ASAAAsaa..
        ..SAAASaaa..
        ..AAASAaas..
        .SSSSSSssss.
        .AASAAAsaaa.
        .ASAAASaaas.
        .SAAASAaasa.
        .AAASAAasaa.
        .AASAAASaaa.
        .SSSSSSSsss.
        .SAAASAAasa.
        .AAASAAAsaa.
        .AASAAASaaa.
        .ASAAASAaas.
        .SAAASAAasa.
        .SSSSSSSsss.
        .AASAAASaaa.
        .ASAAASAaas.
        .SAAASAAasa.
        .AAASAAAsaa.
        .AASAAASaaa.
        """,
        "bkh.mosque": """
        .................TTUUUu.....
        ................TTTUUUuu....
        ...............TTTTUUUuuu...
        ..TTTTTTTTTTT.TTTTTUUUuuuu..
        ..AAAAAAAAAAaUUUUUUUUUuuuuu.
        ..ATTTTTTTTTaUUUUUUUUUuuuuu.
        ..AAAAAAAAAAaUUUUUUUUUuuuuu.
        ..ATAAAAAAATaTTTTTTTTTTTTTT.
        ..AAAAAUAAAAaUUUUUUUUUUUUUU.
        ..AAAAUUUAAAaAAAAAAAAAAAAAA.
        ..ATAUUUUUATaAAAAAAAAAAAAAA.
        AAAAUUUUUUUAaAAAAAAAAAAAAAAa
        AAAAUUUUUUUAaAAAAAAAAAAAAAAa
        AaATUUTUUUUTaaAAaAAaAAaAAaAa
        ADAAUUUUUUUAaDAADAADAADAADAa
        ADAAUUUUUUUAaDAADAADAADAADAa
        ADATUUUTUUUTaDAADAADAADAADAa
        ADAAUUDDDUUAaDAADAADAADAADAa
        ADAAUUDDDUUAaDAADAADAADAADAa
        AAATUUDDDUUTaAAAAAAAAAAAAAAa
        AAAAUUDDDUUAaAAAAAAAAAAAAAAa
        AAAAUUDDDUUAaAAAAAAAAAAAAAAa
        """,
        "bkh.madrasah": """
        ......................
        ...Y..............Y...
        ...t..............t...
        .tVtTt..........tVtTt.
        TtTtTtt........TtTtTtt
        TtTtTtt........TtTtTtt
        UUUUUUTTTTTTTTTUUUUUUU
        AAAAAAAAAAAAAAaAAAAAAA
        AAAAAAATTTTTTTaAAAAAAA
        AAAAAAAAAAAAAAaAAAAAAA
        AAAAAAATAAAAATaAAAAAAA
        AAAAAAAAAAUAAAaAAAAAAA
        AUAAUAAAAUUUAAaAUAAUAA
        AUAAUAATUUUUUTaAUAAUAA
        AUAAUAAUUUUUUUaAUAAUAA
        AUAAUAAUUUUUUUaAUAAUAA
        AAAAAAATUTUUUTaAAAAAAA
        AUAAUAAUUDDDUUaAUAAUAA
        AUAAUAAUUDDDUUaAUAAUAA
        AUAAUAATUDDDUTaAUAAUAA
        AUAAUAAUUDDDUUaAUAAUAA
        AAAAAAAUUDDDUUaAAAAAAA
        """,
        "bkh.square": """
        aAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAa
        aAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAa
        aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        AAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAA
        AAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAA
        aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        aAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAa
        aAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAa
        aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        AAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAA
        AAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAA
        aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        aAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAa
        aAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAa
        aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        AAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAAAAaAA
        """,
        "gur.mausoleum": """
        ...................y....................
        ...................Y....................
        ...................YY...................
        ........................................
        ...............VVVVtTttu................
        ..............VVVVTtTttut...............
        .............VVVVVTtTtTutu..............
        ............VVVVVVTtTtTutut.............
        ...........VVVVVVtTtTtTututu............
        ..........TtTtTtTtTtTtTttutut...........
        ..........TtTtTtTtTtTtTttutut...........
        ..........TtTtTtTtTtTtTttutut...........
        .........tTtTtTtTtTtTtTttututu..........
        .........tTtTtTtTtTtTtTttututu..........
        .........tTtTtTtTtTtTtTttututu..........
        AAAAA....tTtTtTtTtTtTtTttututu....AAAAAA
        TTTTT....tTtTtTtTtTtTtTttututu....TTTTTT
        UUUu.....TTTTTTTTTTTTTTTTTTTTTT....UUUu.
        AAAa.......WWWWWWWWWWWWWWWWWW......AAAa.
        AAAa.......WUWUWUWUWUWUWUWUWW......AAAa.
        TTTt......TTTTTTTTTTTTTTTTTTTT.....TTTt.
        AAAa.......TUTUTUTUTUTUTUTUtu......AAAa.
        UUUu.......UUUTUUUTUUUTUUUtUu......UUUu.
        AAAa.......TUTUTUTUTUTUTUTUtu......AAAa.
        AAAa.......UTUUUTUUUTUUUTUUUt......AAAa.
        TTTt.......TUTUTUTUTUTUTUTUtu......TTTt.
        AAAa.......UUUTUUUTUUUTUUUtUu......AAAa.
        UUUu.......TUTUTUTUTUTUTUTUtu......UUUu.
        AAAa.......UTUUUTUUUTUUUTUUUt......AAAa.
        AAAa.......TUTUTUTUTUTUTUTUtu......AAAa.
        TTTt.......UUUUUUUUUUUUUUUUUu......TTTt.
        AAAa.TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTAAAa.
        UUUu.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAaUUUu.
        AAAa.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAAAa.
        AAAa.AAUUUUUUAAAAAAUUAAAAAAUUUUUUAaAAAa.
        TTTt.AAUTUTUUAAAAAUUUUAAAAAUTUTUUAaTTTt.
        AAAa.AAUUUUUUAAAAUUUUUUAAAAUUUUUUAaAAAa.
        UUUu.AAUUTUTUAAAAUUUUUUAAAAUUTUTUAaUUUu.
        AAAa.AAUUUUUUAAAAUUUUUUAAAAUUUUUUAaAAAa.
        AAAa.AAUTUTUUAAAAUUUUUUAAAAUTUTUUAaAAAa.
        TTTt.AAUUUUUUAAAAUUUUUUAAAAUUUUUUAaTTTt.
        AAAa.AAUUTUTUAAAAUDDDDUAAAAUUTUTUAaAAAa.
        UUUu.AAUUUUUUAAAAUDDDDUAAAAUUUUUUAaUUUu.
        AAAa.AAUUUUUUAAAAUDDDDUAAAAUUUUUUAaAAAa.
        AAAa.AAAAAAAAAAAAUDDDDUAAAAAAAAAAAaAAAa.
        TTTt.AAAAAAAAAAAAUDDDDUAAAAAAAAAAAaTTTt.
        """,
        "gur.paving": """
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        sSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        SSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSSSSSsSS
        ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
        """,
        "tree.big": """
        ...HHHHHHF...
        ..HHHHHHFff..
        .HHHHHHFFFfF.
        .HHHHHFFfFfF.
        HHHHHFfFFfFff
        HHHHFFFFFffff
        HHHfFFfFFffff
        HHFFFffFfffff
        HFFFfFFffffff
        .FFFffffffff.
        ..FFfffffff..
        ...Fffffff...
        .....fXf.....
        ......X......
        """,
        "tsk.tower": """
        ........*........
        ........W........
        ........R........
        ........R........
        ........W........
        ........W........
        ........R........
        ........R........
        ........W........
        ........W........
        ......GGGGG......
        ......ggggg......
        .......ggg.......
        ........G........
        ........G........
        ........G........
        ........G........
        ........G........
        .....GGGGGGG.....
        ....GGGGGGGGG....
        ....ooooooooo....
        ....GGGGGGGGG....
        .....ggggggg.....
        ........Gg.......
        ........GG.......
        ........Gg.......
        ........Gg.......
        ........GG.......
        ........Gg.......
        ........Gg.......
        .......GGGg......
        .......GGgg......
        .......GGgg......
        .......GGGg......
        ......G.Gg.g.....
        ......G.Gg.g.....
        ......GgGGgg.....
        .....G..Gg..g....
        ....G...Gg...g...
        ....G...GG...g...
        ...GggggGgggggg..
        ..G.....Gg.....g.
        .G......GG......g
        G.......Gg.......
        """,
        "tsk.mosque": """
        ............................
        .Y........................Y.
        .T........................T.
        .T........................T.
        TTT......................TTT
        TTT......................TTT
        WWw......................WWw
        WWw..........Y...........WWw
        WWw..........YY..........WWw
        WWw......................WWw
        WWw........VVTTTt........WWw
        WWw.......VVVTTTtt.......WWw
        WWWW.....VVVVTTTttt.....WWWW
        ggg......TTTTTTTttt......ggg
        WWw......TTTTTTTttt......WWw
        WWw......TTTTTTTTTT......WWw
        WWw......WWWWWWWWWw......WWw
        WWw......WWWWWWWWWw......WWw
        WWw......WWWWWWWWWw......WWw
        WWw......WWWWWWWWWw......WWw
        WWWW.....WWWWWWWWWw.....WWWW
        ggg.WWWWWWWWWWWWWWwWWWWW.ggg
        WWw.wwwwwwwwwwwwwwwwwwww.WWw
        WWw.WWWWWWWWWWWWWWWWWWWw.WWw
        WWw.WWWWWWWWWWWWWWWWWWWw.WWw
        WWw.WWwWWwWWwWWwWWwWWwWw.WWw
        WWw.WWDWWDWWDWWDWWDWWDWw.WWw
        WWw.WWDWWDWWDWWDWWDWWDWw.WWw
        WWw.WWDWWDWWDWWDWWDWWDWw.WWw
        WWw.WWDWWDWWDWWDWWDWWDWw.WWw
        WWw.WWDWWDWWDWWDWWDWWDWw.WWw
        WWw.WWDWWDWWDWWDWWDWWDWw.WWw
        WWw.WWDWWDWWDWWDWWDWWDWw.WWw
        WWw.WWWWWWWWWWWWWWWWWWWw.WWw
        """,
        "tsk.city": """
        ..................................................
        ..................................................
        ..................................................
        333333333..........33333333.......................
        3o3o3o3o3..........3o3o3o33.......................
        333333333..........33333333................3333333
        3o3o3o3o3..........3o3o3o33.3333333........3o3o3o3
        333333333.33333333.33333333.3o3o3o3........3333333
        3o3o3o3o3.3o3o3o33.3o3o3o33.3333333.333333.3o3o3o3
        333333333.33333333.33333333.3o3o3o3.3o3o33.3333333
        3o3o3o3o3.3o3o3o33.3o3o3o33.3333333.333333.3o3o3o3
        333333333.33333333.33333333.3o3o3o3.3o3o33.3333333
        """,
        "tsk.bank": """
        WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
        JJJJJJJjJJJJjJJjJJJJJJJJJjJJJJJJJJJJJJJJjJJJJJJJJJJJjJJJJJJJJJJJJJJjJJJJJJJJJJJJjJJJJJjjJjJJJJJj
        JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJjJJJJjJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJ
        JJJJJJJJJJJJJjJJJjJjJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJjJJJJJJJJJJJJJJJjJJJJJJJJJJJJJjJJJJJJJJJJJJJJJ
        JJJJJJJJJJjJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
        JJJJJJJJjJJJJJJJJJJJjJJJJJJJJJjJJJJJJJJJjjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJjJJJJjJJJJJJJJ
        JJJJJJJJJJJJJJJJJjJJjjJJjJJJJJJjJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJjJJJjJ
        JJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJ
        JJJJJJjJJJJJJJJjJJJJJJJJJJJJJjJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJjJJJJJJJJ
        JJJjJJJJJJJJJJJjJJJJJJJJJJJJJJJjJJJJJjjjJJJJJJJJJJJjJJJjJJJJJJJJJJJJJJJJJjJJjJJJJjJJJJJJJJJJJJjJ
        JJjjJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJjjJJJJjJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJjJJJJJJJJJJjJJJjj
        JJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJjJJjJJJjJJJJJjJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJ
        jJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJjJJJJJJJJJJJjJJJJJJJJJJJJjjJJJJjJJ
        JJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJjJJJjJJjJJJJJJJJJJJjJJJJJJJJJJJJJJJjJJJJJJjjJJJJJ
        """,
        "chm.peaks": """
        ..........................................................................V.....................
        .........................................................................Vww....................
        ........................................................................VVwww...................
        .......................................................................VVVVwww..................
        .......................................................................VVVVwww..................
        ......................................................................VVVVVwwww.................
        .....................................................................VVVVVVwwwww................
        ....................................................................VVVVVVwwwwwww...............
        ....................................................................VVVVVwwwwwwwww..............
        ...................................................................VV1VVV22www2www..............
        ..................................................................VV1111V22w2w2w2222............
        .................................................................11111111122222222222...........
        ............................................V....................11111111222222222222...........
        ...........................................Vww.................11111111111222222222222..........
        ..........................................VVVww................111111111222222222222222.........
        ..........................................VVwww...............1111111111222222222222222........V
        .........................................VVVwwwww............111111111112222222222222222......VV
        ........................................VVVVwwwww............1111111111112222222222222222......V
        ........................................VVVVwwwwww.........11111111111112222222222222222222..111
        .....................................VVVVVVVwwwwwwww.......11111111111111222222222222222222..111
        ......................................VVVVVVwwwwwwww......11111111111111222222222222222222221111
        .....................................1VVVVVVww22w2w2.....111111111111112222222222222222222221111
        ................V..................1111VV1VVww22222222...111111111111112222222222222222222211111
        ...............VVw................111111111222222222222.1111111111111112222222222222222222111111
        ..............VVwww..............111111111112222222222111111111111111111222222222222222222111111
        ............VVVVVwwww............111111111112222222222111111111111111112222222222222222221111111
        ..........VVVVVVVwwwwww..........111111111122222222221111111111111111112222222222222222221111111
        .........VVVVVVVwwwwwwww.......11111111111222222222211111111111111111122222222222222222111111111
        ........VVVVVVVVVwwwwwwwww.....11111111111122222222211111111111111111122222222222222222111111111
        .......VVVVVVVVVwwwwwwwwwww...111111111111222222222111111111111111111122222222222222221111111111
        .....VVVVVVVVVVVwwwwwwwwwwwww1111111111111122222222111111111111111111112222222222222211111111111
        ...V1VVV1VV11111wwwwww2wwww111111111111111122222221111111111111111111112222222222222211111111111
        ..V111V111111112wwwww222ww1111111111111111122222111111111111111111111122222222222221111111111111
        111111111111111222222222221111111111111111222222111111111111111111111112222222222221111111111111
        111111111111111222222222221111111111111111222221111111111111111111111222222222222221111111111111
        111111111111111222222222211111111111111111222211111111111111111111111222222222222111111111111111
        111111111111111222222221111111111111111111222211111111111111111111111222222222222111111111111111
        111111111111112222222211111111111111111112222111111111111111111111111122222222222111111111111111
        """,
        "chm.foothills": """
        ................................................................................................
        ................................................................................................
        ................................................................................................
        ...................................jjjjjjjjjjj...............................................jjj
        ...............................jjijjjjjjjiijjjjjjj.........................................iijij
        ............................jijjjjjjjjjijijijjjjjjaaa...............jiijjijijjjjj.........jijjjj
        ...jjjjiijjjjj............jjjjjjijjjjjjjijjjjjjjjjaaaia........jjjjjjjijjjjjijjjjjjjja..jiijjjjj
        ijjjjjjjjjjjjjjjji......jjijjjjjjjjjijjjjjjjjjijjjaaaaaii...jjjjijjjijjjjjjjjjijjijjjiijjijjjjjj
        jjjijjiijjijjjjjjaaa..jjjjjjjjiijijijijjjjjjjjjjjjaaaaaaaajjjjjjjijjjjjjjjjjjjjijijjjajjjjjjijjj
        jjjjjjjijjjjjjjjjaaaajjjjjjjjjjjjjjjjjiiijjjjjjjjjaaiaajijjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjiijjjj
        ijjjjjjjijjjjjjjjiajjjjiiijjijijjjjjjjijjjijijjjjjaaajjijjjjjjjjjijjjijjjijjjjijjjjjjjjjjjjjjjjj
        jjjjjjjiijjijjjjiijjjjjjjjjjjjjjijjjjijjjjjjjjjjjiajjjjjjjjjjijjjijijjjjjjjijijjjjjjijjjijjjjjjj
        ijjjjjjjjjjjiijjjjjijjjjjjijjjjjjjjjjijiiijjjjjjjjjjijjjjjjjjjjjjjjijjjjijjjjjjjjijijjjjjjjijjjj
        jjjijjjjjjjjjjjjjjjjjjjjjjjijjjjjjjjjijjjjjjjjjjjjjjjjjijjjjjijjjjjjijijjjjjjjjjjjjijjijjijijjij
        jjjjjjijjjjjjjijjjjjjjjjjijjijjjjjjjijjijjjjjjjjjjjjjjijjjijjjjjjjjjjjjijjijjiijjjjjijjiijijijjj
        jjjjjjjjjjjjjjjjjjjjjjijjjjjjjjjjjjjjiijijjjjjjiijijjjjjjjjjjjjjijjjjjjjjijjjjjjjjijjjjjijjjjjjj
        """,
        "chm.dacha": """
        ....eEEe....
        ..eEEEEEEe..
        eEEEEEEEEEEe
        .WWoWWWWoWw.
        .WWoWWDWoWw.
        .WWWWWDWWWw.
        """,
        "chm.meadow": """
        JJJJJjJJJJJJJjjJJJPPJJJJJJJJjjJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJPPJJJJJJJJJJJJJJJJJJPJJJJJJjJJJJJJJ
        JJJJJJJJJJJJJJJJJJPJJJJJJJJJJJjJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
        JJJJJJJjJjJJjJJJJJjJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJjJJJPJJPJJJJJJJJJJJJJJJPJJJJJJJjJJJJJJJJJjJJJ
        PJJJJJJJJJjJJJJjJJJJJJJJJJPJJJJJJjJjJJJJJJjJJJJJjJjJJJJPJJJJJJJJJJJJJJJJPjJJJJJJJJjJJJJJJJJJJJjJ
        JJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJjJJPJJJJJJJJJPJJJJJJJJJJJJJjJJJJjjJJJJJJjJJJJjJJJJJJJJJJJJJJjJJ
        jJJJJJJJJJJJjJJPJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJPJJJjJJJPJJJJJJJJJJJJJJPJJJJJJJJJJJJJJPJJJjJJJjJ
        JJJJJJjJjJJJJJJJJJJJJJJJJJJJJjjJjjjJjJJJJJJJJJJjJJJJJJJJJJjJJJJJJJJJJjJJJJJJJJJJJJjJJJjJJJJJJJJJ
        JJJJjJJJJJJJJJJJJJJjJJJJJJJJJJjJJJJJJJJJJJJJJjJJJJJJJJjJJJJJJJJJJJJJJJjJJjjJJJJJJJJJJjjPJJJJJJJJ
        JJJJJJjJJJJJJJJJjJJJJJJJJJJJJJJJPjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJjjJjJ
        JJJJJJJPJJJJJJJJJjJJJJJJJJJJJJJJJJJJPJJJJJJJPJJJJJJJjJJJJjJJJJJJJJJJPJJJJjjJJJjJJJJJJJJJJJJJJJJJ
        JJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJPJJJJJJJJJJJJjJJJJJJJJ
        JJJJJPJJJJJJjJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJjJJJJJjJJJJJJPJjJJJJJJJJPJ
        JJJJJJJJJJJJJJjJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJ
        JJJJjJJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJjJPJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJj
        JJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJPJJJJJJJJJJjJjJJJjJJJJJJJJJJJJJJJJJJJJJJJJJ
        JJJPJJJJJJJJJJJJJJJJjjJJJJJJJJJJJJJJJJjJjJJJJJJJJJJJJJJJJJJJJJjJJJJJJJJJJJJJJJJJJJJJJJJJJJJjJJJJ
        """,
        "chm.poplar": """
        .FHf.
        .FHf.
        .FFf.
        FFFff
        FFHff
        FFHff
        FFHff
        .FHf.
        .FHf.
        .FHf.
        ..X..
        ..X..
        """,
        "bzr.dome": """
        ........................TTTT........................
        .......................SSSSSS.......................
        .......................TTTTTT.......................
        .......................TTTTTT.......................
        .......................TTTTTT.......................
        .................UUVTTTTUUTTTTtuut..................
        .............TVTUTVUTTTUTTUTTTUTtutttu..............
        ...........VTVUVTVTTTUTTTTTTUTTTTttutttt............
        .........UVTUTVTUTTUTTTUTTUTTTUTTUtttuttut..........
        .......TTTUUTTTTTUUTTTTTUUTTTTTUUTttttuutttt........
        ......UTUTTTTUTUTTTTUTUTTTTUTUTTTTUtuttttutut.......
        .....TUTUTTTTUTUTTTTUTUTTTTUTUTTTTUtuttttututt......
        ....UTTTTTUUTTTTTUUTTTTTUUTTTTTUUTTTttuutttttuu.....
        ...TTUTTTUTTUTTTUTTUTTTUTTUTTTUTTUTTtuttutttuttu....
        ...TTTTUTTTTTTUTTTTTTUTTTTTTUTTTTTTUttttttuttttt....
        ..UTTUTTTUTTUTTTUTTUTTTUTTUTTTUTTUTTTuttutttuttut...
        ..TUUTTTTTUUTTTTTUUTTTTTUUTTTTTUUTTTTtuutttttuutt...
        ..TTTTUTUTTTTUTUTTTTUTUTTTTUTUTTTTUTUttttututtttu...
        ..TTTTUTUTTTTUTUTTTTUTUTTTTUTUTTTTUTUttttututtttut..
        ..TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT..
        ..SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs..
        ..SSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSSs..
        ..SSoSSSoSSSoSSSoSSSoSSSoSSSoSSSoSSSoSSSoSSSoSSSSs..
        ..SSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSSs..
        ..SSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSDSSSSs..
        ..SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs..
        """,
        "bzr.stalls": """
        WWRRWWRRWWRRWWRRW..UWWUUWWUUWWUUWWUU..NNWWNNWWNNWWNNWWN..YOOYYOOYYOOYYOOYY..
        WWRRWWRRWWRRWWRRW..UWWUUWWUUWWUUWWUU..NNWWNNWWNNWWNNWWN..YOOYYOOYYOOYYOOYY..
        .r.r.r.r.r.r.r.r...u.u.u.u.u.u.u.u.u...n.n.n.n.n.n.n.n...o.o.o.o.o.o.o.o.o..
        b...............b..b...............b..b...............b..b...............b..
        b...............b..b...............b..b...............b..b...............b..
        b...............b..b...............b..b...............b..b...............b..
        b...............b..b...............b..b...............b..b...............b..
        b....Y...Y......b..b....N...N......b..b....R...R......b..b...............b..
        b..Yy.Yy.Yy.Yy..b..b..Nn.Nn.Nn.Nn..b..b..Rr.Rr.Rr.Rr..b..b...SB.SB.SB.SB.b..
        b..yy.yy.yy.yy..b..b..nn.nn.nn.nn..b..b..rr.rr.rr.rr..b..b...BB.BB.BB.BB.b..
        bbbbbbbbbbbbbbbbb..bbbbbbbbbbbbbbbbb..bbbbbbbbbbbbbbbbb..bbbbbbbbbbbbbbbbb..
        bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..
        bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..
        bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..
        bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..
        bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..bBBBBBBBBBBBBBBBb..
        """,
        "bzr.ground": """
        SsSSSssSSSSSSSSSSSSSSsssSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSsSSSSSSSSS
        SSSSSssssSSsSSSsSSSSSSSSSsSSSSSSSSSsSSSSSSSSsSsSsSSsSSSSSSSSssSSSSSSSSSSSSSSSSsSSSSSSSSSsSSSSsSS
        SSsSSSSSSSSsSSSSSSSSsSSSsSSSSsSSSSsSSSSSSsSsSSSSSSSSSSSSSSSSSSSsSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSS
        SSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSssSSsSSSSsSSSSSSSSSSSSSSSSSSSSS
        SSSSSSSSSSSSSSsSSsSSsSSSSSSsSSSSSSSSSsSSSSsSSSSSSSSSSSSSSSsSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSS
        sSSSSSSSSSSSSSSSSSSSsSsSSsSSSSSSSSSSSsSSSSSSSSSSSSSsSsSSSSSSSSSSsSSSSSSSSSSSSsSSSSSSSSSSSSSsSSSS
        SSSSSSSSSSSSSSSSsSSSsSSSSSSSSSSSSsSSSsSsSSSSsssSSSSSSSSSSSSSSSSSSssSSSSSSSSSSSSSSSSSSSSsSSSssssS
        sSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSsSSSSSSSSSSsSSSSSSsSSsSSSSSSSSSSSSSSSSSSSSsssSSSSSsSsSSSSS
        SSSSSSSSSSSSSSSSSsSsSsSSSSSSSSSSsSsSSSSSSSSSSSSSSSSSSSSSSSsSSSSsSSSSSsSSSSSSSsSSSSSSSSSsSSSSSSSS
        SSsSSsSSSSSSSSSSSSSSsSSsSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSsSSSssSSSSSSS
        SsSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSsSsSSSSSSsSSsSSSSSSSSSSSSSSSSSs
        SSSSSSSSSsSSsSSSsSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSssssSSSSSSSsSSSSSsSsSSSSSSSSSSSSSSSSSSSSSSSSS
        SSSSSSSSSSSSSsSSSSsSSSSSSSSSSSSsSSsSsSSsSSssSSSSSSSSSSSSSsSSSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSS
        SSSSSssSSSSSSssSSsSSSSSsSSSsSSSSSSSSSSSSSSSSSSSSSSSSssSSsSsSSSSSsSSSSSSSSssSsSSsSSSSSSSSSSSSSSSS
        SSSsSSSssSSsssSSsSSSSSSSSSSSSSSSSSSSSSSSSsSSSSSSSSSSSSSSSsSSSSSSSSSSsSsSSSSSSSSSSSSSSSSSSSSSSsSs
        ssSSSSSSSSSSSSSsSSsSSSSsSSSSSSsSSSSSSSSSSSSSsSSsSSSSsSSSSSSSSSSSSSSSSSsSSSSSsSssSSSSSSSSsSSSSSSS
        """,
        "bzr.melons": """
        ...Yy...
        ..YyYy..
        .YyYyYy.
        YyYyYyYy
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
        "galata": Scene(horizon: 60, clouds: [9, 21, 33], ops: [
            .sprite("gal.far", x: 0, bottom: 60, depth: 3, flags: 0),
            .sprite("gal.back", x: 0, bottom: 70, depth: 2, flags: 0),
            .sprite("gal.tower", x: 61, bottom: 64, depth: 1, flags: 2),
            .sprite("gal.left", x: 0, bottom: 70, depth: 1, flags: 0),
            .sprite("gal.right", x: 78, bottom: 70, depth: 1, flags: 0),
            .birds(row: 44, count: 4, speed: 2),
            .sprite("gal.street", x: 0, bottom: 86, depth: 0, flags: 0),
            .boat(["gal.tram"], bottom: 77, speed: -0.9, offset: 20, depth: 0),
            .flag(x: 5, top: 50, bottom: 70, depth: 0),
        ]),
        "pamukkale": Scene(horizon: 62, clouds: [10, 22, 34], ops: [
            .sprite("pam.hills", x: 0, bottom: 62, depth: 4, flags: 0),
            .sprite("pam.ruins", x: 66, bottom: 42, depth: 2, flags: 2),
            .sprite("pam.terraces", x: 0, bottom: 74, depth: 1, flags: 0),
            .sprite("pam.ground", x: 0, bottom: 86, depth: 0, flags: 0),
            .water(top: 70, bottom: 76, from: 0, to: 24, lagoon: true),
            .sprite("tree.round", x: 26, bottom: 74, depth: 0, flags: 0),
            .sprite("tree.roundSmall", x: 34, bottom: 74, depth: 0, flags: 0),
            .birds(row: 44, count: 3, speed: 1.6),
            .flag(x: 5, top: 50, bottom: 74, depth: 0),
        ]),
        "oludeniz": Scene(horizon: 58, clouds: [10, 24], ops: [
            .sprite("olu.mountain", x: 0, bottom: 60, depth: 3, flags: 0),
            .water(top: 58, bottom: 80),
            .water(top: 62, bottom: 78, from: 0, to: 64, lagoon: true),
            .sprite("olu.lagoon", x: 0, bottom: 78, depth: 1, flags: 0),
            .boat(["olu.gulet"], bottom: 66, speed: 0.5, offset: 60, depth: 2),
            .bob("olu.g3", x: 60, bottom: 36, depth: 2, amp: 2, period: 2.5),
            .bob("olu.g1", x: 74, bottom: 44, depth: 1, amp: 2, period: 3),
            .bob("olu.g2", x: 85, bottom: 36, depth: 1, amp: 3, period: 2),
            .bob("olu.g4", x: 64, bottom: 56, depth: 1, amp: 2, period: 3.5),
            .sprite("olu.pine", x: 84, bottom: 80, depth: 0, flags: 0),
            .sprite("olu.pineSmall", x: 92, bottom: 80, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 78, depth: 0),
        ]),
        "ephesus": Scene(horizon: 62, clouds: [10, 24], ops: [
            .sprite("eph.hills", x: 0, bottom: 64, depth: 3, flags: 0),
            .sprite("eph.celsus", x: 58, bottom: 70, depth: 1, flags: 2),
            .sprite("cypress.tall", x: 46, bottom: 70, depth: 1, flags: 0),
            .sprite("cypress.mid", x: 51, bottom: 70, depth: 1, flags: 0),
            .sprite("cypress.tall", x: 93, bottom: 70, depth: 1, flags: 0),
            .sprite("eph.fragments", x: 10, bottom: 72, depth: 1, flags: 0),
            .birds(row: 44, count: 3, speed: 1.5),
            .sprite("eph.street", x: 0, bottom: 86, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 72, depth: 0),
        ]),
        "uzungol": Scene(horizon: 58, clouds: [10, 22, 33], ops: [
            .sprite("uzg.mountains", x: 0, bottom: 62, depth: 3, flags: 0),
            .sprite("uzg.house", x: 40, bottom: 60, depth: 2, flags: 0),
            .sprite("uzg.house", x: 52, bottom: 58, depth: 2, flags: 0),
            .sprite("uzg.house", x: 86, bottom: 61, depth: 2, flags: 0),
            .water(top: 60, bottom: 78),
            .sprite("uzg.mosque", x: 60, bottom: 66, depth: 1, flags: 2),
            .sprite("uzg.pier", x: 44, bottom: 70, depth: 1, flags: 0),
            .sprite("uzg.pine", x: 26, bottom: 70, depth: 1, flags: 0),
            .sprite("uzg.pineSmall", x: 33, bottom: 70, depth: 1, flags: 0),
            .sprite("uzg.pine", x: 90, bottom: 72, depth: 0, flags: 0),
            .birds(row: 46, count: 3, speed: 1.4),
            .flag(x: 5, top: 50, bottom: 74, depth: 0),
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
        "bukhara": Scene(horizon: 62, clouds: [10, 22], ops: [
            .sprite("bkh.mosque", x: 38, bottom: 68, depth: 2, flags: 2),
            .sprite("bkh.madrasah", x: 77, bottom: 68, depth: 1, flags: 2),
            .sprite("bkh.minaret", x: 64, bottom: 68, depth: 1, flags: 2),
            .sprite("uz.poplar", x: 28, bottom: 68, depth: 1, flags: 0),
            .sprite("uz.poplar", x: 34, bottom: 68, depth: 1, flags: 0),
            .birds(row: 46, count: 3, speed: 1.4),
            .sprite("bkh.square", x: 0, bottom: 84, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 70, depth: 0),
        ]),
        "guremir": Scene(horizon: 62, clouds: [9, 21, 33], ops: [
            .sprite("gur.mausoleum", x: 56, bottom: 70, depth: 1, flags: 2),
            .sprite("tree.big", x: 34, bottom: 70, depth: 1, flags: 0),
            .sprite("tree.round", x: 46, bottom: 70, depth: 1, flags: 0),
            .sprite("tree.round", x: 92, bottom: 72, depth: 0, flags: 0),
            .birds(row: 46, count: 3, speed: 1.5),
            .sprite("gur.paving", x: 0, bottom: 86, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 72, depth: 0),
        ]),
        "tashkent": Scene(horizon: 62, clouds: [9, 21, 33], ops: [
            .sprite("tsk.city", x: 0, bottom: 62, depth: 3, flags: 0),
            .sprite("tsk.tower", x: 80, bottom: 68, depth: 2, flags: 2),
            .sprite("tsk.mosque", x: 59, bottom: 68, depth: 1, flags: 2),
            .water(top: 66, bottom: 74),
            .sprite("tree.big", x: 30, bottom: 68, depth: 1, flags: 0),
            .sprite("tree.round", x: 44, bottom: 68, depth: 1, flags: 0),
            .birds(row: 46, count: 3, speed: 1.6),
            .sprite("tsk.bank", x: 0, bottom: 88, depth: 0, flags: 0),
            .flag(x: 5, top: 50, bottom: 74, depth: 0),
        ]),
        "chimgan": Scene(horizon: 60, clouds: [10, 22, 34], ops: [
            .sprite("chm.peaks", x: 0, bottom: 60, depth: 3, flags: 0),
            .sprite("chm.foothills", x: 0, bottom: 66, depth: 2, flags: 0),
            .water(top: 62, bottom: 72, lagoon: true),
            .sprite("chm.meadow", x: 0, bottom: 86, depth: 0, flags: 0),
            .sprite("uz.poplar", x: 26, bottom: 72, depth: 1, flags: 0),
            .sprite("chm.poplar", x: 32, bottom: 72, depth: 1, flags: 0),
            .sprite("uz.poplar", x: 38, bottom: 72, depth: 1, flags: 0),
            .sprite("chm.dacha", x: 58, bottom: 74, depth: 1, flags: 0),
            .sprite("tree.big", x: 82, bottom: 76, depth: 0, flags: 0),
            .birds(row: 46, count: 3, speed: 1.4),
            .flag(x: 5, top: 50, bottom: 76, depth: 0),
        ]),
        "bazaar": Scene(horizon: 62, clouds: [10, 22], ops: [
            .sprite("bzr.dome", x: 46, bottom: 64, depth: 2, flags: 2),
            .sprite("uz.poplar", x: 30, bottom: 66, depth: 2, flags: 0),
            .sprite("uz.poplar", x: 38, bottom: 66, depth: 2, flags: 0),
            .sprite("bzr.ground", x: 0, bottom: 86, depth: 0, flags: 0),
            .sprite("bzr.stalls", x: 22, bottom: 74, depth: 1, flags: 0),
            .sprite("bzr.melons", x: 10, bottom: 74, depth: 0, flags: 0),
            .birds(row: 46, count: 4, speed: 1.8),
            .flag(x: 5, top: 50, bottom: 74, depth: 0),
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
        "TR": ["istanbul", "cappadocia", "galata", "pamukkale", "oludeniz", "ephesus", "uzungol"],
        "UZ": ["samarkand", "khiva", "bukhara", "guremir", "tashkent", "chimgan", "bazaar"],
        "AE": ["dubai", "desert"],
        "RU": ["moscow", "village"],
        "EU": ["paris", "coast"],
        "US": ["newyork"],
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
    ]
}
