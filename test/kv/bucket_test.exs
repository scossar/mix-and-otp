defmodule Kv.BucketTest do
  use ExUnit.Case, async: true

  test "stores value by key" do
    {:ok, bucket} = KV.Bucket.start_link([])
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  # NOTE: the use of `config.test` for the name in the test.
  # It prevents the conflict/error that would occur if two tests
  # attempted to create a `:shopping_list` process.
  test "stores values by key on a named process", config do
    {:ok, _} = KV.Bucket.start_link(name: config.test)
    assert KV.Bucket.get(config.test, "milk") == nil

    KV.Bucket.put(config.test, "milk", 3)
    assert KV.Bucket.get(config.test, "milk") == 3
  end

  test "deletes a key from a named process", config do
    {:ok, _} = KV.Bucket.start_link(name: config.test)
    KV.Bucket.put(config.test, "milk", 3)
    assert KV.Bucket.get(config.test, "milk") == 3

    previous = KV.Bucket.delete(config.test, "milk")
    assert previous == 3
    assert KV.Bucket.get(config.test, "milk") == nil
  end
end
