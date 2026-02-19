import os
import requests
import time
import sys

base_url = "https://raw.githubusercontent.com/semarketir/quranjson/master/source/surah/surah_{}.json"
output_dir = "assets/json/surah"

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

for i in range(1, 115):
    filename = "surah_{}.json".format(i)
    filepath = os.path.join(output_dir, filename)
    
    if os.path.exists(filepath) and os.path.getsize(filepath) > 100:
        print("Skipping {} (already exists)".format(filename))
        continue
        
    url = base_url.format(i)
    headers = {"User-Agent": "Mozilla/5.0"}
    try:
        print("Downloading {}...".format(filename))
        sys.stdout.flush()
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code == 200:
            with open(filepath, "w", encoding="utf-8") as f:
                f.write(response.text)
            print("Downloaded {}".format(filename))
        else:
            print("Failed to download {}: Status {}".format(filename, response.status_code))
    except Exception as e:
        print("Error downloading {}: {}".format(filename, e))
    sys.stdout.flush()
    time.sleep(0.1) 

print("Download complete.")
