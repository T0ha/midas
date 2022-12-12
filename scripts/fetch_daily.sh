#!/bin/sh

PROJECT_PATH=/home/t0ha/midas
echo ${PROJECT_PATH}
python ${PROJECT_PATH}/python/get_prices_db.py
python ${PROJECT_PATH}/python/get_portfolio_db.py
