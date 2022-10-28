//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import UIKit

class CurrencyViewController: UIViewController {

    let currencyModel = CurrencyViewModel()
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    @IBOutlet weak var toCodeLabel: UILabel!
    
    
    @IBOutlet weak var toPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currencyModel.getSymbols { getSymbols in
            do {
                let symbols = try getSymbols()
                self.toPickerView.reloadAllComponents()
                if let usdIndex = symbols.firstIndex(where: { $0.code == "USD" }) {
                    self.toPickerView.selectRow(usdIndex, inComponent: 0, animated: false)
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    /*
    // MARK: - Navigation
    */
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromTextField.resignFirstResponder()
    }
    
    @IBAction func editFromTextField(_ sender: UITextField) {
        convert()
    }
    
    private func getToCode() -> String? {
        let toRow = toPickerView.selectedRow(inComponent: 0)
        if let toCode = currencyModel.symbols?[toRow] {
            return toCode.code
        }
        return nil
    }
    
    private func convert() {
        let from = "EUR"
        
        guard let amountText = fromTextField.text, !amountText.isEmpty else {
            toTextField.text = ""
            return
        }
        
        if let to = getToCode(), let amount = Double(amountText) {
            self.toCodeLabel.text = to
            currencyModel.getConversion(from: from, to: to, amount: amount) { getResult in
                do {
                    let result = try getResult()
                    self.toTextField.text = String(format: "%.2f", result)
                } catch {
                    self.toTextField.text = ""
                    print(error)
                }
            }
        }
    }
    
}

extension CurrencyViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let availableCurrencies = currencyModel.symbols {
            return availableCurrencies.count
        }
        return 0
    }
}

extension CurrencyViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let availableCurrencies = currencyModel.symbols {
            return availableCurrencies[row].country
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        convert()
    }
}
