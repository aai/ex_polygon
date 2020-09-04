defmodule ExPolygon.Rest.CryptoSnapshotGainersLosers do
  @type snap :: ExPolygon.Snapshot.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/snapshot/locale/global/markets/crypto/:direction"

  @spec query(String.t(), api_key) :: {:ok, [snap]} | {:error, shared_error_reasons}
  def query(group, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":direction", group)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
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
end
