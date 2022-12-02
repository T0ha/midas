#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import date, datetime
from settings import API_KEY, SECRET
from binance.spot import Spot as Client
from sqlalchemy import create_engine
import pandas as pd

def main():
    day = date.today()
    engine = create_engine('postgresql://postgres:postgres@localhost:5432/portfolio_dev', echo=False)


    with engine.begin() as connection:
        coins = pd.read_sql_query("""SELECT id, ticker FROM assets WHERE "fetch" """, connection, index_col='ticker')
        print(coins)
    coins.index = coins.index.map(str.upper)

    client = Client(API_KEY, SECRET)

    portfolio = client.account()
    #print(portfolio)
    portfolio_pd = pd.DataFrame(portfolio['balances'], dtype='float')
    portfolio_pd = portfolio_pd.set_index(portfolio_pd['asset'])
    portfolio_pd = portfolio_pd.join(coins).dropna()
    portfolio_pd = portfolio_pd.convert_dtypes({'id': 'int'})
    portfolio_pd.rename({'id': 'asset_id'}, inplace=True, axis=1)
    #print(portfolio_pd)

    free = portfolio_pd.loc[(portfolio_pd['free'] != 0)][['asset_id', 'free']]
    free.columns = ['asset_id', 'amount']
    free = free.assign(date=day, wallet_id=2, locked=False, inserted_at=datetime.now(), updated_at=datetime.now())
    
    
    #print(free)
    
    with engine.begin() as connection:
        free.to_sql('balances', connection, if_exists='append', index=False)

    locked = portfolio_pd.loc[(portfolio_pd['locked'] != 0)][['asset_id', 'locked']]
    locked.columns = ['asset_id', 'amount']
    locked = locked.assign(date=day, wallet_id=2, locked=True, inserted_at=datetime.now(), updated_at=datetime.now())
    
    print(locked)
    
    with engine.begin() as connection:
        locked.to_sql('balances', connection, if_exists='append', index=False)


if __name__ == "__main__":
    main()
