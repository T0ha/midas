#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pycoingecko import CoinGeckoAPI
from sqlalchemy import create_engine
import pandas as pd

def main():
    cg = CoinGeckoAPI()
    coins = cg.get_coins_list()
    data = pd.DataFrame(coins)
    data.columns = ['gecko_id', 'ticker', 'name']
        
    print(data)
    engine = create_engine('postgresql://postgres:postgres@localhost:5432/portfolio_dev', echo=False)
    with engine.begin() as connection:
        data.to_sql('assets', connection, if_exists='append', index_label='id')


if __name__ == "__main__":
    main()

        
    

