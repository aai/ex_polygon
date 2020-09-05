defmodule ExPolygon.Rest.TickerTypes do
  @moduledoc """
  Returns a call to "Ticker Types" Polygon.io
  """

  @type type :: ExPolygon.TickerType.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/reference/types"

  @spec query(api_key) :: {:ok, type} | {:error, shared_error_reasons}
  def query(api_key) do
    with {:ok, data} <- ExPolygon.Rest.HTTPClient.get(@path, %{}, api_key) do
      parse_response(data)
    end
  end

  def parse_response(%{"status" => "OK", "results" => results}) do
    {:ok, type} =
      Mapail.map_to_struct(results, ExPolygon.TickerType, transformations: [:snake_case])

    {:ok, type}
  end
end
