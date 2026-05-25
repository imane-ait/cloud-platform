from contextlib import asynccontextmanager
from fastapi import FastAPI
from sqlalchemy import text
from app.database import engine, Base
from app.routers import vehicles, drivers

@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield

app = FastAPI(title="FleetOps API", lifespan=lifespan)

app.include_router(vehicles.router)
app.include_router(drivers.router)

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get("/ready")
async def ready():
    try:
        async with engine.connect() as conn:
            await conn.execute(text("SELECT 1"))
        return {"status": "ready", "db": "ok"}
    except Exception as e:
        from fastapi import Response
        return Response(status_code=503, content=str(e))
