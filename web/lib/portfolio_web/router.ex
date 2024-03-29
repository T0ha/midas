defmodule PortfolioWeb.Router do
  use PortfolioWeb, :router

  import PortfolioWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PortfolioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PortfolioWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/assets", AssetLive.Index, :index
    live "/assets/new", AssetLive.Index, :new
    live "/assets/:id/edit", AssetLive.Index, :edit

    live "/assets/:id", AssetLive.Show, :show
    live "/assets/:id/show/edit", AssetLive.Show, :edit


    live "/prices/new", PriceLive.Index, :new
    live "/prices/:id/edit", PriceLive.Index, :edit

    live "/prices/:id", PriceLive.Show, :show
    live "/prices/:id/show/edit", PriceLive.Show, :edit

    live "/wallets", WalletLive.Index, :index
    live "/wallets/new", WalletLive.Index, :new
    live "/wallets/:id/edit", WalletLive.Index, :edit

    live "/wallets/:id", WalletLive.Show, :show
    live "/wallets/:id/show/edit", WalletLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", PortfolioWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:portfolio, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PortfolioWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PortfolioWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [PortfolioWeb.AssignTopSelects, {PortfolioWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PortfolioWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [PortfolioWeb.AssignTopSelects, {PortfolioWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/api_keys", ApiKeyLive.Index, :index
      live "/api_keys/new", ApiKeyLive.Index, :new
      live "/api_keys/:id/edit", ApiKeyLive.Index, :edit

      live "/api_keys/:id", ApiKeyLive.Show, :show
      live "/api_keys/:id/show/edit", ApiKeyLive.Show, :edit

    live "/balances", BalanceLive.Index, :index

    live "/balances/:id", BalanceLive.Show, :show
    live "/balances/:id/show/edit", BalanceLive.Show, :edit
    end
  end

  scope "/", PortfolioWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{PortfolioWeb.UserAuth, :mount_current_user}, PortfolioWeb.AssignTopSelects] do
      live "/prices", PriceLive.Index, :index
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
