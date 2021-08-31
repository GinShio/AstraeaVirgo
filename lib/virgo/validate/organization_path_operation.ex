defmodule AstraeaVirgo.Validate.OrganizationPathOperation do
  use Exop.Operation

  @moduledoc """
  Validate the Path Variables of the Organization API

  Authorization: Bearer Token (if permission is admin)

  Request params: Path

    | field           | type | descript        |
    |-----------------|------|-----------------|
    | organization_id | ID   | organization ID |
  """

  parameter "organization_id", type: :string, from: "id", func: &AstraeaVirgo.Validator.is_id/2

  def process(params) do
    case AstraeaVirgo.Cache.Organization.exist?(params["organization_id"]) do
      true -> {:ok, params}
      false -> {:error, {:validation, %{"organization_id" => ["not exists."]}}}
      error -> error
    end
  end

end
