from flask import Flask, jsonify
import requests

app = Flask(__name__)

@app.route('/<user>/<repo>', methods=['GET'])
def get_last_release(user, repo):
    try:
        url = f"https://api.github.com/repos/{user}/{repo}/releases/latest"
        response = requests.get(url)
        if response.status_code == 200:
            release_info = response.json()
            version = release_info['tag_name']
            return jsonify({'version': version}), 200
        else:
            return jsonify({'error': 'Failed to retrieve release information'}), response.status_code
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)