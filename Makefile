.PHONY: dev db stop

db:
	docker compose up -d db

dev:
	python -m uvicorn app.main:app --reload

stop:
	docker compose down
