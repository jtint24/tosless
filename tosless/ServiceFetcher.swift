//
//  ServiceFetcher.swift
//  tosless
//
//  Created by Joshua Tint on 2/8/24.
//

import Foundation

func fetchEvidenceFromURL(_ url: URL?, _ completionHandler: @escaping (String) -> Void) {
    if let url = url {
        Task {
            do {
                let urlSession = URLSession(configuration: URLSessionConfiguration.default)
                let fetchedDataResponse = try await urlSession.data(for: URLRequest(url: url))
                let fetchedData = fetchedDataResponse.0
                // print(fetchedData)
                // let contents = try String(contentsOf: url)
                let text = fetchedData.htmlToString
                
                completionHandler(text)
            } catch {
                print(error)
            }
        }
        
    } else {
        completionHandler("")
    }
}

func fetchServiceInfoFromID(_ serviceID: Int, _ completionHandler: @escaping (Service, URL?) -> Void ) {
    if var urlComps = URLComponents(string: "https://api.tosdr.org/service/v2/") {
        
        print("gotten url \(urlComps)")
        
        urlComps.queryItems = [URLQueryItem(name: "id", value: "\(serviceID)")]
        
        guard let url = urlComps.url else {
            return
        }
        
        print("gotten url \(url)")
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print("gotten response \(String(describing: response)) and error \(String(describing: error))")
            guard let data = data else { return }
            do {
                let containedServiceResponse = try JSONDecoder().decode(TosdrContainer<ServiceResponse>.self, from: data)
                let serviceResponse = containedServiceResponse.parameters
                
                DispatchQueue.main.async {
                    completionHandler(serviceResponse.getService(), serviceResponse.getEvidenceURL())
                }
            } catch {
                print(data)
                print(String(describing: response))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

func getServiceSearches(query: String, _ completionHandler: @escaping ([TosdrService]) -> Void) {
    if var urlComps = URLComponents(string: "https://api.tosdr.org/search/v4/") {
        
        urlComps.queryItems = [URLQueryItem(name: "query", value: query)]
        
        guard let url = urlComps.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let searchBody = try JSONDecoder().decode(TosdrContainer<TosdrSearchServices>.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(searchBody.parameters.services)
                }
            } catch {
                print(data)
                print(String(describing: response))
                print(error.localizedDescription)
            }
        }.resume()
    }
}


struct ServiceResponse: Decodable {
    let evidenceDocuments: [TosdrDocument]
    let serviceName: String
    let iconURL: String
    
    func getService() -> Service {
        return Service(title: serviceName, iconURL: URL(string: iconURL))
    }
    
    func getEvidenceURL() -> URL? {
        for document in evidenceDocuments {
            if let url = URL(string: document.urlString) {
                return url
            }
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case serviceName = "name"
        case iconURL = "image"
        case evidenceDocuments = "documents"
    }
}

struct TosdrDocument: Decodable {
    let name: String
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case urlString = "url"
    }
}

struct TosdrService: Decodable, Hashable {
    let name: String
    let id: Int
    
    public func isDeprecated() -> Bool {
        return name.starts(with: "[") || name.lowercased().contains("deprecated")
    }
}

struct TosdrContainer<T: Decodable>: Decodable {
    let parameters: T
}

struct TosdrSearchServices: Decodable {
    let services: [TosdrService]
}
