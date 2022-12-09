FROM python:3.11.0-alpine

COPY . /opt

WORKDIR /opt
RUN apk add --no-cache --update make g++ openssl-dev libffi-dev py3-pandas
RUN python -m pip install -r requirements.txt

CMD ["sh"]
