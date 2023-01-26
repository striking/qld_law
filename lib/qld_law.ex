defmodule QldLaw do

  alias QldLaw.Probate
  import QldLaw.Impl.ProbateParser 

  # ensure main flow is piped with {:ok, data} | {:error, reason}

  @spec export_public_notices(String.t()) :: {:ok, String.t}
  def export_public_notices(file \\ "priv/test.pdf") do
    PdfToText.from_path(file)
  end

  # handle error case 
  # create regex helper

  @spec parse_text({:ok, String.t}) :: list(QldLaw.Probate.t)
  def parse_text({:ok, content}) do
      content
        |> String.split(~r/\n\n;PUBLIC NOTICES\nNotice of intention to apply for Grant\nof Probate or Letters of Administration\n/)
        |> List.last
        |> String.split(~r/[\s;]([A-Z]+,\s[A-Z]+.*)\nAfter/)      
        |> convert_to_probates_struct
  end
  
  # handle error case

  def convert_to_probates_struct(content) do
    Enum.map(content, fn item ->
      probates = 
        %Probate{
        full_name: extract_full_name(item),
        first_name: extract_first_name(item), 
        last_name: extract_last_name(item), 
        number: extract_number(item),  
        street_name: extract_street(item),
        address: extract_address(item), 
        suburb: extract_suburb(item), 
        middle_name: extract_middle_name(item), 
        law_firm: extract_law_firm(item),
        raw_content: "",
        } 
        
      if Enum.any?(Map.values(probates), &is_nil/1) do
        Map.put(probates, :raw_content, item)
      else
        probates
      end
    end)
  end

  # handle single item struct case
end
