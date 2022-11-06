//
//  TranslateViewModel.swift
//  LeBaluchon
//
//  Created by laz on 29/10/2022.
//

import Foundation

class TranslateViewModel {
    private var translateService = TranslateService.shared
    var languages: [TranslateLanguages.Language]?

    init() {}
    init(session: URLSession) {
        translateService = TranslateService(session: session)
    }

    func getLanguages(completionHandler: @escaping(() throws -> ([TranslateLanguages.Language])) -> Void) {
        if let languages = languages {
            completionHandler({ return languages })
        } else {
            translateService.getAvailableLanguages { getLanguages in
                do {
                    self.languages = try getLanguages()
                    completionHandler({ return self.languages! })
                } catch {
                    completionHandler({ throw error })
                }
            }
        }
    }

    func getTranslation(from: String,
                        to: String,
                        text: [String],
                        completionHandler: @escaping(() throws -> [String]) -> Void) {
        translateService.getTranslatedText(from: from, to: to, text: text) { getTranslation in
            do {
                let translation = try getTranslation()
                completionHandler({ return translation })
            } catch {
                completionHandler({ throw error })
            }
        }
    }
}
