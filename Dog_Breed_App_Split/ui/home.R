
tabItem(
  tabName = "home",
  
  # CUSTOM HOMEPAGE STYLING
  tags$style(HTML("
    .home-title {
      text-align: center;
      font-size: 34px;
      font-weight: bold;
      margin-bottom: 20px;
    }

    .home-intro {
      text-align: center;
      font-size: 17px;
      margin: 15px 40px 25px 40px;
    }

    .home-text {
      font-size: 16px;
      line-height: 1.8;
      text-align: justify;
      margin: 20px 10px;
    }

    .home-image {
      width: 100%;
      height: 280px;
      object-fit: cover;
      border-radius: 10px;
      margin-bottom: 15px;
    }

    .hero-image {
      width: 100%;
      max-height: 400px;
      object-fit: cover;
      border-radius: 12px;
      margin-bottom: 20px;
    }

    .gallery {
      display: flex;
      overflow-x: auto;
      gap: 20px;
      padding: 15px 5px;
      scroll-snap-type: x mandatory;
    }

    .gallery-card {
      flex: 0 0 240px;
      scroll-snap-align: start;
      text-align: center;
    }

    .gallery-card img {
      width: 100%;
      height: 190px;
      object-fit: cover;
      border-radius: 10px;
    }

    .gallery-caption {
      font-size: 14px;
      padding: 10px;
    }

    .home-closing {
      text-align: center;
      font-size: 22px;
      font-weight: bold;
      padding: 25px;
    }
  ")),
  
  # TITLE
  h1(class = "home-title", "Welcome to Our Dog Breed Explorer!"),
  
  p(
    class = "home-intro",
    "Made by four dog-loving seniors enrolled in an introductory
    data science course at Washington and Lee University, this app
    seeks to provide users a fun way to interact with data regarding dogs."
  ),
  
  # MAIN DOG IMAGE
  fluidRow(
    column(
      width = 12,
      tags$img(
        src = "home/wolfpug.png",
        class = "hero-image",
        alt = "Dogs"
      )
    )
  ),
  
  # DOMESTICATION SECTION
  h2("The History of Dogs"),
  
  p(
    class = "home-text",
    "Dogs (Canis familiaris) were the first species to be
    domesticated by humans, preceding even the advent of agriculture!
    Domestication is the process through which humans modify
    physiological and behavioral traits of a species by selectively
    breeding its members. With some archaeological suggestions of
    earlier domestication, a burial dated at 12,000 years before
    present from the Ain Mallaha site contained a human skeleton
    cuddled with a dog's skeleton. This site was inhabited by a
    hunter-gatherer population that buried their deceased in tombs."
  ),
  
  p(
    class = "home-text",
    "Descendants from the wolf, dogs' mitochondrial DNA differs
    only 2% from the wolf's, which differs 7.5% from coyotes!
    Human interference in breeding to have dogs suited for different
    roles has led to the modern recognition of more than 400 dog
    breeds. Further, our domestication has led to their evolved
    ability to process starches better than their carnivorous
    ancestor and resultantly gain adequate nutrition from a kibble diet!"
  ),
  
  # TWO SIDE-BY-SIDE IMAGES
  fluidRow(
    column(
      width = 6,
      tags$img(
        src = "home/Amylase.png",
        class = "home-image",
        alt = "Amylase"
      )
    ),
    column(
      width = 6,
      tags$img(
        src = "home/Maltase.png",
        class = "home-image",
        alt = "Domestic dog"
      )
    )
  ),
  
  # STARCH DIGESTION SECTION
  h2("How Dogs Adapted to Their Diet"),
  
  p(
    class = "home-text",
    "Dogs have a higher expression of amylase and maltase
    (MGAM) mRNA than wolves, enzymes which play a crucial role
    in breaking down starch!"
  ),
  
  # GIF
  fluidRow(
    column(
      width = 8,
      offset = 2,
      tags$img(
        src = "home/bowl.gif",
        style = "width:100%; border-radius:12px; margin:15px 0;",
        alt = "Dog animation"
      )
    )
  ),
  
  # PHOTO CAROUSEL / HORIZONTAL GALLERY
  h2("Meet the Many Different Breeds"),
  
  p(
    class = "home-text",
    "Explore the incredible diversity of dogs and the unique
    characteristics that make each breed special."
  ),
  
  div(
    class = "gallery",
    
    div(
      class = "gallery-card",
      tags$img(src = "home/huntdog.jpg"),
      p(class = "gallery-caption",
        "The Jōmon Inhabited the Japanese archipelago from 16000-2400. 
        Above is a hunt reconstructed by the Niigata Prefectural Museum of 
        History. Archaeologists have discovered dog bone burials dated to around 
        9000BP here, with the remains surrounded in the same shells which 
        surrounded human burials from this time. Further, grave goods, 
        such as shell bracelets and deer antlers were also found in 
        these dog burials! ")
    ),
    
  
  # CLOSING
  p(
    class = "home-closing",
    "We hope that you enjoy exploring our website!"
  )
)
)

