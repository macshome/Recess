import Cocoa
import Vision


let loginScreenURL = Bundle.main.url(forResource: "Loginscreen", withExtension: "png")
let remindersURL = Bundle.main.url(forResource: "Reminders", withExtension: "png")
let azureBaseURL = Bundle.main.url(forResource: "AzureBase", withExtension: "png")

let loginRequestHandler = VNImageRequestHandler(url: loginScreenURL!)
let remindersRequestHandler = VNImageRequestHandler(url: remindersURL!)
let azureRequestHandler = VNImageRequestHandler(url: azureBaseURL!)

var rectangleDetectionRequest: VNDetectRectanglesRequest = {
    let rectDetectRequest = VNDetectRectanglesRequest(completionHandler: handleObservations)
    // Customize & configure the request to detect only certain rectangles.
    //        rectDetectRequest.maximumObservations = 8 // Vision currently supports up to 16.
            rectDetectRequest.minimumConfidence = 0.6 // Be confident.
    return rectDetectRequest
}()

let featurePrintRequest = VNGenerateImageFeaturePrintRequest(completionHandler: handleObservations)
let textDetectionRequest = VNRecognizeTextRequest(completionHandler: handleObservations)

func handleObservations(request: VNRequest?, error: Error?) {
    guard let results = request?.results as? [VNObservation], !results.isEmpty else {
        return
    }

    if results.first!.isKind(of: VNFeaturePrintObservation.self) {
        results.compactMap { observation in
            let featurePrint = observation as? VNFeaturePrintObservation
            let count = featurePrint?.elementCount
            var score = Float(0)
            try! featurePrint?.computeDistance(&score, to: featurePrint!)
            print("Score: \(score)")
        }
    }

    if results.first!.isKind(of: VNRecognizedTextObservation.self) {
        results.compactMap { observation in
            let textObs = observation as? VNRecognizedTextObservation
            let text = textObs?.topCandidates(1).first?.string
            let boundingBox = textObs?.boundingBox
            let coords = VNImageRectForNormalizedRect(boundingBox!, 2880, 1800)
            print("text detected: \"\(text!)\" \nconfidence: \(String(describing: textObs!.confidence))\nCoordinates: \(coords.debugDescription)\n")
        }
        return
    }
    print(results)
}

try! loginRequestHandler.perform([rectangleDetectionRequest])
//try! remindersRequestHandler.perform([featurePrintRequest])
//try! azureRequestHandler.perform([rectangleDetectionRequest, textDetectionRequest])
