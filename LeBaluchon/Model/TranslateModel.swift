//
//  TranslateViewModel.swift
//  LeBaluchon
//
//  Created by laz on 29/10/2022.
//

import Foundation

final class TranslateModel {
    // Translate service singleton
    private var translateService = TranslateService.shared

    // List of available languages
    var languages = [TranslateLanguages.Language]()

    init() {}

    // Init used for unit tests
    init(session: URLSession) {
        translateService = TranslateService(session: session)
    }

    // Request available languages from service
    func getLanguages(completionHandler: @escaping(() throws -> ([TranslateLanguages.Language])) -> Void) {
        // If languages already exist, return languages
        if !languages.isEmpty {
            completionHandler({ return languages })
        } else {
            // Else get languages from service
            translateService.getAvailableLanguages { getLanguages in
                do {
                    // Save requested languages
                    self.languages = try getLanguages()
                    completionHandler({ return self.languages })
                } catch {
                    // Throw error service
                    completionHandler({ throw error })
                }
            }
        }
    }

    // Get translation for from/to languages
    func getTranslation(from: String, to: String, text: String, completionHandler: @escaping(() throws -> String) -> Void) {
        translateService.getTranslatedText(from: from, to: to, text: text.components(separatedBy: "\n")) { getTranslation in
            do {
                // Return translated text
                let translation = try getTranslation()
                completionHandler({ return translation })
            } catch {
                // Throw error service
                completionHandler({ throw error })
            }
        }
    }
}
