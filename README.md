Vending Machine simulation
-------------------------

1) The logic has been controlled by Genserver process communication.
2) It has the following functionalities
  - Vending machine booting up, by generating a process pid.
  - Load the machine, with various items and the coins (cost of the item)
  - There is no separate functionality to load coins separately.
  - View the available items and their cost.
  - Select the item and insert the coin.
  - Vending machine display the appropriate message and returns the change.
  - Vending machine display the warning, if the coin is invalid or less than the    price of selected item.
  - Supervisor for handling pid in tests across multiple test blocks.
  - Tests are included.


3) Entry point
vending_machine/lib/vending_machine.ex.

Code run in iex examples
-------------------------
{:ok, pid} = VendingMachine.start_link
VendingMachine.add(pid, "chips", "£2")
VendingMachine.add(pid, "snacks", "£1")
VendingMachine.view(pid)
VendingMachine.select_item(pid, "chips", "£2")
VendingMachine.view(pid)
VendingMachine.select_item(pid, "snacks", "£2")

Run test
---------
mix test


4) If I spend more time, I would improve the following
- Loading of coins separately to arrange for giving the change.
- Better interaction, like display the list of items and prices.
- Selecting only the item number, based on the order of display.


Thanks,
Santosh T