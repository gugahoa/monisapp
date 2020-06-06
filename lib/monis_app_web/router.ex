defmodule MonisAppWeb.Router do
  use MonisAppWeb, :router

  import MonisAppWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MonisAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/", MonisAppWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    delete "/register", UserRegistrationController, :delete
  end

  scope "/", MonisAppWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", PageLive, :index
  end

  scope "/", MonisAppWeb do
    pipe_through :browser

    delete "/logout", UserSessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", MonisAppWeb do
  #   pipe_through :api
  # end
end
