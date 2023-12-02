
# Backend - Python/Flask

This Backend Developed Using Flask to open API Connection On Port 5000 which make a connection with phone and SQL Database

## Acknowledgements

 - Why To Use?
 - How It works?
 - How to Build?


## Why To Use

- Difficult To Connect directly from flutter to SQL DB
- SQL DB Isn't Published
- Fast SQL Connection


## How It Works

 -  Open Api On Port 5000

```python
if __name__ == '__main__':
    app.run(host="0.0.0.0",port=5000)
```
 -  Validate Flutter Connection To The Api

```python
@app.route('/Secconnect', methods=['POST'])
def scanconnect():
    uid = request.form.get('uid')

    #users.csv is the csv file which has the  ids of authored users

    df = pd.read_csv('users.csv', header=None)
    for id in df[0]:
        if(id == uid):
            return jsonify(
                {'User': "Authenticated"}
            )

    return jsonify(
        {'User': "Is Not Authenticated"}
    )
```
 -  Get Info From SQL

```python
@app.route('/Secinfo', methods=['POST'])
def scaninfo():
    servername = ##ServerName
    database = ##DatabaseName
    username = ##Username Of SQL Server
    password = ##Password Of Username
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
```
 -  Return SheetNames

```python
@app.route('/sheets', methods=['POST'])
def sheets():
    servername = ##ServerName
    database = ##DatabaseName
    username = ##Username Of SQL Server
    password = ##Password Of Username
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
```
 -  Update Info Inside Database

```python
@app.route('/storechecker', methods=['POST'])
def storechecker():
    barcode = request.form.get('barcode')
    servername = "EC2AMAZ-B9DEASU\\FLOCKERLABS"
    database = "PDS-RMS"
    username = "sa"
    password = "adminH@"
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
```



## How To Build

- build EXE File
  -
  From Python Terminal Enter This Command
  
  ```command line
    python -m PyInstaller --onefile app.py
    ```

    That Will Create 'app.exe'

- build Installer File
  -

  - Open 'RMS Price CHecker.aip' With Advanced Installer and generate 'RMS Price Checker.exe'
  - Don't Forget To Import 'licences.txt'