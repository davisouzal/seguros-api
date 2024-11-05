# seguros-api

seguros-api is a RESTful API for managing insurance records. This API allows users to create, read, update, and delete insurance entries efficiently.

## Installation

### Installing Crystal

1. Make sure you have [Crystal](https://crystal-lang.org/install/) installed on your system.
2. Clone the repository:
   ```
   git clone https://github.com/davisouzal/seguros-api.git
   ``` 

3.  Navigate to the project directory:
        
    ```
    cd seguros-api
    ``` 
    
4.  Install dependencies:

    ```
    shards install
    ```

### Creating the Database

Install Postgres by downloading and following the instructions from the [Official Website](https://www.postgresql.org/download/). 

Access the database in the terminal by running:

```
psql -U postgres
```

Create the database:

```
CREATE DATABASE seguros_db;
```

Connect to the database:

```
\c seguros_db
```

Create the tables:

```
CREATE TABLE insurance (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  type TEXT NOT NULL,
  max_coverage FLOAT8 NOT NULL,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL
);
```

```
CREATE TABLE claim (
  id SERIAL PRIMARY KEY,
  insurance_id INT NOT NULL,
  claim_number FLOAT8 NOT NULL,
  claim_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP,
  claim_amount FLOAT8 NOT NULL,
  status TEXT NOT NULL,
  FOREIGN KEY (insurance_id) REFERENCES insurance(id) ON DELETE CASCADE
);
```

```
CREATE TABLE logs (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  protocol_number INT NOT NULL,
  date TIMESTAMP NOT NULL,
  type TEXT NOT NULL
);
```
    

## Usage


### Runnig the API

To start the API server, run the following command:


#### On Windows
```
make run
```

#### On linux

```
crystal run src/seguros-api.cr
```

The server will start running at `http://localhost:3000`.

### Endpoints

#### Insurance

-   **POST /insurances**: Create a new insurance entry.
-   **GET /insurances**: Retrieve all insurance entries.
-   **GET /insurances/`id`**: Retrieve a specific insurance entry by ID.
-   **PUT /insurances/`id`** : Update a specific insurance entry by ID.
-   **DELETE /insurances/`id`**: Delete a specific insurance entry by ID.
-   **GET /insurances/user/`user_id`**: Retrieve all insurance entries for an specific user.

#### Claim

-   **POST /claim**: Create a new claim entry.
-   **GET /claim**: Retrieve all claim entries.
-   **GET /claim/`id`**: Retrieve a specific claim entry by ID.
-   **PUT /claim/`id`** : Update a specific claim entry by ID.
-   **DELETE /claim/`id`**: Delete a specific claim entry by ID.
-   **GET /claim/insurance/`insurance_id`**: Retrieve all claim entries for an specific insurance.

#### Log

-   **POST /log**: Create a new log entry.
-   **GET /log**: Retrieve all log entries.
-   **GET /log/`id`**: Retrieve a specific log entry by ID.
-   **PUT /log/`id`** : Update a specific log entry by ID.
-   **DELETE /log/`id`**: Delete a specific log entry by ID.

### Example JSON for POST Request

#### Insurance POST json

```
{
  "user_id": "123",
  "type": "Health",
  "max_coverage": "100000.00",
  "start_date": "2024-10-01T00:00:00Z",
  "end_date": "2025-10-01T00:00:00Z"
}
``` 

#### Insurance POST json

```
{
  "insurance_id": "1",
  "claim_number": "12345.67",
  "claim_date": "2024-10-01T00:00:00Z",
  "end_date": "2024-10-01T00:00:00Z",
  "claim_amount": "5000.00",
  "status": "Approved"
}
```
## Contributors

-   [Davi Souza](https://github.com/davisouzal) - creator and maintainer
-   [José Augusto](https://github.com/jaofe) - cocreator and maintainer


