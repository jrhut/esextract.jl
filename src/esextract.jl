module esextract
export get_query_dataframe, get_query_json, write_dataframe, read_dataframe

using PyCall
using DataFrames
using CSV

"""
Converts from a Python Pandas DataFrame to a Julia DataFrame
...
# Arguments
- `p_df::Pandas DataFrame`: a pandas python DataFrame
# Returns 
- `DataFrame`: julia DataFrame
...
"""
function p_df_to_j_df(p_df::PyObject)
    println("Converting from python DataFrame to julia DataFrame")
    cols = p_df[:columns]
    j_df = DataFrame(Any[collect(values(p_df[c])) for c in cols], map(Symbol, cols))
    return j_df
end
"""
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
"""
function get_query_dataframe(; index::Union{String, Nothing}=nothing, paging_id_field::Union{String, Nothing}=nothing, 
    paging_time_field::Union{String, Nothing}=nothing, return_fields::Union{Vector{String}, Nothing}=String[], 
    fields_to_search::Union{Vector{String}, Nothing}=String[], search_string::Union{String, Nothing}=nothing, 
    field_to_exist::Union{String, Nothing}=nothing, date_field::Union{String, Nothing}=nothing, 
    start_date::Union{String, Nothing}=nothing, end_date::Union{String, Nothing}=nothing, is_match_all::Bool=false)
    
    es = pyimport("esextract")

    p_df = es.query_to_dataframe(index, paging_id_field, paging_time_field, return_fields, 
        fields_to_search, search_string, field_to_exist, date_field, start_date, end_date, is_match_all)
    
    df = p_df_to_j_df(p_df)

    return df
end

"""
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
"""
function get_query_json(; index::Union{String, Nothing}=nothing, paging_id_field::Union{String, Nothing}=nothing, 
    paging_time_field::Union{String, Nothing}=nothing, return_fields::Union{Vector{String}, Nothing}=String[], 
    fields_to_search::Union{Vector{String}, Nothing}=String[], search_string::Union{String, Nothing}=nothing, 
    field_to_exist::Union{String, Nothing}=nothing, date_field::Union{String, Nothing}=nothing, 
    start_date::Union{String, Nothing}=nothing, end_date::Union{String, Nothing}=nothing, is_match_all::Bool=false)

    es = pyimport("esextract")

    json = es.query_to_json(index, paging_id_field, paging_time_field, return_fields, 
        fields_to_search, search_string, field_to_exist, date_field, start_date, end_date, is_match_all)

    return json
end

"""
Writes a DataFrame to CSV
...
# Arguments
- `path::String`: path to file output
- `df::DataFrame`: DataFrame to save
...
"""
function write_dataframe(path::String, df::DataFrame)
    println("Writing dataframe to csv")
    CSV.write(path, df)
end

"""
Reads a DataFrame in from csv, json and arrow parquet
...
# Arguments
- `path::String`: path to file output
# Returns
- `df::DataFrame`: DataFrame from file
...
"""
function read_dataframe(path::String)
    println("Reading data into dataframe")
    es = pyimport("esextract")
    p_df = es.read_dataframe_from_file(path)
    df = p_df_to_j_df(p_df)
    return df
end

end # module
