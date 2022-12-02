defmodule QldLaw do

  def extract_public_notices(file \\ "priv/test.pdf") do

    with  {:ok, content} <- PdfToText.from_path(file) do
      content
      |> parse_text  #pparse text
    end
  end

  def parse_text(string) do
    # string
    # |> String.split() 
  end
end
