defmodule AstraeaVirgo.Cache.Judgement do
  @moduledoc """
  Implement Judgement operation for cache

  ## Judgement Info
  It shares KV with `AstraeaVirgo.Cache.Submission`

  ## Judgement Check
  A string of judgement check
    - Key: `Astraea:Submission:ID:<submission_id>:Check`
    - type: string
    - Value:
      - "Pending"
      - "Finished"
  """

  use AstraeaVirgo.Cache.Utils.Hash

  def get_show_key(id), do: "Astraea:Submission:ID:#{id}"
  def get_check_key(id), do: "Astraea:Submission:ID:#{id}:Check"
  defp get_field_name(), do: ["id", "submitter", "judgement", "code", "message"]
  defp get_empty_value(), do: [nil, nil, nil, nil, nil]

  defp get_info_from_db(id) do
    # TODO: request submission info from DB
    {:ok, nil}
  end

  defp parse([id, submitter, judgement, code, message]) do
    %{
      id: id,
      submitter: submitter,
      judgement: judgement,
      code: code,
    } |>
      AstraeaVirgo.Cache.Utils.Parse.message(message)
  end

  def check(id) do
    case Redix.command(:redix, ["GET", get_check_key(id)]) do
      {:ok, "Pending"} -> {:ok, :pending}
      {:ok, "Finished"} -> {:ok, :finished}
      {:ok, _} -> {:ok, nil}
      {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
    end
  end

end
