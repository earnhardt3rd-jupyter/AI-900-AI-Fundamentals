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
        "PatientID": 1882185,
        "Pregnancies": 9,
        "PlasmaGlucose": 104,
        "DiastolicBloodPressure": 51,
        "TricepsThickness": 7,
        "SerumInsulin": 24,
        "BMI": 27.36983156,
        "DiabetesPedigree": 1.3504720469999998,
        "Age": 43
      },
      {
        "PatientID": 1662484,
        "Pregnancies": 6,
        "PlasmaGlucose": 73,
        "DiastolicBloodPressure": 61,
        "TricepsThickness": 35,
        "SerumInsulin": 24,
        "BMI": 18.74367404,
        "DiabetesPedigree": 1.074147566,
        "Age": 75
      },
      {
        "PatientID": 1228510,
        "Pregnancies": 4,
        "PlasmaGlucose": 115,
        "DiastolicBloodPressure": 50,
        "TricepsThickness": 29,
        "SerumInsulin": 243,
        "BMI": 34.69215364,
        "DiabetesPedigree": 0.7411599259999999,
        "Age": 59
      }
    ]
  },
  "GlobalParameters": {}
}')

requestBody = enc2utf8(toJSON(req))
# Replace this with the primary/secondary key or AMLToken for the endpoint
api_key = "PWLVKbkXLWEP95G9pdcbeyNTPs8S0ovM"
if (api_key == "" || !is.character(api_key))
{
    stop("A key should be provided to invoke the endpoint")
}
authz_hdr = paste('Bearer', api_key, sep=' ')

h$reset()

# The azureml-model-deployment header will force the request to go to a specific deployment.
# Remove this header to have the request observe the endpoint traffic rules
curlPerform(
    url = "http://c37b8afb-3fa2-4277-89d3-b38c58b47285.eastus.azurecontainer.io/score",
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