
# Define UI for application
pageWithSidebar(
  headerPanel('Tax Cuts and Jobs Act; Example Calculations'),
  sidebarPanel(
    selectInput('status', 'Filing Status', choices = c("Married Filing Jointly",
                                                       "Single",
                                                       "Head of Household",
                                                       "Married Filing Separately")),
    numericInput('dependents', "# of Dependents", 2, min=0),
    numericInput('child', "Children 17 and Younger", 2, min=0),
    numericInput('agi', 'Adjusted Gross Income', 63217),
    numericInput('capgains', 'Long Term Dividends/Capital Gains', 0),
    h3("Itemized Deductions"),
    p("1040 Schedule A line in parentheses"),
    numericInput('med', 'Medical and Dental Expenses (4)', 0, min = 0),
    numericInput('state', 'State and Local Taxes Paid (5)', 0, min = 0),
    numericInput('realest', 'Real Estate Taxes Paid (6)', 0, min = 0),
    numericInput('pptax', 'Personal Property Taxes Paid (7)', 0, min = 0),
    numericInput('othtax', 'Other Taxes Paid (8)', 0, min = 0),
    numericInput('intpd', 'Interest Paid (Icl. Mortgage Interest) (15)', 0, min = 0),
    numericInput('char', 'Gifts to Charity (19)', 0, min = 0),
    numericInput('caustheft', 'Casualty & Theft Losses (20)', 0, min = 0),
    numericInput('jobmisc', 'Job Expenses/Miscellaneous (27)', 0, min = 0),
    numericInput('othermisc', 'Other Misc Deductions (28)', 0, min = 0)
  ),
  mainPanel(
    h3("Federal Taxes"),
    tableOutput("taxtable"),
    htmlOutput("summary"),
    h3("State Taxes"),
    tableOutput("mntax")
    #plotOutput("taxgraph")
    
  )
)

