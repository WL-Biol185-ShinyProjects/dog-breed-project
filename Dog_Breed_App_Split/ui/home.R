
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
      height: 350px;
      object-fit: contain;
      border-radius: 10px;
      margin-bottom: 15px;
      background-color: white;
    }
    
.heart-image {
  display: block;
  height: 300px;
  width: auto;
  max-width: 100%;
  object-fit: contain;
  border-radius: 10px;
  margin: 0 auto 15px;
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
        src = "home/am2.png",
        class = "heart-image",
        alt = "am"
      )
    ),
    column(
      width = 6,
      tags$img(
        src = "home/malt2.png",
        class = "heart-image",
        alt = "malt"
      )
    )
  ),
  
  # STARCH DIGESTION SECTION
  
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
  
  div(
    class = "gallery",
    
    # CARD 1
    div(
      class = "gallery-card",
      tags$img(
        src = "home/huntdog.jpg",
        alt = "Jomon"
      ),
      p(
        class = "gallery-caption",
        "The Jōmon inhabited the Japanese archipelago from 16000–2400 BP.
        Above is a hunt reconstructed by the Niigata Prefectural Museum of
        History. Archaeologists have discovered dog bone burials dated to
        around 9000 BP, with the remains surrounded by shells similar to
        those found in human burials."
      )
    ),
    
    # CARD 2
    div(
      class = "gallery-card",
      tags$img(
        src = "home/bronzeJhunt.jpg",
        alt = "Bronze"
      ),
      p(
        class = "gallery-caption",
        "Bronze bell depicting a Jōmon hunt with dogs 2500 BP.
        Located in the Tokyo National Museum"
      )
    ),
    
    # CARD 3
    div(
      class = "gallery-card",
      tags$img(
        src = "home/renaissance dog.jpg",
        alt = "Painting"
      ),
      p(
        class = "gallery-caption",
        "Renaissance painting featuring a dog, Diego Vélazquez's Las
        Meninas, 1656, Museo Nacional del Prado, Madrid, Spain"
      )
    ),
    
    # CARD 4
    div(
      class = "gallery-card",
      tags$img(
        src = "home/dogpull.jpeg",
        alt = "Dog pulling"
      ),
      p(
        class = "gallery-caption",
        "Antique photo from the early 18th century depicting a dog
        harnessed for play"
      )
    ),
    
    # CARD 5
    div(
      class = "gallery-card",
      tags$img(
        src = "home/blonde.jpg",
        alt = "Chihuahua"
      ),
      p(
        class = "gallery-caption",
        "Paris Hilton holding a chihuahua in a matching pink sweater
        in the 2001 film, Legally Blonde"
      )
    )
  ),
  
  # CLOSING
  p(
    class = "home-closing",
    "We hope that you enjoy exploring our website!"
  )
)