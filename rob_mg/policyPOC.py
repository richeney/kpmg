from msrestazure.azure_active_directory import AADTokenCredentials
from azure.mgmt import policyinsights
import sys 
import json
import logging
import azure
import requests
import msal
import adal


class MSALClient:
    def __init__(self, client_id, secret):
        self.url = "https://login.microsoftonline.com/"
        self.client_id = client_id
        self.secret = secret

    def authenticate(self, tenant_id, scope):
        app = msal.ConfidentialClientApplication(self.client_id, authority=self.url + tenant_id, client_credential=self.secret)
        token = None
        token = app.acquire_token_silent(scope, account=None)
        if not token:
            logging.info("No suitable token exists in cache. Retriving new one")
            token = app.acquire_token_for_client(scopes=scope)
            print(token)
        return AADTokenCredentials(token, self.client_id)

class ADALClient:
    def __init__(self, client_id, secret):
        self.url = "https://login.microsoftonline.com/"
        self.client_id = client_id
        self.secret = secret

    def authenticate(self, tenant_id, scope):
        app = adal.AuthenticationContext(authority=self.url + tenant_id)
        token = None
        token = app.acquire_token_with_client_credentials(scope, self.client_id, self.secret)
        print(token)
        return AADTokenCredentials(token, self.client_id)

def load_config():
    config = json.load(open("parameters.json"))
    # check for client_id exists ect here
    return config

config = load_config()
client = ADALClient(config["client_id"], config["secret"])

mngmt_creds = client.authenticate(config["tenant_id"], config["management_scope"])

policy_client = policyinsights.PolicyInsightsClient(mngmt_creds)

output = policy_client.policy_states.list_query_results_for_management_group("default", "DevSecOps")

print(output)

