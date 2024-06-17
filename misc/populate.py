import pandas as pd
import psycopg2
from psycopg2 import sql
from datetime import datetime
import sys

# Define your PostgreSQL connection parameters
DB_HOST = 'localhost'
DB_PORT = '5432'
DB_USER = 'postgres'
DB_PASSWORD = 'password'
DB_NAME = 'immigrant'

# Function to establish a connection to PostgreSQL
def connect_to_db():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        return conn
    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None

def format_wage(wage_str: str) -> int:
    if type(wage_str) is float or type(wage_str) is int:
        try:
            return int(wage_str)
        except:
            return 0
    if not wage_str or len(wage_str) == 0:
        return 0
    res = wage_str.strip().replace('$', '').replace(',', '')
    split_res = res.split('.')
    return int(split_res[0])

def format_phone(num) -> str:
    if not num:
        return ""
    if num != num:
        return ""
    return str(num).strip().replace('+', '')

def format_str(input):
    if input != input:
        return ""
    return str(input).strip()

def format_boolean(input) -> bool:
    if input != input:
        return False
    if type(input) is str:
        lower = input.lower()
        return lower == 'yes'

def insert_visa_application(conn, data):
    cur = conn.cursor()

    # Convert dates to Python datetime objects
    received_date = datetime.strptime(data['RECEIVED_DATE'], '%m/%d/%Y').date()
    decision_date = datetime.strptime(data['DECISION_DATE'], '%m/%d/%Y').date()
    begin_date = datetime.strptime(data['BEGIN_DATE'], '%m/%d/%Y').date()
    end_date = datetime.strptime(data['END_DATE'], '%m/%d/%Y').date() if pd.notnull(data['END_DATE']) else None

    # Insert into VisaApplication table using SQL query with lowercase field names
    insert_query = sql.SQL("""
        INSERT INTO "visa_application" (
            case_number, case_status, received_date, decision_date, visa_class,
            job_title, soc_code, soc_title, full_time_position, begin_date, end_date,
            total_worker_positions, wage_rate_of_pay_from, wage_rate_of_pay_to, 
            wage_unit_of_pay, prevailing_wage, total_worksite_locations, 
            agree_to_lc_statement, h_1b_dependent, willful_violator
        ) VALUES (
            %(case_number)s, %(case_status)s, %(received_date)s, %(decision_date)s, %(visa_class)s,
            %(job_title)s, %(soc_code)s, %(soc_title)s, %(full_time_position)s, %(begin_date)s, %(end_date)s,
            %(total_worker_positions)s, %(wage_rate_of_pay_from)s, %(wage_rate_of_pay_to)s, 
            %(wage_unit_of_pay)s, %(prevailing_wage)s, %(total_worksite_locations)s, 
            %(agree_to_lc_statement)s, %(h_1b_dependent)s, %(willful_violator)s
        ) RETURNING id
    """)

    # Execute the query
    cur.execute(insert_query, {
        'case_number': data['CASE_NUMBER'],
        'case_status': data['CASE_STATUS'].lower(),
        'received_date': received_date,
        'decision_date': decision_date,
        'visa_class': data['VISA_CLASS'],
        'job_title': data['JOB_TITLE'],
        'soc_code': data['SOC_CODE'],
        'soc_title': data['SOC_TITLE'],
        'full_time_position': format_boolean(data['FULL_TIME_POSITION']),
        'begin_date': begin_date,
        'end_date': end_date,
        'total_worker_positions': int(data['TOTAL_WORKER_POSITIONS']),
        'wage_rate_of_pay_from': format_wage(data['WAGE_RATE_OF_PAY_FROM']),
        'wage_rate_of_pay_to': format_wage(data['WAGE_RATE_OF_PAY_TO']),
        'wage_unit_of_pay': data['WAGE_UNIT_OF_PAY'],
        'prevailing_wage': format_wage(data['PREVAILING_WAGE']),
        'total_worksite_locations': data['TOTAL_WORKSITE_LOCATIONS'],
        'agree_to_lc_statement': format_boolean(data['AGREE_TO_LC_STATEMENT']),
        'h_1b_dependent': format_boolean(data['H_1B_DEPENDENT']),
        'willful_violator': format_boolean(data['WILLFUL_VIOLATOR'])
    })


    visa_application_id = cur.fetchone()[0]
    conn.commit()

    return visa_application_id

def insert_employer(conn, row, visa_app_id):
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO "employer" (
            name, address1, address2, city, state, postal_code, country,
            province, phone, phone_ext, visa_application_id
        ) VALUES (
            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
        ) RETURNING id
        """, (
            row['EMPLOYER_NAME'],
            row['EMPLOYER_ADDRESS1'],
            row['EMPLOYER_ADDRESS2'],
            row['EMPLOYER_CITY'],
            row['EMPLOYER_STATE'],
            row['EMPLOYER_POSTAL_CODE'],
            row['EMPLOYER_COUNTRY'],
            row['EMPLOYER_PROVINCE'],
            format_phone(row['EMPLOYER_PHONE']),
            format_phone(row['EMPLOYER_PHONE_EXT']),
            visa_app_id
        ))

    employer_id = cur.fetchone()[0]

    conn.commit()
    return employer_id

# Function to insert data into EmployerContact table
def insert_employer_contacts(conn, row, employer_id):
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO "employer_contact" (
            last_name, first_name, middle_name, job_title, address1, address2,
            city, state, postal_code, country, province, phone, phone_ext, email, employer_id
        ) VALUES (
            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
        )
    """, (
        row['EMPLOYER_POC_LAST_NAME'],
        row['EMPLOYER_POC_FIRST_NAME'],
        row['EMPLOYER_POC_MIDDLE_NAME'],
        row['EMPLOYER_POC_JOB_TITLE'],
        row['EMPLOYER_POC_ADDRESS1'],
        row['EMPLOYER_POC_ADDRESS2'],
        row['EMPLOYER_POC_CITY'],
        row['EMPLOYER_POC_STATE'],
        row['EMPLOYER_POC_POSTAL_CODE'],
        row['EMPLOYER_POC_COUNTRY'],
        row['EMPLOYER_POC_PROVINCE'],
        format_phone(row['EMPLOYER_POC_PHONE']),
        format_phone(row['EMPLOYER_POC_PHONE_EXT']),
        format_str(row['EMPLOYER_POC_EMAIL']),
        employer_id
    ))

    conn.commit()

# Function to insert data into Agent table
def insert_agent(conn, row, visa_application_id):
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO "Agent" (
            last_name, first_name, middle_name, address1, address2,
            city, state, postal_code, country, province, phone, phone_ext, email_address, lawfirm_name_business,
            visa_application_id
        ) VALUES (
            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
            %s
        )
    """, (
        row['AGENT_ATTORNEY_LAST_NAME'],
        row['AGENT_ATTORNEY_FIRST_NAME'],
        row['AGENT_ATTORNEY_MIDDLE_NAME'],
        row['AGENT_ATTORNEY_ADDRESS1'],
        row['AGENT_ATTORNEY_ADDRESS2'],
        row['AGENT_ATTORNEY_CITY'],
        row['AGENT_ATTORNEY_STATE'],
        row['AGENT_ATTORNEY_POSTAL_CODE'],
        row['AGENT_ATTORNEY_COUNTRY'],
        row['AGENT_ATTORNEY_PROVINCE'],
        format_phone(row['AGENT_ATTORNEY_PHONE']),
        format_phone(row['AGENT_ATTORNEY_PHONE_EXT']),
        format_str(row['AGENT_ATTORNEY_EMAIL_ADDRESS']),
        row['LAWFIRM_NAME_BUSINESS_NAME'],
        visa_application_id
    ))

    conn.commit()


def insert_worksite(conn, row, visa_app_id):
    cur = conn.cursor()
    
    # Execute the query and fetch the ID
    cur.execute("""
        INSERT INTO "worksite" (
            address1, address2, city, county, state, postal_code, visa_application_id
        ) VALUES (
            %s, %s, %s, %s, %s, %s, %s
        )
    """, (
        row['WORKSITE_ADDRESS1'],
        row['WORKSITE_ADDRESS2'],
        row['WORKSITE_CITY'],
        row['WORKSITE_COUNTY'],
        row['WORKSITE_STATE'],
        row['WORKSITE_POSTAL_CODE'],
        visa_app_id
    ))
    
    conn.commit()

# Example usage:
if __name__ == "__main__":
    conn = connect_to_db()
    if conn:
        # Load CSV data into a Pandas DataFrame
        print(f'Reading CSV {sys.argv[1]}')
        csv_file = sys.argv[1]  # Replace with your CSV file path
        df = pd.read_csv(csv_file, keep_default_na=False)

        # Convert column names in DataFrame to uppercase
        df.columns = df.columns.str.upper()

        # Iterate over rows in the DataFrame and insert into PostgreSQL
        failed = 0
        for index, row in df.iterrows():
            try:
                visa_app_id = insert_visa_application(conn, row)
                employer_id = insert_employer(conn, row, visa_app_id)
                insert_employer_contacts(conn, row, employer_id)
                insert_agent(conn, row, visa_app_id)
                insert_worksite(conn, row, visa_app_id)
            except Exception as e:
                print(f'Failed to process {index}')
                #raise e
                failed += 1
                continue
            if index == 1000:
                break
        print(f'Finished proccesing, failed {failed}')
        print(f'Failed {((failed / len(df)) * 100)} %')
        
        conn.close()
        print('Connection closed succesfully')
    else:
        print("Connection to database failed.")