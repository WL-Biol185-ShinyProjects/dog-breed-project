tabItem(
  tabName = "references",

h2("References:"),

#creates bulletted list
tags$ul(
  #creates individual list item
  tags$li
  #creates clickable link
  (tags$a(
    #hyperlink
    href = "https://comptes-rendus.academie-sciences.fr/biologies/articles/en/10.1016/j.crvi.2010.12.011/",
    #make open in new tab instead of our website link
    target="_blank",
    #what words u want the link to appear as
    "Dog Evolution Research"
  )),
  
  tags$li(tags$a(
    href = "https://www.nature.com/articles/nature11837",
    target="_blank",
    "Nature Research Article"
  )),
  
  tags$li(tags$a(
    href = "https://www.telegraph.co.uk/women/womens-life/
    11557289/RIP-Tinkerbell-and-Paris-Hiltons-brand-of-handbog-dog-celebrity.html",
    target="_blank",
    "Photo: Paris Hilton"
  )),
  
  tags$li(tags$a(
    href = "https://www.dailyartmagazine.com/dog-breeds-famous-paintings/",
    target="_blank",
    "Photo: Renaissance painting"
  )),
  
  tags$li(tags$a(
    href = "https://www.akc.org/expert-advice/lifestyle/11-
    fascinating-antique-photos-of-dogs-and-people/",
    target="_blank",
    "Photo: Dog pulling wagon"
  )),
  
  tags$li(tags$a(
    href = "https://commons.wikimedia.org/wiki/File:Comparison_of_a_wolf_and_a_pug.png",
    target="_blank",
    "Photo: Wolf and pug comparison"
  )),
  
  tags$li(tags$a(
    href = "https://tenor.com/view/hungry-dog-hungry-dog-crazy-gif-20937509",
    target="_blank",
    "Dog GIF"
  ))
),

h2("Data Used:"),

tags$ul(tags$li(
tags$a(
  href = "https://datacommons.morrisanimalfoundation.org/",
  target="_blank",
  "Morris Animal Foundation Data Commons"
  )),

tags$li(tags$a(
  href = "https://github.com/paiv/fci-breeds/blob/main/fci-breeds.csv",
  target = "_blank",
  "FCI Breeds dataset"
)),

tags$li(tags$a(
  href = "https://github.com/kkakey/dog_traits_AKC/blob/main/data/breed_rank_all.csv",
  target = "_blank",
  "American Kennel Club Dog Breed Rank dataset"
))

)
)
