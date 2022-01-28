# Jupita Swift SDK
This SDK is developed for iOS using Swift 5.4 and utilizes `URLSession` in order to create the required API call requests. This library will allow you to make the required `dump` API calls with Jupita. API call is made asynchronously, thus there are event listeners available to handle the API results.


## Overview
Jupita is an API product that provides omnichannel communications analytics. Within the SDK documentation, `type` refers to which user the utterance is from. `type` 0 = `TOUCHPOINT` and `type` 1 = `INPUT` although these labels are handled by the SDK.

The required parameters for the APIs include setting `type` along with assigning a `touchpointID` + `inputID` to be passed. Please note when assigning the `touchpointID` that no data will be available for that particular touchpoint until the touchpoint has sent at least 1 utterance via the `dump` API. 

You may set any `TOUCHPOINT` or `INPUT` ID format within the confines of JSON. How this is structured or deployed is completely customisable, for example, you may wish to use full names for users from your database, or you may wish to apply sequencing numbers for `INPUT` users where the user is not known. 

`TOUCHPOINT` & `INPUT` IDs must be unique to that user. When dumping an initial `TOUCHPOINT` utterance where there is no `INPUT` user, such as creating a new Twitter post, simply pass a nominal `inputID` each time, such as '0' for example.

## APIs
There is one API within the Jupita product – `dump`:

- `dump` allows you to dump each utterance.


## Quickstart
### Step 1
Right Click on project name in the `Project Navigator` pane and select `Add Files to` option. Select the SDK folder `Jupita.framework` and make sure to keep `Copy items if needed` selected while adding. Then click on project name under the `Targets` and select  `General` tab. Go to `Frameworks, Libraries, and Embedded Content` section, verify the framework is added correctly and make sure `Embed & Sign` option is selected.


### Step 2
Import the Jupita.framework into your class.


### Step 3
Build Jupita. Insert your API key as the token as well as a touchpoint user ID. In the example below '2' represents the touchpoint_id;

```
let token = "your-authentication-token"
let jupita = Jupita(token, "2")
```

### Step 4
Dump an utterance from a touchpoint by calling the dump API as a message by specifying the message text and the ID of the input, represented in the example below as '3'. 

The parameter `isCall` is required and set to false by default. This tells Jupita if the utterance is from an audio call. When dumping an utterance from an audio call, set the `isCall` parameter to `true` otherwise set to `false`;

```
jupita.dump(text: "Hi, how are you?", inputID: "3", type: jupita.TOUCHPOINT, isCall: false) { (result) -> Void in
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

Similarly, call the dump API whenever dumping an utterance from an input by specifying the message text and ID of the input;

```
jupita.dump(text: "Hi, good thanks!", inputID: "3", type: jupita.INPUT, isCall: false) { (result) -> Void in
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

## Error handling
- `JSONException` which occurs if the user input is not JSON compatible. This can be incorrect usage of strings when passed on to the Jupita methods.
- `IllegalArgumentException` which occurs if the `type` set in the dump method is not 1 or 0.
- A 401 error code is thrown when the token is incorrect, otherwise Jupita returns error 400 with details.


## Libraries
Use Step 1 and 2 so that the Jupita Swift SDK is available within the scope of the project. Currently the Jupita Swift SDK is dependent on `URLSession`.


## Classes
The available product under the Swift SDK is Jupita. Jupita can be constructed directly using the public constructor however it is highly recommended to use the `Jupita` class to build the product. This will ensure that mistakes are not made while building the Jupita Swift SDK.

```
let token = “your-authentication-token”; 
let jupita = Jupita(token, "2")
```


## `dump` method definitions
This is needed for building the `URLSession` request. Next the token and touchpointID needs to be set. Jupita can now be used to call `dump` methods asynchronously. The definitions for the `dump` methods are as follows;

```
public func dump(text: String, inputID: String, type: Int, isCall: Bool, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?)
 
public func dump(text: String, inputID: String, type: Int, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?)
 
public func dump(text: String, inputID: String, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?)
 
public func dump(text: String, inputID: String) 
```

If the values of `type` and `isCall` are not provided the values are considered as `jupita.TOUCHPOINT` and `false` by default. Thus `text` and the `inputID` are essential when creating a dump request. To avoid illegal argument error use `jupita.TOUCHPOINT` or `jupita.INPUT` for `type`.

`completionHandler` is a callback which needs to be implemented to listen to the results of the API request. It will return the success message as well as the utterance rating as a double.

## Support
If you require additional support please contact support@jupita.io
