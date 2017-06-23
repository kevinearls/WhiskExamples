Create some simple Whisk actions based on the documentation here: https://github.com/apache/incubator-openwhisk/blob/master/docs/actions.md

# How to run the Java action #
wsk action delete helloJava
mvn clean package
wsk action create helloJava target/whiskexamples-1.0-SNAPSHOT.jar --main Hello
wsk action invoke --result helloJava --param name FRED

# How to run the Swift action
cd src/main/script
wsk action delete helloSwift
wsk action create helloSwift src/main/swift/hello.swift
wsk action invoke --result helloSwift --param name World


# How to run the javascript example
cd src/main/javascript
wsk package create demo
wsk action create /guest/demo/hello hello.js --web true
--> set APIHOST from the value in ~/.wskprops
curl ${APIHOST}/api/v1/web/guest/demo/hello.http
curl ${APIHOST}/api/v1/web/guest/demo/hello.http?name=Zoidberg

