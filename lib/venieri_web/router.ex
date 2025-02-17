defmodule VenieriWeb.Router do
  use VenieriWeb, :router

  import VenieriWeb.UserAuth
  import Backpex.Router
  import Oban.Web.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VenieriWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user

  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VenieriWeb do
    pipe_through :browser

    live "/", EventList
    # live "/", Archive.EventList
    # get "/", PageController, :events
    live "/bio", BioLive
    live "/projects", ProjectsLive
    get "/projects/:id", PageController, :project
    get "/events", PageController, :events
    get "/events/:id", PageController, :event
    get "/virtual-world", PageController, :virtual_world


    resources "/archives/references", ReferenceController
    get "/test", PageController, :test
    # get "/", PageController, :home

     oban_dashboard "/oban"
  end

  # Other scopes may use custom stacks.
  # scope "/api", VenieriWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:venieri, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VenieriWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/admin", VenieriWeb do
    pipe_through :browser

    # add this line
    backpex_routes()

    # get "/", RedirectController, :redirect_to_posts

    live_session :default, on_mount: Backpex.InitAssigns do
        live_resources "/posts", AdminPostLive
        live_resources "/projects", AdminProjectLive
        live_resources "/tags", AdminTagLive
        live_resources "/works", AdminWorkLive
        live_resources "/media", AdminMediaLive
        live_resources "/events", AdminEventLive
        live_resources "/references", AdminReferenceLive
    end
  end

  ## Authentication routes

  scope "/", VenieriWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{VenieriWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", VenieriWeb do
    pipe_through [:browser, :require_authenticated_user]



    live_session :require_authenticated_user,
      on_mount: [{VenieriWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email


      live "/archives/tags", Archives.TagLive.Index, :index
      live "/archives/tags/new", Archives.TagLive.Index, :new
      live "/archives/tags/:id/edit", Archives.TagLive.Index, :edit
      live "/archives/tags/:id", Archives.TagLive.Show, :show
      live "/archives/tags/:id/show/edit", Archives.TagLive.Show, :edit

      live "/archives/projects", Archives.ProjectLive.Index, :index
      live "/archives/projects/new", Archives.ProjectLive.Index, :new
      live "/archives/projects/:id/edit", Archives.ProjectLive.Index, :edit
      live "/archives/projects/:id", Archives.ProjectLive.Show, :show
      live "/archives/projects/:id/show/edit", Archives.ProjectLive.Show, :edit


      live "/archives/works", Archives.WorkLive.Index, :index
      live "/archives/works/new", Archives.WorkLive.Index, :new
      live "/archives/works/:id/edit", Archives.WorkLive.Index, :edit
      live "/archives/works/:id", Archives.WorkLive.Show, :show
      live "/archives/works/:id/show/edit", Archives.WorkLive.Show, :edit

      # live "/archives/events", Archives.EventLive.Index, :index
      live "/archives/events/new", Archives.EventLive.Index, :new
      live "/archives/events/:id/edit", Archives.EventLive.Index, :edit
      live "/archives/events/:id", Archives.EventLive.Show, :show
      live "/archives/events/:id/show/edit", Archives.EventLive.Show, :edit


      live "/archives/media", Archives.MediaLive.Index, :index
      live "/archives/media/new", Archives.MediaLive.Index, :new
      live "/archives/media/:id/edit", Archives.MediaLive.Index, :edit
      live "/archives/media/:id", Archives.MediaLive.Show, :show
      live "/archives/media/:id/show/edit", Archives.MediaLive.Show, :edit



    end
  end

  scope "/", VenieriWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{VenieriWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end




end
