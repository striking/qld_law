defmodule QldLaw.Impl.OutputGenerator do
  alias QldLaw.Probate

  @columns ~w(first_name last_name number street_name street_suffix suburb boundary_area zoning development_opportunity splitter? law_firm )a
  @filename "output.csv"

  # update to IO.iodata_to_binary
  @spec format_output_to_string(QldLaw.Probate.t()) :: String.t()
  def format_output_to_string(%Probate{} = probate) do
    "#{probate.number}, #{probate.street_name} #{probate.street_suffix}, #{probate.suburb}, #{probate.development_opportunity}"
  end

  def format_output_to_string({:ok, probate_list}) when is_list(probate_list) do
    Enum.map(probate_list, &format_output_to_string/1)
  end

  def format_output_to_string(error), do: error

  def process_custom_data({:ok, data}, file_name) do
    write_headings(file_name)

    data
    |> Enum.map(&parse_line(&1, @columns))
    |> CSV.encode()
    |> Enum.into(File.stream!(file_name <> "_" <> @filename, [:write, :utf8, :append]))
  end
  
  def write_to_csv({:ok, maps}, file_name) do
    headers = get_headers(maps)
    values = get_values(maps)
    data = values
      |> Enum.reduce([headers |> Enum.join(",")], fn value, acc -> [acc, value |> Enum.join(",")] end)
  
    write_to_csv_file(file_name, data)
  end

  def write_headings(file_name) do
    headings = Enum.join(@columns, ",")
    File.write(file_name <> "_" <> @filename, headings <> "\n")
  end

  defp parse_line(record, columns) do
    Enum.map(columns, &Map.get(record, &1))
  end

  defp get_headers(maps) do
    maps |> List.first() |> Map.keys()
  end
  
  defp get_values(maps) do
    maps |> Enum.map(&Map.values/1)
  end
  
  defp write_to_csv_file(file_name, data) do
    path = file_name <> ".csv"

    case File.write(path, data) do
      :ok -> 
        {:ok, path}

      {:error, reason} ->
        {:error, "Failed to write to CSV file #{path}: #{inspect(reason)}"}
    end
  end
end
