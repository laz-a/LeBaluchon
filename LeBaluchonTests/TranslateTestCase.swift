//
//  TranslateTestCase.swift
//  LeBaluchonTests
//
//  Created by laz on 31/10/2022.
//

import XCTest
@testable import LeBaluchon

final class TranslateTestCase: XCTestCase {

    // init CurrencyViewModel with MockURLProtocol
    private func getTranslateViewModel(_ mock: AnyClass) -> TranslateViewModel {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [mock]
        let urlSession = URLSession(configuration: configuration)
        return TranslateViewModel(session: urlSession)
    }

    func testGetLanguagesShouldPostFailedCallbackIfError() async {
        // Given
        let translateModel = getTranslateViewModel(MockFailedCallbackIfError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getLanguages { getLanguages in
            do {
                _ = try getLanguages()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetLanguagesShouldPostFailedCallbackIfNoData() async {
        // Given
        let translateModel = getTranslateViewModel(MockFailedCallbackIfNoData.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getLanguages { getLanguages in
            do {
                _ = try getLanguages()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetLanguagesShouldPostFailedCallbackIfDecodeError() async {
        // Given
        let translateModel = getTranslateViewModel(MockFailedCallbackIfDecodeError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getLanguages { getLanguages in
            do {
                _ = try getLanguages()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetLanguagesShouldPostSuccess() async {
        // Given
        let translateModel = getTranslateViewModel(MockTranslateLanguagesSuccess.self)
        
        // When
        XCTAssertTrue(translateModel.languages.isEmpty)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getLanguages { getLanguages in
            // Then
            if let languages = try? getLanguages() {
                XCTAssertEqual(languages.map { $0.name }, ["English", "French", "Japanese"])
            }
            translateModel.getLanguages { getLanguages in
                if let languages = try? getLanguages() {
                    XCTAssertEqual(languages.map { $0.name }, ["English", "French", "Japanese"])
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetTranslationShouldPostFailedCallbackIfError() async {
        // Given
        let translateModel = getTranslateViewModel(MockFailedCallbackIfError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getTranslation(from: "fr", to: "en", text: "Bonjour !") { getTranslation in
            do {
                _ = try getTranslation()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetTranslationShouldPostFailedCallbackIfNoData() async {
        // Given
        let translateModel = getTranslateViewModel(MockFailedCallbackIfNoData.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getTranslation(from: "fr", to: "en", text: "Bonjour !") { getTranslation in
            do {
                _ = try getTranslation()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetTranslationShouldPostFailedCallbackIfDecodeError() async {
        // Given
        let translateModel = getTranslateViewModel(MockFailedCallbackIfDecodeError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getTranslation(from: "fr", to: "en", text: "Bonjour !") { getTranslation in
            do {
                _ = try getTranslation()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetTranslationShouldPostSuccess() async {
        // Given
        let translateModel = getTranslateViewModel(MockTranslateTranslationSuccess.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getTranslation(from: "fr", to: "en", text: "Bonjour !") { getTranslation in
            let translation = try? getTranslation()
            // Then
            XCTAssertEqual(translation, "Good morning !")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
