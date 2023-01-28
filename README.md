# Torium-Flutter

General description of project can be found here:
[TORIUM-Torium-generalinfo-280123-0718.pdf](https://github.com/ArtCie/Torium-Flutter/files/10526567/TORIUM-Torium-generalinfo-280123-0718.pdf)

## Project dependencies:
```
dependencies:
  flutter:
    sdk: flutter
  quickalert: ^1.0.0
  amplify_flutter: <1.0.0
  amplify_auth_cognito: <1.0.0
  amplify_authenticator: ^0.2.0
  flutter_spinkit: ^5.1.0
  http: ^0.13.5
  intl_phone_field: ^3.1.0
  phone_number: ^1.0.0
  shared_preferences: ^2.0.15
  code_input: ^2.0.0
  firebase_core: ^2.1.1
  badges: ^2.0.3
  intl: ^0.17.0
  dropdown_button2: ^1.8.9
  string_extensions: ^0.6.4
  table_calendar: ^2.2.1
  cupertino_icons: ^1.0.2
  firebase_messaging: ^14.0.3
  flutter_local_notifications: ^12.0.3
  url_launcher: ^6.1.6
  ```
  Dependencies can be installed by:
  ```
  flutter pub get
  ```
  
## Data fetch - BE
Files located under lib/api includes classes to fetch data from Backend.
Data flow for fetching data from Backend:

<img width="499" alt="Screenshot 2023-01-28 at 09 23 46" src="https://user-images.githubusercontent.com/72509444/215255544-be090d96-fe45-412c-907c-e0085358356f.png">


## Authentication
Process of authentication is configured using AWS Cognito User Pool + integration using AWS Amplify + flutter dependencies:

```
  amplify_flutter: <1.0.0
  amplify_auth_cognito: <1.0.0
  amplify_authenticator: ^0.2.0
```
Configuration of Amplify within Flutter project:

```
flutter pub get
amplify init
amplify add auth
amplify push
```
Configuration class for Cognito and Amplify can be found under lib/authentication/amplify.dart

## Integration of Authentication module with Backend
### Registration
While registration - app is integrated with preSignUp and postConfirmation Lambda triggers that save/confirm user in Relational Database.
Dataflow for registration process:
<img width="961" alt="Screenshot 2023-01-28 at 09 43 53" src="https://user-images.githubusercontent.com/72509444/215256389-12c5f55d-922f-4d5f-b121-4cb1f6a44a5e.png">

<img width="828" alt="Screenshot 2023-01-28 at 09 44 27" src="https://user-images.githubusercontent.com/72509444/215256437-af4dbe11-237e-4943-94b7-6bc612881faf.png">

### Login
After providing email + password user is redirected to main page.

<img width="774" alt="Screenshot 2023-01-28 at 09 48 56" src="https://user-images.githubusercontent.com/72509444/215256657-3282971a-20f4-4183-bc68-59dcd264042a.png">

