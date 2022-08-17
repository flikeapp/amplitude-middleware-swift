//
//  FlikeMiddleware.swift
//  AmplitudeTestProject
//
//  Created by Jannek Ulm on 03.06.22.
//

import Foundation
import Amplitude


// convertyPayload converts Middleware Payload (event,extra) into JSON Dictionary Data
func convertPayload(event: NSMutableDictionary,extra: NSMutableDictionary?) -> Data {
    // convert to JSON ....
    print("converting event JSON")
    var data: [String: NSMutableDictionary]
    if extra != nil {
        print("event with extra")
        data = ["event": event, "extra": extra!]
    } else {
        print("event without extra")
        data = ["event": event]
    }
    guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
        print("Error when converting JSON")
        return Data()
    }
    print(jsonData)
    return jsonData
}




// makeFlikeMiddleware constructs the AmplitudeMiddleware that sends the Amplitude Event to Flike's Server.
func makeFlikeMiddleware(keyId: String, key: String) -> AMPBlockMiddleware {
    // create the Middleware handler
    let loggingMiddleware = AMPBlockMiddleware
        { (payload, next) in
            // Output event and extra from payload
            print("FlikeMiddleWare:")
            //let payload_string = String(format:"[ampli] event=\(payload.event) payload=\(String(describing: payload.extra))")
            //print(payload_string)
            // make http post request
            let requestString = "https://ingest.goflike.app/amplitude/\(keyId)"
            let requestUrl = URL(string: requestString)
            if requestUrl == nil {
                print("FlikeMiddleWare: URL creation error")
                /// Returns `nil` if a `URL` cannot be formed with the string (for example, if the string contains characters that are illegal in a URL, or is an empty string).
                return
            }
            var request = URLRequest(url: requestUrl!)
            // configute http request with headers etc
            request.httpBody = convertPayload(event: payload.event, extra: payload.extra)
            request.httpMethod = "POST"
            request.addValue(key, forHTTPHeaderField: "x-api-key")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // http response handler?
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                // print("FlikeMiddleware: handle response")
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    // print("FlikeMiddleware: HttpResponse error")
                    return
                }
                // Request will time out! Ignore
                //print("httpResponse.statusCode \(httpResponse.statusCode)")
                //print("FlikeMiddleware: handle response success")
            }
            // make dataTask go
            dataTask.resume()
            // Continue to next middleware
            next(payload);
        }
    return loggingMiddleware
}
