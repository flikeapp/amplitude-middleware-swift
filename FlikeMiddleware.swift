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
    var data: [String: NSMutableDictionary]
    guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
        print("[FLIKE] Error when converting JSON")
        return Data()
    }
    return jsonData
}




// makeFlikeMiddleware constructs the AmplitudeMiddleware that sends the Amplitude Event to Flike's Server.
func makeFlikeMiddleware(customerId: String, key: String) -> AMPBlockMiddleware {
    // create the Middleware handler
    let loggingMiddleware = AMPBlockMiddleware
        { (payload, next) in
            // send raw data off to flike backend
            let requestString = "https://ingest.flike.app/amplitude/\(customerId)"
            let requestUrl = URL(string: requestString)
            if requestUrl == nil {
                print("[FLIKE] URL creation error")
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
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    // TODO: retry with backoff like gtm.js
                    return
                }
                // Request will time out! Ignore
            }
            // make dataTask go
            dataTask.resume()
            // Continue to next middleware
            next(payload);
        }
    return loggingMiddleware
}
