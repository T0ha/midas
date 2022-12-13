#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pycoingecko import CoinGeckoAPI
from sqlalchemy import create_engine
import pandas as pd
import os

def main():
    cg = CoinGeckoAPI()
    coins = cg.get_coins_list()
    data = pd.DataFrame(coins)
    data.columns = ['gecko_id', 'ticker', 'name']
        
    print(data)

    db_url = 'postgresql://{}:{}@{}:{}/{}'.format(
        os.environ.get('POSTGRES_USER', 'postgres'),
        os.environ.get('POSTGRES_PASSWORD', 'postgres'),
        os.environ.get('POSTGRES_HOST', 'localhost'),
        os.environ.get('POSTGRES_PORT', '5432'),
        os.environ.get('POSTGRES_DB', 'portfolio_dev'),
    )

    engine = create_engine(db_url, echo=False)

    with engine.begin() as connection:
        data.to_sql('assets', connection, if_exists='append', index_label='id')


if __name__ == "__main__":
    main()

        
    

