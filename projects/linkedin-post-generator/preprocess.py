import json

def process_posts(raw_file_path, processed_file_path="data/processed_posts.json"):
    with open(raw_file_path, encoding='utf-8') as file:
        posts = json.load(file)
        print(posts)
#         for post in posts:
#             extract_metadata(post['text'])
#             post_with_metadata = post | metadata
#             enriched.posts.append(post_with_metadata)

#             post = {'text':'abc' , 'engagement' : 500}'
#             metadata = {'line_count':10, 'language' : 'English', 'tags': ['Mental Health','Motivation']}

# def extract_metadata(post):
#     return {
#         'line_count':10,
#         'language' : 'English',
#         'tags': ['Mental Health','Motivation']

#     }

if __name__ == "__main__":
    process_posts("data/raw_posts.json","data/processed_posts.json")
