open Graphics

type t = color

let black                = rgb 0x00 0x00 0x00
let navy                 = rgb 0x00 0x00 0x80
let darkblue             = rgb 0x00 0x00 0x8B
let mediumblue           = rgb 0x00 0x00 0xCD
let blue                 = rgb 0x00 0x00 0xFF
let darkgreen            = rgb 0x00 0x64 0x00
let green                = rgb 0x00 0x80 0x00
let teal                 = rgb 0x00 0x80 0x80
let darkcyan             = rgb 0x00 0x8B 0x8B
let deepskyblue          = rgb 0x00 0xBF 0xFF
let darkturquoise        = rgb 0x00 0xCE 0xD1
let mediumspringgreen    = rgb 0x00 0xFA 0x9A
let lime                 = rgb 0x00 0xFF 0x00
let springgreen          = rgb 0x00 0xFF 0x7F
let aqua                 = rgb 0x00 0xFF 0xFF
let cyan                 = rgb 0x00 0xFF 0xFF
let midnightblue         = rgb 0x19 0x19 0x70
let dodgerblue           = rgb 0x1E 0x90 0xFF
let lightseagreen        = rgb 0x20 0xB2 0xAA
let forestgreen          = rgb 0x22 0x8B 0x22
let seagreen             = rgb 0x2E 0x8B 0x57
let darkslategray        = rgb 0x2F 0x4F 0x4F
let limegreen            = rgb 0x32 0xCD 0x32
let mediumseagreen       = rgb 0x3C 0xB3 0x71
let turquoise            = rgb 0x40 0xE0 0xD0
let royalblue            = rgb 0x41 0x69 0xE1
let steelblue            = rgb 0x46 0x82 0xB4
let darkslateblue        = rgb 0x48 0x3D 0x8B
let mediumturquoise      = rgb 0x48 0xD1 0xCC
let indigo               = rgb 0x4B 0x00 0x82
let darkolivegreen       = rgb 0x55 0x6B 0x2F
let cadetblue            = rgb 0x5F 0x9E 0xA0
let cornflowerblue       = rgb 0x64 0x95 0xED
let rebeccapurple        = rgb 0x66 0x33 0x99
let mediumaquamarine     = rgb 0x66 0xCD 0xAA
let dimgray              = rgb 0x69 0x69 0x69
let slateblue            = rgb 0x6A 0x5A 0xCD
let olivedrab            = rgb 0x6B 0x8E 0x23
let slategray            = rgb 0x70 0x80 0x90
let lightslategray       = rgb 0x77 0x88 0x99
let mediumslateblue      = rgb 0x7B 0x68 0xEE
let lawngreen            = rgb 0x7C 0xFC 0x00
let chartreuse           = rgb 0x7F 0xFF 0x00
let aquamarine           = rgb 0x7F 0xFF 0xD4
let maroon               = rgb 0x80 0x00 0x00
let purple               = rgb 0x80 0x00 0x80
let olive                = rgb 0x80 0x80 0x00
let gray                 = rgb 0x80 0x80 0x80
let skyblue              = rgb 0x87 0xCE 0xEB
let lightskyblue         = rgb 0x87 0xCE 0xFA
let blueviolet           = rgb 0x8A 0x2B 0xE2
let darkred              = rgb 0x8B 0x00 0x00
let darkmagenta          = rgb 0x8B 0x00 0x8B
let saddlebrown          = rgb 0x8B 0x45 0x13
let darkseagreen         = rgb 0x8F 0xBC 0x8F
let lightgreen           = rgb 0x90 0xEE 0x90
let mediumpurple         = rgb 0x93 0x70 0xDB
let darkviolet           = rgb 0x94 0x00 0xD3
let palegreen            = rgb 0x98 0xFB 0x98
let darkorchid           = rgb 0x99 0x32 0xCC
let yellowgreen          = rgb 0x9A 0xCD 0x32
let sienna               = rgb 0xA0 0x52 0x2D
let brown                = rgb 0xA5 0x2A 0x2A
let darkgray             = rgb 0xA9 0xA9 0xA9
let lightblue            = rgb 0xAD 0xD8 0xE6
let greenyellow          = rgb 0xAD 0xFF 0x2F
let paleturquoise        = rgb 0xAF 0xEE 0xEE
let lightsteelblue       = rgb 0xB0 0xC4 0xDE
let powderblue           = rgb 0xB0 0xE0 0xE6
let firebrick            = rgb 0xB2 0x22 0x22
let darkgoldenrod        = rgb 0xB8 0x86 0x0B
let mediumorchid         = rgb 0xBA 0x55 0xD3
let rosybrown            = rgb 0xBC 0x8F 0x8F
let darkkhaki            = rgb 0xBD 0xB7 0x6B
let silver               = rgb 0xC0 0xC0 0xC0
let mediumvioletred      = rgb 0xC7 0x15 0x85
let indianred            = rgb 0xCD 0x5C 0x5C
let peru                 = rgb 0xCD 0x85 0x3F
let chocolate            = rgb 0xD2 0x69 0x1E
let tan                  = rgb 0xD2 0xB4 0x8C
let lightgray            = rgb 0xD3 0xD3 0xD3
let thistle              = rgb 0xD8 0xBF 0xD8
let orchid               = rgb 0xDA 0x70 0xD6
let goldenrod            = rgb 0xDA 0xA5 0x20
let palevioletred        = rgb 0xDB 0x70 0x93
let crimson              = rgb 0xDC 0x14 0x3C
let gainsboro            = rgb 0xDC 0xDC 0xDC
let plum                 = rgb 0xDD 0xA0 0xDD
let burlywood            = rgb 0xDE 0xB8 0x87
let lightcyan            = rgb 0xE0 0xFF 0xFF
let lavender             = rgb 0xE6 0xE6 0xFA
let darksalmon           = rgb 0xE9 0x96 0x7A
let violet               = rgb 0xEE 0x82 0xEE
let palegoldenrod        = rgb 0xEE 0xE8 0xAA
let lightcoral           = rgb 0xF0 0x80 0x80
let khaki                = rgb 0xF0 0xE6 0x8C
let aliceblue            = rgb 0xF0 0xF8 0xFF
let honeydew             = rgb 0xF0 0xFF 0xF0
let azure                = rgb 0xF0 0xFF 0xFF
let sandybrown           = rgb 0xF4 0xA4 0x60
let wheat                = rgb 0xF5 0xDE 0xB3
let beige                = rgb 0xF5 0xF5 0xDC
let whitesmoke           = rgb 0xF5 0xF5 0xF5
let mintcream            = rgb 0xF5 0xFF 0xFA
let ghostwhite           = rgb 0xF8 0xF8 0xFF
let salmon               = rgb 0xFA 0x80 0x72
let antiquewhite         = rgb 0xFA 0xEB 0xD7
let linen                = rgb 0xFA 0xF0 0xE6
let lightgoldenrodyellow = rgb 0xFA 0xFA 0xD2
let oldlace              = rgb 0xFD 0xF5 0xE6
let red                  = rgb 0xFF 0x00 0x00
let fuchsia              = rgb 0xFF 0x00 0xFF
let magenta              = rgb 0xFF 0x00 0xFF
let deeppink             = rgb 0xFF 0x14 0x93
let orangered            = rgb 0xFF 0x45 0x00
let tomato               = rgb 0xFF 0x63 0x47
let hotpink              = rgb 0xFF 0x69 0xB4
let coral                = rgb 0xFF 0x7F 0x50
let darkorange           = rgb 0xFF 0x8C 0x00
let lightsalmon          = rgb 0xFF 0xA0 0x7A
let orange               = rgb 0xFF 0xA5 0x00
let lightpink            = rgb 0xFF 0xB6 0xC1
let pink                 = rgb 0xFF 0xC0 0xCB
let gold                 = rgb 0xFF 0xD7 0x00
let peachpuff            = rgb 0xFF 0xDA 0xB9
let navajowhite          = rgb 0xFF 0xDE 0xAD
let moccasin             = rgb 0xFF 0xE4 0xB5
let bisque               = rgb 0xFF 0xE4 0xC4
let mistyrose            = rgb 0xFF 0xE4 0xE1
let blanchedalmond       = rgb 0xFF 0xEB 0xCD
let papayawhip           = rgb 0xFF 0xEF 0xD5
let lavenderblush        = rgb 0xFF 0xF0 0xF5
let seashell             = rgb 0xFF 0xF5 0xEE
let cornsilk             = rgb 0xFF 0xF8 0xDC
let lemonchiffon         = rgb 0xFF 0xFA 0xCD
let floralwhite          = rgb 0xFF 0xFA 0xF0
let snow                 = rgb 0xFF 0xFA 0xFA
let yellow               = rgb 0xFF 0xFF 0x00
let lightyellow          = rgb 0xFF 0xFF 0xE0
let ivory                = rgb 0xFF 0xFF 0xF0
let white                = rgb 0xFF 0xFF 0xFF

let of_string s = match String.lowercase_ascii s with
  | "black"                -> black
  | "navy"                 -> navy
  | "darkblue"             -> darkblue
  | "mediumblue"           -> mediumblue
  | "blue"                 -> blue
  | "darkgreen"            -> darkgreen
  | "green"                -> green
  | "teal"                 -> teal
  | "darkcyan"             -> darkcyan
  | "deepskyblue"          -> deepskyblue
  | "darkturquoise"        -> darkturquoise
  | "mediumspringgreen"    -> mediumspringgreen
  | "lime"                 -> lime
  | "springgreen"          -> springgreen
  | "aqua"                 -> aqua
  | "cyan"                 -> cyan
  | "midnightblue"         -> midnightblue
  | "dodgerblue"           -> dodgerblue
  | "lightseagreen"        -> lightseagreen
  | "forestgreen"          -> forestgreen
  | "seagreen"             -> seagreen
  | "darkslategray"        -> darkslategray
  | "limegreen"            -> limegreen
  | "mediumseagreen"       -> mediumseagreen
  | "turquoise"            -> turquoise
  | "royalblue"            -> royalblue
  | "steelblue"            -> steelblue
  | "darkslateblue"        -> darkslateblue
  | "mediumturquoise"      -> mediumturquoise
  | "indigo"               -> indigo
  | "darkolivegreen"       -> darkolivegreen
  | "cadetblue"            -> cadetblue
  | "cornflowerblue"       -> cornflowerblue
  | "rebeccapurple"        -> rebeccapurple
  | "mediumaquamarine"     -> mediumaquamarine
  | "dimgray"              -> dimgray
  | "slateblue"            -> slateblue
  | "olivedrab"            -> olivedrab
  | "slategray"            -> slategray
  | "lightslategray"       -> lightslategray
  | "mediumslateblue"      -> mediumslateblue
  | "lawngreen"            -> lawngreen
  | "chartreuse"           -> chartreuse
  | "aquamarine"           -> aquamarine
  | "maroon"               -> maroon
  | "purple"               -> purple
  | "olive"                -> olive
  | "gray"                 -> gray
  | "skyblue"              -> skyblue
  | "lightskyblue"         -> lightskyblue
  | "blueviolet"           -> blueviolet
  | "darkred"              -> darkred
  | "darkmagenta"          -> darkmagenta
  | "saddlebrown"          -> saddlebrown
  | "darkseagreen"         -> darkseagreen
  | "lightgreen"           -> lightgreen
  | "mediumpurple"         -> mediumpurple
  | "darkviolet"           -> darkviolet
  | "palegreen"            -> palegreen
  | "darkorchid"           -> darkorchid
  | "yellowgreen"          -> yellowgreen
  | "sienna"               -> sienna
  | "brown"                -> brown
  | "darkgray"             -> darkgray
  | "lightblue"            -> lightblue
  | "greenyellow"          -> greenyellow
  | "paleturquoise"        -> paleturquoise
  | "lightsteelblue"       -> lightsteelblue
  | "powderblue"           -> powderblue
  | "firebrick"            -> firebrick
  | "darkgoldenrod"        -> darkgoldenrod
  | "mediumorchid"         -> mediumorchid
  | "rosybrown"            -> rosybrown
  | "darkkhaki"            -> darkkhaki
  | "silver"               -> silver
  | "mediumvioletred"      -> mediumvioletred
  | "indianred"            -> indianred
  | "peru"                 -> peru
  | "chocolate"            -> chocolate
  | "tan"                  -> tan
  | "lightgray"            -> lightgray
  | "thistle"              -> thistle
  | "orchid"               -> orchid
  | "goldenrod"            -> goldenrod
  | "palevioletred"        -> palevioletred
  | "crimson"              -> crimson
  | "gainsboro"            -> gainsboro
  | "plum"                 -> plum
  | "burlywood"            -> burlywood
  | "lightcyan"            -> lightcyan
  | "lavender"             -> lavender
  | "darksalmon"           -> darksalmon
  | "violet"               -> violet
  | "palegoldenrod"        -> palegoldenrod
  | "lightcoral"           -> lightcoral
  | "khaki"                -> khaki
  | "aliceblue"            -> aliceblue
  | "honeydew"             -> honeydew
  | "azure"                -> azure
  | "sandybrown"           -> sandybrown
  | "wheat"                -> wheat
  | "beige"                -> beige
  | "whitesmoke"           -> whitesmoke
  | "mintcream"            -> mintcream
  | "ghostwhite"           -> ghostwhite
  | "salmon"               -> salmon
  | "antiquewhite"         -> antiquewhite
  | "linen"                -> linen
  | "lightgoldenrodyellow" -> lightgoldenrodyellow
  | "oldlace"              -> oldlace
  | "red"                  -> red
  | "fuchsia"              -> fuchsia
  | "magenta"              -> magenta
  | "deeppink"             -> deeppink
  | "orangered"            -> orangered
  | "tomato"               -> tomato
  | "hotpink"              -> hotpink
  | "coral"                -> coral
  | "darkorange"           -> darkorange
  | "lightsalmon"          -> lightsalmon
  | "orange"               -> orange
  | "lightpink"            -> lightpink
  | "pink"                 -> pink
  | "gold"                 -> gold
  | "peachpuff"            -> peachpuff
  | "navajowhite"          -> navajowhite
  | "moccasin"             -> moccasin
  | "bisque"               -> bisque
  | "mistyrose"            -> mistyrose
  | "blanchedalmond"       -> blanchedalmond
  | "papayawhip"           -> papayawhip
  | "lavenderblush"        -> lavenderblush
  | "seashell"             -> seashell
  | "cornsilk"             -> cornsilk
  | "lemonchiffon"         -> lemonchiffon
  | "floralwhite"          -> floralwhite
  | "snow"                 -> snow
  | "yellow"               -> yellow
  | "lightyellow"          -> lightyellow
  | "ivory"                -> ivory
  | "white"                -> white
  | _ ->
    let error () = failwith (Printf.sprintf "invalid color: %S" s) in
    if String.length s <> 7 then error ();
    if s.[0] <> '#' then error ();
    try
      let sub i = String.sub s i 2 in
      let rat i = int_of_string ("0x" ^ sub i) in
      rgb (rat 1) (rat 3) (rat 5)
    with _ ->
      error ()
;;
