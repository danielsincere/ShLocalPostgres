# ShLocalPostgres

Commands for setting up local Postgres databases. Pairs well with [Sh](https://github.com/FullQueueDeveloper/Sh) & [Swish](https://github.com/FullQueueDeveloper/Swish)!


## Example

```swift
let config = LocalPostgres(role: "fqauth",
                           password: "FQAuthPassword123",
                           databaseStem: "fqauth",
                           databaseTails: ["development", "testing"])
```

then

```swift
try config.createAll() // Will create "fqauth_development" & "fqauth_testing"                                             
```
or
```swift
try config.destroyAll() // Will destroy "fqauth_development" & "fqauth_testing"    
```

## Getting started

In your `Package.swift`
```swift
  dependencies: [
    // ...
    .package(url: "https://github.com/FullQueueDeveloper/ShLocalPostgres.git", from: "0.1.0"),
```

And then in the target's dependencies:
```swift
  dependencies: [
      // ...
      "ShLocalPostgres"
  ]
```
