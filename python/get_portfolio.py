#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import date
from settings import API_KEY, SECRET
from binance.spot import Spot as Client
import pandas as pd


def main():
    client = Client(API_KEY, SECRET)

    portfolio = client.account()
    print(portfolio)
    portfolio_pd = pd.DataFrame(portfolio['balances'], dtype='float')
    portfolio_pd = portfolio_pd.set_index(portfolio_pd['asset'])
    print(portfolio_pd.loc[(portfolio_pd['free'] != 0)])

if __name__ == "__main__":
    main()
