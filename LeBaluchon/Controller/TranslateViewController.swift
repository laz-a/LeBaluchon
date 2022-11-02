//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import UIKit

class TranslateViewController: UIViewController {
    private let translateModel = TranslateViewModel()
    
    @IBOutlet weak var fromLanguageButton: UIButton!
    @IBOutlet weak var toLanguageButton: UIButton!
    
    @IBOutlet weak var selectLanguagePickerView: UIPickerView!
    
    @IBOutlet weak var translateTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectLanguagePickerView.isHidden = true
        
        translateModel.getLanguages { getLanguages in
            print("translateModel.getLanguages")
            do {
                let languages = try getLanguages()
                self.selectLanguagePickerView.reloadAllComponents()
                if let cuurentLanguage = Locale.current.language.languageCode?.identifier {
                    print("laaaaaz")
                    if let currentLanguageIndex = languages.firstIndex(where: { $0.language == cuurentLanguage }) {
                        self.selectLanguagePickerView.selectRow(currentLanguageIndex, inComponent: 0, animated: false)
                        self.pickerView(self.selectLanguagePickerView, didSelectRow: currentLanguageIndex, inComponent: 0)
                    }
                    if let enIndex = languages.firstIndex(where: { $0.language == "en" }) {
                        self.selectLanguagePickerView.selectRow(enIndex, inComponent: 1, animated: false)
                        self.pickerView(self.selectLanguagePickerView, didSelectRow: enIndex, inComponent: 1)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    /*
    // MARK: - Navigation
    */
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        translateTextView.resignFirstResponder()
        selectLanguagePickerView.isHidden = true
    }
    
    @IBAction func tappedSelectLanguage(_ sender: UIButton) {
        translateTextView.resignFirstResponder()
        selectLanguagePickerView.isHidden = false
    }
    
    @IBAction func tappedSwapLanguageButton(_ sender: UIButton) {
        translateTextView.resignFirstResponder()
        let fromLanguageIndex = selectLanguagePickerView.selectedRow(inComponent: 0)
        let toLanguageIndex = selectLanguagePickerView.selectedRow(inComponent: 1)
        
        selectLanguagePickerView.selectRow(toLanguageIndex, inComponent: 0, animated: false)
        selectLanguagePickerView.selectRow(fromLanguageIndex, inComponent: 1, animated: false)
        
        translate()
        
        if let translateText = translateTextView.text, !translateText.isEmpty, let translatedText = translatedTextView.text, !translatedText.isEmpty {
            translateTextView.text = translatedText
            translatedTextView.text = translateText
        }
    }
    
    @IBAction func tappedTranslateButton(_ sender: UIButton) {
        dismissKeyboard(sender)
        
        let fromLanguageRow = selectLanguagePickerView.selectedRow(inComponent: 0)
        let toLanguageRow = selectLanguagePickerView.selectedRow(inComponent: 1)
        
//        guard let _ = translateModel.languages?.indices.contains(fromLanguageRow), let _ = translateModel.languages?.indices.contains(toLanguageRow) else {
//            print("guard else !!!")
//            return
//        }
        
        if let fromLanguage = translateModel.languages?[fromLanguageRow].language, let toLanguage = translateModel.languages?[toLanguageRow].language, let text = translateTextView.text, !text.isEmpty {
            print("\(fromLanguage) :: \(toLanguage)")
            
            print(text)
            print(text.components(separatedBy: "\n"))
            
            let aze = text.components(separatedBy: "\n")
            
            translateModel.getTranslation(from: fromLanguage, to: toLanguage, text: aze) { getTranslation in
                do {
                    let translation = try getTranslation()
                    self.translatedTextView.text = translation.joined(separator: "\n")
                    print(translation)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func translate() {
        let fromLanguageIndex = selectLanguagePickerView.selectedRow(inComponent: 0)
        let toLanguageIndex = selectLanguagePickerView.selectedRow(inComponent: 1)
        
        if let fromLanguage = translateModel.languages?[fromLanguageIndex], let toLanguage = translateModel.languages?[toLanguageIndex] {
            fromLanguageButton.setTitle(fromLanguage.name, for: .normal)
            toLanguageButton.setTitle(toLanguage.name, for: .normal)
        }
    }
}

extension TranslateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        selectLanguagePickerView.isHidden = true
    }
}

extension TranslateViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let availableLanguages = translateModel.languages {
            return availableLanguages.count
        }
        return 0
    }
}

extension TranslateViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let availableLanguages = translateModel.languages {
            return availableLanguages[row].name
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        translate()
    }
}
