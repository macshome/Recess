import Foundation
import PlaygroundSupport

// Need this for the async methods.
PlaygroundPage.current.needsIndefiniteExecution = true

// This playground works if you have the MicroMDM SCEP palyground running locally.
let kServerString = "http://127.0.0.1:9001/scep"

//let kServerString = "https://adfs.nomad.menu/certsrv/mscep/mscep.dll"
typealias GetCACapsReply = ([String], HTTPURLResponse)
let requiredCaps = ["POSTPKIOperation", "Renewal", "SHA-512", "SHA-256", "SHA-1", "DES3"]

// Extension to add a result type to URLSession
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

// An easy way to build the 4 different queries that are required for SCEP.
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

// Simple SCEP client
class SCEPclient {
    let baseURL: URLComponents
    var caCert: SecCertificate?
    var isCAtrusted = true

    init?(server: String) {
        guard let serverURL = URL(string: server),
            let baseURL = URLComponents(url: serverURL, resolvingAgainstBaseURL: false) else {
                return nil
        }
        self.baseURL = baseURL
    }

    // This is the first thing we do for a SCEP client. Need to make sure the CA supports it with the
    // "SCEPStandard" capability.
    func getCACaps(_ handler: @escaping (Bool) -> Void) {
        var capsQuery = baseURL
        capsQuery.queryItems = SCEPRequest(operation: .getCACaps).query
        guard let capsURL = capsQuery.url else {
            handler(false)
            return
        }
        URLSession.shared.dataTask(with: capsURL) {data, response, error in
            if let error = error {
                print(error.localizedDescription)
                handler(false)
                return
            }

            guard let data = data,
                let caps = String(data: data, encoding: .utf8),
                let response = response as? HTTPURLResponse else {
                print("Something smells stupid here.")
                return
            }
            let capsArray = caps.components(separatedBy: .newlines)
            handler(self.evaluateCaps((capsArray, response)))
            return
        }.resume()
    }

    func evaluateCaps(_ caps: GetCACapsReply) -> Bool {
        if caps.0.contains("SCEPStandard") {
            return true
        }

        if let serverType = caps.1.value(forHTTPHeaderField: "Server"),
            serverType.contains("Microsoft-IIS"), caps.0.contains("POSTPKIOperation")  {
            return true
        }

        return false
    }

    // If the CA supports SCEP, we can then use this operation to fetch the CA Certificate.
    func getCACert(_ handler: @escaping (Data) -> Void) {
        var certQuery = baseURL
        certQuery.queryItems = SCEPRequest(operation: .getCACert).query
        guard let certURL = certQuery.url else {
            return
        }
        URLSession.shared.dataTask(with: certURL) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let certData = data,
                let response = response as? HTTPURLResponse else {
                print("Something smells stupid here.")
                    return
            }

            print(response.allHeaderFields)
            self.caCert = self.extractCACert(derData: certData)
            handler(certData)
            return

        }.resume()
    }

    // A simple way to extract the certificate from the DER data.
    func extractCACert(derData: Data) -> SecCertificate? {
        // Convert and return the DER as a SecCertificate
        guard let cert =  SecCertificateCreateWithData(nil, derData as CFData) else {
            return nil
        }

        return cert
    }

    // Create a trust object and evaluate the certificate.
    //
    // In order for the certificate to be trusted the Root CA must be installed on the system
    // or part of the certificate chain array we are going to evaluate.
    func validateCACert(cert: SecCertificate) -> Bool {
        // Create a certificate chain
        let certChain = [cert]

        // Get the default trust policy
        let policy = SecPolicyCreateBasicX509()

        // Create a trust objuct from the policy and chain
        var optionalTrust: SecTrust?
        let status = SecTrustCreateWithCertificates(certChain as AnyObject,
                                                    policy,
                                                    &optionalTrust)
        guard status == errSecSuccess else { return isCAtrusted }
        let trust = optionalTrust!

        // Using the sync method for the playground example. In real code use the async version.
        // In real use you need to use the async so that you don't block the main thread while
        // looking up certificate chains.
        //
        // I'm also not checking the error here.
        isCAtrusted =  SecTrustEvaluateWithError(trust, nil)

        //In real code use this version!
        // Evaluate the trust
        //        DispatchQueue.global().async {
        //            SecTrustEvaluateAsyncWithError(trust, DispatchQueue.global()) {
        //                trust, result, error in
        //
        //                if result {
        //                    // Its trusted so we can use the public key
        //                    let publicKey = SecTrustCopyPublicKey(trust)
        //                    self.isCAtrusted = true
        //
        //
        //                } else {
        //                    // Not trusted!
        //                    self.isCAtrusted = false
        //                    print("Trust failed: \(error!.localizedDescription)")
        //                }
        //            }
        //        }

        return isCAtrusted
    }
}

//Create a client
let client = SCEPclient(server: kServerString)

//Check the CACaps of the server
client?.getCACaps() { supported in
    if supported {
        print("This is a scep server")
    }
}

//Get and validate the certificate of the CA
client?.getCACert() { certData in
    if let cert = client?.extractCACert(derData: certData) {
        let summary = SecCertificateCopySubjectSummary(cert)! as String
        print(summary)
        client?.validateCACert(cert: cert)
    }
}



