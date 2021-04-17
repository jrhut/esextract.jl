## esextract.jl

Query elasticsearch databases straight into a DataFrame. Wraps a python package of the same name.

# Installation

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

At this point if you are using a venv virtual environment you need to configure you julia python variable

Use ```ENV["PYTHON"] = "path/to/venv/bin/python"``` to do this then call ```Pkg.build("PyCall")``` to rebuild the package.

Now all thats left to use this project is starting up the project environment with ```Pkg.activate("path/to/local/repo")```

This will allow you to finally use ```using esextract```
