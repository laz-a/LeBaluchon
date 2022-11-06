//
//  TranslateService.swift
//  LeBaluchon
//
//  Created by laz on 29/10/2022.
//

import Foundation

class TranslateService {
    static var shared = TranslateService()
    private init() {}

    private static let url = "https://translation.googleapis.com/language/translate/v2"
    private static let apiKey = ApiKey.googleTranslate
    private static let target = "en"

    private var task: URLSessionDataTask?
    private var session = URLSession.shared

    init(session: URLSession) {
        self.session = session
    }

    func getAvailableLanguages(callback: @escaping(() throws -> [TranslateLanguages.Language]) -> Void) {
        let urlLanguages = URL(string: "\(TranslateService.url)/languages")!
        var requestLanguages = URLRequest(url: urlLanguages)
        let queryItems = [URLQueryItem(name: "key", value: TranslateService.apiKey),
                          URLQueryItem(name: "target", value: TranslateService.target)]
        requestLanguages.url?.append(queryItems: queryItems)

        task?.cancel()
        task = session.dataTask(with: requestLanguages) { data, response, error in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }
                guard let languages = try? JSONDecoder().decode(TranslateLanguages.self, from: data) else {
                    callback({ throw AsyncError.decode })
                    return
                }
                callback({ return languages.languages })
            }
        }
        task?.resume()
    }

    func getTranslatedText(from: String, to: String, text: [String],
                           callback: @escaping(() throws -> [String]) -> Void) {
        let urlTranslate = URL(string: "\(TranslateService.url)")!
        var requestTranslate = URLRequest(url: urlTranslate)
        requestTranslate.httpMethod = "POST"
        var queryItems = [URLQueryItem(name: "key", value: TranslateService.apiKey),
                          URLQueryItem(name: "source", value: from),
                          URLQueryItem(name: "target", value: to),
                          URLQueryItem(name: "format", value: "text")]
        text.forEach { line in
            queryItems.append(URLQueryItem(name: "q", value: line))
        }
        requestTranslate.url?.append(queryItems: queryItems)

        task?.cancel()
        task = session.dataTask(with: requestTranslate) { data, response, error in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }
                guard let translation = try? JSONDecoder().decode(TranslateTranslation.self, from: data) else {
                    callback({ throw AsyncError.decode })
                    return
                }
                callback({ return translation.translatedText })
            }
        }
        task?.resume()
    }
}
