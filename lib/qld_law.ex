defmodule QldLaw do

  def extract_public_notices(file \\ "priv/test.pdf") do
    {:ok, content} = PdfToText.from_path(file)
      # content
      # |> parse_text  #pparse text
  end

@suburbs ~w[
    Alderley Enoggera Gaythorne Grange Lutwyche Newmarket Herston Wilston Everton Mcdowall 
    Mitchelton Chermside Grovely Keperra Dorrington Stafford Gordon Kedroin Kalinga Lytwyche 
    Windsor Wooloowin Nundah Northgate Toombul Wavell Clayfield Albion Hendra Milton Paddington 
    Rosalie Gap Ashgrove Bardon Rainworth Auchenflower Torwood Jubilee Toowong Chelmer 
    Indooroopilly Taringa Sherwood Graceville Tennyson Oxley Corinda Rocklea Inala Darra 
    Richlands Durack Doolandella Pallara 
  ]

  

  def parse_text(content) do
    # string
    String.split(content, ~r/\n\n;PUBLIC NOTICES\nNotice of intention to apply for Grant\nof Probate or Letters of Administration\n/)
    |> List.last
    |> String.split(~r/\n?\n;?[A-Z]\w+,\s[A-Z]\w+([A-Z]\w)?/)
    |> filter_by_suburb
  end

  def filter_by_suburb(content) do
    Enum.filter(content, &String.contains?(&1, @suburbs)) 
  end

  def extract_first_name(content) do
    Regex.named_captures(~r/of\s(?<firstname>[A-Z]{3,}\w+)\n?\s?/, content)
  end

  def extract_last_name(content) do
    Regex.named_captures(~r/(?<lastname>[A-Z]{3,}\w+)\n?\s?late/, content)
  end

  def extract_middle_name(content) do
    Regex.named_captures(~r/[A-Z]{3,}\w+\n?\s?(?<middlename>[A-Z]{3,}\w+)\s[A-Z]\w+\slate/, content)
  end

  def extract_address(content) do
    Regex.named_captures(~r/of\s(?<address>[0-9]{1,}\/?[0-9]{1,}\s[A-Za-z]\w+\s[A-Za-z]\w+)\,/, content)
  end

  def extract_suburb(content) do
    Regex.named_captures(~r/\,\s(?<suburb>[A-Z][a-z]\w+(\s[A-Z][a-z]\w+)?)\s?\,?/, content)
  end
end
