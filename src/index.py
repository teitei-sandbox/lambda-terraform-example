import os
import sys
import requests
from bs4 import BeautifulSoup


def lambda_handler(event: dict, context):
    response = requests.get("http://example.com/")
    bs = BeautifulSoup(response.text)
    return bs.title.name
