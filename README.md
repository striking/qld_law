# QldLaw
** Requirements**
## Release 1
As a user, I should be able to enter a list of suburb's, so that I can customise the return information.
As a user, I should be able to enter a list of negative keywords, so that I can improve the returned information
Parse text from the "Public Notices" section that match any of the list of suburbs entered and return:
    - Full street address
    - suburb
    - Name of deceased
    - Lawyer firm name and address

Default Suburb search = ~W[Alderley, Enoggera, Ferny Grove, Gaythorne, Grange, Lutwyche, Newmarket, Herston, Wilston, ]

Default negative keywords = ~W[AVEO, Wesley, BUPA. Regis. Uniting Care, Anglicare]

## Release 2

Dowload the latest report from "https://queenslandlawreports.com.au/qlr/db-qlr-editions" and run search
Lookup address from BCC developmet portal ad return the following:
    - Zoning Code (LDR, CR1, LMR 2)
    - lost size in m2
    - number of registered lots on title
    - Full address
    - land size
    - zoning
    - name of owner (deceased)


**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `qld_law` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:qld_law, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/qld_law>.

