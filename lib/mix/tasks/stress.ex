defmodule Mix.Tasks.Stress do
  use Mix.Task

  @queues Enum.map(1..100, fn _ -> Faker.Internet.user_name() end)

  @impl Mix.Task
  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:faker)
    {:ok, _} = Application.ensure_all_started(:httpoison)

    1..10_000
    |> Task.async_stream(fn _ ->
      enqueue_message()
    end, max_concurrency: 32)
    |> Stream.run()
  end

  defp enqueue_message do
    message = Faker.Internet.user_name()
    queue = Enum.random(@queues)

    HTTPoison.get("http://localhost:4000/receive-message?queue=#{queue}&message=#{message}")
  end
end
