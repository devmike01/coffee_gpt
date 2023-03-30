# This is a sample Python script.

from api import suggest, suggest_model as sm
from fastapi import FastAPI

app = FastAPI()
logic = suggest.SuggestLogic()
suggest_model = sm.SuggestModel()


@app.get('/suggest')
async def suggest(content: str):
    suggest_model.content = content
    return logic.get_suggest(suggest_model)
