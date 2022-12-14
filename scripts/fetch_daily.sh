#!/bin/sh

COMPOSE_CONFIG="/home/t0ha/projects/midas/compose.yml"
CMD="docker compose -f ${COMPOSE_CONFIG} run spider python"

${CMD} get_prices_db.py
${CMD} get_portfolio_db.py
