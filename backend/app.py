from flask import Flask, request, jsonify, send_from_directory
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import logging
import os

# Set the static folder to the frontend directory in the parent folder
app = Flask(__name__, static_url_path='', static_folder=os.path.join(os.pardir, 'frontend'))
CORS(app)  # Enable CORS for all routes

# Configure logging
logging.basicConfig(level=logging.INFO)

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:Kunal@34.133.181.58:5432/postgres'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize the database
db = SQLAlchemy(app)

# Define your data model
class Data(db.Model):
    __tablename__ = 'data'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), nullable=False)
    phone = db.Column(db.String(255), nullable=False)
    country = db.Column(db.String(255), nullable=False)
    value1 = db.Column(db.String(255), nullable=False)
    value2 = db.Column(db.String(255), nullable=False)

# Route to serve HTML file
@app.route('/')
def index():
    return send_from_directory(app.static_folder, 'index.html')

# Route to check health
@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'}), 200

# Route to handle POST request
@app.route('/submit', methods=['POST'])
def submit():
    try:
        data = request.json
        required_fields = ['name', 'email', 'phone', 'country', 'value1', 'value2']
        if not all(field in data for field in required_fields):
            return jsonify({'error': 'All fields are required!'}), 400

        new_data = Data(
            name=data['name'],
            email=data['email'],
            phone=data['phone'],
            country=data['country'],
            value1=data['value1'],
            value2=data['value2']
        )
        db.session.add(new_data)
        db.session.commit()
        return jsonify({'message': 'Data submitted successfully!'}), 200
    except Exception as e:
        logging.error(f"Error inserting data: {e}")
        return jsonify({'error': f'An error occurred: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
