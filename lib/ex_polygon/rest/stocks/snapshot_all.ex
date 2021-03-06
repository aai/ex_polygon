defmodule ExPolygon.Rest.Stocks.SnapshotAll do
  @moduledoc """
  Returns a call to Stocks "Snapshot - All Tickers" Polygon.io
  """

  @type snap :: ExPolygon.Snapshot.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/snapshot/locale/us/markets/stocks/tickers"

  # Data heavy, may take a while to spit a responce
  @spec query(api_key) :: {:ok, [snap]} | {:error, shared_error_reasons}
  def query(api_key) do
    with {:ok, data} <- ExPolygon.Rest.HTTPClient.get(@path, %{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK", "tickers" => results}) do
    snapshots =
      results
      |> Enum.map(&Mapail.map_to_struct(&1, ExPolygon.Snapshot, transformations: [:snake_case]))
      |> Enum.map(fn {:ok, t} -> t end)

    {:ok, snapshots}
  end

  defp parse_response(%{"status" => "NOT_FOUND"} = _data) do
    {:error, :not_found}
  end

  defp parse_response(_) do
    {:error, :bad_request}
  end
end
