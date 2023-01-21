//
//  OpenAIManager.swift
//  OpenAISwift
//
//  Created by Meet Patel on 21/01/23.
//

import Foundation
import UIKit

enum OpenAIEngine: String {
    
    // https://beta.openai.com/docs/engines
    case davinci
    case curie
    case babbage
    case ada
    
    case instructcurie = "instruct-curie"
    case instructdavinci = "instruct-davinci"
}

class OpenAIManager {
    
    static let shared = OpenAIManager()
    
    var engine: OpenAIEngine = .davinci
    
    func makeRequest(json: [String: Any], completion: @escaping (String)->()) {
        
        guard let url = URL(string: "https://api.openai.com/v1/engines/\(engine)/completions"),
              let payload = try? JSONSerialization.data(withJSONObject: json) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(OpenAISecretKey.SECRETKEY)", forHTTPHeaderField: "Authorization")
        request.httpBody = payload
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { completion("Error::\(String(describing: error?.localizedDescription))"); return }
            guard let data = data else { completion("Error::Empty data"); return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            
            if let json = json,
               let choices = json["choices"] as? [[String: Any]],
               let str = choices.first?["text"] as? String {
                completion (str)
            } else {
                completion("Error::nothing returned")
            }
            
        }.resume()
    }
    
    func processPrompt(prompt: String, completion: @escaping ((_ reponse: String) -> Void)) {
        
        let jsonPayload = [
            "prompt": prompt,
            //"model": "text-davinci-003",
            "max_tokens": 200
        ] as [String : Any]
        
        self.makeRequest(json: jsonPayload) { [weak self] (str) in
            DispatchQueue.main.async {
                
                print("===>", str)
                completion(str)
            }
        }
    }
}
