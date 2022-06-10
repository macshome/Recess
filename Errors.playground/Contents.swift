import Foundation

enum CertificateUtilityError: Error {
    case noLocalCertificateFound
    case certificateExpired
    case noKerberosTickets
    case invalidURL
    case sslError
    case noCADefaultsSet
    case caIssuingError
    case unknownError
}

extension CertificateUtilityError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noCADefaultsSet:
            return "No default CA was set in the preferences."
        case .unknownError:
            return "Something unknown happened"
        case .noLocalCertificateFound:
                        return "No existing local certificate was located."
        case .certificateExpired:
                        return "The existing local certificate for the user is expired."
        case .noKerberosTickets:
                        return "No TGT for the user is present so we can't request a certificate yet."
        case .invalidURL:
                        return "Could not create a valid URL from the passed in preference."
        case .sslError:
                        return "A SSL error occured when connecting to the CA. Make sure that you have trusted the root cert of the CA."
        case .caIssuingError:
                        return "The CA returned an error when we tried to get a certificate."
        }
    }
}


print("error: " + CertificateUtilityError.noCADefaultsSet.localizedDescription)

