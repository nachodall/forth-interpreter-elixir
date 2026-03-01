defmodule ForthInterpreterElixirWeb.ForthLive do
  use ForthInterpreterElixirWeb, :live_view

  import Ecto.Query
  alias ForthInterpreterElixir.Interpreters
  alias ForthInterpreterElixir.Interpreters.Execution
  alias ForthInterpreterElixir.Repo
  alias Forth

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       input: "",
       result: nil,
       history: list_history()
     )}
  end

  @impl true
  def handle_event("evaluate", %{"input" => input}, socket) do
    result = Forth.eval(input)

    result_text =
      case result do
        {:ok, stack} -> "Stack: #{inspect(stack, charlists: :as_lists)}"
        {:error, reason} -> "Error: #{reason}"
      end

    {:ok, _execution} = Interpreters.create_execution(%{input: input, result: result_text})

    {:noreply,
     assign(socket,
       input: input,
       result: result,
       history: list_history()
     )}
  end

  defp list_history do
    Repo.all(from e in Execution, order_by: [desc: e.inserted_at], limit: 10)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto py-10 px-4 sm:px-6 lg:px-8">
      <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-8">Forth Interpreter</h1>

      <div class="bg-white dark:bg-gray-800 shadow rounded-lg p-6 mb-8">
        <form phx-submit="evaluate" class="space-y-4">
          <div>
            <label for="input" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Program Input</label>
            <textarea
              name="input"
              id="input"
              rows="4"
              class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm bg-white text-gray-900 dark:bg-gray-800 dark:text-white dark:border-gray-600"
              placeholder="Enter Forth code here (e.g., 1 2 +)"
            ><%= @input %></textarea>
          </div>
          <button
            type="submit"
            class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            Evaluate
          </button>
        </form>
      </div>

      <%= if @result do %>
        <div class="bg-white dark:bg-gray-800 shadow rounded-lg p-6 mb-8">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Most Recent Result</h2>
          <div class={"p-4 rounded-md #{case @result do
            {:error, _} -> "bg-red-50 text-red-700 dark:bg-red-900 dark:text-red-100"
            _ -> "bg-green-50 text-green-700 dark:bg-green-900 dark:text-green-100"
          end}"}>
            <pre><%= inspect(@result, charlists: :as_lists) %></pre>
          </div>
        </div>
      <% end %>

      <div class="bg-white dark:bg-gray-800 shadow rounded-lg overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white">History</h2>
        </div>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead class="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Input</th>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Result</th>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Date</th>
              </tr>
            </thead>
            <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
              <%= for execution <- @history do %>
                <tr>
                  <td class="px-6 py-4 whitespace-pre-wrap text-sm text-gray-900 dark:text-gray-100"><%= execution.input %></td>
                  <td class="px-6 py-4 whitespace-pre-wrap text-sm text-gray-500 dark:text-gray-400"><%= inspect(execution.result, charlists: :as_lists) %></td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400"><%= execution.inserted_at %></td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end
end
