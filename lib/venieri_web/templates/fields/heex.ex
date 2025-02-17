defmodule Backpex.Fields.Heex do
  @moduledoc """
  A field for handling map values.

  ## Options

  * `:rows` - Optional integer number of visible text lines for the control. If it is not specified, the default value is 5.
  * `:placeholder` - Optional placeholder value or function that receives the assigns.
  * `:debounce` - Optional integer timeout value (in milliseconds), "blur" or function that receives the assigns.
  * `:throttle` - Optional integer timeout value (in milliseconds) or function that receives the assigns.
  """
  @config_schema [
    readonly: [
      doc: "Sets the field to readonly",
      type: :boolean
    ],
    except: [
      doc: "List of actions to exclude from the field",
      type: :list
    ],
    rows: [
      doc: "Number of visible text lines for the control",
      type: :integer
    ]
    # see https://hexdocs.pm/nimble_options/NimbleOptions.html
    # or any other core backpex field for examples...
  ]

  use Backpex.Field, config_schema: @config_schema

  import Ecto.Query
  import Backpex.HTML.Layout, only: [modal: 1]
  import PhoenixHTMLHelpers.Form, only: [hidden_inputs_for: 1]
  alias Backpex.LiveResource
  alias Ecto.Changeset


  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      # |> apply_action(assigns.type)

    {:ok, socket}
  end






  @impl Backpex.Field
  def render_value(assigns) do
    assigns = assign(assigns, :casted_value, maybe_cast_value(assigns.name, assigns.schema, assigns.value))
    ~H"""

    <p
      class={[
        @live_action in [:index, :resource_action] && "truncate",
        @live_action == :show &&
          "overflow-auto whitespace-pre-wrap bg-neutral text-white p-2 rounded-md text-sm"
      ]}
      phx-no-format
    >
<LiveMonacoEditor.code_editor
  style="min-height: 250px; width: 100%;"
  value={@value |> Phoenix.json_library().encode!() |> Jason.Formatter.pretty_print()}
  opts={
    Map.merge(
      LiveMonacoEditor.default_opts(),
      %{"language" => "json"}
    )
  }
/>
    </p>

    """
  end

  @impl Backpex.Field
  def render_form(assigns) do
    assigns = assign(assigns, :casted_value, maybe_cast_form(PhoenixForm.input_value(assigns.form, assigns.name)))
    ~H"""
    <div>
      <Layout.field_container>
        <:label align={Backpex.Field.align_label(@field_options, assigns, :top)}>
          <Layout.input_label text={@field_options[:label]} />
        </:label>

    <LiveMonacoEditor.code_editor
      style="min-height: 250px; width: 100%;"
      value={@form[@name].value |> Jason.encode!() |> Jason.Formatter.pretty_print()}
      change="hoho"
      id="meta_data_id"
      path="meta_data_path"
      target="meta_data_target"
      name="meta_data_name"
      opts={
        Map.merge(
          LiveMonacoEditor.default_opts(),
          %{"language" => "elixir"}
        )
      }
    />
      </Layout.field_container>
    </div>
    """
  end

  @impl Backpex.Field
  def render_form_readonly(assigns) do
    ~H"""
    <div>
      <Layout.field_container>
        <:label align={Backpex.Field.align_label(@field_options, assigns, :top)}>
          <Layout.input_label text={@field_options[:label]} />
        </:label>
 <BackpexForm.input
          value={@form[@name].value |> Jason.encode!() |> Jason.Formatter.pretty_print()}
          type="textarea"
          field={@form[@name]}
          rows={@field_options[:rows] || 4}
          translate_error_fun={Backpex.Field.translate_error_fun(@field_options, assigns)}
          phx-debounce={Backpex.Field.debounce(@field_options, assigns)}
          phx-throttle={Backpex.Field.throttle(@field_options, assigns)}
          readonly
          disabled
        />

      </Layout.field_container>
    </div>
    """
  end
  require Logger
  # @impl Backpex.Field
  # def before_changeset(changeset, %{"meta_data" => meta_data}, metadata, repo, field, assigns) do
  #   Logger.error("meta_data is binary")
  #   changeset
  #   |> dbg(label: "before")
  #   |> Ecto.Changeset.put_change(:meta_data, Jason.decode!(meta_data))
  #   |> dbg(label: "after")
  # end
  # def before_changeset(changeset, attrs, metadata, repo, field, assigns), do: changeset

  # def before_changeset(
  #       changeset,
  #       %{"meta_data" => meta_data},
  #       _repo,
  #       _field,
  #       _assigns
  #     ) when is_binary(meta_data) do
  #       Logger.error("meta_data is binary")
  #       Logger.error("#{inspect(changeset)}")
  #   changeset
  #   |> Ecto.Changeset.put_change(:meta_data, Jason.decode!(meta_data))
  # end

  # @impl Backpex.Field
  # def before_changeset(
  #   changeset,
  #   _metadata,
  #   _repo,
  #   _field,
  #   _assigns
  # ) do
  #   Logger.error("meta_data is map")
  #   changeset
  # end



  defp maybe_cast_value(field_name, schema, value) do
    type = schema.__schema__(:type, field_name) || schema.__schema__(:virtual_type, field_name)

    case type do
      {:parameterized, Ecto.Type.Map, opts} ->
        {:ok, map} = Ecto.Type.cast(value, opts)

        Jason.encode!(map)

      _type ->
        value
    end
  end

  defp maybe_cast_form(val) when is_binary(val), do: val
  defp maybe_cast_form(nil), do: Decimal.new("{}")
  defp maybe_cast_form(%{} = val), do: Jason.encode!(val)



end
