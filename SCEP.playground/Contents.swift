import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension URLSession {
    func dataTask(
        with url: URL,
        handler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: url) { data, _, error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(data ?? Data()))
            }
        }
    }
}

let kServerString = "http://adfs.nomad.menu/certsrv/mscep/mscep.dll"

protocol SCEPOperations {
    var server: SCEPServer { get set }

   func getCACaps()
}

class SCEPClient: SCEPOperations {

    var server: SCEPServer
    var caps: String?

    init?(withURL url: String) {
        guard let server = SCEPServer(server: url) else { return nil }
        self.server = server
    }

     func getCACaps() {
        guard var baseURL = URLComponents(url: server.url, resolvingAgainstBaseURL: false) else {
            return
        }

        baseURL.queryItems = SCEPRequest(operation: .getCACaps).query
        guard let serverURL = baseURL.url else { return }

        let task = URLSession.shared.dataTask(with: serverURL)  { data, response, error in
            if let error = error {

                print(error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                return
            }

            print(response.statusCode)

            if let data = data, let caps = String(data: data, encoding: .utf8) {
                self.caps = caps
            }
        }
        task.resume()
    }
}




class SCEPServer {
    let url: URL
    var capabilities: String?
    
    init?(server: String) {
        guard let server = URL(string: server) else {
            return nil
        }
        self.url = server
        self.getCaps()
    }

    func getCaps() {
        guard var baseURL = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }

        baseURL.queryItems = SCEPRequest(operation: .getCACaps).query
        guard let serverURL = baseURL.url else { return }

        URLSession.shared.dataTask(with: serverURL) { result in
            switch result {
            case .success(let data):
                if let string = String(data: data, encoding: .utf8) {
                    self.capabilities = string
                }
                return
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }.resume()

//        let task = URLSession.shared.dataTask(with: serverURL)  { data, response, error in
//            if let error = error {
//
//                print(error)
//                return
//            }
//            guard let response = response as? HTTPURLResponse else {
//                return
//            }
//
//            print(response.statusCode)
//
//            if let data = data, let string = String(data: data, encoding: .utf8) {
//                self.capabilities = string
//
//            }
//        }
//        task.resume()
    }
}

struct SCEPRequest {
    enum Operations: String, Equatable, CaseIterable {
        case getCACaps = "GetCACaps"
        case getCACert = "GetCACert"
        case pkiOperation = "PKIOperation"
        case getNextCACert = "GetNextCACert"
    }

    let operation: String
    let query: [URLQueryItem]
    let message: String?

    init(operation: Operations, message: String? = nil) {
        self.message = message
        self.operation = operation.rawValue
        let opQuery = URLQueryItem(name: "operation", value: self.operation)
        if message != nil {
            let messageQuery = URLQueryItem(name: "message", value: message)
            self.query = [opQuery, messageQuery]
        } else {
            self.query = [opQuery]
        }
    }
}

struct SCEPOperation {

    func getCACaps(_ server: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard var baseURL = URLComponents(url: server, resolvingAgainstBaseURL: false) else {
            return
        }

        baseURL.queryItems = SCEPRequest(operation: .getCACaps).query
        guard let serverURL = baseURL.url else { return }
        let task = URLSession.shared.dataTask(with: serverURL)  { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                print(error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                return
            }

            print(response.statusCode)

            if let data = data, let string = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    completion(.success(string))
                }
            }
        }
        task.resume()

    }
}



if var client = SCEPClient(withURL: kServerString) {
    client.server.url
    client.server.capabilities
}



