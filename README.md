# esextract.jl

Query elasticsearch databases straight into a DataFrame. Wraps a python package of the same name.

## Installation

Requires python3.8, steps for using venv virtual environment will be described below.

Install the python package esextract ```pip install -i https://test.pypi.org/simple/ esextract==0.0.1```

Now configue some environment variables as so

```
ELASTIC_HOST = {{ELASTICSEARCH HOST ADDRESS}}
ELASTIC_PORT = {{ELASTICSEARCH PORT}}
ELASTIC_USER = {{ELASTICSEARCH LOGIN USERNAME}}
ELASTIC_SECRET = {{ELASTICSEARCH LOGIN PASSWORD}}
```

Optionally to make life easier also configure the default variables below. This will save you needing extra arguments when making a query.

```
DEFAULT_INDEX = {{DEFAULT INDEX TO QUERY}}
DEFAULT_DATE_FIELD = {{DEFAULT DATE FIELD FOR RANGE SEARCHES}} 
PAGE_ID_FIELD = {{THE DOCUMENT ID FIELD TO PAGE ON}}
PAGE_TIME_FIELD = {{THE DOCUMENT DATE FIELD TO PAGE ON}}
```

Now the python package is configured clone this repository to your local system.

Make sure you have the dependancies with

```
using Pkg
Pkg.add("DataFrames")
Pkg.add("CSV")
Pkg.add("PyCall")
```

At this point if you are using a venv virtual environment or non default python you need to configure you julia python variable

Use ```ENV["PYTHON"] = "path/to/venv/bin/python"``` to do this then call ```Pkg.build("PyCall")``` to rebuild the package.

Now all thats left to use this project is starting up the project environment with ```Pkg.activate("path/to/local/repo")```

This will allow you to finally use ```using esextract```

## Usage

This package provides functions get_query_dataframe, get_query_json, write_dataframe and read_dataframe.

```
  get_query_dataframe(index, paging_id_field, paging_time_field, return_fields, fields_to_search, field_to_exist, date_field, start_date, end_date, is_match_all)
  
Takes elasticsearch query parameters and returns result as DataFrame
...
# Arguments
- `index::String`: the elasticsearch index you want to query
- `paging_id_field::String` (str): the id field to page on
- `paging_time_field::String`: the date/time field to page on
- `return_fields::Array`: the fields you want returned from the query
- `fields_to_search::Array`: the fields you want to search for your query string in
- `search_string::String`: the terms you want to search for in the search fields
- `field_to_exist::String`: supplied field will be used as an extra check to 
    only return documents where this field isn't null
- `date_field::String`: supplied field will be used to search by a custom date field
    use in conjunction with start_date and end_date args
- `start_date::String`: the first date you want to return documents from in format
    yyyy-mm-dd
- `end_date::String`: the last date you want to return documents from in format
    yyyy-mm-dd, can also be set to 'now' to use current date
- `is_match_all::Number`: this overrides search terms and exist terms and returns
    all documents between start and end dates if specified
# Returns 
- `DataFrame`: julia DataFrame
...
```

```
  get_query_json(index, paging_id_field, paging_time_field, return_fields, fields_to_search, field_to_exist, date_field, start_date, end_date, is_match_all)
  
Takes elasticsearch query parameters and returns result as a JSON dictionary
...
# Arguments
- `index::String`: the elasticsearch index you want to query
- `paging_id_field::String` (str): the id field to page on
- `paging_time_field::String`: the date/time field to page on
- `return_fields::Array`: the fields you want returned from the query
- `fields_to_search::Array`: the fields you want to search for your query string in
- `search_string::String`: the terms you want to search for in the search fields
- `field_to_exist::String`: supplied field will be used as an extra check to 
    only return documents where this field isn't null
- `date_field::String`: supplied field will be used to search by a custom date field
    use in conjunction with start_date and end_date args
- `start_date::String`: the first date you want to return documents from in format
    yyyy-mm-dd
- `end_date::String`: the last date you want to return documents from in format
    yyyy-mm-dd, can also be set to 'now' to use current date
- `is_match_all::Number`: this overrides search terms and exist terms and returns
    all documents between start and end dates if specified
# Returns 
- `Dict`: Json results
...
```

```
  write_dataframe(path, df)

Writes a DataFrame to CSV
...
# Arguments
- `path::String`: path to file output
- `df::DataFrame`: DataFrame to save
...
```

```
  read_dataframe(path)
  
Reads a DataFrame in from csv, json and arrow parquet
...
# Arguments
- `path::String`: path to file output
# Returns
- `df::DataFrame`: DataFrame from file
...
```

Examlpe without optional env variables 

```get_query_dataframe(index="index01", paging_id_field="id", paging_time_field="date", fields_to_search=["body"], search_string="Hello!")```

Example with optional env variables

```get_query_json(field_to_exist="url", fields_to_search=["body"], search_string="Bye!")```

