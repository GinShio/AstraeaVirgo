defmodule AstraeaVirgoWeb.Router do
  use AstraeaVirgoWeb, :router

  @moduledoc false

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.Pipeline,
      otp_app: :virgo,
      module: AstraeaVirgo.Token,
      error_handler: AstraeaVirgo.Token.ErrorHandler
    plug Guardian.Plug.VerifyHeader, claims: %{typ: "access"}, realm: "Bearer"
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :ensure do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :perm_one_of do
    plug Guardian.Permissions, one_of: [
      %{user: ["solo"]},
      %{user: ["admin"]},
      %{user: ["contestant"]},
    ]
  end

  pipeline :perm_solo do
    plug Guardian.Permissions, ensure: %{user: ["solo"]}
  end

  pipeline :perm_admin do
    plug Guardian.Permissions, ensure: %{user: ["admin"]}
  end

  pipeline :perm_contestant do
    plug Guardian.Permissions, ensure: %{user: ["contestant"]}
  end

  scope "/api", AstraeaVirgoWeb do
    pipe_through :api

    # Base
    resources("/judgement-types", JudgementTypeController, only: [:index, :show])
    resources("/languages", LanguageController, only: [:index, :show])
    resources("/organizations", OrganizationController, only: [:index, :show])
    resources("/submissions", SubmissionController, only: [:index, :show])
    get("/submissions/:id/check", SubmissionController, :check)

    # Token
    post("/tokens", TokenController, :create)
    resources("/users", UserController, only: [:create, :show])
    resources("/sessions", SessionController, only: [:create])

    # maybe auth
    scope "/" do
      pipe_through [:auth]
      resources("/problems", ProblemController, only: [:index, :show])
      get("/problems/:id/detail", ProblemController, :detail)
    end
  end

  scope "/api", AstraeaVirgoWeb, as: :auth do
    pipe_through [:api, :auth, :ensure]

    # user
    resources("/users", UserController, only: [:update, :delete])
    resources("/sessions", SessionController, only: [:update])

    # perm: user
    scope "/" do
      pipe_through [:perm_solo]
      post("/submissions", SubmissionController, :create)
      get("/submissions/:id/detail", SubmissionController, :detail)
    end
  end

  scope "/api", AstraeaVirgoWeb, as: :admin do
    pipe_through [:api, :auth, :ensure, :perm_admin]

    resources("/contests", ContestController, only: [:create, :delete])
    resources("/languages", LanguageController, only: [:create, :update, :delete])
    resources("/organizations", OrganizationController, only: [:create, :update, :delete])
    resources("/problems", ProblemController, only: [:create, :update, :delete])
  end

  scope "/api/contests", AstraeaVirgoWeb, as: :contests do
    pipe_through [:api, :auth]

    resources("/", ContestController, only: [:index, :show])

    scope "/:contest_id", Contests do
      resources("/judgement-types", JudgementTypeController, only: [:index, :show])
      resources("/languages", LanguageController, only: [:index, :show])
      resources("/organizations", OrganizationController, only: [:index, :show])
      resources("/problems", ProblemController, only: [:index, :show])
      get("/problems/:id/detail", ProblemController, :detail)
      resources("/submissions", SubmissionController, only: [:index, :show])
    end

    scope "/:contest_id", Contests do
      pipe_through [:ensure, :perm_admin]
    end

    scope "/:contest_id", Contests do
      pipe_through [:ensure, :perm_contestant]
      post("/submissions", SubmissionController, :create)
      get("/submissions/:id/detail", SubmissionController, :detail)
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: AstraeaVirgoWeb.Telemetry
    end
  end
end
