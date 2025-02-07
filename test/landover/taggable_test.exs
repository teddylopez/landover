defmodule Landover.TaggableTest do
  use Landover.DataCase

  alias Landover.Taggable

  describe "tags" do
    alias Landover.Taggable.Tag

    import Landover.TaggableFixtures

    @invalid_attrs %{name: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Taggable.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Taggable.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tag{} = tag} = Taggable.create_tag(valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Taggable.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tag{} = tag} = Taggable.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Taggable.update_tag(tag, @invalid_attrs)
      assert tag == Taggable.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Taggable.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Taggable.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Taggable.change_tag(tag)
    end
  end

  describe "story_tags" do
    alias Landover.Taggable.StoryTag

    import Landover.TaggableFixtures

    @invalid_attrs %{}

    test "list_story_tags/0 returns all story_tags" do
      tagging = tagging_fixture()
      assert Taggable.list_story_tags() == [tagging]
    end

    test "get_tagging!/1 returns the tagging with given id" do
      tagging = tagging_fixture()
      assert Taggable.get_tagging!(tagging.id) == tagging
    end

    test "create_tagging/1 with valid data creates a tagging" do
      valid_attrs = %{}

      assert {:ok, %StoryTag{} = tagging} = Taggable.create_tagging(valid_attrs)
    end

    test "create_tagging/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Taggable.create_tagging(@invalid_attrs)
    end

    test "update_tagging/2 with valid data updates the tagging" do
      tagging = tagging_fixture()
      update_attrs = %{}

      assert {:ok, %StoryTag{} = tagging} = Taggable.update_tagging(tagging, update_attrs)
    end

    test "update_tagging/2 with invalid data returns error changeset" do
      tagging = tagging_fixture()
      assert {:error, %Ecto.Changeset{}} = Taggable.update_tagging(tagging, @invalid_attrs)
      assert tagging == Taggable.get_tagging!(tagging.id)
    end

    test "delete_tagging/1 deletes the tagging" do
      tagging = tagging_fixture()
      assert {:ok, %StoryTag{}} = Taggable.delete_tagging(tagging)
      assert_raise Ecto.NoResultsError, fn -> Taggable.get_tagging!(tagging.id) end
    end

    test "change_tagging/1 returns a tagging changeset" do
      tagging = tagging_fixture()
      assert %Ecto.Changeset{} = Taggable.change_tagging(tagging)
    end
  end
end
