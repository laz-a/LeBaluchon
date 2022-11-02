//
//  Translate.swift
//  LeBaluchon
//
//  Created by laz on 29/10/2022.
//

import Foundation

struct TranslateLanguages: Decodable {
    
    struct Language: Decodable {
      let language: String
      let name: String
    }
    
    enum RootKeys: String, CodingKey {
        case data
    }

    enum LanguagesKeys: String, CodingKey {
        case languages
    }

    enum LanguageKeys: String, CodingKey {
        case language, name
    }
    
    let languages: [Language]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let languagesContainer = try container.nestedContainer(keyedBy: LanguagesKeys.self, forKey: .data)
        languages = try languagesContainer.decode([Language].self, forKey: .languages)
    }
}

struct TranslateTranslation: Decodable {
    enum RootKeys: String, CodingKey {
        case data
    }
    
    enum TranslationsKeys: String, CodingKey {
        case translations
    }
    
    enum TranslationKeys: String, CodingKey {
        case translatedText
    }
    
    struct TranslatedText: Decodable {
        let translatedText: String
    }
    
    let translatedText: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let translationsContainer = try container.nestedContainer(keyedBy: TranslationsKeys.self, forKey: .data)
        let translatedText = try translationsContainer.decode([TranslatedText].self, forKey: .translations)
        self.translatedText = translatedText.map{ $0.translatedText }
    }
}
