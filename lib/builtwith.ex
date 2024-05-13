defmodule Builtwith do
  @moduledoc """
  An unofficial module for interacting with the Builtwith API.

  Please note: This module is not an official Builtwith API client and is not affiliated with or endorsed by Builtwith. It is a third-party implementation.

  This module provides functions to make requests to the Builtwith API and extract specific data from the JSON response.

  To use this module, you need to have a valid Builtwith API key (bwpass).
  """

  def make_request(domain: domain, bwpass: bw_pass) do
    url = "https://api.builtwith.com/v21/api.json?KEY=#{bw_pass}&LOOKUP=#{domain}"

    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:ok, %{status_code: status_code}} ->
        {:error, "Request failed with status code: #{status_code}"}
      {:error, error} ->
        {:error, "Request failed with error: #{inspect(error)}"}
    end
  end


  def get_results(response) do
    with {:ok, data} <- response do
      Map.get(data, "Results")
    end
  end

  @doc """
  This function takes a JSON object and returns the 'IsDB' field from the 'Result' field of the JSON object.

  ## Examples

      iex> Builtwith.get_db_status([%{"Result" => %{"IsDB" => true}}])
      true

  Possible return values are `true`, `false`, `"Misleading"`, or `nil` if the 'Result' or 'IsDB' field is not found.
  """
  def get_db_status(builtwithjson) do
    get_results(builtwithjson)
    |> Enum.find(fn map -> Map.has_key?(map, "Result") end)
      |> case do
        nil ->
          nil
        dbstatus ->
          Map.get(dbstatus, "Result")
          |> Map.get("IsDB")
      end
  end

  @doc """
  This function takes the result of a Builtwith API request and returns the value of the 'Lookup' field, which is the domain being looked up.

  ## Examples

      iex> results = [%{"Lookup" => "example.com"}]
      iex> Builtwith.get_lookup(results)
      "example.com"

  If the 'Lookup' field is not found, the function returns `nil`.
  """
  def get_lookup(builtwithjson)do
    get_results(builtwithjson)
    |> Enum.find(fn map -> Map.has_key?(map, "Lookup") end)
    |> case do
        nil ->
          nil
        lookup ->
          Map.get(lookup, "Lookup")
      end
  end
  @doc """
  This function takes a list of JSON objects (results from a Builtwith API request) and returns a list of all 'SubDomain' values found in the 'Paths' field of the 'Result' object.

  ## Examples

      iex> Builtwith.get_subdomains([%{"Result" => %{"Paths" => [%{"SubDomain" => "sub1.example.com"}, %{"SubDomain" => "sub2.example.com"}]}}])
      ["sub1.example.com", "sub2.example.com"]

  If no 'SubDomain' values are found, or if the 'Result' or 'Paths' fields are not found, the function returns `nil`.
  """
  def get_subdomains(builtwithjson) do
      get_results(builtwithjson)
      |> Enum.find(fn map -> Map.has_key?(map, "Result") end)
      |> case do
        nil ->
          nil
        subdomains ->
          Map.get(subdomains, "Result")
          |> Map.get("Paths")
          |> Enum.map(fn x -> Map.get(x, "SubDomain") end)
          |> Enum.reject(&(&1 == ""))
      end
  end

  @doc """
  This function takes a list of JSON objects (results from a Builtwith API request) and returns the value of the 'Attributes' field from the first object where this field is found.

  ## Examples

      iex> Builtwith.get_attributes([%{"Attributes" => %{"key" => "value"}}])
      %{"key" => "value"}

  If the 'Attributes' field is not found in any of the JSON objects in the list, the function returns `nil`.
  """
  def get_attributes(builtwithjson) do
      get_results(builtwithjson)
      |> Enum.find(fn map -> Map.has_key?(map, "Attributes") end)
      |> case do
        nil ->
          nil
        attributes ->
          Map.get(attributes, "Attributes")
      end
  end

  @doc """
  This function takes a list of JSON objects (results from a Builtwith API request) and returns the value of the 'Meta' field from the first object where this field is found.

  ## Examples

      iex> Builtwith.get_meta([%{"Meta" => %{"key" => "value"}}])
      %{"key" => "value"}

    If the 'Meta' field is not found in any of the JSON objects in the list, the function returns `nil`.
  """
  def get_meta(builtwithjson) do
        get_results(builtwithjson)
        |> Enum.find(fn map -> Map.has_key?(map, "Meta") end)
        |> case do
          nil -> nil
          meta ->
            Map.get(meta, "Meta")
        end
  end
  @doc """
  This function takes a list of JSON objects (results from a Builtwith API request) and returns the value of the 'Spend' field from the 'Result' object of the first JSON object where the 'Result' field is found.

  ## Examples

      iex> Builtwith.get_spend([%{"Result" => %{"Spend" => 100}}])
      100

  If the 'Result' or 'Spend' field is not found in any of the JSON objects in the list, the function returns `nil`.
  """
  def get_spend(builtwithjson) do
    get_results(builtwithjson)
    |> Enum.find(fn map -> Map.has_key?(map, "Result") end)
    |> case do
      nil ->
        nil
      spend ->
        Map.get(spend, "Result")
        |> Map.get("Spend")
    end
  end
  @doc """
  This function takes a list of JSON objects (results from a Builtwith API request) and returns a map where the keys are the 'Tag' values and the values are lists of technologies with that 'Tag' value, extracted from the 'Technologies' field in the 'Paths' array of the 'Result' object.

  ## Examples

      iex> Builtwith.get_technologies([%{"Result" => %{"Paths" => [%{"Technologies" => [%{"Tag" => "tag1", "Name" => "tech1"}, %{"Tag" => "tag1", "Name" => "tech2"}, %{"Tag" => "tag2", "Name" => "tech3"}]}]}}])
      %{"tag1" => [%{"Tag" => "tag1", "Name" => "tech1"}, %{"Tag" => "tag1", "Name" => "tech2"}], "tag2" => [%{"Tag" => "tag2", "Name" => "tech3"}]}

  If the 'Result', 'Paths', or 'Technologies' field is not found, or if no technologies are present, the function returns an empty map.
  """
  def get_technologies(builtwithjson) do
      get_results(builtwithjson)
      |> Enum.find(fn map -> Map.has_key?(map, "Result") end)
      |> case do
        nil ->
          nil
        technologies ->
          Map.get(technologies, "Result")
          |> Map.get("Paths")
          |> Enum.flat_map(fn path ->
            Map.get(path, "Technologies", [])
          end)
          |> Enum.group_by(fn tech -> Map.get(tech, "Tag") end)
      end
  end
end
