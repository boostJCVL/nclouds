import time
import psycopg2
import redis
from flask import Flask, render_template, request

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

pgconn = psycopg2.connect(
    user = "postgres",
    password = "password",
    host = "postgres",
    port = "5432",
    database = "postgres"
)
pgconn.autocommit=True
cursor=pgconn.cursor()

def get_user_count():
    retries = 5
    while True:
        try:
            return cache.incr('user')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)



""" if __name__ == '__main__':
    app.run(debug=True) """

""" @app.route('/')
def index():
    name = request.form['name']
    email = request.form['email']
    password = request.form['password']
    return render_template('index.html', name=name, email=email, password=password) """



@app.route('/', methods=['GET', 'POST']) #'/submit'
def submit():
    if request.method == "POST":
        name = request.form.get("name")
        email = request.form.get("email")
        password = request.form.get("password")

        if request.form['action'] == 'record to Redis':
            count = get_user_count()
            cache.hmset(f"user:{count}", {
                        "name": f"{name}",
                        "email": f"{email}",
                        "password": f"{password}"
                        })
            print("Your data has been saved to Redis Cache")
            return "Your data has been saved to Redis Cache"
        else:
            print("ERROR: Something went wrong")


        if request.form['action'] == 'record to PostgreSQL':
            insert = """ INSERT INTO users (Username, Email, Pass) VALUES (%s,%s,%s)"""
            values = (name, email, password)
            cursor.execute(insert, values)
            print("Your data has been saved to PostgreSQL") 
            return "Your data has been saved to PostgreSQL"

    else:
        print('passed')
        pass




    return render_template("index.html")

