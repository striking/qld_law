defmodule HandleFile do
  def read_pdf(path) do
    path
    |> PdfToText.from_path() 
  end
end
