//
//  ResponseDataFake.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import Foundation

struct ResponseDataFake {
    static let responseOk = HTTPURLResponse(url: URL(string: "http://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    static let responseNok = HTTPURLResponse(url: URL(string: "http://openclassrooms.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
    
    class FakeError: Error {}
    static let error = FakeError()
    
    static let incorrectData = "erreur".data(using: .utf8)!
    
// MARK: - Currency
    
    static let currencyServiceDataError = """
    {
        "success": false,
        "error": {
            "code": 402,
            "type": "invalid_to_currency",
            "info": "You have entered an invalid to property. [Example: to=GBP]"
        }
    }
    """.data(using: .utf8)!
    
    static let currencyServiceAvailableCurrenciesData = """
    {
        "success": true,
        "symbols": {
            "BTC": "Bitcoin",
            "BTN": "Bhutanese Ngultrum",
            "BWP": "Botswanan Pula",
            "EUR": "Euro",
            "USD": "United States Dollar",
        }
    }
    """.data(using: .utf8)!
    
    static let currencyServiceConvertData = """
    {
        "success": true,
        "query": {
            "from": "EUR",
            "to": "USD",
            "amount": 1
        },
        "info": {
            "timestamp": 1666640584,
            "rate": 0.987523
        },
        "date": "2022-10-24",
        "result": 0.987523
    }
    """.data(using: .utf8)!
    
// MARK: - Translate
    
    static let translateServiceLanguagesData = """
    {
        "data": {
            "languages": [
                {
                    "language": "en",
                    "name": "English"
                },
                {
                    "language": "fr",
                    "name": "French"
                },
                {
                    "language": "ja",
                    "name": "Japanese"
                }
            ]
        }
    }
    """.data(using: .utf8)!
    
    static let translateServiceTranslationData = """
    {
        "data": {
            "translations": [
                {
                    "translatedText": "Good morning !"
                }
            ]
        }
    }
    """.data(using: .utf8)!
    
// MARK: - Weather
    static let weatherServiceData = """
    {
        "lat": 48.8566,
        "lon": 2.3522,
        "timezone": "Europe/Paris",
        "timezone_offset": 3600,
        "current": {
            "dt": 1667657011,
            "sunrise": 1667630610,
            "sunset": 1667665490,
            "temp": 11.94,
            "feels_like": 11.2,
            "pressure": 1019,
            "humidity": 77,
            "dew_point": 8.04,
            "uvi": 0.61,
            "clouds": 100,
            "visibility": 10000,
            "wind_speed": 4.63,
            "wind_deg": 240,
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ]
        },
        "daily": [
            {
                "dt": 1667646000,
                "sunrise": 1667630610,
                "sunset": 1667665490,
                "moonrise": 1667661960,
                "moonset": 1667616900,
                "moon_phase": 0.4,
                "temp": {
                    "day": 12.19,
                    "min": 8.19,
                    "max": 12.38,
                    "night": 10.84,
                    "eve": 12.24,
                    "morn": 9.1
                },
                "feels_like": {
                    "day": 11.19,
                    "night": 9.86,
                    "eve": 11.24,
                    "morn": 7.96
                },
                "pressure": 1020,
                "humidity": 66,
                "dew_point": 6.03,
                "wind_speed": 4.38,
                "wind_deg": 190,
                "wind_gust": 11.27,
                "weather": [
                    {
                        "id": 501,
                        "main": "Rain",
                        "description": "moderate rain",
                        "icon": "10d"
                    }
                ],
                "clouds": 100,
                "pop": 0.2,
                "rain": 1.78,
                "uvi": 1.1
            },
            {
                "dt": 1667732400,
                "sunrise": 1667717106,
                "sunset": 1667751799,
                "moonrise": 1667749320,
                "moonset": 1667707860,
                "moon_phase": 0.43,
                "temp": {
                    "day": 10.25,
                    "min": 9.35,
                    "max": 13.14,
                    "night": 11.59,
                    "eve": 12.87,
                    "morn": 9.35
                },
                "feels_like": {
                    "day": 9.21,
                    "night": 11.05,
                    "eve": 12.33,
                    "morn": 7.16
                },
                "pressure": 1011,
                "humidity": 72,
                "dew_point": 5.23,
                "wind_speed": 6.1,
                "wind_deg": 225,
                "wind_gust": 14.04,
                "weather": [
                    {
                        "id": 501,
                        "main": "Rain",
                        "description": "moderate rain",
                        "icon": "10d"
                    }
                ],
                "clouds": 100,
                "pop": 1,
                "rain": 4.68,
                "uvi": 0.67
            },
            {
                "dt": 1667818800,
                "sunrise": 1667803602,
                "sunset": 1667838110,
                "moonrise": 1667836740,
                "moonset": 1667798760,
                "moon_phase": 0.47,
                "temp": {
                    "day": 14.19,
                    "min": 11.47,
                    "max": 15.73,
                    "night": 12.71,
                    "eve": 14.46,
                    "morn": 11.78
                },
                "feels_like": {
                    "day": 13.62,
                    "night": 12.07,
                    "eve": 13.82,
                    "morn": 11.26
                },
                "pressure": 1015,
                "humidity": 75,
                "dew_point": 9.73,
                "wind_speed": 6.53,
                "wind_deg": 210,
                "wind_gust": 13.86,
                "weather": [
                    {
                        "id": 804,
                        "main": "Clouds",
                        "description": "overcast clouds",
                        "icon": "04d"
                    }
                ],
                "clouds": 98,
                "pop": 0.35,
                "uvi": 1.15
            },
            {
                "dt": 1667905200,
                "sunrise": 1667890098,
                "sunset": 1667924423,
                "moonrise": 1667924280,
                "moonset": 1667889720,
                "moon_phase": 0.5,
                "temp": {
                    "day": 14.69,
                    "min": 12.48,
                    "max": 15.23,
                    "night": 13.02,
                    "eve": 14.59,
                    "morn": 12.65
                },
                "feels_like": {
                    "day": 13.94,
                    "night": 12.47,
                    "eve": 13.96,
                    "morn": 11.51
                },
                "pressure": 1009,
                "humidity": 66,
                "dew_point": 8.24,
                "wind_speed": 6.55,
                "wind_deg": 211,
                "wind_gust": 16.56,
                "weather": [
                    {
                        "id": 804,
                        "main": "Clouds",
                        "description": "overcast clouds",
                        "icon": "04d"
                    }
                ],
                "clouds": 100,
                "pop": 0.25,
                "uvi": 0.46
            },
            {
                "dt": 1667991600,
                "sunrise": 1667976595,
                "sunset": 1668010738,
                "moonrise": 1668012120,
                "moonset": 1667980560,
                "moon_phase": 0.53,
                "temp": {
                    "day": 14.85,
                    "min": 11.46,
                    "max": 15.55,
                    "night": 11.46,
                    "eve": 13.63,
                    "morn": 12.95
                },
                "feels_like": {
                    "day": 14.09,
                    "night": 10.72,
                    "eve": 12.85,
                    "morn": 12.39
                },
                "pressure": 1015,
                "humidity": 65,
                "dew_point": 8.23,
                "wind_speed": 5.02,
                "wind_deg": 207,
                "wind_gust": 12,
                "weather": [
                    {
                        "id": 501,
                        "main": "Rain",
                        "description": "moderate rain",
                        "icon": "10d"
                    }
                ],
                "clouds": 73,
                "pop": 0.95,
                "rain": 1.85,
                "uvi": 0.88
            },
            {
                "dt": 1668078000,
                "sunrise": 1668063090,
                "sunset": 1668097055,
                "moonrise": 1668100320,
                "moonset": 1668071280,
                "moon_phase": 0.56,
                "temp": {
                    "day": 14.64,
                    "min": 10.25,
                    "max": 15.21,
                    "night": 11.73,
                    "eve": 12.85,
                    "morn": 10.54
                },
                "feels_like": {
                    "day": 13.83,
                    "night": 10.94,
                    "eve": 11.99,
                    "morn": 9.76
                },
                "pressure": 1026,
                "humidity": 64,
                "dew_point": 7.79,
                "wind_speed": 2.67,
                "wind_deg": 213,
                "wind_gust": 4.07,
                "weather": [
                    {
                        "id": 802,
                        "main": "Clouds",
                        "description": "scattered clouds",
                        "icon": "03d"
                    }
                ],
                "clouds": 30,
                "pop": 0,
                "uvi": 1
            },
            {
                "dt": 1668164400,
                "sunrise": 1668149586,
                "sunset": 1668183373,
                "moonrise": 1668189000,
                "moonset": 1668161760,
                "moon_phase": 0.6,
                "temp": {
                    "day": 14.72,
                    "min": 9.36,
                    "max": 15.36,
                    "night": 11.07,
                    "eve": 12.6,
                    "morn": 9.36
                },
                "feels_like": {
                    "day": 13.81,
                    "night": 10.27,
                    "eve": 11.77,
                    "morn": 8.83
                },
                "pressure": 1029,
                "humidity": 60,
                "dew_point": 6.91,
                "wind_speed": 1.99,
                "wind_deg": 129,
                "wind_gust": 5.01,
                "weather": [
                    {
                        "id": 802,
                        "main": "Clouds",
                        "description": "scattered clouds",
                        "icon": "03d"
                    }
                ],
                "clouds": 43,
                "pop": 0,
                "uvi": 1
            },
            {
                "dt": 1668250800,
                "sunrise": 1668236081,
                "sunset": 1668269694,
                "moonrise": 1668278340,
                "moonset": 1668251640,
                "moon_phase": 0.63,
                "temp": {
                    "day": 13.45,
                    "min": 8.64,
                    "max": 14.18,
                    "night": 9.97,
                    "eve": 11.26,
                    "morn": 8.64
                },
                "feels_like": {
                    "day": 12.31,
                    "night": 9.97,
                    "eve": 10.24,
                    "morn": 8.05
                },
                "pressure": 1023,
                "humidity": 56,
                "dew_point": 4.73,
                "wind_speed": 2.23,
                "wind_deg": 93,
                "wind_gust": 5.23,
                "weather": [
                    {
                        "id": 804,
                        "main": "Clouds",
                        "description": "overcast clouds",
                        "icon": "04d"
                    }
                ],
                "clouds": 98,
                "pop": 0,
                "uvi": 1
            }
        ]
    }
    """.data(using: .utf8)!
}
