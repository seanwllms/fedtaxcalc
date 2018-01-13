
function(input, output) {
  
  output$taxtable <- renderTable({
    
    #base itemized deductions
    tot_item_base <- input$med + input$intpd + input$txpaid + input$char + 
      input$jobmisc + input$othermisc + input$caustheft
    
    #get pease agi threshhold
    pease_agi <- filter(pease_limits, status == input$status) %>%
      pull(limit)
    
    pease_base <- max(min(.03*(input$agi-pease_agi), .8*tot_item_base),0)
    
    st_ded_base <- filter(stded, status ==input$status, basealt == "Base") %>% 
      pull(standard_deduction)
    
    exemptions_base <- 4050 * (ifelse(input$status == "Married Filing Jointly", 2, 1) + input$dependents)
    
    taxable_income_base <- input$agi - max(st_ded_base, tot_item_base-pease_base) - exemptions_base
    
    tax_base <- calculate_tax(input$status, taxable_income_base, "Base")
    
    data_base <- as_tibble(list(
      scenario = "Base",
      AGI = input$agi,
      `Capital Gains` = input$capgains,
      `Itemized Deductions` = tot_item_base,
      `Pease Limitation on Deductions` = pease_base,
      `Standard Deduction` = st_ded_base,
      `Deductions Claimed` = max(st_ded_base, tot_item_base-pease_base),
      `Exemptions` = exemptions_base,
      `Federal Taxable Income` = taxable_income_base,
      Tax = tax_base
    )) %>% 
      select(-scenario) %>% 
      map_df(scales::comma) %>% 
      gather(Item, `Pre TCJA (TY 2017)`, AGI:Tax)
    
    
    #data_alt
    tot_item_alt <- input$med + input$intpd + min(10000,input$txpaid) + input$char 
    
    st_ded_alt <- filter(stded, status ==input$status, basealt == "Alt") %>% 
      pull(standard_deduction)
    
    exemptions_alt <- 0
    
    taxable_income_alt <- input$agi - max(st_ded_alt, tot_item_alt) - exemptions_alt
    
    tax_alt <- calculate_tax(input$status, taxable_income_alt, "Alt")
    
    data_alt <- as_tibble(list(
      scenario = "Alt",
      AGI = input$agi,
      `Capital Gains` = input$capgains,
      `Itemized Deductions` = tot_item_alt,
      `Pease Limitation on Deductions` = 0,
      `Standard Deduction` = st_ded_alt,
      `Deductions Claimed` = max(st_ded_alt, tot_item_alt),
      `Exemptions` = exemptions_alt,
      `Federal Taxable Income` = taxable_income_alt,
      Tax = tax_alt
    )) %>% 
      select(-scenario) %>%
      map_df(scales::comma) %>% 
      gather(Item, `Post TCJA (TY 2018)`, AGI:Tax)
    
    output <- left_join(data_base, data_alt) 
    
    
    output
  })
  
}