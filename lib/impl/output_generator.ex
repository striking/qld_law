defmodule QldLaw.Impl.OutputGenerator do
  alias QldLaw.Probate 
   
  # update to IO.iodata_to_binary
  @spec format_output_to_string(QldLaw.Probate.t()) :: String.t()
  def format_output_to_string(%Probate{} = probate) do
    "#{probate.full_name}, #{probate.address}, #{probate.law_firm} \n"
  end

  def format_output_to_string(probate_list) when is_list(probate_list) do
    Enum.map(probate_list, &format_output_to_string/1)
  end

  @spec format_csv_output(list(map)) :: String.t
  def format_csv_output(listings) do
    listings
    |> Enum.map(&Map.values(&1))
    |> Enum.map_join("\n",
    fn {first_name, last_name, middle_name, address, suburb, law_firm, raw_content} ->
        "#{first_name}, #{last_name}, #{middle_name}, #{address}, #{suburb}, #{law_firm}, #{raw_content}" end) 
  end
end
