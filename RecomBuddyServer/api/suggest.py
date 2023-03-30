from typing import Union
from api import suggest_model as sm
import json
from openai_engine import open_ai_engine as aoe


class SuggestLogic:
    open_ai_suggestion = aoe.OpenAiEngine()

    def get_suggest(self, suggest_model: sm.SuggestModel):
        suggest_m = suggest_model.content  # eval()
        print(suggest_m)
        try:
            if suggest_m is not None:
                # Ask for suggestions
                response = self.open_ai_suggestion.make_suggestion(suggest_m)
                print('response: ' + str(response))
                choices = response['choices']
                # message = choices['message']
                return {
                    'data': choices
                }
            else:
                return {
                    'code': 500,
                    'message': 'Content cannot be Null'
                }
        except Exception as e:
            return {
                'code': 500,
                'message': 'Content cannot be %s' % e.__str__()
            }
