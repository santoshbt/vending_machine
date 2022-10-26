defmodule VendingMachineTest do
  use ExUnit.Case
  doctest VendingMachine
  alias VendingMachine.VendingMachineSupervisor

  setup do
    pid =
      start_supervised!(VendingMachineSupervisor,
        start: {VendingMachine, :start_link, []},
        restart: :transient,
        type: :worker
      )

    {:ok, %{pid: pid}}
  end

  describe "Vending machine booted up" do
    test "start_link/1 starts a GenServer" do
      {:ok, pid} = VendingMachine.start_link()
      assert is_pid(pid)
    end
  end

  describe "Vending machine loading" do
    test "Load items with appropriate amount", %{pid: pid} do
      assert VendingMachine.add(pid, "chips", "£2") == :ok
      assert VendingMachine.add(pid, "snacks", "£2") == :ok
      assert VendingMachine.add(pid, "water bottle", "£1") == :ok
    end

    test "View available items", %{pid: pid} do
      add_items(pid)

      available_items = VendingMachine.view(pid)
      assert length(available_items) == 3

      assert available_items ==
        [
          %{item: "water bottle", price: "£1"},
          %{item: "snacks", price: "£1"},
          %{item: "chips", price: "£2"}
        ]
    end
  end

  describe "Select items" do
    test "Select item and insert coin", %{pid: pid} do
      add_items(pid)

      selected_item_msg = VendingMachine.select_item(pid, "chips", "£2")

      assert selected_item_msg,
            "Thank you, please collect the item in the tray"
    end

    test "Select the unavailable item and insert coin", %{pid: pid} do
      add_items(pid)

      unavailable_item_msg = VendingMachine.select_item(pid, "snacks", "£1")
      assert unavailable_item_msg,
        "Sorry, selected item is not in the stock. Please choose another. Thank you."
    end

    test "Select the item and insert more than the price of item", %{pid: pid} do
      add_items(pid)

      more_money_msg = VendingMachine.select_item(pid, "water bottle", "£2")
      assert more_money_msg, "Thank you, please collect the item in the tray. You receive change £1 back"
    end

    test "Select the item and insert less than the price of item", %{pid: pid} do
      add_items(pid)

      more_money_msg = VendingMachine.select_item(pid, "chips", "£1")
      assert more_money_msg, "Please insert valid amount"
    end

    test "Select the item and insert invalid coin", %{pid: pid} do
      add_items(pid)

      invalid_coin_msg = VendingMachine.select_item(pid, "chips", "$1")
      assert invalid_coin_msg, "Please insert valid coin"
    end
  end

  defp add_items(pid) do
    VendingMachine.add(pid, "chips", "£2")
    VendingMachine.add(pid, "snacks", "£1")
    VendingMachine.add(pid, "water bottle", "£1")
  end
end
