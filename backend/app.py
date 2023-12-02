from flask import Flask, render_template, request, jsonify
import pyodbc as odbc
import pandas as pd
import os

app = Flask(__name__)

@app.route('/')
def home():
    return "RMS Price Checker"


@app.route('/Secconnect', methods=['POST'])
def scanconnect():
    uid = request.form.get('uid')
    df = pd.read_csv('users.csv', header=None)
    for id in df[0]:
        if(id == uid):
            return jsonify(
                {'User': "Authenticated"}
            )

    return jsonify(
        {'User': "Is Not Authenticated"}
    )

@app.route('/Secinfo', methods=['POST'])
def scaninfo():
    # servername = "192.168.4.53"
    # database = "Starhouse"
    # username = "sa"
    # password = "Micr0s0ft@2020"
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = f'{servername}'
    DATABASE_NAME = f'{database}'
    print(servername)
    connection_string = f"""
                DRIVER={{{DRIVER_NAME}}};
                SERVER={SERVER_NAME};
                DATABASE={DATABASE_NAME};
                Trust_Connection=yes;
                uid={username};
                pwd={password};
            """

    conn = odbc.connect(connection_string)
    uid = request.form.get('uid')
    barcode = request.form.get('barcode')
    df = pd.read_csv('users.csv', header=None)
    for id in df[0]:
        if(id == uid):
            selectquerys = f"SELECT Description, Price, Quantity, SalePrice, SaleStartDate, SaleEndDate FROM ITEM  WHERE ItemLookupCode= '{barcode}';"
            try:
                cursor = conn.cursor()
                cursor.execute(selectquerys)
            except:
                return jsonify(
                    {'User': "Is Authenticated But Error Committed"}
                )
            i = 1
            data = ["data"]
            print("Barcode Readed : ", barcode)
            for row in cursor.fetchall():
                for s in row:
                    data.append(s)
                print("Data Returned Successfully");

            return jsonify(
                {'Description': str(data[1]),
                 'Price': str(data[2]),
                 'Quantity': str(data[3]),
                 'SalePrice': str(data[4]),
                 'SaleStartDate': str(data[5]),
                 'SaleEndDate': str(data[6]),
                 'Warehouse Quantity': str(0),
                 'State': "success",
                 'User': "Authenticated",
                 'Code':barcode}
            )

    return jsonify(
        {'User': "Is Not Authenticated"}
    )

@app.route('/Secupdate', methods=['POST'])
def scanupdate():
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = f'{servername}'
    DATABASE_NAME = f'{database}'

    connection_string = f"""
                DRIVER={{{DRIVER_NAME}}};
                SERVER={SERVER_NAME};
                DATABASE={DATABASE_NAME};
                Trust_Connection=yes;
                uid={username};
                pwd={password};
            """

    conn = odbc.connect(connection_string)
    uid = request.form.get('uid')
    barcode = request.form.get('barcode')
    df = pd.read_csv('users.csv', header=None)
    for id in df[0]:
        if(id == uid):
            selectquerys = f"SELECT Description, Quantity FROM ITEM  WHERE ItemLookupCode= '{barcode}';"
            try:
                cursor = conn.cursor()
                cursor.execute(selectquerys)
            except:
                return jsonify(
                    {'User': "Is Authenticated But Error Committed"}
                )
            i = 1
            data = ["data"]
            print("Barcode Readed : ", barcode)
            for row in cursor.fetchall():
                for s in row:
                    data.append(s)
                print("Data Returned Successfully");

            return jsonify(
                {'Description': str(data[1]),
                 'Code': barcode,
                 'Quantiy':str(data[2]),
                 'User': "Authenticated"}
            )

    return jsonify(
        {'User': "Is Not Authenticated"}
    )


@app.route('/connect', methods=['POST'])
def connect():
    servername = request.form.get('server')
    database = request.form.get('dbname')
    username = request.form.get('uname')
    password = request.form.get('pass')
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = f'{servername}'
    DATABASE_NAME = f'{database}'

    connection_string = f"""
            DRIVER={{{DRIVER_NAME}}};
            SERVER={SERVER_NAME};
            DATABASE={DATABASE_NAME};
            Trust_Connection=yes;
            uid={username};
            pwd={password};
        """
    try:
        conn = odbc.connect(connection_string)
    except:
        return jsonify(
            {'Connection':"failed"}
        )
    print(conn)
    return jsonify(
            {'Connection': "Successfully"}
    )

@app.route('/select', methods=['POST'])
def mobile():
    barcode = request.form.get('barcode')
    servername = request.form.get('server')
    database = request.form.get('dbname')
    username = request.form.get('uname')
    password = request.form.get('pass')
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = f'{servername}'
    DATABASE_NAME = f'{database}'

    connection_string = f"""
        DRIVER={{{DRIVER_NAME}}};
        SERVER={SERVER_NAME};
        DATABASE={DATABASE_NAME};
        Trust_Connection=yes;
        uid={username};
        pwd={password};
    """


    conn = odbc.connect(connection_string)
    selectquery = f"select i.[Description],i.price,i.quantity,I.salesprice,I.salestartdate,I.saleenddate,iw.quantuty from item i left join ['{waredb}'].[warehouse].dbo.Item iw on iw.ItemLookupCode ='{barcode}' where i.PictureName !=''"
    selectquerys = f"SELECT Description, Price, Quantity, SalePrice, SaleStartDate, SaleEndDate FROM ITEM  WHERE ItemLookupCode= '{barcode}';"
    try:
        print("Warehouse DB IP : ",waredb)
        cursor = conn.cursor()
        cursor.execute(selectquerys)
    except:
        return jsonify(
            {'State':"failed"}
        )
    i = 1
    data = ["data"]
    print("Barcode Readed : ",barcode)
    for row in cursor.fetchall():
        for s in row:
            data.append(s)
        print("Data Returned Successfully");


    return jsonify(
            {'Description': str(data[1]),
            'Price': str(data[2]),
            'Quantity': str(data[3]),
            'SalePrice': str(data[4]),
            'SaleStartDate': str(data[5]),
            'SaleEndDate': str(data[6]),
             'Warehouse Quantity':str(0),
             'State':"success"}
    )


@app.route('/sheets', methods=['POST'])
def sheets():
    servername = request.form.get('server')
    database = request.form.get('dbname')
    username = request.form.get('uname')
    password = request.form.get('pass')
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = f'{servername}'
    DATABASE_NAME = f'{database}'

    connection_string = f"""
            DRIVER={{{DRIVER_NAME}}};
            SERVER={SERVER_NAME};
            DATABASE={DATABASE_NAME};
            Trust_Connection=yes;
            uid={username};
            pwd={password};
        """

    conn = odbc.connect(connection_string)
    cursor = conn.cursor()
    command = "SELECT name FROM IMSRMSSheetNames"
    try:
        cursor.execute(command)
    except:
        return jsonify(
            {"State":"No Sheets Available"}
        )

    i = 0
    rows = cursor.fetchall()
    sheetname = []
    for row in rows:
        for s in row:
            i += 1
            sheetname.append(s)
            print(s)

    return jsonify(
        {"State": "Success",
        "sheets":sheetname}
    )

@app.route('/storechecker', methods=['POST'])
def storechecker():
    barcode = request.form.get('barcode')
    newquan = request.form.get('newquan')
    oldquan = request.form.get('oldquan')
    sheet = request.form.get('sheet')
    description = request.form.get('desc')
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = f'{servername}'
    DATABASE_NAME = f'{database}'

    connection_string = f"""
        DRIVER={{{DRIVER_NAME}}};
        SERVER={SERVER_NAME};
        DATABASE={DATABASE_NAME};
        Trust_Connection=yes;
        uid={username};
        pwd={password};
    """

    conn = odbc.connect(connection_string)
    cursor = conn.cursor()
    command = """IF OBJECT_ID ( 'selectiontest', 'P' ) IS NOT NULL   
                        DROP PROCEDURE selectiontest;"""
    command1 = """IF OBJECT_ID ( N'fn_Count', N'FN' ) IS NOT NULL   
                        DROP FUNCTION dbo.fn_Count;"""

    command2 = f"""CREATE PROCEDURE selectiontest  
                    AS  
                        INSERT INTO IMSStoreChecker(barcode, description, NewQuantity, OldQuantity, SheetName) VALUES('{barcode}','{description}',{int(newquan)},'{oldquan}','{sheet}')
                """

    command3 = f"""
    Create function fn_Count()
	    returns int
	    as
	        Begin
		        DECLARE @conoccur INT;
		        SELECT @conoccur = COUNT(barcode) FROM IMSStoreChecker WHERE SheetName = '{sheet}' AND description='{description}';
		        Return @conoccur;
	        End"""

    command4 = f"""
    BEGIN TRY
    
	DECLARE @oldq INT;
	DECLARE @count INT;

	SELECT @count = dbo.fn_Count();

	IF @count >0
	BEGIN
		SELECT @oldq = NewQuantity FROM IMSStoreChecker WHERE SheetName = '{sheet}' AND description='{description}';
		Declare @result int
		Set @result = @oldq + {int(newquan)};
		UPDATE IMSStoreChecker SET NewQuantity = @result WHERE SheetName = '{sheet}' AND description='{description}'; 
	END
	ELSE
		EXECUTE selectiontest;
    END TRY  
    BEGIN CATCH
        CREATE TABLE dbo.IMSStoreChecker (
            id int IDENTITY(1,1) PRIMARY KEY , 
            barcode NVARCHAR(50) NOT NULL, 
            description NVARCHAR(50) NOT NULL, 
            NewQuantity INTEGER NOT NULL, 
            OldQuantity NVARCHAR(50) NOT NULL, 
            SheetName NVARCHAR(100) NOT NULL
            );
        EXECUTE selectiontest;
    END CATCH;"""
    try:
        cursor.execute(command)
        cursor.execute(command1)
        cursor.execute(command2)
        cursor.execute(command3)
        cursor.execute(command4)
        conn.commit()
        print("New Data Added To IMSStoreChecker In Sheet",sheet);
    except:
        return jsonify(
            {'State':"Failed"}
        )


    return jsonify(
            {'State': "Updated"}
    )

@app.route('/storegetter', methods=['POST'])
def storegetter():
    servername = request.form.get('server')
    database = request.form.get('dbname')
    username = request.form.get('uname')
    password = request.form.get('pass')
    sheet = request.form.get('sheet')
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = f'{servername}'
    DATABASE_NAME = f'{database}'

    connection_string = f"""
        DRIVER={{{DRIVER_NAME}}};
        SERVER={SERVER_NAME};
        DATABASE={DATABASE_NAME};
        Trust_Connection=yes;
        uid={username};
        pwd={password};
    """

    conn = odbc.connect(connection_string)
    selectquery = f"Select * FROM IMSStoreChecker WHERE SheetName = '{sheet}'"
    cursor = conn.cursor()
    cursor.execute(selectquery)
    rows = cursor.fetchall()
    i = 0;
    barcode = []
    description = []
    sheetname = []
    oldquantity = []
    newquantity = []
    for row in rows:
        i += 1
        barcode.append(row[1])
        description.append(row[2])
        newquantity.append(row[3])
        oldquantity.append(row[4])
        sheetname.append(row[5])

    return jsonify(
        {"count":i,
         "Barcode":barcode,
         "Description":description,
         "new":newquantity,
         "old":oldquantity,
         "sheet":sheetname}
    )


if __name__ == '__main__':
    waredb = ""
    servername = input("Enter ServerName : \n")
    database = input("Enter DatabaseName : \n")
    username = input("Enter Username : \n")
    password = input("Enter Password : \n")
    os.system('cls')
    print("===============> Welcome TO PDS RMS Version v1.0 <===============")
    app.run(host="0.0.0.0",port=5000)


"""
    Connect -> Connection
    Select -> State
    storeChecker -> State
"""