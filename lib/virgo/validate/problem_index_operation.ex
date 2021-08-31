defmodule AstraeaVirgo.Validate.ProblemIndexOperation do
  use Exop.Operation

  @moduledoc """
  Validate Param for Problem Index API
    - `GET /api/problems`

  Request params: **Query**

    | field    | type   | required | default |
    |----------|--------|----------|---------|
    | category | string | no       | default |
  """

  parameter "category", type: :string, required: false, default: "default"

  def process(params) do
    case params["category"] do
      "" -> {:ok, %{params | "category" => "default"}}
      _ -> {:ok, params}
    end
  end

end
