# Pipeline and process of Python package

## Pipeline

1. Process incoming query sequence
    1. Single simple query # Elaborate
        1. 1 database with one gene
    1. Bulk query
        1. Identify databases
        1. Collasping similar ids/query string into list of unique id
        1. Create query matrix

            Query matrix is a table of unique ids/query parameters and database. Each cell constitude to an individual single query

1. Fetch information about databases
    1. Database information is stored in a database (metadatabase)
    1. Differential between database is intuitively indexed base on both name and function of the database
        1. In current version, each function of the databases if accessed differently is considered separated database. For example funricegene db is divided into 3 different databases' entry.
        1. In future revision, function of the databases will be integrated into the description of database using template metaprogramming technique.
    1. Part of html page that correspond to the data is exacted per definition store in database
        1. Current version define the area of data and parse datas into cell according to list of headers
        1. Future version will define individual cells and actively search for each headers' content
    1. Database definition is stored in database objects. Functions: # in future revision
        #list of accessor and query function here. # in future revision

1. Running the actual query
    1. Powered by BeautifulSoup, Requests and CSV module
    1. Requests built using information stored in db
    1. Possiblity for paralelization
        1. Different IP address/proxy server etc.
        1. Survey on how different databases/server handle parallel query (limitation, DDOS etc.)

1. Post-processing of data
    1. Text clean up

        Option for
        * Regular Expression
        * Python script (In future version)
        * Gawk (In future version)
    1. Trimming and filterings

        Option for
        * Regular Expression
        * Python script (In future version)
        * (R ?) (In future version)
    1. Exporting
        1. Single query:
            * CSV
            * Excel
            * JSON
            * RDF
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

## Result return

1. CSV