defmodule QldLaw.Impl.ProbateParser do

  @spec extract_full_name(String.t) :: String.t
  def extract_full_name(content) do
    case Regex.named_captures(~r/[of\s](?<fullname>[A-Z]+\s[A-Z]+.*\s)late/, content) do
      nil -> nil
      %{"fullname" => fullname} -> standardise_string(fullname)
    end
  end

  @spec extract_first_name(String.t) :: String.t
  def extract_first_name(content) do
    # case Regex.named_captures(~r/(Will dated.*? of)\s+(?<firstname>\b[A-Z][A-Za-z]*\b)/, content) do
    case Regex.named_captures(~r/of[\n\s](?<firstname>[A-Z]+)\s[A-Z]+.*(late|,)/, content) do
      nil -> nil
      %{"firstname" => firstname} -> standardise_string(firstname)  
    end
  end

  @spec extract_last_name(String.t) :: String.t
  def extract_last_name(content) do
    case Regex.named_captures(~r/(of|the\slate)\s[A-Z]+(?<lastname>[A-Z].*)\n?\s?late/, content) do
      nil -> nil 
      %{"lastname" => lastname} -> standardise_string(lastname)
    end
  end

  @spec extract_middle_name(String.t) :: String.t
  def extract_middle_name(content) do
    case Regex.named_captures(~r/[A-Z]{3,}\w+\n?\s?(?<middlename>[A-Z]{3,}\w+)\s[A-Z]\w+\slate/, content) do
      nil -> "" 
      %{"middlename" => middlename} -> standardise_string(middlename)
    end
  end

  @spec extract_address(String.t) :: String.t
  def extract_address(content) do
    # case Regex.named_captures(~r/late of (?<address>(.*?))\,/, content) do
    case Regex.named_captures(~r/(formerly\sof|late\sof)(?<address>\d+[\w\s-\/]+),/, content) do
      nil -> retry_address(content) 
      %{"address" => address} -> standardise_string(address)
    end
  end

  @spec extract_number(String.t) :: String.t
  def extract_number(content) do
    case Regex.named_captures(~r/late.*\s(?<number>\d{1,}(\/\d{1,})?).*[A-Za-z]+,/, content) do
      nil -> retry_address(content)
      %{"number" => number} -> standardise_string(number)
    end
  end

  @spec extract_street(String.t) :: String.t
  def extract_street(content) do
    case Regex.named_captures(~r/late.*\d+\s(?<street_name>[\w\s]+),/, content) do
      nil -> retry_address(content)
      %{"street_name" => street_name} -> standardise_string(street_name)
    end
  end

  @spec extract_suburb(String.t) :: String.t
  def extract_suburb(content) do
    case Regex.named_captures(~r/\,\s(?<suburb>[A-Z][a-z]\w+(\s[A-Z][a-z]\w+)?)\s?\,?/, content) do
      nil -> nil 
      %{"suburb" => suburb} -> standardise_string(suburb)
    end
  end

  @spec extract_law_firm(String.t) :: String.t
  def extract_law_firm(content) do
    case Regex.named_captures(~r/\nLodged by:?\s(?<law_firm>.*[\n\D\W]*.*)\./, content) do
      nil -> nil  
      %{"law_firm" => law_firm} -> standardise_string(law_firm)
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
    |> String.replace("of", "", trim: true)
    |> String.replace(",", "", trim: true)
    |> String.replace("in the State", "", trim: true)
    |> String.replace("deceased", "", trim: true)
    |> String.trim() 

  end
end
