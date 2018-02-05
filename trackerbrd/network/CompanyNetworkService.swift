//
//  CompanyNetworkService.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/3/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import SwiftyJSON

class CompanyNetworkService {
    public static let shared = CompanyNetworkService()
    
    func getListCompanies(completion: @escaping (CompaniesJson?, Message?) -> ()) {
        guard let url = URL(string: Links.site.rawValue + Links.companies.rawValue) else { return }
        
        NetworkService.shared.getData(url: url) { (data, response, error) in
            guard error == nil else { completion(nil, Message(error?.localizedDescription)); return }
            guard let jsonArray = data else { completion(nil, Message("fail to load data")); return}
            
            let js = JSON(jsonArray)
            do {
                let answer = try CompaniesJson(with: js)
                completion(answer, nil)
            }
            catch {
                completion(nil, Message(error.localizedDescription))
            }
        }
    }
    
    func getOneCompany(with id: Int64, completion: @escaping (CompaniesJson?, Message?) -> ()) {
        guard let url = URL(string: Links.site.rawValue + Links.company.rawValue + "\(id)") else { return }
        NetworkService.shared.getData(url: url) { (data, response, error) in
            guard error == nil else { completion(nil, Message(error?.localizedDescription)); return }
            guard let jsonArray = data else { completion(nil, Message("fail to load data")); return}
            
            let js = JSON(jsonArray)
            do {
                let answer = try CompaniesJson(one: js)
                completion(answer, nil)
            }
            catch {
                completion(nil, Message(error.localizedDescription))
            }
        }
    }
    
    func updateCompany(_ company: Company, completion: @escaping (Message?) -> ()) {
        guard let url = URL(string: Links.site.rawValue + Links.updateCompany.rawValue) else { return }
        
        let data = try? JSON(company.dictionary!).rawData()
        guard data != nil else { completion(Message("Fail to load data")) ; return }
        NetworkService.shared.postData(url: url, data: data!) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode != 200 {
                let json = JSON(data!)
                let message = Message(json)
                completion(message)
                return
            }
            completion(nil)
        }
    }
    
    func addCompany(_ company: Company, completion: @escaping (Message?) -> ()) {
        guard let url = URL(string: Links.site.rawValue + Links.updateCompany.rawValue) else { return }
        
        let data = try? JSON(company.dictionary!).rawData()
        guard data != nil else { completion(Message("Fail to load data")) ; return }
        NetworkService.shared.putData(url: url, data: data!) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode != 200 {
                let json = JSON(data!)
                let message = Message(json)
                completion(message)
                return
            }
            completion(nil)
        }
    }
    
    func deleteCompany(_ id: Int64, completion: @escaping (Message?) -> ()) {
        guard let url = URL(string: Links.site.rawValue + Links.company.rawValue + "\(id)") else { return }
        
        NetworkService.shared.deleteData(url: url) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode != 200 {
                let json = JSON(data!)
                let message = Message(json)
                completion(message)
                return
            }
            completion(nil)
        }
    }
}
