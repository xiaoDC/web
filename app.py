from flask import Flask, jsonify,render_template,url_for,request
import requests

# create an Flask app object
app = Flask(__name__)
app.config["DEBUG"] = True  # Only include this while you are testing your app

@app.route("/")
@app.route("/index.html")
def hello():
    return render_template("page.html")


@app.route("/about.html")
def about():
    return render_template("index.html")

@app.route('/signin', methods=['GET'])
def signin_form():
    return render_template('form.html')

@app.route('/signin', methods=['POST'])
def signin():
    username = request.form['username']
    password = request.form['password']
    if username=='admin' and password=='password':
        return render_template('signin-ok.html', username=username)
    return render_template('form.html', message='Bad username or password', username=username)

@app.route("/name")
def my_name():
	return "Sara"

@app.route("/website")
def website():
	return "adicu.com"

@app.route("/search/<search_query>")
def search(search_query):
	url = "https://api.github.com/search/repositories?q=" + search_query # add url , get info from github , input http://0.0.0.0:5000/search/Space%20Invaders%20HTML5+language:JavaScript
	response = requests.get(url)
	response_dict = response.json()
	return jsonify(response_dict) # convert it json to string, flask always want to string

@app.route("/add/<x>/<y>")
def add(x,y):
	return str(int(x) + int(y))

@app.route("/search/nope")
def nope():
	return "Gotcha!"
# handler
@app.errorhandler(404)
def not_found(error):
	return "Sorry",400

@app.errorhandler(500)
def internal_server_error(error):
	return "My code broke",500
# if the user executed this python file, typed python app.py in their # terminal, run our app
if __name__ == "__main__":
    app.run(host="0.0.0.0")
