//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

enum Status: String, Codable, CaseIterable {
    case cloudy = "CLOUDY"
    case sunny = "SUNNY"
    case mostlySunny = "MOSTLY_SUNNY"
    case partlySunnyRain = "PARTLY_SUNNY_RAIN"
    case thunderCloudAndRain = "THUNDER_CLOUD_AND_RAIN"
    case tornado = "TORNADO"
    case barelySunny = "BARELY_SUNNY"
    case lightening = "LIGHTENING"
    case snowCloud = "SNOW_CLOUD"
    case rainy = "RAINY"
    
    static func allStatuses() -> [Status] {
        return [
            .cloudy,
            .sunny,
            .mostlySunny,
            .partlySunnyRain,
            .thunderCloudAndRain,
            .tornado,
            .barelySunny,
            .lightening,
            .snowCloud,
            .rainy
        ]
    }
}

struct WeatherLocation: Decodable {
    let id: String
    let name: String
    let status: Status
    let temperature: Int
}

extension Status {
    
    var weatherIconImageName: String {
        switch self {
        case .cloudy: return "icon-cloudy"
        case .sunny: return "icon-sunny"
        case .mostlySunny: return "icon-mostly-sunny"
        case .partlySunnyRain: return "icon-partly-sunny-rain"
        case .thunderCloudAndRain: return "icon-thunder-cloud-rain"
        case .tornado: return "icon-tornado"
        case .barelySunny: return "icon-barely-sunny"
        case .lightening: return "icon-lightening"
        case .snowCloud: return "icon-snow"
        case .rainy: return "icon-rain"
        }
    }
    
    var weatherDescription: String {
        switch self {
        case .cloudy: return "CLOUDY"
        case .sunny: return "SUNNY"
        case .mostlySunny: return "MOSTLY SUNNY"
        case .partlySunnyRain: return "PARTLY SUNNY WITH RAIN"
        case .thunderCloudAndRain: return "CLOUDY WITH THUNDERSTORMS"
        case .tornado: return "WINDY"
        case .barelySunny: return "BARELY SUNNY"
        case .lightening: return "THUNDERS"
        case .snowCloud: return "SNOW"
        case .rainy: return "RAIN"
        }
    }
}
