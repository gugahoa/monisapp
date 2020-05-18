defmodule MonisApp.FinanceTest do
  use MonisApp.DataCase

  alias MonisApp.Finance

  describe "category" do
    alias MonisApp.Finance.Category

    test "default_categories/0 returns list of default categories with no errors" do
      categories = Finance.default_categories()
      Enum.map(categories, &assert %Category{} = &1)
    end
  end
end
