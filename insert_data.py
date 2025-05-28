import pandas as pd
from sqlalchemy import create_engine

# 1. Database connection info
username = 'root'
password = 'Rladdha@278'  # your actual password
host = 'localhost'
port = 3306
database = 'ecommerce_project'

# 2. Load your CSV file
csv_file = 'cleaned_data.csv'  # make sure it's in the same folder
df = pd.read_csv(csv_file)

# 3. Create SQLAlchemy engine
engine = create_engine("mysql+pymysql://root:Rladdha%40278@localhost:3306/ecommerce_project")



# 4. Load data into MySQL
df.to_sql('raw_transactions', con=engine, if_exists='append', index=False)

print("✅ Data import completed successfully!")
