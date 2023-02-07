//
//  OpenAIManager.swift
//  OpenAISwift
//
//  Created by Meet Patel on 21/01/23.
//

import Foundation
import UIKit

//https://api.openai.com/v1/completions
//https://api.openai.com/v1/images/generations

struct Response: Decodable {
    
    let data: [ImageURL]
}

struct ImageURL: Decodable {
    
    let url: String
}

enum APIError: Error {
    
    case unableToCreateImageURL
    case unableToConvertDataIntoImage
    case unableToCreateURLForURLRequest
}

class OpenAIManager {
    
    static let shared = OpenAIManager()
    
    func makeRequest(json: [String: Any], completion: @escaping (String)->()) {
        
        guard let url = URL(string: "https://api.openai.com/v1/completions"),
              let payload = try? JSONSerialization.data(withJSONObject: json) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(OpenAISecretKey.SECRETKEY)", forHTTPHeaderField: "Authorization")
        request.httpBody = payload
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { completion("Error::\(String(describing: error?.localizedDescription))"); return }
            guard let data = data else { completion("Error::Empty data"); return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            
            if let json = json,
               let choices = json["choices"] as? [[String: Any]],
               let str = choices.first?["text"] as? String {
                completion(str)
            } else {
                completion("Error::nothing returned")
            }
            
        }.resume()
    }
    
    func processPrompt(prompt: String, completion: @escaping ((_ reponse: String) -> Void)) {
        
        let jsonPayload = [
            "prompt": prompt,
            "model": "text-davinci-003",
            "max_tokens": 2048,
            "temperature": 0
        ] as [String : Any]
        
        print("Parameters: \(jsonPayload)")
        
        self.makeRequest(json: jsonPayload) { [weak self] (str) in
            DispatchQueue.main.async {
                
                print("===>", str.trime())
                completion(str)
            }
        }
    }
    
    func fetchImageForPrompt(prompt: String, completion: @escaping ([ImageURL])->()) {
        
        let jsonPayload = [
            "prompt": prompt,
            "n": 10,
            "size": "1024x1024"
        ] as [String : Any]
        
        print("Parameters: \(jsonPayload)")
        
        guard let url = URL(string: "https://api.openai.com/v1/images/generations"),
              let payload = try? JSONSerialization.data(withJSONObject: jsonPayload) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(OpenAISecretKey.SECRETKEY)", forHTTPHeaderField: "Authorization")
        request.httpBody = payload
        
        print("URL: \(request)")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let decoder = JSONDecoder()
            let results = try? decoder.decode(Response.self, from: data ?? Data())
            
            print("Data:", results?.data)
            
            let imageURL = results?.data
            print("imageURL:", imageURL)
            completion(imageURL ?? [ImageURL]())
            
        }.resume()
    }
}
