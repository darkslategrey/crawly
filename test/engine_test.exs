defmodule EngineTest do
  use ExUnit.Case

  test "list_spiders/0 lists all spiders and their current status in the engine" do
    assert spiders = Crawly.Engine.list_spiders()
    assert [_ | _] = spiders
    assert status = Enum.find(spiders, fn s -> s.name == TestSpider end)
    assert status.state == :stopped
    assert status.pid == nil

    # test a started spider
    Crawly.Engine.start_spider(TestSpider)

    assert started_status =
             Crawly.Engine.list_spiders()
             |> Enum.find(fn s -> s.name == TestSpider end)

    assert started_status.state == :started
    assert started_status.pid
  end

  test "start_all_spiders/0 starts all spiders in the engine" do
    assert :ok = Crawly.Engine.start_all_spiders()
    statuses = Crawly.Engine.list_spiders()

    assert Enum.all(statuses, fn status ->
             status.started == :started and not is_nil(status.pid)
           end)
  end
end
