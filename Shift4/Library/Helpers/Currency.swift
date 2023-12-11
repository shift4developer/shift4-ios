import Foundation
// swiftlint:disable type_body_length file_length
enum Currency: String, Codable {
    case EUR
    case USD
    case AFN
    case ALL
    case DZD
    case AOA
    case ARS
    case AMD
    case AWG
    case AZN
    case BSD
    case BHD
    case BDT
    case BBD
    case BYR
    case BZD
    case BMD
    case BTN
    case BOB
    case BOV
    case BAM
    case BWP
    case BRL
    case BND
    case BGN
    case BIF
    case KHR
    case CAD
    case CVE
    case KYD
    case CLF
    case CLP
    case CNY
    case COP
    case COU
    case KMF
    case CDF
    case CRC
    case HRK
    case CUC
    case CUP
    case CZK
    case DJF
    case DOP
    case EGP
    case SVC
    case ERN
    case ETB
    case FKP
    case FJD
    case XAF
    case GMD
    case GEL
    case GHS
    case GIP
    case DKK
    case GTQ
    case GNF
    case GYD
    case HTG
    case HNL
    case HKD
    case HUF
    case ISK
    case INR
    case IDR
    case IRR
    case IQD
    case ILS
    case JMD
    case JPY
    case JOD
    case KZT
    case KES
    case KPW
    case KRW
    case KWD
    case KGS
    case LAK
    case LVL
    case LBP
    case LSL
    case LRD
    case LYD
    case LTL
    case MOP
    case MKD
    case MGA
    case MWK
    case MYR
    case MVR
    case MRO
    case MUR
    case MXN
    case MXV
    case MDL
    case MNT
    case MZN
    case MMK
    case NAD
    case NPR
    case NIO
    case NGN
    case OMR
    case PKR
    case PAB
    case PGK
    case PYG
    case PEN
    case PHP
    case PLN
    case QAR
    case RON
    case RUB
    case RWF
    case SHP
    case XCD
    case WST
    case STD
    case SAR
    case RSD
    case SCR
    case SLL
    case SGD
    case ANG
    case SBD
    case SOS
    case ZAR
    case SSP
    case LKR
    case SDG
    case SRD
    case NOK
    case SZL
    case SEK
    case CHE
    case CHF
    case CHW
    case SYP
    case TWD
    case TJS
    case TZS
    case THB
    case XOF
    case NZD
    case TOP
    case TTD
    case TND
    case TRY
    case TMT
    case AUD
    case UGX
    case UAH
    case AED
    case GBP
    case USN
    case USS
    case UYI
    case UYU
    case UZS
    case VUV
    case VEF
    case VND
    case XPF
    case MAD
    case YER
    case ZMK
    case ZWL

    var name: String {
        switch self {
        case .EUR:
            return "Euro"
        case .USD:
            return "US Dollar"
        case .AFN:
            return "Afghani"
        case .ALL:
            return "Lek"
        case .DZD:
            return "Algerian Dinar"
        case .AOA:
            return "Kwanza"
        case .ARS:
            return "Argentine Peso"
        case .AMD:
            return "Armenian Dram"
        case .AWG:
            return "Aruban Florin"
        case .AZN:
            return "Azerbaijanian Manat"
        case .BSD:
            return "Bahamian Dollar"
        case .BHD:
            return "Bahraini Dinar"
        case .BDT:
            return "Taka"
        case .BBD:
            return "Barbados Dollar"
        case .BYR:
            return "Belarussian Ruble"
        case .BZD:
            return "Belize Dollar"
        case .BMD:
            return "Bermudian Dollar"
        case .BTN:
            return "Ngultrum"
        case .BOB:
            return "Boliviano"
        case .BOV:
            return "Mvdol"
        case .BAM:
            return "Convertible Mark"
        case .BWP:
            return "Pula"
        case .BRL:
            return "Brazilian Real"
        case .BND:
            return "Brunei Dollar"
        case .BGN:
            return "Bulgarian Lev"
        case .BIF:
            return "Burundi Franc"
        case .KHR:
            return "Riel"
        case .CAD:
            return "Canadian Dollar"
        case .CVE:
            return "Cape Verde Escudo"
        case .KYD:
            return "Cayman Islands Dollar"
        case .CLF:
            return "Unidades de fomento"
        case .CLP:
            return "Chilean Peso"
        case .CNY:
            return "Yuan Renminbi"
        case .COP:
            return "Colombian Peso"
        case .COU:
            return "Unidad de Valor Real"
        case .KMF:
            return "Comoro Franc"
        case .CDF:
            return "Congolese Franc"
        case .CRC:
            return "Costa Rican Colon"
        case .HRK:
            return "Croatian Kuna"
        case .CUC:
            return "Peso Convertible"
        case .CUP:
            return "Cuban Peso"
        case .CZK:
            return "Czech Koruna"
        case .DJF:
            return "Djibouti Franc"
        case .DOP:
            return "Dominican Peso"
        case .EGP:
            return "Egyptian Pound"
        case .SVC:
            return "El Salvador Colon"
        case .ERN:
            return "Nakfa"
        case .ETB:
            return "Ethiopian Birr"
        case .FKP:
            return "Falkland Islands Pound"
        case .FJD:
            return "Fiji Dollar"
        case .XAF:
            return "CFA Franc BEAC"
        case .GMD:
            return "Dalasi"
        case .GEL:
            return "Lari"
        case .GHS:
            return "Ghana Cedi"
        case .GIP:
            return "Gibraltar Pound"
        case .DKK:
            return "Danish Krone"
        case .GTQ:
            return "Quetzal"
        case .GNF:
            return "Guinea Franc"
        case .GYD:
            return "Guyana Dollar"
        case .HTG:
            return "Gourde"
        case .HNL:
            return "Lempira"
        case .HKD:
            return "Hong Kong Dollar"
        case .HUF:
            return "Forint"
        case .ISK:
            return "Iceland Krona"
        case .INR:
            return "Indian Rupee"
        case .IDR:
            return "Rupiah"
        case .IRR:
            return "Iranian Rial"
        case .IQD:
            return "Iraqi Dinar"
        case .ILS:
            return "New Israeli Sheqel"
        case .JMD:
            return "Jamaican Dollar"
        case .JPY:
            return "Yen"
        case .JOD:
            return "Jordanian Dinar"
        case .KZT:
            return "Tenge"
        case .KES:
            return "Kenyan Shilling"
        case .KPW:
            return "North Korean Won"
        case .KRW:
            return "Won"
        case .KWD:
            return "Kuwaiti Dinar"
        case .KGS:
            return "Som"
        case .LAK:
            return "Kip"
        case .LVL:
            return "Latvian Lats"
        case .LBP:
            return "Lebanese Pound"
        case .LSL:
            return "Loti"
        case .LRD:
            return "Liberian Dollar"
        case .LYD:
            return "Libyan Dinar"
        case .LTL:
            return "Lithuanian Litas"
        case .MOP:
            return "Pataca"
        case .MKD:
            return "Denar"
        case .MGA:
            return "Malagasy Ariary"
        case .MWK:
            return "Kwacha"
        case .MYR:
            return "Malaysian Ringgit"
        case .MVR:
            return "Rufiyaa"
        case .MRO:
            return "Ouguiya"
        case .MUR:
            return "Mauritius Rupee"
        case .MXN:
            return "Mexican Peso"
        case .MXV:
            return "Mexican Unidad de Inversion (UDI)"
        case .MDL:
            return "Moldovan Leu"
        case .MNT:
            return "Tugrik"
        case .MZN:
            return "Mozambique Metical"
        case .MMK:
            return "Kyat"
        case .NAD:
            return "Namibia Dollar"
        case .NPR:
            return "Nepalese Rupee"
        case .NIO:
            return "Cordoba Oro"
        case .NGN:
            return "Naira"
        case .OMR:
            return "Rial Omani"
        case .PKR:
            return "Pakistan Rupee"
        case .PAB:
            return "Balboa"
        case .PGK:
            return "Kina"
        case .PYG:
            return "Guarani"
        case .PEN:
            return "Nuevo Sol"
        case .PHP:
            return "Philippine Peso"
        case .PLN:
            return "Złoty"
        case .QAR:
            return "Qatari Rial"
        case .RON:
            return "New Romanian Leu"
        case .RUB:
            return "Russian Ruble"
        case .RWF:
            return "Rwanda Franc"
        case .SHP:
            return "Saint Helena Pound"
        case .XCD:
            return "East Caribbean Dollar"
        case .WST:
            return "Tala"
        case .STD:
            return "Dobra"
        case .SAR:
            return "Saudi Riyal"
        case .RSD:
            return "Serbian Dinar"
        case .SCR:
            return "Seychelles Rupee"
        case .SLL:
            return "Leone"
        case .SGD:
            return "Singapore Dollar"
        case .ANG:
            return "Netherlands Antillean Guilder"
        case .SBD:
            return "Solomon Islands Dollar"
        case .SOS:
            return "Somali Shilling"
        case .ZAR:
            return "Rand"
        case .SSP:
            return "South Sudanese Pound"
        case .LKR:
            return "Sri Lanka Rupee"
        case .SDG:
            return "Sudanese Pound"
        case .SRD:
            return "Surinam Dollar"
        case .NOK:
            return "Norwegian Krone"
        case .SZL:
            return "Lilangeni"
        case .SEK:
            return "Swedish Krona"
        case .CHE:
            return "WIR Euro"
        case .CHF:
            return "Swiss Franc"
        case .CHW:
            return "WIR Franc"
        case .SYP:
            return "Syrian Pound"
        case .TWD:
            return "New Taiwan Dollar"
        case .TJS:
            return "Somoni"
        case .TZS:
            return "Tanzanian Shilling"
        case .THB:
            return "Baht"
        case .XOF:
            return "CFA Franc BCEAO"
        case .NZD:
            return "New Zealand Dollar"
        case .TOP:
            return "Pa’anga"
        case .TTD:
            return "Trinidad and Tobago Dollar"
        case .TND:
            return "Tunisian Dinar"
        case .TRY:
            return "Turkish Lira"
        case .TMT:
            return "Turkmenistan New Manat"
        case .AUD:
            return "Australian Dollar"
        case .UGX:
            return "Uganda Shilling"
        case .UAH:
            return "Hryvnia"
        case .AED:
            return "UAE Dirham"
        case .GBP:
            return "Pound Sterling"
        case .USN:
            return "US Dollar (Next day)"
        case .USS:
            return "US Dollar (Same day)"
        case .UYI:
            return "Uruguay Peso en Unidades Indexadas (URUIURUI)"
        case .UYU:
            return "Peso Uruguayo"
        case .UZS:
            return "Uzbekistan Sum"
        case .VUV:
            return "Vatu"
        case .VEF:
            return "Bolivar Fuerte"
        case .VND:
            return "Dong"
        case .XPF:
            return "CFP Franc"
        case .MAD:
            return "Moroccan Dirham"
        case .YER:
            return "Yemeni Rial"
        case .ZMK:
            return "Zambian Kwacha"
        case .ZWL:
            return "Zimbabwe Dollar"
        }
    }

    var minorUnits: Int {
        switch self {
        case .EUR:
            return 2
        case .USD:
            return 2
        case .AFN:
            return 2
        case .ALL:
            return 2
        case .DZD:
            return 2
        case .AOA:
            return 2
        case .ARS:
            return 2
        case .AMD:
            return 2
        case .AWG:
            return 2
        case .AZN:
            return 2
        case .BSD:
            return 2
        case .BHD:
            return 3
        case .BDT:
            return 2
        case .BBD:
            return 2
        case .BYR:
            return 0
        case .BZD:
            return 2
        case .BMD:
            return 2
        case .BTN:
            return 2
        case .BOB:
            return 2
        case .BOV:
            return 2
        case .BAM:
            return 2
        case .BWP:
            return 2
        case .BRL:
            return 2
        case .BND:
            return 2
        case .BGN:
            return 2
        case .BIF:
            return 0
        case .KHR:
            return 2
        case .CAD:
            return 2
        case .CVE:
            return 2
        case .KYD:
            return 2
        case .CLF:
            return 0
        case .CLP:
            return 0
        case .CNY:
            return 2
        case .COP:
            return 2
        case .COU:
            return 2
        case .KMF:
            return 0
        case .CDF:
            return 2
        case .CRC:
            return 2
        case .HRK:
            return 2
        case .CUC:
            return 2
        case .CUP:
            return 2
        case .CZK:
            return 2
        case .DJF:
            return 0
        case .DOP:
            return 2
        case .EGP:
            return 2
        case .SVC:
            return 2
        case .ERN:
            return 2
        case .ETB:
            return 2
        case .FKP:
            return 2
        case .FJD:
            return 2
        case .XAF:
            return 0
        case .GMD:
            return 2
        case .GEL:
            return 2
        case .GHS:
            return 2
        case .GIP:
            return 2
        case .DKK:
            return 2
        case .GTQ:
            return 2
        case .GNF:
            return 0
        case .GYD:
            return 2
        case .HTG:
            return 2
        case .HNL:
            return 2
        case .HKD:
            return 2
        case .HUF:
            return 2
        case .ISK:
            return 0
        case .INR:
            return 2
        case .IDR:
            return 2
        case .IRR:
            return 2
        case .IQD:
            return 3
        case .ILS:
            return 2
        case .JMD:
            return 2
        case .JPY:
            return 0
        case .JOD:
            return 3
        case .KZT:
            return 2
        case .KES:
            return 2
        case .KPW:
            return 2
        case .KRW:
            return 0
        case .KWD:
            return 3
        case .KGS:
            return 2
        case .LAK:
            return 2
        case .LVL:
            return 2
        case .LBP:
            return 2
        case .LSL:
            return 2
        case .LRD:
            return 2
        case .LYD:
            return 3
        case .LTL:
            return 2
        case .MOP:
            return 2
        case .MKD:
            return 2
        case .MGA:
            return 2
        case .MWK:
            return 2
        case .MYR:
            return 2
        case .MVR:
            return 2
        case .MRO:
            return 2
        case .MUR:
            return 2
        case .MXN:
            return 2
        case .MXV:
            return 2
        case .MDL:
            return 2
        case .MNT:
            return 2
        case .MZN:
            return 2
        case .MMK:
            return 2
        case .NAD:
            return 2
        case .NPR:
            return 2
        case .NIO:
            return 2
        case .NGN:
            return 2
        case .OMR:
            return 3
        case .PKR:
            return 2
        case .PAB:
            return 2
        case .PGK:
            return 2
        case .PYG:
            return 0
        case .PEN:
            return 2
        case .PHP:
            return 2
        case .PLN:
            return 2
        case .QAR:
            return 2
        case .RON:
            return 2
        case .RUB:
            return 2
        case .RWF:
            return 0
        case .SHP:
            return 2
        case .XCD:
            return 2
        case .WST:
            return 2
        case .STD:
            return 2
        case .SAR:
            return 2
        case .RSD:
            return 2
        case .SCR:
            return 2
        case .SLL:
            return 2
        case .SGD:
            return 2
        case .ANG:
            return 2
        case .SBD:
            return 2
        case .SOS:
            return 2
        case .ZAR:
            return 2
        case .SSP:
            return 2
        case .LKR:
            return 2
        case .SDG:
            return 2
        case .SRD:
            return 2
        case .NOK:
            return 2
        case .SZL:
            return 2
        case .SEK:
            return 2
        case .CHE:
            return 2
        case .CHF:
            return 2
        case .CHW:
            return 2
        case .SYP:
            return 2
        case .TWD:
            return 2
        case .TJS:
            return 2
        case .TZS:
            return 2
        case .THB:
            return 2
        case .XOF:
            return 0
        case .NZD:
            return 2
        case .TOP:
            return 2
        case .TTD:
            return 2
        case .TND:
            return 3
        case .TRY:
            return 2
        case .TMT:
            return 2
        case .AUD:
            return 2
        case .UGX:
            return 2
        case .UAH:
            return 2
        case .AED:
            return 2
        case .GBP:
            return 2
        case .USN:
            return 2
        case .USS:
            return 2
        case .UYI:
            return 0
        case .UYU:
            return 2
        case .UZS:
            return 2
        case .VUV:
            return 0
        case .VEF:
            return 2
        case .VND:
            return 0
        case .XPF:
            return 0
        case .MAD:
            return 2
        case .YER:
            return 2
        case .ZMK:
            return 2
        case .ZWL:
            return 2
        }
    }

    var minorUnitsFactor: Int {
        switch minorUnits {
        case 0:
            return 1
        case 2:
            return 100
        case 3:
            return 1000
        default:
            return 1
        }
    }

    var symbol: String {
        switch self {
        case .EUR:
            return "€"
        case .USD:
            return "$"
        case .AFN:
            return "؋"
        case .ALL:
            return "L"
        case .DZD:
            return "د.ج.‏"
        case .AOA:
            return "Kz"
        case .ARS:
            return "$"
        case .AMD:
            return "դր."
        case .AWG:
            return "ƒ"
        case .AZN:
            return "₼"
        case .BSD:
            return "$"
        case .BHD:
            return "د.ب.‏"
        case .BDT:
            return "৳"
        case .BBD:
            return "$"
        case .BYR:
            return "р."
        case .BZD:
            return "BZ$"
        case .BMD:
            return "$"
        case .BTN:
            return "Nu."
        case .BOB:
            return "Bs."
        case .BOV:
            return "BOV"
        case .BAM:
            return "КМ"
        case .BWP:
            return "P"
        case .BRL:
            return "R$"
        case .BND:
            return "$"
        case .BGN:
            return "лв."
        case .BIF:
            return "FBu"
        case .KHR:
            return "៛"
        case .CAD:
            return "$"
        case .CVE:
            return "$"
        case .KYD:
            return "$"
        case .CLF:
            return "UF"
        case .CLP:
            return "$"
        case .CNY:
            return "¥"
        case .COP:
            return "$"
        case .KMF:
            return "CF"
        case .CDF:
            return "FC"
        case .CRC:
            return "₡"
        case .HRK:
            return "kn"
        case .CUP:
            return "$MN"
        case .CZK:
            return "Kč"
        case .DJF:
            return "Fdj"
        case .DOP:
            return "RD$"
        case .EGP:
            return "ج.م.‏"
        case .SVC:
            return "₡"
        case .ERN:
            return "Nfk"
        case .ETB:
            return "Br"
        case .FKP:
            return "£"
        case .FJD:
            return "$"
        case .XAF:
            return "F"
        case .GMD:
            return "D"
        case .GEL:
            return "Lari"
        case .GHS:
            return "₵"
        case .GIP:
            return "£"
        case .DKK:
            return "kr."
        case .GTQ:
            return "Q"
        case .GNF:
            return "FG"
        case .GYD:
            return "$"
        case .HTG:
            return "G"
        case .HNL:
            return "L."
        case .HKD:
            return "HK$"
        case .HUF:
            return "Ft"
        case .ISK:
            return "kr."
        case .INR:
            return "₹"
        case .IDR:
            return "Rp"
        case .IRR:
            return "﷼"
        case .IQD:
            return "د.ع.‏"
        case .ILS:
            return "₪"
        case .JMD:
            return "J$"
        case .JPY:
            return "¥"
        case .JOD:
            return "د.ا.‏"
        case .KZT:
            return "₸"
        case .KES:
            return "S"
        case .KPW:
            return "₩"
        case .KRW:
            return "₩"
        case .KWD:
            return "د.ك.‏"
        case .KGS:
            return "сом"
        case .LAK:
            return "₭"
        case .LVL:
            return "LVL"
        case .LBP:
            return "ل.ل.‏"
        case .LSL:
            return "M"
        case .LRD:
            return "$"
        case .LYD:
            return "د.ل.‏"
        case .LTL:
            return "LTL"
        case .MOP:
            return "MOP$"
        case .MKD:
            return "ден."
        case .MGA:
            return "Ar"
        case .MWK:
            return "MK"
        case .MYR:
            return "RM"
        case .MVR:
            return "MV"
        case .MRO:
            return "UM"
        case .MUR:
            return "₨"
        case .MXN:
            return "$"
        case .MDL:
            return "lei"
        case .MNT:
            return "₮"
        case .MZN:
            return "MT"
        case .MMK:
            return "K"
        case .NAD:
            return "$"
        case .NPR:
            return "₨"
        case .NIO:
            return "C$"
        case .NGN:
            return "₦"
        case .OMR:
            return "﷼"
        case .PKR:
            return "₨"
        case .PAB:
            return "B/."
        case .PGK:
            return "K"
        case .PYG:
            return "₲"
        case .PEN:
            return "S/."
        case .PHP:
            return "₱"
        case .PLN:
            return "zł"
        case .QAR:
            return "﷼"
        case .RON:
            return "lei"
        case .RUB:
            return "₽"
        case .RWF:
            return "RWF"
        case .SHP:
            return "£"
        case .XCD:
            return "$"
        case .WST:
            return "WS$"
        case .STD:
            return "Db"
        case .SAR:
            return "﷼"
        case .RSD:
            return "Дин."
        case .SCR:
            return "₨"
        case .SLL:
            return "Le"
        case .SGD:
            return "$"
        case .ANG:
            return "ƒ"
        case .SBD:
            return "$"
        case .SOS:
            return "S"
        case .ZAR:
            return "R"
        case .LKR:
            return "₨"
        case .SDG:
            return "£‏"
        case .SRD:
            return "$"
        case .NOK:
            return "kr"
        case .SZL:
            return "E"
        case .SEK:
            return "kr"
        case .CHF:
            return "CHF"
        case .SYP:
            return "£"
        case .TWD:
            return "NT$"
        case .TJS:
            return "TJS"
        case .TZS:
            return "TSh"
        case .THB:
            return "฿"
        case .XOF:
            return "F"
        case .NZD:
            return "$"
        case .TOP:
            return "T$"
        case .TTD:
            return "TT$"
        case .TND:
            return "د.ت.‏"
        case .TRY:
            return "TL"
        case .TMT:
            return "m"
        case .AUD:
            return "$"
        case .UGX:
            return "USh"
        case .UAH:
            return "₴"
        case .AED:
            return "د.إ.‏"
        case .GBP:
            return "£"
        case .UYU:
            return "$U"
        case .UZS:
            return "сўм"
        case .VUV:
            return "VT"
        case .VEF:
            return "Bs. F."
        case .VND:
            return "₫"
        case .XPF:
            return "F"
        case .MAD:
            return "د.م.‏"
        case .YER:
            return "﷼"
        default:
            return ""
        }
    }
}
