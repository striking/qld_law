defmodule QldLaw do

  alias QldLaw.Probate
  alias QldLaw.Impl.ProbateParser 

  @spec extract_public_notices(binary()) :: {:ok, String.t}
  def extract_public_notices(file \\ "priv/test.pdf") do
    {:ok, content} = PdfToText.from_path(file)
  end

  @spec parse_text({:ok, String.t}) :: list(QldLaw.Probate.t)
  def parse_text({:ok, content}) do
    listings = 
      content
        |> String.split(~r/\n\n;PUBLIC NOTICES\nNotice of intention to apply for Grant\nof Probate or Letters of Administration\n/)
        |> List.last
        |> String.split(~r/[\s;]([A-Z]+,\s[A-Z]+.*)\nAfter/)      
        |> convert_to_probates_struct
  end

  def convert_to_probates_struct(content) do
    Enum.map(content, fn item ->
      probates = 
        %Probate{
        full_name: ProbateParser.extract_full_name(item),
        first_name: ProbateParser.extract_first_name(item), 
        last_name: ProbateParser.extract_last_name(item), 
        address: ProbateParser.extract_address(item), 
        suburb: ProbateParser.extract_suburb(item), 
        middle_name: ProbateParser.extract_middle_name(item), 
        law_firm: ProbateParser.extract_law_firm(item),
        raw_content: "",
        } 
        
      if Enum.any?(Map.values(probates), &is_nil/1) do
        Map.put(probates, :raw_content, item)
        # %Probate{ probates | raw_content: item}
      else
        probates
      end
    end)
  end
end
