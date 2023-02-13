import SwiftUI

enum WeatherCondition {
    enum Variant: String {
        case day = "day"
        case night = "night"
        case polarTwilight = "polartwilight"
    }
    
    case clearSky(variant: Variant)
    case cloudy
    case fair(variant: Variant)
    case fog
    case heavyRain
    case heavyRainAndThunder
    case heavyRainShowers(variant: Variant)
    case heavyRainShowersAndThunder(variant: Variant)
    case heavySleet
    case heavySleetAndThunder
    case heavySleetShowers(variant: Variant)
    case heavySleetShowersAndThunder(variant: Variant)
    case heavySnow
    case heavySnowAndThunder
    case heavySnowShowers(variant: Variant)
    case heavySnowShowersAndThunder(variant: Variant)
    case lightRain
    case lightRainAndThunder
    case lightRainShowers(variant: Variant)
    case lightRainShowersAndThunder(variant: Variant)
    case lightSleet
    case lightSleetAndThunder
    case lightSleetShowers(variant: Variant)
    case lightSnow
    case lightSnowAndThunder
    case lightSnowShowers(variant: Variant)
    case lightSleetShowersAndThunder(variant: Variant)
    case lightSnowShowersAndThunder(variant: Variant)
    case partlyCloudy(variant: Variant)
    case rain
    case rainAndThunder
    case rainShowers(variant: Variant)
    case rainShowersAndThunder(variant: Variant)
    case sleet
    case sleetAndThunder
    case sleetShowers(variant: Variant)
    case sleetShowersAndThunder(variant: Variant)
    case snow
    case snowAndThunder
    case snowShowers(variant: Variant)
    case snowShowersAndThunder
    
    init?(rawValue: String) {
        var variant: Variant? = nil
        if let variantString = rawValue.components(separatedBy: "_").last {
            variant = Variant(rawValue: variantString)
        }
        
        if rawValue.starts(with: "clearsky") {
            guard let variant = variant else { return nil }
            self = .clearSky(variant: variant)
        } else if rawValue.starts(with: "cloudy") {
            self = .cloudy
        } else if rawValue.starts(with: "fair") {
            guard let variant = variant else { return nil }
            self = .fair(variant: variant)
        } else if rawValue.starts(with: "fog") {
            self = .fog
        } else if rawValue.starts(with: "heavyrain") {
            self = .heavyRain
        } else if rawValue.starts(with: "heavyrainandthunder") {
            self = .heavyRainAndThunder
        } else if rawValue.starts(with: "heavyrainshowers") {
            guard let variant = variant else { return nil }
            self = .heavyRainShowers(variant: variant)
        } else if rawValue.starts(with: "heavyrainshowersandthunder") {
            guard let variant = variant else { return nil }
            self = .heavyRainShowersAndThunder(variant: variant)
        } else if rawValue.starts(with: "heavysleet") {
            self = .heavySleet
        } else if rawValue.starts(with: "heavysleetandthunder") {
            self = .heavySleetAndThunder
        } else if rawValue.starts(with: "heavysleetshowers") {
            guard let variant = variant else { return nil }
            self = .heavySleetShowers(variant: variant)
        } else if rawValue.starts(with: "heavysleetshowersandthunder") {
            guard let variant = variant else { return nil }
            self = .heavySleetShowersAndThunder(variant: variant)
        } else if rawValue.starts(with: "heavysnow") {
            self = .heavySnow
        } else if rawValue.starts(with: "heavysnowandthunder") {
            self = .heavySnowAndThunder
        } else if rawValue.starts(with: "heavysnowshowers") {
            guard let variant = variant else { return nil }
            self = .heavySnowShowers(variant: variant)
        } else if rawValue.starts(with: "heavysnowshowersandthunder") {
            guard let variant = variant else { return nil }
            self = .heavySnowShowersAndThunder(variant: variant)
        } else if rawValue.starts(with: "lightrain") {
            self = .lightRain
        } else if rawValue.starts(with: "lightrainandthunder") {
            self = .lightRainAndThunder
        } else if rawValue.starts(with: "lightrainshowers") {
            guard let variant = variant else { return nil }
            self = .lightRainShowers(variant: variant)
        } else if rawValue.starts(with: "lightrainshowersandthunder") {
            guard let variant = variant else { return nil }
            self = .lightRainShowersAndThunder(variant: variant)
        } else if rawValue.starts(with: "lightsleet") {
            self = .lightSleet
        } else if rawValue.starts(with: "lightsleetandthunder") {
            self = .lightSleetAndThunder
        } else if rawValue.starts(with: "lightsleetshowers") {
            guard let variant = variant else { return nil }
            self = .lightSleetShowers(variant: variant)
        } else if rawValue.starts(with: "lightsnow") {
            self = .lightSnow
        } else if rawValue.starts(with: "lightsnowandthunder") {
            self = .lightSnowAndThunder
        } else if rawValue.starts(with: "lightsnowshowers") {
            guard let variant = variant else { return nil }
            self = .lightSnowShowers(variant: variant)
        } else if rawValue.starts(with: "lightssleetshowersandthunder") {
            guard let variant = variant else { return nil }
            self = .lightSleetShowersAndThunder(variant: variant)
        } else if rawValue.starts(with: "lightssnowshowersandthunder") {
            guard let variant = variant else { return nil }
            self = .lightSnowShowersAndThunder(variant: variant)
        } else if rawValue.starts(with: "partlycloudy") {
            guard let variant = variant else { return nil }
            self = .partlyCloudy(variant: variant)
        } else if rawValue.starts(with: "rain") {
            self = .rain
        } else if rawValue.starts(with: "rainandthunder") {
            self = .rainAndThunder
        } else if rawValue.starts(with: "rainshowers") {
            guard let variant = variant else { return nil }
            self = .rainShowers(variant: variant)
        } else if rawValue.starts(with: "rainshowersandthunder") {
            guard let variant = variant else { return nil }
            self = .rainShowersAndThunder(variant: variant)
        } else if rawValue.starts(with: "sleet") {
            self = .sleet
        } else if rawValue.starts(with: "sleetandthunder") {
            self = .sleetAndThunder
        } else if rawValue.starts(with: "sleetshowers") {
            guard let variant = variant else { return nil }
            self = .sleetShowers(variant: variant)
        } else if rawValue.starts(with: "sleetshowersandthunder") {
            guard let variant = variant else { return nil }
            self = .sleetShowersAndThunder(variant: variant)
        } else if rawValue.starts(with: "snow") {
            self = .snow
        } else if rawValue.starts(with: "snowandthunder") {
            self = .snowAndThunder
        } else if rawValue.starts(with: "snowshowers") {
            guard let variant = variant else { return nil }
            self = .snowShowers(variant: variant)
        } else if rawValue.starts(with: "snowshowersandthunder") {
            self = .snowShowersAndThunder
        } else {
            return nil
        }
    }
    
    var presentDescription: String {
        switch self {
            case .clearSky(_): return  "Le temps est ensoleillé"
            case .cloudy: return  "Le temps est couvert"
            case .fair(_): return  "Il fait beau"
            case .fog: return  "Il y a du brouillard"
            case .heavyRain: return  "Il pleut abondamment"
            case .heavyRainAndThunder: return  "Il pleut abondamment avec de l'orage"
            case .heavyRainShowers(_): return  "De fortes averses sont à prévoir"
            case .heavyRainShowersAndThunder(_): return  "De fortes averses orageuses sont à prévoir"
            case .heavySleet: return "Il tombe beaucoup de neige fondue"
            case .heavySleetAndThunder: return "Il tombe beaucoup de neige fondue avec des orages"
            case .heavySleetShowers(_): return "De fortes averses de neige fondue sont à prévoir"
            case .heavySleetShowersAndThunder(_): return "De fortes averses orageuses de neige fondue sont à prévoir"
            case .heavySnow: return  "Il neige abondamment"
            case .heavySnowAndThunder: return  "Il neige abondamment"
            case .heavySnowShowers(_): return  "Fortes averses de neige à prévoir"
            case .heavySnowShowersAndThunder(_): return  "Fortes averses orageuses de neige à prévoir"
            case .lightRain: return  "Il pleut légèrement"
            case .lightRainAndThunder: return  "Il pleut légèrement avec un risque d'orages"
            case .lightRainShowers(_): return  "De légères averses sont à prévoir"
            case .lightRainShowersAndThunder(_): return  "De légères averses orageuses sont à prévoir"
            case .lightSleet: return "Il tombe un peu de neige fondue"
            case .lightSleetAndThunder: return "Il tombe un peu de neige fondue avec des orages"
            case .lightSleetShowers(_): return "De légères averses de neige fondue sont à prévoir"
            case .lightSnow: return  "Il tombe quelques flocons"
            case .lightSnowAndThunder: return "Il tombe quelques flocons avec un risque d'orage"
            case .lightSnowShowers(_): return "Il peut tomber quelques flocons"
            case .lightSleetShowersAndThunder(_): return "Il peut y avoir de légères averses de neige fondue et de l'orage"
            case .lightSnowShowersAndThunder(_): return "Il peut tomber quelques flocons avec de l'orage"
            case .partlyCloudy(_): return "Belles éclaircies"
            case .rain: return "Il pleut"
            case .rainAndThunder: return "Pluie orageuse au programme"
            case .rainShowers(_): return "Des averses sont à prévoir"
            case .rainShowersAndThunder(_): return "Des averses orageuses sont à prévoir"
            case .sleet: return "Il tombe de la neige fondue"
            case .sleetAndThunder: return "Il tombe de la neige fondue avec un risque d'orage"
            case .sleetShowers(_): return "Des averses de neige fondue sont à prévoir"
            case .sleetShowersAndThunder(_): return "Des averses de neige fondue sont à prévoir avec un risque d'orage"
            case .snow: return "Il neige"
            case .snowAndThunder: return "Neige et orage au programme"
            case .snowShowers(_): return "Averses de neige à prévoir"
            case .snowShowersAndThunder: return "Averses de neige à prévoir avec un risque d'orage"
        }
    }
    
    var futureDescription: String {
        switch self {
            case .clearSky(_): return  "le temps sera ensoleillé"
            case .cloudy: return  "le temps sera couvert"
            case .fair(_): return  "il fera beau"
            case .fog: return  "il y aura du brouillard"
            case .heavyRain: return  "il pleuvra abondamment"
            case .heavyRainAndThunder: return  "orage et forte pluie"
            case .heavyRainShowers(_): return  "il y aura de fortes averses"
            case .heavyRainShowersAndThunder(_): return  "il y aura de fortes averses orageuses"
            case .heavySleet: return "il tombera beaucoup de neige fondue"
            case .heavySleetAndThunder: return "il tombera beaucoup de neige fondue avec des orages"
            case .heavySleetShowers(_): return "il y aura de fortes averses de neige fondue"
            case .heavySleetShowersAndThunder(_): return "il y aura de fortes averses orageuses de neige fondue"
            case .heavySnow: return  "il neigera abondamment"
            case .heavySnowAndThunder: return  "il neigera abondamment"
            case .heavySnowShowers(_): return  "il y aura de fortes averses de neige"
            case .heavySnowShowersAndThunder(_): return  "il y aura de fortes averses orageuses de neige"
            case .lightRain: return  "il pleuvra légèrement"
            case .lightRainAndThunder: return  "il pleuvra légèrement"
            case .lightRainShowers(_): return  "il y aura de légères averses"
            case .lightRainShowersAndThunder(_): return  "il y aura de légères averses orageuses"
            case .lightSleet: return "il tombera un peu de neige fondue"
            case .lightSleetAndThunder: return "il tombera un peu de neige fondue avec des orages"
            case .lightSleetShowers(_): return "il y aura de légères averses de neige fondue"
            case .lightSnow: return  "il tombera quelques flocons"
            case .lightSnowAndThunder: return "il tombera quelques flocons avec de l'orage"
            case .lightSnowShowers(_): return "il tombera occasionellement quelques flocons"
            case .lightSleetShowersAndThunder(_): return "il y aura de légères averses de neige fondue et de l'orage"
            case .lightSnowShowersAndThunder(_): return "il tombera occasionellement quelques flocons avec de l'orage"
            case .partlyCloudy(_): return "il y aura des éclaircies"
            case .rain: return "il va pleuvoir"
            case .rainAndThunder: return "pluie orageuse au programme"
            case .rainShowers(_): return "il y aura des averses"
            case .rainShowersAndThunder(_): return "averses orageuses au programme"
            case .sleet: return "il tombera de la neige fondue"
            case .sleetAndThunder: return "il tombera de la neige fondue avec de l'orage"
            case .sleetShowers(_): return "il y aura des averses de neige fondue"
            case .sleetShowersAndThunder(_): return "il y aura des averses orageuses de neige fondue"
            case .snow: return "il neigera"
            case .snowAndThunder: return "neige et orage au programme"
            case .snowShowers(_): return "il y aura des averses neigeuses"
            case .snowShowersAndThunder: return "il y aura des averses orageuses de neige"
        }
    }
    
    var icon: Image {
        switch self {
            case .clearSky(let variant): return Image("clearsky_\(variant.rawValue)")
            case .cloudy: return Image("cloudy")
            case .fair(let variant): return Image("fair_\(variant.rawValue)")
            case .fog: return Image("fog")
            case .heavyRain: return Image("heavyrain")
            case .heavyRainAndThunder: return Image("heavyrainandthunder")
            case .heavyRainShowers(let variant): return Image("heavyrainshowers_\(variant.rawValue)")
            case .heavyRainShowersAndThunder(let variant): return Image("heavyrainshowersandthunder_\(variant.rawValue)")
            case .heavySleet: return Image("heavysleet")
            case .heavySleetAndThunder: return Image("heavysleetandthunder")
            case .heavySleetShowers(let variant): return Image("heavysleetshowers_\(variant.rawValue)")
            case .heavySleetShowersAndThunder(let variant): return Image("heavysleetshowersandthunder_\(variant.rawValue)")
            case .heavySnow: return Image("heavysnow")
            case .heavySnowAndThunder: return Image("heavysnowandthunder")
            case .heavySnowShowers(let variant): return Image("heavysnowshowers_\(variant.rawValue)")
            case .heavySnowShowersAndThunder(let variant): return Image("heavysnowshowersandthunder_\(variant.rawValue)")
            case .lightRain: return Image("lightrain")
            case .lightRainAndThunder: return Image("lightrainandthunder")
            case .lightRainShowers(let variant): return Image("lightrainshowers_\(variant.rawValue)")
            case .lightRainShowersAndThunder(let variant): return Image("lightrainshowersandthunder_\(variant.rawValue)")
            case .lightSleet: return Image("lightsleet")
            case .lightSleetAndThunder: return Image("lightsleetandthunder")
            case .lightSleetShowers(let variant): return Image("lightsleetshowers_\(variant.rawValue)")
            case .lightSnow: return Image("lightsnow")
            case .lightSnowAndThunder: return Image("lightsnowandthunder")
            case .lightSnowShowers(let variant): return Image("lightsnowshowers_\(variant.rawValue)")
            case .lightSleetShowersAndThunder(let variant): return Image("lightssleetshowersandthunder_\(variant.rawValue)")
            case .lightSnowShowersAndThunder(let variant): return Image("lightssnowshowersandthunder_\(variant.rawValue)")
            case .partlyCloudy(let variant): return Image("partlycloudy_\(variant.rawValue)")
            case .rain: return Image("rain")
            case .rainAndThunder: return Image("rainandthunder")
            case .rainShowers(let variant): return Image("rainshowers_\(variant.rawValue)")
            case .rainShowersAndThunder(let variant): return Image("rainshowersandthunder_\(variant.rawValue)")
            case .sleet: return Image("sleet")
            case .sleetAndThunder: return Image("sleetandthunder")
            case .sleetShowers(let variant): return Image("sleetshowers_\(variant.rawValue)")
            case .sleetShowersAndThunder(let variant): return Image("sleetshowersandthunder_\(variant.rawValue)")
            case .snow: return Image("snow")
            case .snowAndThunder: return Image("snowandthunder")
            case .snowShowers(let variant): return Image("snowshowers_\(variant.rawValue)")
            case .snowShowersAndThunder: return Image("snowshowersandthunder")
        }
    }
}

