# Pipeline and process of Python package

## Pipeline

1. Process incoming query sequence
    1. Single simple query
    1. Bulk query
        1. Identify databases
        1. Collasping similar ids/query string into list of unique id
        1. Create query matrix

            Query matrix is a table of unique ids/query parameters and database. Each cell constitude to an individual single query

1. Fetch information about databases
    1. Database information is stored in a database (metadatabase)
    1. Differential between database is intuitively indexed base on both name and function of the database
        1. In current version, each function of the databases if accessed differently is considered separated database. For example funricegene db is divided into 3 different databases entry.
        1. In future revision, function of the databases will be integrated into the description of database using template metaprogramming technique.
    1. Part of html page that correspond to the data is exacted per instruction store in database
    1. Database definition is stored in database objects. Functions:
        #list of accessor and query function here.

1. Running the actual query
    1. Powered by BeautifulSoup, Requests and CSV module
    1. Requests built using information stored in db

1. Post-processing of data
    1. Text clean up
        Option for
        * Regular Expression
        * Python script
        * Gawk
    1. Trimming and filtering
        Option for
        * Regular Expression
        * Python script
        * (R ?)
    1. Exporting
        1. Single query:
            * CSV
            * Excel
        2. Query Matrix:
            * Flat CSV file

                Cell with multiple data will be delimited with `;`
            * Structured folder

                Each folder correspond to one database in the bulk query
    1. Chain query(?)

## Database Object

1. Storable object
1. Attributes:
1. Functions:
    * Accessors
    * Execute Query
