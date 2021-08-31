defmodule AstraeaVirgoWeb.Contests.OrganizationController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Contest Organization API for specified contest
    - `GET /api/contests/<contest_id>/organizations`: get organizations info for specified contest
    - `GET /api/contests/<contest_id>/organizations/<organization_id>`: get specified organization info for specified contest

  These APIs are aliases of `AstraeaVirgoWeb.OrganizationController`, and the execution results are exactly the same
  """

  def index(conn, params) do
    AstraeaVirgoWeb.OrganizationController.index(conn, params)
  end

  def show(conn, params) do
    AstraeaVirgoWeb.OrganizationController.show(conn, params)
  end
end
