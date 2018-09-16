defmodule PhoenixIm.Router do
  use PhoenixIm.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do

  end

  scope "/api", PhoenixIm do
    pipe_through :api
    post "/send/user", ApiController, :sendUser
    post "/send/room", ApiController, :sendRomm
    get "/socket/container/info", ApiController, :socketContainerInfo
    get "/socket/all", ApiController, :allSocket
  end

  scope "/", PhoenixIm do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/socket/test", PageController, :socketTest
  end



  # Other scopes may use custom stacks.
  # scope "/api", PhoenixIm do
  #   pipe_through :api
  # end
end
