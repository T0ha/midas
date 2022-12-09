#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import date, datetime
from pycoingecko import CoinGeckoAPI
from sqlalchemy import create_engine
import pandas as pd

import os

db_url = 'postgresql://{}:{}@{}:{}/{}'.format(
    os.environ.get('POSTGRES_USER', 'postgres'),
    os.environ.get('POSTGRES_PASSWORD', 'postgres'),
    os.environ.get('POSTGRES_HOST', 'localhost'),
    os.environ.get('POSTGRES_PORT', '5432'),
    os.environ.get('POSTGRES_DB', 'portfolio_dev'),
)

engine = create_engine(db_url, echo=False)

cg = CoinGeckoAPI()

def main():
    day = date.today()
    data = pd.DataFrame(index=[day.isoformat()])
    with engine.begin() as connection:
        coins = pd.read_sql_query("""SELECT id, gecko_id FROM assets WHERE "fetch" """, connection, index_col='id')
        print(coins)


    for coin in coins.iterrows():
        #print(coin[1])
        prices = get_coin_price_for_date(coin[1].gecko_id, day)
        #print(prices)
        series = pd.DataFrame.from_dict(prices, orient='index', columns=['price'], dtype=float)
        series = series.assign(asset_id=coin[0], date=day, currency=series.index, inserted_at=datetime.now(), updated_at=datetime.now())
        print(series)
        with engine.begin() as connection:
            series.to_sql('prices', connection, if_exists='append', index=False)

def get_coin_price_for_date(coin, d):
        try:
            cd = cg.get_coin_history_by_id(coin, d.strftime("%d-%m-%Y"))
            #print(cd['market_data'])
            return cd['market_data']['current_price']
        except KeyError:
            return pd.NA

if __name__ == "__main__":
    main()

        
    

