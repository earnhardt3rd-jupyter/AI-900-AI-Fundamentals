import urllib.request
import json
import os
import ssl

def allowSelfSignedHttps(allowed):
    # bypass the server certificate verification on client side
    if allowed and not os.environ.get('PYTHONHTTPSVERIFY', '') and getattr(ssl, '_create_unverified_context', None):
        ssl._create_default_https_context = ssl._create_unverified_context

allowSelfSignedHttps(True) # this line is needed if you use self-signed certificate in your scoring service.

# Request data goes here
# The example below assumes JSON formatting which may be updated
# depending on the format your endpoint expects.
# More information can be found here:
# https://docs.microsoft.com/azure/machine-learning/how-to-deploy-advanced-entry-script
data =  {
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
}

body = str.encode(json.dumps(data))

url = 'http://6e15fd5b-0cc6-4e25-80df-f6b82b2a5ae7.eastus.azurecontainer.io/score'
# Replace this with the primary/secondary key or AMLToken for the endpoint
api_key = 'M1gLyZLNLy3G4TZkjdhU3GiA2gQOlFhT'
if not api_key:
    raise Exception("A key should be provided to invoke the endpoint")


headers = {'Content-Type':'application/json', 'Authorization':('Bearer '+ api_key)}

req = urllib.request.Request(url, body, headers)

try:
    response = urllib.request.urlopen(req)

    result = response.read()
    print(result)
except urllib.error.HTTPError as error:
    print("The request failed with status code: " + str(error.code))

    # Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
    print(error.info())
    print(error.read().decode("utf8", 'ignore'))