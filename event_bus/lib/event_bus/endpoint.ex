defmodule EventBus.Endpoint do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    # NOTE: This starts Cowboy listening on the default port of 4000
    {:ok, _} = Plug.Adapters.Cowboy.http(__MODULE__, [])
  end

  # curl -H "Content-Type: application/json" -X POST -d '{}' http://localhost:4000/event
  get "/event" do
    send_resp(conn, 200, "Hello, world!")
  end

  # curl -H "Content-Type: application/json" -X POST -d '{"email":"example.org"}' http://localhost:4000/event
  post "/event" do
    {status, body} =
      case conn.body_params do
        %{"email" => email} -> {200, save_email(email)}
        _ -> {422, missing_email()}
      end
    send_resp(conn, status, body)
  end

  def say_hello(email) do
    Poison.encode!(%{response: "Hello, #{email}"})
  end

  defp missing_email do
    Poison.encode!(%{error: "Expected a \"email\" key"})
  end

  defp save_email(email) do
    binary = :erlang.term_to_binary(email)

    File.write("conversions/conversions_#{:os.system_time}", binary)
    Poison.encode!(%{response: "Hello, #{email}"})
  end
end
