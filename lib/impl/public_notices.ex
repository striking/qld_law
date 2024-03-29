defmodule QldLaw.Impl.PublicNotices do
  
  alias QldLaw.Probate
  alias QldLaw.Impl.OutputGenerator
  alias QldLaw.Impl.CouncilApis.BccPlanningApi
  import QldLaw.Impl.ProbateParser 

  @public_notices ~r/\n\n;PUBLIC NOTICES\nNotice of intention to apply for Grant\nof Probate or Letters of Administration\n/
  @paragrph_delimeter ~r/[\s;]([A-Z]+,\s[A-Z]+.*)\nAfter/      

  @spec export_public_notices(String.t()) :: {:error, String.t()} | {:ok, list(map())}
  def export_public_notices(file_name) when is_binary(file_name) do
    file_name
    |> convert_pdf_to_text
    |> parse_text
    |> convert_to_probates_struct
    |> Probate.filter_by_address
    |> Probate.filter_by_suburb
    |> get_zoning_data
    |> get_lot_size_data
    |> Probate.reject_non_developable
    |> check_if_splitter_block
  end

  def check_if_splitter_block({:ok, probate_list}) do
    result = Enum.map(probate_list, &check_if_splitter_block/1)

    {:ok, result}
  end

  def check_if_splitter_block(%QldLaw.Probate{} = probate) when probate.boundary_area > probate.lot_area do
    boundary = probate.boundary_area
    result = %{probate | splitter?: "maybe - Boundary area: #{boundary} lot area: #{probate.lot_area}"}

    result
  end

  def check_if_splitter_block(probate_list), do: probate_list

  def export_public_notices_to_csv(file_name) when is_binary(file_name) do
    file_name 
    |> export_public_notices
    |> OutputGenerator.process_custom_data(file_name)
  end

  def export_public_notices_to_csv(files) when is_list(files) do
    Enum.map(files, &export_public_notices_to_csv/1)
  end

  def flatten_list({:ok, list}) do
    {:ok, List.flatten(list)}
  end

  def flatten_list(error), do: error

  def get_zoning_data({:ok, probate_list}) do
    result = Enum.map(probate_list, &BccPlanningApi.get_zoning_data/1)

    {:ok, result}
  end

  def get_zoning_data(error), do: error
  
  def get_lot_size_data({:ok, probate_list}) do
    result = Enum.map(probate_list, &BccPlanningApi.get_lot_size_date/1)

    {:ok, result}
  end

  def get_lot_size_data(error), do: error
  
  @spec convert_pdf_to_text(String.t()) :: {atom(), String.t()}
  def convert_pdf_to_text(path) do
    IO.puts "processing #{path}"
    PdfToText.from_path(path)
  end
 
  @spec parse_text({:ok, String.t()}) :: {:ok, list(QldLaw.Probate.t())}
  def parse_text({:ok, content}) do
    probate_list = content
    |> String.split(@public_notices)
    |> List.last
    |> String.split(@paragrph_delimeter)     

    {:ok, probate_list}
  end

  def parse_text(error), do: error

  def convert_to_probates_struct({:ok, probate_list}) do
    result = Enum.map(probate_list, fn item ->
      probates = 
        %Probate{
        full_name: extract_full_name(item),
        first_name: extract_first_name(item), 
        middle_name: extract_middle_name(item), 
        last_name: extract_last_name(item), 
        number: extract_number(item),  
        street_name: extract_street(item),
        street_suffix: extract_street_suffix(item), 
        address: extract_address(item), 
        suburb: extract_suburb(item), 
        law_firm: extract_law_firm(item),
        raw_content: "",
        } 
        
      if Enum.any?(Map.values(probates), &is_nil/1) do
        Map.put(probates, :raw_content, item)
      else
        probates
      end
    end)

    {:ok, result}
  end

  # handle single item struct case
  def convert_to_probates_struct(error), do: error
end
