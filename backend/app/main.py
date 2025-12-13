from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import auth, api_aggregation, automation, alerts, insights
from app.config import settings

app = FastAPI(title="Enterprise AI Workflow Platform", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(api_aggregation.router, prefix="/api-aggregation", tags=["API Aggregation"])
app.include_router(automation.router, prefix="/automation", tags=["Automation"])
app.include_router(alerts.router, prefix="/alerts", tags=["Alerts"])
app.include_router(insights.router, prefix="/insights", tags=["Insights"])

@app.get("/")
def root():
    return {"message": "Enterprise AI Workflow Platform API"}
