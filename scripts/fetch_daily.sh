#!/bin/sh

PROJECT_PATH="/home/t0ha/projects/midas"
COMPOSE_CONFIG="${PROJECT_PATH}/compose.yml"
CMD="docker compose -f ${COMPOSE_CONFIG} run spider python"

${CMD} get_prices_db.py >> ${PROJECT_PATH}/daily.log 2>&1
${CMD} get_portfolio_db.py >> ${PROJECT_PATH}/daily.log 2>&1
