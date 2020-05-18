defmodule MonisApp.FinanceTest do
  use MonisApp.DataCase

  alias MonisApp.Finance

  describe "category" do
    alias MonisApp.Finance.Category

    test "default_categories/0 returns list of default categories with no errors" do
      categories = Finance.default_categories()
      Enum.map(categories, &assert %Category{} = &1)
    end

    test "create_default_categories/1 creates the default categories for a given user" do
      user = insert(:user)

      default_categories = Finance.default_categories()
      assert {:ok, categories} = Finance.create_default_categories(user)
      assert length(default_categories) == length(categories)
    end
  end
end
