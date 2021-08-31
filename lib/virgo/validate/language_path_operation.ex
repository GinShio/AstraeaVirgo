defmodule AstraeaVirgo.Validate.LanguagePathOperation do
  use Exop.Operation

  @moduledoc """
  Validate the Path Variables of the Language API

  Authorization: Bearer Token (if permission is admin)

  Request params: Path

    | field        | type | descript    |
    |--------------|------|-------------|
    | lannguage_id | ID   | language ID |
  """

  parameter "language_id", type: :string, from: "id", func: &AstraeaVirgo.Validator.is_id/2

  def process(params) do
    case AstraeaVirgo.Cache.Language.exist?(params["language_id"]) do
      true -> {:ok, params}
      false -> {:error, {:validation, %{"language_id" => ["not exists."]}}}
      error -> error
    end
  end

end
