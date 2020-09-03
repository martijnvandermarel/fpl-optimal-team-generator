import requests
import pandas as pd

url = 'https://fantasy.premierleague.com/api/bootstrap-static/'
r = requests.get(url)
json = r.json()

elements_df = pd.DataFrame(json['elements'])
elements_types_df = pd.DataFrame(json['element_types'])
teams_df = pd.DataFrame(json['teams'])

slim_elements_df = elements_df[['web_name','now_cost','total_points','ep_next','chance_of_playing_next_round','element_type','team']]
slim_elements_df['now_cost'] = slim_elements_df['now_cost']/10
slim_elements_df['position'] = slim_elements_df.element_type.map(elements_types_df.set_index('id').singular_name)
slim_elements_df['team_name'] = slim_elements_df.team.map(teams_df.set_index('id').name)
slim_elements_df = slim_elements_df.sort_values(['position','ep_next'],ascending=[True,False],kind='mergesort')
slim_elements_df.to_csv('fpl_scraped_data.csv', index=False)
