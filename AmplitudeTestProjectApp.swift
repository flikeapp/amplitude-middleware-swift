//
//  AmplitudeTestProjectApp.swift
//  AmplitudeTestProject
//
//  Created by Jannek Ulm on 03.06.22. for Flike
//

import SwiftUI
import Amplitude

@main
struct AmplitudeTestProjectApp: App {
    
    init() {
        
        // Set up Amplitude Environment
        Amplitude.instance().trackingSessionEvents = true
        // Initialize SDK
        Amplitude.instance().initializeApiKey("your amplitude api key")
        // Set userId
        Amplitude.instance().setUserId("userId")
        // get FlikeMiddleware
        let flikeMiddleWare = makeFlikeMiddleware(keyId: "yourFlikeKeyId", key: "yourFlikeKey")
        // add the Middleware
        Amplitude.instance().addEventMiddleware(flikeMiddleWare)
        
        // Sample log of 2 events
        // Log an event
        Amplitude.instance().logEvent("app_start")
        // Log an event with extra properties
        Amplitude.instance().logEvent("extra event with payload", withEventProperties: ["bool1": true,"bool2": false,"bool3": true])
    }
    
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }
}
