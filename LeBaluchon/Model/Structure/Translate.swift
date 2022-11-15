//
//  Translate.swift
//  LeBaluchon
//
//  Created by laz on 29/10/2022.
//

import Foundation

// Languages structure
struct TranslateLanguages: Decodable {

    // Languages are defined by language and name
    struct Language: Decodable {
      let language: String
      let name: String
    }

    // Root coding keys
    enum RootKeys: String, CodingKey {
        case data
    }

    // Languages coding keys
    enum LanguagesKeys: String, CodingKey {
        case languages
    }

    // Language coding keys
    enum LanguageKeys: String, CodingKey {
        case language, name
    }

    // Keep only languages
    let languages: [Language]

    // Decode json
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let languagesContainer = try container.nestedContainer(keyedBy: LanguagesKeys.self, forKey: .data)
        languages = try languagesContainer.decode([Language].self, forKey: .languages)
    }
}

// Translation response structure
struct TranslateTranslation: Decodable {
    // Root coding keys
    enum RootKeys: String, CodingKey {
        case data
    }

    // Translations coding keys
    enum TranslationsKeys: String, CodingKey {
        case translations
    }

    // Translation coding keys
    enum TranslationKeys: String, CodingKey {
        case translatedText
    }

    struct TranslatedText: Decodable {
        let translatedText: String
    }

    // Keep only array of translated text
    let translatedText: String

    // Decode json
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let translationsContainer = try container.nestedContainer(keyedBy: TranslationsKeys.self, forKey: .data)
        let translatedText = try translationsContainer.decode([TranslatedText].self, forKey: .translations)
        self.translatedText = translatedText.map { $0.translatedText }.joined(separator: "\n")
    }
}
