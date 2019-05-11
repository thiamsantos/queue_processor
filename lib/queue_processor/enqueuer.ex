defmodule QueueProcessor.Enqueuer do
  alias QueueProcessor.{QueueRegistry, QueueSupervisor, Consumer}

  require Logger

  def enqueue(name, message) do
    QueueRegistry
    |> Registry.lookup(name)
    |> handle_registry_lookup(name, message)
  end

  defp handle_registry_lookup([], name, message) do
    log(~s(Starting consumer for queue "#{name}"))
    DynamicSupervisor.start_child(QueueSupervisor, {Consumer, name: name, initial_value: message})
  end

  defp handle_registry_lookup([{pid, _value}], name, message) do
    log(~s(Enqueueing new message for queue "#{name}"))
    Consumer.enqueue(pid, message)
  end

  defp log(message) do
    Logger.info("[#{inspect(__MODULE__)}] #{message}")
  end
end
