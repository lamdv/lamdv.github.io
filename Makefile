.PHONY: docs

default: install

all: install build


h help:
	@grep '^[a-z]' Makefile


install:
	pip install pip --upgrade
	pip install -r requirements.txt

upgrade:
	pip install pip --upgrade
	pip install -r requirements.txt --upgrade


s serve:
	mkdocs serve --strict


b build:
	mkdocs build

d deploy:
	mkdocs gh-deploy --force