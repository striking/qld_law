defmodule QldLaw.Impl.ProbateParser do

  @spec extract_full_name(String.t) :: String.t
  def extract_full_name(content) do
    standardise_and_extract(~r/[of\s](?<fullname>[A-Z]+\s[A-Z]+.*\s)late/, content, "fullname")
  end

  @spec extract_first_name(String.t) :: String.t
  def extract_first_name(content) do
   standardise_and_extract(~r/of[\n\s](?<firstname>[A-Z]+)\s[A-Z]+.*(late|,)/, content, "firstname")
  end

  @spec extract_last_name(String.t) :: String.t
  def extract_last_name(content) do
    standardise_and_extract(~r/of\s[\w\s]+\s(?<lastname>[A-Z]+)(\s|,|deceased|late|of|\(also)/, content, "lastname")
  end

  @spec extract_middle_name(String.t) :: String.t
  def extract_middle_name(content) do
    standardise_and_extract(~r/[A-Z]{3,}\w+\n?\s?(?<middlename>[A-Z]{3,}\w+)\s[A-Z]\w+\slate/, content, "middlename")
  end

  @spec extract_address(String.t) :: String.t
  def extract_address(content) do
    standardise_and_extract(~r/late.*\s(?<address>\d[\-\/\d\w\s\n\,]+)\sdeceased/, content, "address")
  end

  @spec extract_number(String.t) :: String.t
  def extract_number(content) do
    standardise_and_extract(~r/late.*\s(?<number>\d{1,}(\/\d{1,})?).*[A-Za-z]+,/, content, "number")
  end

  @spec extract_street(String.t) :: String.t
  def extract_street(content) do
    standardise_and_extract(~r/late\sof.*\s\d+[a-z\-\\\/\d]*\s(?<street_name>[\n\w]+),?/, content, "street_name")
  end

  @spec extract_street_suffix(String.t) :: String.t()
  def extract_street_suffix(content) do
    standardise_and_extract(~r/late.*\d+\s[\w\s]+(?<suffix>Street|Road|Court|Avenue|Lane),/, content, "suffix")
  end

  @spec extract_suburb(String.t) :: String.t
  def extract_suburb(content) do
    standardise_and_extract(~r/\,\s(?<suburb>[A-Z][a-z]\w+(\s[A-Z][a-z]\w+)?)\s?\,?/, content, "suburb")
  end

  @spec extract_law_firm(String.t) :: String.t
  def extract_law_firm(content) do
    standardise_and_extract(~r/\nLodged by:?\s(?<law_firm>.*\s.*)\./, content, "law_firm")
  end

  defp standardise_and_extract(regex, content, capture_group) do
    case Regex.named_captures(regex, content) do
      nil -> nil
      %{^capture_group => captured_value} -> standardise_string(captured_value)
    end
  end

  defp retry_address(content) do
    case Regex.named_captures(~r/(late\s|formerly\sof\s|the\slate\s)(?<address>.+\s*).(deceased|who|will\sbe)/, content) do
      nil -> nil
      %{"address" => address} -> standardise_string(address)  
    end
  end

  defp standardise_string(string) do
    string
    |> String.replace("\n", " ", trim: true)
    |> String.replace(" of ", "", trim: true)
    |> String.replace(",", "", trim: true)
    |> String.replace("in the State", "", trim: true)
    |> String.replace("deceased", "", trim: true)
    |> String.trim() 

  end
end
