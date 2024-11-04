from flask import Flask, request, jsonify
app = Flask(__name__)


@app.route('/add', methods=['POST'])
def add():
    num1 = request.form['num1']
    num2 = request.form['num2']
    result = int(num1) + int(num2)
    return jsonify({'result': result})


@app.route('/sub', methods=['POST'])
def subtract():
    num1 = request.form['num1']
    num2 = request.form['num2']
    result = int(num1) - int(num2)
    return jsonify({'result': result})


@app.route('/mult', methods=['POST'])
def multiply():
    num1 = request.form['num1']
    num2 = request.form['num2']
    result = int(num1) * int(num2)
    return jsonify({'result': result})


@app.route('/div', methods=['POST'])
def divide():
    num1 = request.form['num1']
    num2 = request.form['num2']
    result = int(num1) / int(num2)
    return jsonify({'result': result})


if __name__ == '__main__':
    app.run('0.0.0.0', 8000)
