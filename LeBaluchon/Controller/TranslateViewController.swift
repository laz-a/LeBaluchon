//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import UIKit

class TranslateViewController: UIViewController {
    private let translateModel = TranslateModel()

    @IBOutlet weak var fromLanguageButton: UIButton!
    @IBOutlet weak var toLanguageButton: UIButton!
    @IBOutlet weak var swapLanguageButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var selectLanguagePickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var translateTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!

    // Return selected source language
    private var selectedFromLanguage: TranslateLanguages.Language {
        let fromLanguageRow = selectLanguagePickerView.selectedRow(inComponent: 0)
        return translateModel.languages[fromLanguageRow]
    }

    // Return selected target language
    private var selectedToLanguage: TranslateLanguages.Language {
        let toLanguageRow = selectLanguagePickerView.selectedRow(inComponent: 1)
        return translateModel.languages[toLanguageRow]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide PickerView
        selectLanguagePickerView.isHidden = true
        // Set buttons and TextViews disable
        setEnableButtons(false)
        // Get available languages
        getLanguages()
    }

    /*
    // MARK: - Navigation
    */

    // Dismiss keyboard
    @IBAction func dismissKeyboard(_ sender: Any) {
        translateTextView.resignFirstResponder()
        selectLanguagePickerView.isHidden = true
    }

    // Show PickerView when languages buttons tapped
    @IBAction func tappedSelectLanguage(_ sender: UIButton) {
        translateTextView.resignFirstResponder()
        selectLanguagePickerView.isHidden = false
    }

    // Swap language action
    @IBAction func tappedSwapLanguagesButton(_ sender: UIButton) {
        dismissKeyboard(sender)
        swapLanguages()
    }

    // Translate text action
    @IBAction func tappedTranslateButton(_ sender: UIButton) {
        dismissKeyboard(sender)
        translate()
    }

    // Set buttons and textViews enabled
    private func setEnableButtons(_ enabled: Bool) {
        fromLanguageButton.isEnabled = enabled
        swapLanguageButton.isEnabled = enabled
        toLanguageButton.isEnabled = enabled
        translateButton.isEnabled = enabled
    }

    // Get available languages
    private func getLanguages() {
        activityIndicator.startAnimating()
        translateModel.getLanguages { getLanguages in
            do {
                let languages = try getLanguages()
                // Reload PickerView content
                self.selectLanguagePickerView.reloadAllComponents()

                // Get device languages
                if let cuurentLanguage = Locale.preferredLanguages.first {
                    // If device language exist in available google api languages, set source language to device lanaguage
                    if let currentLanguageIndex = languages.firstIndex(where: { $0.language == cuurentLanguage }) {
                        self.selectLanguagePickerView.selectRow(currentLanguageIndex, inComponent: 0, animated: false)
                        self.pickerView(self.selectLanguagePickerView, didSelectRow: currentLanguageIndex, inComponent: 0)
                    }
                    // Set target language to english if available
                    let toLanguage = cuurentLanguage == "fr" ? "en" : "fr"
                    if let enIndex = languages.firstIndex(where: { $0.language == toLanguage }) {
                        self.selectLanguagePickerView.selectRow(enIndex, inComponent: 1, animated: false)
                        self.pickerView(self.selectLanguagePickerView, didSelectRow: enIndex, inComponent: 1)
                    }
                    // Once PickerView reloaded set source/target language buttons title
                    self.setEnableButtons(true)
                }
            } catch {
                // Display alert error
                self.displayAlertError(message: error.localizedDescription)
            }
            self.activityIndicator.stopAnimating()
        }
    }

    // Swap source/target languages
    private func swapLanguages() {
        let fromLanguageIndex = selectLanguagePickerView.selectedRow(inComponent: 0)
        let toLanguageIndex = selectLanguagePickerView.selectedRow(inComponent: 1)

        selectLanguagePickerView.selectRow(toLanguageIndex, inComponent: 0, animated: false)
        selectLanguagePickerView.selectRow(fromLanguageIndex, inComponent: 1, animated: false)

        // Update source/target buttons titles
        setButtonsTitles()

        // Swipe source/target TextView content
        if let translateText = translateTextView.text, !translateText.isEmpty,
           let translatedText = translatedTextView.text, !translatedText.isEmpty {
            translateTextView.text = translatedText
            translatedTextView.text = translateText
        }
    }

    // Translate text
    private func translate() {
        // Test translateTextView content
        guard let text = translateTextView.text, !text.isEmpty else {
            return
        }

        activityIndicator.startAnimating()
        // Translate text according to source/target languages
        translateModel.getTranslation(from: selectedFromLanguage.language, to: selectedToLanguage.language, text: text) { getTranslation in
            do {
                let translation = try getTranslation()
                // Set translatedTextView content
                self.translatedTextView.text = translation
            } catch {
                // Display alert error
                self.displayAlertError(message: error.localizedDescription)
            }
            self.activityIndicator.stopAnimating()
        }
    }

    // Set source/target languages button title according to selected rows in PickerView
    private func setButtonsTitles() {
        // Set buttons title
        fromLanguageButton.setTitle(selectedFromLanguage.name, for: .normal)
        toLanguageButton.setTitle(selectedToLanguage.name, for: .normal)
    }

}

// Hide PickerView on TextView editing
extension TranslateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        selectLanguagePickerView.isHidden = true
    }
}

// PickerView dataSource
extension TranslateViewController: UIPickerViewDataSource {
    // Number of component in PickerView : Source and Target languages
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    // Same data, same number of rows in both component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return translateModel.languages.count
    }
}

// PickerView delegate
extension TranslateViewController: UIPickerViewDelegate {
    // Set PickerView row title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return translateModel.languages[row].name
    }

    // On select PickerView row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Prevent same source/target languages rows
        let otherComponent = component == 0 ? 1 : 0
        if pickerView.selectedRow(inComponent: otherComponent) == row {
            // If source/target languages are same select next (or previous) row
            let numberOfRow = pickerView.numberOfRows(inComponent: component)
            let newRow = (numberOfRow - 1) > row ? row + 1 : row - 1
            pickerView.selectRow(newRow, inComponent: component, animated: true)
        }
        // Set title of source/target language button
        setButtonsTitles()
    }
}
