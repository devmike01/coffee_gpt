import os
import openai

from openai_engine.api_key import OpenApiKey


class OpenAiEngine:
    def __init__(self):
        openai.organization = OpenApiKey.organisation
        openai.api_key = OpenApiKey.openai_key

    @staticmethod
    def make_suggestion(content: str):
        return openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[{'role': 'user',
                       'content': "Suggest: {}".format(content)}],
            temperature=0.9,
            max_tokens=150,
            top_p=1,
            frequency_penalty=0.0,
            presence_penalty=0.6,
            stop=[" Human:", " AI:"]
        )
