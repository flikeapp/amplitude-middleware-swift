# Swift-Amplitude-Middleware

## Usage

In your app's initialisation, add the following lines after instantiating
Amplitude:

``` swift
// ...
// your amplitude initialisation may look something like this:
Amplitude.instance().trackingSessionEvents = true
Amplitude.instance().initializeApiKey("your amplitude api key")
Amplitude.instance().setUserId("userId")

// add this to initialise Flike
let flikeMiddleWare = makeFlikeMiddleware(customerId: "<your Flike customer ID>", key: "<your Flike public API key>")
Amplitude.instance().addEventMiddleware(flikeMiddleWare)
```

