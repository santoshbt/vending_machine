defmodule Display do
  @doc ~S"""
    Based on the change value machine displays the appropriate messages.
  """
  def message(change, list, amount) do
    case change do
      "change_required" ->
        {list, "Thank you, please collect the item in the tray. You receive change #{Money.to_string(Money.new(amount, :GBP))} back" }
      "no_change_required" ->
        {list, "Thank you, please collect the item in the tray" }
      "invalid_amount" ->
        {list, "Please insert valid coin"}
      "not_found" ->
        {list, "Sorry, selected item is not in the stock. Please choose another. Thank you."}
      "no_items" ->
        {[], "Sorry, No items in the machine"}
    end
  end
end
