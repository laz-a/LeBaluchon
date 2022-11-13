//
//  TranslateService.swift
//  LeBaluchon
//
//  Created by laz on 29/10/2022.
//

import Foundation

class TranslateService {
    // Define singleton
    static var shared = TranslateService()
    private init() {}

    private static let url = ServiceURL.translate
    private static let apiKey = ApiKey.googleTranslate
    private static let target = "en"

    private var task: URLSessionDataTask?
    private var session = URLSession.shared

    // Unit test custom init
    init(session: URLSession) {
        self.session = session
    }

    // Get list of available languages
    func getAvailableLanguages(callback: @escaping(() throws -> [TranslateLanguages.Language]) -> Void) {
        var urlLanguages = URLComponents(string: "\(TranslateService.url)/languages")!
        // Set query parameters
        urlLanguages.queryItems = [URLQueryItem(name: "key", value: TranslateService.apiKey),
                                   URLQueryItem(name: "target", value: TranslateService.target)]

        // Build request
        let requestLanguages = URLRequest(url: urlLanguages.url!)

        // Cancel in progress task if exist
        task?.cancel()

        // Configure task
        task = session.dataTask(with: requestLanguages) { data, response, error in
            DispatchQueue.main.async {
                // Throw error if status code error
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }

                // Throw error if data is empty
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }

                // Throw error if decode error
                guard let languages = try? JSONDecoder().decode(TranslateLanguages.self, from: data) else {
                    callback({ throw AsyncError.decode })
                    return
                }

                // Return result if success
                callback({ return languages.languages })
            }
        }

        // Perform request
        task?.resume()
    }

    func getTranslatedText(from: String, to: String, text: [String], callback: @escaping(() throws -> String) -> Void) {
        // Throw error if source language = target language
        guard !(from == to) else {
            callback({ throw AsyncError.response })
            return
        }

        var urlTranslate = URLComponents(string: "\(TranslateService.url)")!
        // Set query parameters
        var queryItems = [URLQueryItem(name: "key", value: TranslateService.apiKey),
                          URLQueryItem(name: "source", value: from),
                          URLQueryItem(name: "target", value: to),
                          URLQueryItem(name: "format", value: "text")]

        // Transform text : array of string to query
        queryItems += text.map { URLQueryItem(name: "q", value: $0) }
        urlTranslate.queryItems = queryItems

        // Build request
        var requestTranslate = URLRequest(url: urlTranslate.url!)
        requestTranslate.httpMethod = "POST"

        // Cancel in progress task if exist
        task?.cancel()

        // Configure task
        task = session.dataTask(with: requestTranslate) { data, response, error in
            DispatchQueue.main.async {
                // Throw error if status code error
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }

                // Throw error if data is empty
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }

                // Throw error if decode error
                guard let translation = try? JSONDecoder().decode(TranslateTranslation.self, from: data) else {
                    callback({ throw AsyncError.decode })
                    return
                }

                // Return result if success
                callback({ return translation.translatedText })
            }
        }

        // Perform request
        task?.resume()
    }
}
