//
//  ViewController.swift
//  FLEXAsyncEmptyDemo
//
//  Created by brian.plattenburg on 5/3/23.
//

import UIKit
import FLEX

class ViewController: UIViewController {
    @IBOutlet weak var responseDataLabel: UILabel!
    
    @IBAction func openFLEXPressed(_ sender: Any) {
        FLEXManager.shared.showExplorer()
    }
    
    @IBAction func networkRequestPressed(_ sender: Any) {
        Task {
            let url = URL(string: "https://cat-fact.herokuapp.com/facts/")
            guard let url = url else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            do {
                let (responseData, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode([CatFact].self, from: responseData)
                let catFactsString = response.map({ $0.text }).joined(separator: ",\n\n")
                updateUI(text: catFactsString)
            } catch let error {
                updateUI(text: "Error:\n\(error.localizedDescription)")
            }
        }
    }

    @MainActor func updateUI(text: String) {
        responseDataLabel.text = text
    }
}

struct CatFact: Codable {
    let text: String // We could map a lot more but we don't really care about whether it maps data back
}
