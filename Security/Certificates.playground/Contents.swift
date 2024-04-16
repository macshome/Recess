//: Playground - noun: a place where people can play

import Foundation

let fileURL = URL(fileURLWithPath: "/Users/joshwisenbaker/Desktop/cert.cer")
let certificateData = try Data(contentsOf: fileURL) as CFData
let certificate = SecCertificateCreateWithData(nil, certificateData)
let subject = SecCertificateCopySubjectSummary(certificate!)
let pkhOID = SecCertificateCopyValues(certificate!, [kSecOIDX509V1SubjectPublicKey] as CFArray, nil) as! [String: Any]
let pkh = SecCertificateCopyKey(certificate!)!
let cfd = SecKeyCopyAttributes(pkh)!


