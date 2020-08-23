//
//  ViewController.swift
//  Crypto Exchange Rates
//
//  Created by Hanqing Liu on 8/22/20.
//  Copyright © 2020 Hanqing Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cryptoLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var cryptoAndCurrencyPicker: UIPickerView!
    
    var rateManager = RateManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rateManager.delegate = self
        cryptoAndCurrencyPicker.dataSource = self
        cryptoAndCurrencyPicker.delegate = self
        
    }
}

//MARK: - RateManagerDelegate

extension ViewController: RateManagerDelegate {
    
    func didUpdatePrice(rate: String, currency: String) {
        DispatchQueue.main.async {
            self.rateLabel.text = rate
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView DataSource & Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return rateManager.cryptoArray.count
        } else {
            return rateManager.currencyArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: rateManager.combinedArray[component][row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            cryptoLabel.text = rateManager.cryptoArray[row]
            return rateManager.getCoinPrice(crypto: rateManager.cryptoArray[row], currency: rateManager.currencyArray[pickerView.selectedRow(inComponent: 1)])
        } else {    
            return rateManager.getCoinPrice(crypto: rateManager.cryptoArray[pickerView.selectedRow(inComponent: 0)], currency: rateManager.currencyArray[row])
        }
    }
}
