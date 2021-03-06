defmodule ExPolygon.Rest.Crypto.SnapshotSingle do
  @moduledoc """
  Returns a call to Crypto "Snapshot - Single Ticker" Polygon.io
  """

  @type snap :: ExPolygon.Snapshot.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/snapshot/locale/global/markets/crypto/tickers/:symbol"

  @spec query(String.t(), api_key) :: {:ok, snap} | {:error, shared_error_reasons}
  def query(symbol, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":symbol", symbol)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK", "ticker" => ticker}) do
    {:ok, snapshot} =
      Mapail.map_to_struct(ticker, ExPolygon.Snapshot, transformations: [:snake_case])

    {:ok, snapshot}
  end

  defp parse_response(%{"status" => "NOT_FOUND"} = _data) do
    {:error, :not_found}
  end

  defp parse_response(_) do
    {:error, :bad_request}
  end
end
