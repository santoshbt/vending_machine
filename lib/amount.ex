defmodule Amount do
  @doc ~S"""
    Calculation and conversion of the item cost and validation of coins.
  """
  def calculate_change(selected_item, list) do
    available_item = Enum.find(list, fn(li) -> li.item == selected_item.item end)
    if available_item do
      inserted_coin_in_pence = get_value_in_pence(selected_item.inserted_coin)
      available_item_price_in_pence = get_value_in_pence(available_item.price)

      cond do
        available_item && available_item_price_in_pence < inserted_coin_in_pence ->
          {"change_required", inserted_coin_in_pence - available_item_price_in_pence, list}

          available_item && available_item_price_in_pence == inserted_coin_in_pence ->
          {"no_change_required", 0, list}

          available_item && available_item_price_in_pence > inserted_coin_in_pence ->
          {"invalid_amount", -1, list}

        true -> {"invalid_coin", 0, list}
      end
    else
      {"not_found", 0, list}
    end
  end

  @doc ~S"""
    If the coin does not match as per the requirement, its value becomes 0
  """
  def get_value_in_pence(inserted_coin) do
    if Enum.member?(["1p", "2p", "5p", "10p", "20p", "50p", "£1", "£2"], inserted_coin) do
      convert_pound_to_pence(inserted_coin)
    else
      0
    end
  end

  def convert_pence_to_pound(value) do
    Money.to_string(Money.new(value, :GBP) )
  end

  defp convert_pound_to_pence(inserted_coin) do
    cond do
      String.match?(inserted_coin, ~r/^£/) ->
        actual_amount(inserted_coin) * 100

      String.match?(inserted_coin, ~r/p/) ->
        actual_amount(inserted_coin)

      true -> 0
    end
  end

  defp actual_amount(inserted_coin) do
    {value, ""} = inserted_coin
                  |> String.replace(~r/[^\d]/, "")
                  |> Integer.parse()

    value
  end
end
