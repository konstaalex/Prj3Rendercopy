//
//  UserHTTPRequests.swift
//  StalkerApp
//
//  Created by Sarah Largou on 14.12.23.
//

import Foundation

enum RequestError: Error {
    case invalidURL
    case missingData
    case httpError
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case internalErr
    case invalidResponse
}
func getUsers(token: String) async throws -> [User] {
    guard let url = URL(string: "http://[::1]:3000/users") else {
        throw RequestError.invalidURL
    }
    var request = URLRequest(url: url)
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.invalidResponse
        }
        
        print("HTTP Status Code: \(httpResponse.statusCode)")
        
        guard 200..<300 ~= httpResponse.statusCode else {
            print("Unexpected status code: \(httpResponse.statusCode)")
            throw RequestError.unexpectedStatusCode
        }
        
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    } catch {
        print("Error fetching users: \(error)")
        throw error
    }
}


func postSignup(urlString: String, user: User) async throws {
    
    //first check url
    guard let url = URL(string: "\(urlString)") else {
        throw RequestError.invalidURL
    }
    
    // create request and configure before sending
    var request = URLRequest(url: url)
    // setting content type so that the service knows to expect json
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //set method to post
    request.httpMethod = "POST"
    
    // converting user object to a data object
    let data = try JSONEncoder().encode(user)
    //attach data object to the request
    request.httpBody = data
    
    //do the request
    // create a data task with data method
    
    let (_, response) = try await URLSession.shared.data(for: request)
    
    guard let statusCode = response as? HTTPURLResponse, (200...299) ~= statusCode.statusCode else {
        
        let code = (response as? HTTPURLResponse)!.statusCode
        print(code)
        // throw error if request could not be processed. just check wikipedia for the list of errorcodes
        switch code {
        case 400: throw RequestError.missingData
        case 401: throw RequestError.unauthorized
        case 402...499: throw RequestError.unexpectedStatusCode
        case 500...510: throw RequestError.internalErr
        default: throw RequestError.unknown
        }
        
    }
}

struct ServerResponse: Decodable{
    let token: String
}


func postLogin(username: String, password: String) async throws -> String {
    
    //first check url
    guard let url = URL(string: "http://[::1]:3000/users/login") else {
        throw RequestError.invalidURL
    }
    
    let body = UserLogin(username: username, password: password)
    // create request and configure before sending
    var request = URLRequest(url: url)
    // setting content type so that the service knows to expect json
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //set method to post
    request.httpMethod = "POST"
    // converting user object to a data object
    //attach data object to the request
    request.httpBody =  try JSONEncoder().encode(body)
    
    //do the request
    // create a data task with data method
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let statusCode = response as? HTTPURLResponse, (200...299) ~= statusCode.statusCode else {
        let code = (response as? HTTPURLResponse)!.statusCode
        // throw error if request could not be processed. just check wikipedia for the list of errorcodes
        switch code {
        case 400: throw RequestError.missingData
        case 401: throw RequestError.unauthorized
        case 402...499: throw RequestError.unexpectedStatusCode
        case 500...510: throw RequestError.internalErr
        default: throw RequestError.unknown
        }
        
    }
    //server replies with token
    // parse response from server to a swift object
    do {
        let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
        let token = serverResponse.token
        UserDefaults.standard.set(token, forKey: "jwtToxen")
        return token
    } catch {
        throw RequestError.unknown
    }
}

func postStalkerList(urlString: String, stalkerList: StalkerList) async throws {
    
    guard let url = URL(string: "http://[::1]:3000/stalker-lists") else {
        throw RequestError.invalidURL
    }
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    let data = try JSONEncoder().encode(stalkerList)
    request.httpBody = data
    
    do {
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard (200...299) ~= (response as? HTTPURLResponse)!.statusCode else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            print("Error creating stalker list. HTTP status code: \(code)")
            throw RequestError.unexpectedStatusCode
        }
    } catch {
        print("Error creating stalker list: \(error)")
        throw error
    }
}


func addStalkerToTheList(urlString: String, stalkerListId:Int, user: User) async throws {
    guard let url = URL(string: "http://[::1]:3000/stalker-lists/id/users") else {
        throw RequestError.invalidURL
    }
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    let data = try JSONEncoder().encode(user)
    request.httpBody = data
    
    do {
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard (200...299) ~= (response as? HTTPURLResponse)!.statusCode else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            print("Error adding user to stalker list. HTTP status code: \(code)")
            
            
            
            
            throw RequestError.unexpectedStatusCode
        }
    } catch {
        print("Error adding user to stalker list: \(error)")
        throw error
    }
}

