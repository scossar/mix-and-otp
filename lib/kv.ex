defmodule KV do
  use Application

  # The `@impl true` annotation indicates that a callback is bding implemented.
  @impl true
  def start(_type, _args) do
    children = [
      # A child specification; typically represented as `{module, options}`, i.e.
      # `{Registry, name: KV, keys: :unique}`
      {Registry, name: KV, keys: :unique},
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @doc """
  Creates a bucket with the given name.
  """
  def create_bucket(name) do
    DynamicSupervisor.start_child(KV.BucketSupervisor, {KV.Bucket, name: via(name)})
  end

  @doc """
  Looks up the given bucket.
  """
  def lookup_bucket(name) do
    GenServer.whereis(via(name))
  end

  defp via(name), do: {:via, Registry, {KV, name}}
end
