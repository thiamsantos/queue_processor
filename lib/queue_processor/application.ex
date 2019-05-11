defmodule QueueProcessor.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: QueueProcessor.QueueSupervisor},
      {Registry, keys: :unique, name: QueueProcessor.QueueRegistry},
      {Task.Supervisor, name: QueueProcessor.EnqueuerTaskSupervisor},
      QueueProcessorWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: QueueProcessor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    QueueProcessorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
