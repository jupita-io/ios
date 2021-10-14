# Jupita iOS SDK

This SDK is developed for iOS using Swift 5.4, and utilizes `URLSession` in order to create the required API call requests. This library will allow you to make the required `dump` API calls with Jupita. API call is made asynchronously, thus there are event listeners available to handle the API results.

## Overview
Jupita is an API product that provides deep learning powered touchpoint analytics. Within the SDK documentation, `type` refers to which user the utterance is from. `type` 0 = `touchpoint`, and `type` 1 = `input`, although these labels are handled by the SDK.

The required parameters for the APIs include setting `type`, along with assigning an `touchpointID` + `inputID` to be passed - how this is structured or deployed is completely flexible and customizable. Please note when assigning the `touchpointID` that no data will be available for that particular touchpoint until the touchpoint has sent at least 1 utterance via the `dump` API. 

## APIs
There is one API within the Jupita product – `dump`:

- `dump` allows you to dump each communication utterance.

### Quickstart

#### Step 1

Right Click on project name in the `Project Navigator` pane and select `Add Files to` option. Select the SDK folder `Jupita.framework` and make sure to keep `Copy items if needed` selected while adding. Then click on project name under the `Targets` and select  `General` tab. Go to `Frameworks, Libraries, and Embedded Content` section, verify the framework is added correctly and make sure `Embed & Sign` option is selected.

#### Step 2

Import the Jupita.framework into your class.

#### Step 3

Build Jupita, in the example below '2' has been used to represent the `touchpointID`

```
let token:String = “authentication token”; 
let jupita = Jupita(token, "2")
```

#### Step 4

Call the `dump` API as a message from Jupita by specifying the `type` and `touchpointID` – represented as '3' below;

```
jupita.dump(text: "Hello", inputID: "3", type: jupita.TOUCHPOINT) { (result) -> Void in
      switch result {
      case .success(let json):
        debugPrint(json)
        break
      case .failure(let error):
        debugPrint(error)
        break
      }
    }
```

Similarly, call the `dump` API whenever input responds back to the same touchpoint by specifying the `type` and `inputID`;


```
jupita.dump(text: "Hello", inputID: "3", type: jupita.INPUT) { (result) -> Void in
      switch result {
      case .success(let json):
        debugPrint(json)
        break
      case .failure(let error):
        debugPrint(error)
        break
      }
    }
```

The parameter `isCall` is required and set to false within the SDK. This tells Jupita whether or not the utterance is from an audio call. When dumping an utterance from an audio call, set the `isCall` parameter to `true`;

```
jupita.dump(text: "Hello", inputID: "3", type: jupita.TOUCHPOINT, true) { (result) -> Void in
      switch result {
      case .success(let json):
        debugPrint(json)
        break
      case .failure(let error):
        debugPrint(error)
        break
      }
    }
```

### Error handling

The SDK throws one error, which occurs if the user input is not JSON compatible. This can be incorrect usage of strings when passed on to the Jupita methods. This error may also arise if the `type` set in the dump method is not 1 or 0.

### Error codes 

Error codes thrown are 401 when the token is incorrect.

### Libraries

Use Step 1 and 2 so that the Jupita Swift SDK is available within the scope of the project. Currently the Jupita Swift SDK is dependent on `URLSession`.

### Classes

The available product under the Swift SDK is Jupita. Jupita can be constructed directly using the public constructor however it is highly recommended to use the `Jupita` class to build the product. This will ensure that mistakes are not made while building the Jupita Swift SDK.

```
let token:String = “your-token”; 
let jupita = Jupita(token, "2")
```


This is needed for building the `URLSession` request. Next the token and touchpointID needs to be set.
Jupita can now be used to call `dump` methods asynchronously. The definitions for the `dump` methods are as follows;

```
public func dump(text: String, inputID: String, type: Int, isCall: Bool, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?)
 
public func dump(text: String, inputID: String, type: Int, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?)
 
public func dump(text: String, inputID: String, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?)
 
public func dump(text: String, inputID: String) 
```

If the values of `type` and `isCall` are not provided by default the values are considered `0` and `false`. Thus `text` and the `inputID` are essential when creating a dump request. To avoid illegal argument error use `jupita.TOUCHPOINT` or `jupita.INPUT` for `type`.

### Notes

`completionHandler` is a callback which needs to be implemented to listen to the results of the API request. It will return the success message as well as the utterance rating as a double.
