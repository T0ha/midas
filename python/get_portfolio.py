#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import date
from binance.spot import Spot as Client
import pandas as pd

API_KEY = "wbG3iHSZiOAoEh0K5T5ZQ9RFBgVQdSHTXOcd4WumMNYaGdDytNf0RZvfoU2DPm9C"
SECRET = "o8Q6Sy1Ioi3MoLwcKR7DUMKzLYlV2sgEyRYoY1ZdSK9wNCrGEm0HTFu5lKqUytli"

def main():
    client = Client(API_KEY, SECRET)
    #await client.load()

    portfolio = client.account()
    print(portfolio)
    portfolio_pd = pd.DataFrame(portfolio['balances'])
    portfolio_pd = portfolio_pd.set_index(portfolio_pd['asset'])
    print(portfolio_pd.loc[(portfolio_pd['free'] != 0)])
    #await client.close()

if __name__ == "__main__":
    main()
