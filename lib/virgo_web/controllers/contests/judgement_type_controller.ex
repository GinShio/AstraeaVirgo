defmodule AstraeaVirgoWeb.Contests.JudgementTypeController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Contest Judgement Type API for specified contest
    - `GET /api/contests/<contest_id>/judgment-types`: get judgement types info for specified contest
    - `GET /api/contests/<contest_id>/judgment-types/<judgement_type_id>`: get specified judgement type info for specified contest

  These APIs are aliases of `AstraeaVirgoWeb.JudgementTypeController`, and the execution results are exactly the same
  """

  def index(conn, params) do
    AstraeaVirgoWeb.JudgementTypeController.index(conn, params)
  end

  def show(conn, params) do
    AstraeaVirgoWeb.JudgementTypeController.show(conn, params)
  end
end
