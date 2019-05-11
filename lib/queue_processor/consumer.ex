defmodule QueueProcessor.Consumer do
  use GenServer

  require Logger

  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)
    initial_value = Keyword.fetch!(opts, :initial_value)

    GenServer.start_link(__MODULE__, {name, initial_value})
  end

  def enqueue(pid, message) do
    GenServer.cast(pid, {:in, message})
  end

  @impl true
  def init({name, initial_value}) do
    log(~s(Running for queue "#{name}"))

    {:ok, _} = Registry.register(QueueProcessor.QueueRegistry, name, :queue)
    :timer.send_interval(1_000, :process)

    {:ok, %{name: name, queue: :queue.in(initial_value, :queue.new())}}
  end

  @impl true
  def handle_cast({:in, message}, %{queue: queue} = state) do
    new_queue = :queue.in(message, queue)
    {:noreply, %{state | queue: new_queue}}
  end

  @impl true
  def handle_info(:process, %{queue: queue, name: name} = state) do
    {result, new_queue} = :queue.out(queue)

    case result do
      {:value, message} ->
        log(~s(Processing "#{message}" for queue "#{name}"))

      :empty ->
        log(~s(Queue "#{name}" is empty!))
    end

    {:noreply, %{state | queue: new_queue}}
  end

  defp log(message) do
    Logger.info("[#{inspect(__MODULE__)}] #{message}")
  end
end
