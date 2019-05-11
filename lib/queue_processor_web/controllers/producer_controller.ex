defmodule QueueProcessorWeb.ProducerController do
  use QueueProcessorWeb, :controller

  alias QueueProcessor.Enqueuer

  def receive_message(conn, %{"queue" => queue, "message" => message}) do
    Task.Supervisor.start_child(QueueProcessor.EnqueuerTaskSupervisor, Enqueuer, :enqueue, [
      queue,
      message
    ])

    conn
    |> json(%{data: %{queue: queue, message: message}, success: true, error: nil})
  end

  def receive_message(conn, _params) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{data: nil, success: false, error: %{code: 101, message: "invalid params"}})
  end
end
