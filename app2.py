from flask import Flask

app = Flask(__name__)
#app.config['DEBUG'] = True

@app.route("/")
def hello():
    return "hello world"

@app.route("/name")
def my_name():
    return "Dan Schlosser"

@app.route('/search/<search_query>')
def search(search_query):
    return "hello" + search_query

@app.route('/search/nope')
def nope():
    return "Gotcha!"

@app.route('/add/<x>/<y>')
def add(x,y):
    return (int(x) + int(y))

@app.errorhandler(404)
def not_found(error):
    return "Sorry, I haven't coded that yet, I'll get back to you.", 404

@app.errorhandler(500)
def not_found(error):
    return "My code sucks.", 500

if __name__ == '__main__':
    app.run(host = '0.0.0.0')

