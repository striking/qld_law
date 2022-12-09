defmodule QldLaw do

  def extract_public_notices(file \\ "priv/test.pdf") do
    {:ok, content} = PdfToText.from_path(file)
      # content
      # |> parse_text  #pparse text
  end
7

  def parse_text(content) do
    # string
    String.split(content, ~r/\n\n;PUBLIC NOTICES\nNotice of intention to apply for Grant\nof Probate or Letters of Administration\n/)
    |> List.last
    # |> String.split() 
  end
end
