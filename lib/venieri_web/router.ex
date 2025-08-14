defmodule VenieriWeb.Router do
  use VenieriWeb, :router

  import Oban.Web.Router
  import VenieriWeb.UserAuth
  import Backpex.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VenieriWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VenieriWeb do
    pipe_through :browser

    get "/media/export/:slug", MediaController, :export

    live "/media", MediaLive.Index
    live "/media/:slug", MediaLive.Show

    live "/", PostLive.Index
    live "/bio", BioLive.Index
    live "/posts", PostLive.Index
    live "/posts/:slug", PostLive.Show
    # live "/works", WorkLive.Index
    live "/works/:slug", WorkLive.Show
    live "/projects", ProjectLive.Index
    live "/projects/:id", ProjectLive.Show
    live "/virtual-world", VirtualWorld
  end

  scope "/admin", VenieriWeb.Admin do
    pipe_through :browser

    # add this line
    backpex_routes()

    get "/", RedirectController, :redirect_to_posts

    live_session :default, on_mount: Backpex.InitAssigns do
      # add this line
      live_resources "/media", MediaLive
      live_resources "/projects", ProjectsLive
      live_resources "/tags", TagsLive
      live_resources "/works", WorksLive
      live_resources "/posts", PostsLive
      live_resources "/references", ReferencesLive
      live_resources "/snippets", SnippetsLive
    end
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

    scope "/" do
      pipe_through :browser

      oban_dashboard("/oban")
    end
  end

  ## Authentication routes

  scope "/", VenieriWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{VenieriWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", VenieriWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{VenieriWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
