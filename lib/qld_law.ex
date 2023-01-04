defmodule QldLaw do

  alias QldLaw.Probate

@suburbs ~w[
    Alderley Enoggera Gaythorne Grange Lutwyche Newmarket Herston Wilston Everton Mcdowall 
    Mitchelton Chermside Grovely Keperra Dorrington Stafford Gordon Kedroin Kalinga Lytwyche 
    Windsor Wooloowin Nundah Northgate Toombul Wavell Clayfield Albion Hendra Milton Paddington 
    Rosalie Gap Ashgrove Bardon Rainworth Auchenflower Torwood Jubilee Toowong Chelmer 
    Indooroopilly Taringa Sherwood Graceville Tennyson Oxley Corinda Rocklea Inala Darra 
    Richlands Durack Doolandella Pallara 
  ]

  def extract_public_notices(file \\ "priv/test.pdf") do
    {:ok, content} = PdfToText.from_path(file)
  end

  def parse_text({:ok, content}) do
    listings = 
      content
        |> String.split(~r/\n\n;PUBLIC NOTICES\nNotice of intention to apply for Grant\nof Probate or Letters of Administration\n/)
        |> List.last
        |> String.split(~r/\n?\n;?[A-Z]\w+,\s[A-Z]\w+([A-Z]\w)?/)

    Enum.map(listings, fn item ->
      %Probate{
        first_name: extract_first_name(item), 
        last_name: extract_last_name(item), 
        address: extract_address(item), 
        suburb: extract_suburb(item), 
        middle_name: extract_middle_name(item), 
        law_firm: extract_law_firm(item),
        } end)
  end

# Enum.map(suburbs, fn map -> %QldLaw.Probate{suburb: map["suburb"]} end)
  
  def filter_by_suburb(content) do
    Enum.filter(content, &String.contains?(&1["suburb"], @suburbs)) 
  end

  def extract_full_name(content) do
    case Regex.named_captures(~r/(?<fullname>[A-Z][a-z]*(?:\s[A-Z][a-z]*)*)/, content) do
      nil -> %{"fullname" => "Not Found"}
      %{"fullname" => fullname} -> %{"fullname" => fullname}
    end

  end

  def extract_first_name(content) do
    case Regex.named_captures(~r/of\s(?<firstname>[A-Z]{3,}\w+)\n?\s?/, content) do
      nil -> %{"firstname" => "Not Found"} 
      %{"firstname" => firstname} -> %{"firstname" => firstname}  
    end
  end

  def extract_last_name(content) do
    case Regex.named_captures(~r/(?<lastname>[A-Z]{3,}\w+)\n?\s?late/, content) do
      nil -> %{"lastname" => "Not Found"}
      %{"lastname" => lastname} -> %{"lastname" => lastname}
    end
  end

  def extract_middle_name(content) do
    case Regex.named_captures(~r/[A-Z]{3,}\w+\n?\s?(?<middlename>[A-Z]{3,}\w+)\s[A-Z]\w+\slate/, content) do
      nil -> %{"middlename" => "Not Found"} 
      %{"middlename" => middlename} -> %{"middlename" => middlename}
    end
  end

  def extract_address(content) do
    case Regex.named_captures(~r/late of (?<address>(.*?))\,/, content) do
      nil -> %{"address" => "Not Found"}
      %{"address" => address} -> %{"address" => address}
    end
  end

  def extract_suburb(content) do
    case Regex.named_captures(~r/\,\s(?<suburb>[A-Z][a-z]\w+(\s[A-Z][a-z]\w+)?)\s?\,?/, content) do
      nil -> %{"suburb" => "Not found"}
      %{"suburb" => suburb} -> %{"suburb" => suburb}
    end
  end

  def extract_law_firm(content) do
    case Regex.named_captures(~r/\nLodged by:\s(?<law_firm>(.*?)[\n.])/, content) do
      nil -> %{"law_firm" => "Not Found"}  
      %{"law_firm" => law_firm} -> %{"law_firm" => law_firm}
    end
  end
end
