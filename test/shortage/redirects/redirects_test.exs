defmodule Shortage.RedirectsTest do
  use Shortage.DataCase

  alias Shortage.Redirects

  describe "links" do
    alias Shortage.Redirects.Link

    @valid_attrs %{short: "some short", target: "some target"}
    @update_attrs %{short: "some updated short", target: "some updated target"}
    @invalid_attrs %{short: nil, target: nil}

    def link_fixture(attrs \\ %{}) do
      {:ok, link} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Redirects.create_link()

      link
    end

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Redirects.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Redirects.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      assert {:ok, %Link{} = link} = Redirects.create_link(@valid_attrs)
      assert link.short == "some short"
      assert link.target == "some target"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Redirects.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      assert {:ok, %Link{} = link} = Redirects.update_link(link, @update_attrs)
      assert link.short == "some updated short"
      assert link.target == "some updated target"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Redirects.update_link(link, @invalid_attrs)
      assert link == Redirects.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Redirects.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Redirects.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Redirects.change_link(link)
    end
  end
end
