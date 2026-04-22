import os
from flask import Flask
import pymysql
from database import db


def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'dev'
    # ensure instance folder exists (not committed to VCS)
    instance_dir = os.path.join(app.root_path, 'instance')
    os.makedirs(instance_dir, exist_ok=True)
    # store the sqlite DB in the instance folder
    app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://isaac:2001@localhost/smart_health'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db.init_app(app)

    # import models so SQLAlchemy knows about them
    with app.app_context():
        import models  # noqa: F401

    from routes import main_bp
    app.register_blueprint(main_bp)

    @app.cli.command('init-db')
    def init_db():
        db.create_all()
        print(f'Initialized the database at {os.path.join(instance_dir, "hospital.db")}')

    return app


if __name__ == '__main__':
    create_app().run(debug=True)
