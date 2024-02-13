library("RCurl")
library("rjson")

# Accept SSL certificates issued by public Certificate Authorities
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"), ssl.verifypeer = FALSE))

h = basicTextGatherer()
hdr = basicHeaderGatherer()

# Request data goes here
# The example below assumes JSON formatting which may be updated
# depending on the format your endpoint expects.
# More information can be found here:
# https://docs.microsoft.com/azure/machine-learning/how-to-deploy-advanced-entry-script
req = fromJSON('{
  "Inputs": {
    "WebServiceInput0": [
      {
        "symboling": 3,
        "normalized-losses": 1.0,
        "make": "alfa-romero",
        "fuel-type": "gas",
        "aspiration": "std",
        "num-of-doors": "two",
        "body-style": "convertible",
        "drive-wheels": "rwd",
        "engine-location": "front",
        "wheel-base": 88.6,
        "length": 168.8,
        "width": 64.1,
        "height": 48.8,
        "curb-weight": 2548,
        "engine-type": "dohc",
        "num-of-cylinders": "four",
        "engine-size": 130,
        "fuel-system": "mpfi",
        "bore": 3.47,
        "stroke": 2.68,
        "compression-ratio": 9,
        "horsepower": 111,
        "peak-rpm": 5000,
        "city-mpg": 21,
        "highway-mpg": 27
      },
      {
        "symboling": 3,
        "normalized-losses": 1.0,
        "make": "alfa-romero",
        "fuel-type": "gas",
        "aspiration": "std",
        "num-of-doors": "two",
        "body-style": "convertible",
        "drive-wheels": "rwd",
        "engine-location": "front",
        "wheel-base": 88.6,
        "length": 168.8,
        "width": 64.1,
        "height": 48.8,
        "curb-weight": 2548,
        "engine-type": "dohc",
        "num-of-cylinders": "four",
        "engine-size": 130,
        "fuel-system": "mpfi",
        "bore": 3.47,
        "stroke": 2.68,
        "compression-ratio": 9,
        "horsepower": 111,
        "peak-rpm": 5000,
        "city-mpg": 21,
        "highway-mpg": 27
      },
      {
        "symboling": 1,
        "normalized-losses": 1.0,
        "make": "alfa-romero",
        "fuel-type": "gas",
        "aspiration": "std",
        "num-of-doors": "two",
        "body-style": "hatchback",
        "drive-wheels": "rwd",
        "engine-location": "front",
        "wheel-base": 94.5,
        "length": 171.2,
        "width": 65.5,
        "height": 52.4,
        "curb-weight": 2823,
        "engine-type": "ohcv",
        "num-of-cylinders": "six",
        "engine-size": 152,
        "fuel-system": "mpfi",
        "bore": 2.68,
        "stroke": 3.47,
        "compression-ratio": 9,
        "horsepower": 154,
        "peak-rpm": 5000,
        "city-mpg": 19,
        "highway-mpg": 26
      }
    ]
  },
  "GlobalParameters": {}
}')

requestBody = enc2utf8(toJSON(req))
# Replace this with the primary/secondary key or AMLToken for the endpoint
api_key = "57xQkZuJa5t2rwRY6XR0Dlmlxqcxmqsl"
if (api_key == "" || !is.character(api_key))
{
    stop("A key should be provided to invoke the endpoint")
}
authz_hdr = paste('Bearer', api_key, sep=' ')

h$reset()

# The azureml-model-deployment header will force the request to go to a specific deployment.
# Remove this header to have the request observe the endpoint traffic rules
curlPerform(
    url = "http://96362ed6-ce48-461a-915d-b20494314f75.eastus.azurecontainer.io/score",
    httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
    postfields=requestBody,
    writefunction = h$update,
    headerfunction = hdr$update,
    verbose = TRUE
)

headers = hdr$value()
httpStatus = headers["status"]
if (httpStatus >= 400)
{
    print(paste("The request failed with status code:", httpStatus, sep=" "))

    # Print the headers - they include the request ID and the timestamp, which are useful for debugging the failure
    print(headers)
}

print("Result:")
result = h$value()
print(result)