defmodule AstraeaVirgoWeb.Contests.LanguageController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Contest Language API for specified contest
    - `GET /api/contests/<contest_id>/languages`: get languages info for specified contest
    - `GET /api/contests/<contest_id>/languages/<language_id>`: get specified language info for specified contest

  These APIs are aliases of `AstraeaVirgoWeb.LanguageController`, and the execution results are exactly the same
  """

  def index(conn, params) do
    AstraeaVirgoWeb.LanguageController.index(conn, params)
  end

  def show(conn, params) do
    AstraeaVirgoWeb.LanguageController.show(conn, params)
  end
end
