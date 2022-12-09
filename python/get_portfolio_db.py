#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import date, datetime

from settings import API_KEY, SECRET
from binance.spot import Spot as Client
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

def main():
    day = date.today()


    with engine.begin() as connection:
        coins = pd.read_sql_query("""SELECT id, ticker FROM assets WHERE "fetch" """, connection, index_col='ticker')
        print(coins)
    coins.index = coins.index.map(str.upper)

    client = Client(API_KEY, SECRET)

    # Binance Spot
    portfolio = client.account()
    #print(portfolio)
    portfolio_pd = to_df(portfolio['balances'], coins)
    portfolio_pd = portfolio_pd.set_index(portfolio_pd['asset'])
    #print(portfolio_pd)

    free = portfolio_pd.loc[(portfolio_pd['free'] != 0)][['asset_id', 'free']]
    free.columns = ['asset_id', 'amount']
    free = free.assign(date=day, wallet_id=2, user_id=1, locked=False, inserted_at=datetime.now(), updated_at=datetime.now())
    
    
    #print(free)
    
    save_db('balances', free)
    locked = portfolio_pd.loc[(portfolio_pd['locked'] != 0)][['asset_id', 'locked']]
    locked.columns = ['asset_id', 'amount']
    locked = locked.assign(date=day, wallet_id=2, user_id=1, locked=True, inserted_at=datetime.now(), updated_at=datetime.now())
    
    #print(locked)
    
    save_db('balances', locked)

    # Earn
    staking = client.staking_product_position("STAKING")
    staking += client.staking_product_position("F_DEFI")
    staking += client.staking_product_position("L_DEFI")
    #print(staking)
    df_staking = to_df(staking, coins)
    df_staking = add_fields(df_staking[['asset_id', 'amount']], 3)
    print(df_staking)
    save_db('balances', df_staking)

    savings = client.savings_project_position()
    savings += client.savings_flexible_product_position()
    #print(savings)
    df_savings = to_df(savings, coins)
    df_savings_locked = add_fields(df_savings.loc[(df_savings['freeAmount'] < df_savings['totalAmount'])][['asset_id', 'totalAmount']], 3, locked=True)
    df_savings_free = add_fields(df_savings.loc[(df_savings['freeAmount'] == df_savings['totalAmount'])][['asset_id', 'totalAmount']], 3, locked=False)
    print(df_savings)
    save_db('balances', df_savings_locked)
    save_db('balances', df_savings_free)



def to_df(data, coins):
    df = pd.DataFrame(data, dtype='float')
    df = df.join(coins, on='asset').dropna(subset='id')
    df = df.convert_dtypes({'id': 'int'})
    return df.rename({'id': 'asset_id'}, inplace=False, axis=1)

def add_fields(df, wallet_id, locked=False):
    df.columns = ['asset_id', 'amount']
    return df.assign(date=date.today(), wallet_id=wallet_id, user_id=1, locked=locked, inserted_at=datetime.now(), updated_at=datetime.now())

def save_db(table, df):
    try:
        with engine.begin() as connection:
            df.to_sql(table, connection, if_exists='append', index=False)
    except:
        pass

if __name__ == "__main__":
    main()
