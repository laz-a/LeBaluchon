//
//  TranslateTestCase.swift
//  LeBaluchonTests
//
//  Created by laz on 31/10/2022.
//

import XCTest
@testable import LeBaluchon

final class TranslateTestCase: XCTestCase {

    private func getTranslateViewModel(_ mock: AnyClass) -> TranslateViewModel {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [mock]
        let urlSession = URLSession(configuration: configuration)
        return TranslateViewModel(session: urlSession)
    }

    func testGetLanguagesShouldPostFailedCallbackIfError() async {
        let translateModel = getTranslateViewModel(MockFailedCallbackIfError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getLanguages { getLanguages in
            do {
                let _ = try getLanguages()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetLanguagesShouldPostFailedCallbackIfNoData() async {
        let translateModel = getTranslateViewModel(MockFailedCallbackIfNoData.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getLanguages { getLanguages in
            do {
                let _ = try getLanguages()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetLanguagesShouldPostFailedCallbackIfDecodeError() async {
        let translateModel = getTranslateViewModel(MockFailedCallbackIfDecodeError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getLanguages { getLanguages in
            do {
                let _ = try getLanguages()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetLanguagesShouldPostSuccess() async {
        let translateModel = getTranslateViewModel(MockTranslateLanguagesSuccess.self)
        XCTAssertNil(translateModel.languages)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getLanguages { getLanguages in
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfError() async {
        let translateModel = getTranslateViewModel(MockFailedCallbackIfError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getTranslation(from: "fr", to: "en", text: ["Bonjour !"]) { getTranslation in
            do {
                let _ = try getTranslation()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetTranslationShouldPostFailedCallbackIfNoData() async {
        let translateModel = getTranslateViewModel(MockFailedCallbackIfNoData.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getTranslation(from: "fr", to: "en", text: ["Bonjour !"]) { getTranslation in
            do {
                let _ = try getTranslation()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetTranslationShouldPostFailedCallbackIfDecodeError() async {
        let translateModel = getTranslateViewModel(MockFailedCallbackIfDecodeError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getTranslation(from: "fr", to: "en", text: ["Bonjour !"]) { getTranslation in
            do {
                let _ = try getTranslation()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetTranslationShouldPostSuccess() async {
        let translateModel = getTranslateViewModel(MockTranslateTranslationSuccess.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateModel.getTranslation(from: "fr", to: "en", text: ["Bonjour !"]) { getTranslation in
            let trnaslation = try? getTranslation()
            XCTAssertEqual(trnaslation, ["Good morning !"])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
}
