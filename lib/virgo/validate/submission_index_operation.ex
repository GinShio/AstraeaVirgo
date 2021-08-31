defmodule AstraeaVirgo.Validate.SubmissionIndexOperation do
  use Exop.Operation

  @moduledoc """
  Validate Param for Submission Index API
    - `GET /api/submissions`

  Request params: **Query**

    | field   | type | required | descript |
    |---------|------|----------|----------|
    | user_id | ID   | yes      | User ID  |
  """

  parameter "user_id", type: :string, func: &AstraeaVirgo.Validator.is_snowflake/2

  def process(params) do
    case AstraeaVirgo.Cache.User.show(params["user_id"]) do
      {:ok, nil} -> {:error, {:validation, %{"user_id" => ["not exists."]}}}
      {:ok, user} ->
        case user.permission do
          "solo" -> true
          "contestant" -> true
          _ -> false
        end
      error -> error
    end
  end

end
