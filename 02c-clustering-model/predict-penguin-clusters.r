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
    "input1": [
      {
        "CulmenLength": 39.1,
        "CulmenDepth": 18.7,
        "FlipperLength": 181,
        "BodyMass": 3750
      },
      {
        "CulmenLength": 49.1,
        "CulmenDepth": 14.8,
        "FlipperLength": 220,
        "BodyMass": 5150
      },
      {
        "CulmenLength": 46.6,
        "CulmenDepth": 17.8,
        "FlipperLength": 193,
        "BodyMass": 3800
      }
    ]
  },
  "GlobalParameters": {}
}')

requestBody = enc2utf8(toJSON(req))
# Replace this with the primary/secondary key or AMLToken for the endpoint
api_key = "M1gLyZLNLy3G4TZkjdhU3GiA2gQOlFhT"
if (api_key == "" || !is.character(api_key))
{
    stop("A key should be provided to invoke the endpoint")
}
authz_hdr = paste('Bearer', api_key, sep=' ')

h$reset()

# The azureml-model-deployment header will force the request to go to a specific deployment.
# Remove this header to have the request observe the endpoint traffic rules
curlPerform(
    url = "http://6e15fd5b-0cc6-4e25-80df-f6b82b2a5ae7.eastus.azurecontainer.io/score",
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