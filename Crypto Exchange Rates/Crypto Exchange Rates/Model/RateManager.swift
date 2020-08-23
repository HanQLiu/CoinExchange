//
//  RateManager.swift
//  Crypto Exchange Rates
//
//  Created by Hanqing Liu on 8/23/20.
//  Copyright © 2020 Hanqing Liu. All rights reserved.
//

import Foundation

protocol RateManagerDelegate {
    func didUpdatePrice(rate: String, currency: String)
    func didFailWithError(error: Error)
}

struct RateManager {
    
    var delegate: RateManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "135AE0A5-3CE9-456C-811C-1D5E7AC12BA9"
    
    let cryptoArray = ["BTC", "ETH", "XRP", "USDT", "BCH", "BSV", "LTC", "EOS", "BNB", "XTZ"]
    let currencyArray = ["AUD", "CAD", "CNY", "EUR", "GBP", "HKD", "JPY", "NZD", "RUB", "USD"]
    var combinedArray = [["BTC", "ETH", "XRP", "USDT", "BCH", "BSV", "LTC", "EOS", "BNB", "XTZ"], ["AUD", "CAD", "CNY", "EUR", "GBP", "HKD", "JPY", "NZD", "RUB", "USD"]]
    
    func getCoinPrice(crypto:String, currency: String){
        let urlString = "\(baseURL)/\(crypto)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(rate: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            return rate
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
