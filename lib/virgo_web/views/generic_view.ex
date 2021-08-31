defmodule AstraeaVirgoWeb.GenericView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Generic Response
  """

  @doc """
  Response

  ## empty.txt
  Response nothing
  """
  def render("empty.txt", _assigns), do: ""

end
