from pydantic import BaseModel, Field


class SuggestModel:
    def __init__(self):
        self.content: str = Field(max_length=50)
