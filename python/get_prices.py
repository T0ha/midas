#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import date
from pandas.core.dtypes.dtypes import re
from pycoingecko import CoinGeckoAPI
import pandas as pd

DATE = "2022-11-18"

cg = CoinGeckoAPI()
ticker_ids = {}

def main(coins):
    day = date.fromisoformat(DATE)
    data = pd.DataFrame(index=[day.isoformat()])

    ids = cg.get_coins_list()

    for id in ids:
        if id['symbol'].upper() in ticker_ids:
            ticker_ids[id['symbol'].upper()].append(id['id'])
        else:
            ticker_ids[id['symbol'].upper()] = [id['id']]

    for coin in coins:
        print(coin)
        prices = get_ticker_price_for_date(coin, day)
        series = pd.DataFrame(prices, index=[day.isoformat()], columns=prices.keys())
        #print(series)
        data = data.join(series)
        
    print(data)
    data.to_csv("../../data/stat/prices_{}.csv".format(DATE))

def get_ticker_price_for_date(ticker, d):
    data = {}
    try:
        for coin in ticker_ids[ticker]:
            print(coin)
            price =  get_coin_price_for_date(coin, d)
            print(price)
            data['{} ({})'.format(ticker, coin)] = price
    except KeyError:
        data['{}'.format(ticker)] = pd.NA
    return data

def get_coin_price_for_date(coin, d):
        try:
            cd = cg.get_coin_history_by_id(coin, d.strftime("%d-%m-%Y"))
            #print(cd)
            return cd['market_data']['current_price']['usd']
        except KeyError:
            return pd.NA

if __name__ == "__main__":
    csv = pd.read_csv("../../data/stat/stat/Prices-Prices USD.csv", parse_dates=True, index_col='Asset', sep=';', decimal=',')
    print(csv)
    main(csv.columns)

        
    

