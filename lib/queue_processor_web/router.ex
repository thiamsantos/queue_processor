defmodule QueueProcessorWeb.Router do
  use QueueProcessorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", QueueProcessorWeb do
    get "/receive-message", ProducerController, :receive_message
  end
end
