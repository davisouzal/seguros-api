`# seguros-api

seguros-api is a RESTful API for managing insurance records. This API allows users to create, read, update, and delete insurance entries efficiently.

## Installation

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
    `shards install` 
    ```
    

## Usage

To start the API server, run the following command:

`make run` 

The server will start running at `http://localhost:3000`.

### Endpoints

-   **POST /insurances**: Create a new insurance entry.
-   ~~**GET /insurances**: Retrieve all insurance entries.~~
-   ~~**GET /insurances/**: Retrieve a specific insurance entry by ID.~~
-   ~~**PUT /insurances/{id}** : Update a specific insurance entry by ID.~~
-   ~~**DELETE /insurances/{id}**: Delete a specific insurance entry by ID.~~

### Example JSON for POST Request

```
{
  "user_id": 123,
  "type": "Health",
  "max_coverage": 100000.00,
  "start_date": "2024-10-01T00:00:00Z",
  "end_date": "2025-10-01T00:00:00Z"
}
``` 

## Contributors

-   [Davi Souza](https://github.com/davisouzal) - creator and maintainer
-   [José Augusto](https://github.com/jaofe) - cocreator and maintainer


