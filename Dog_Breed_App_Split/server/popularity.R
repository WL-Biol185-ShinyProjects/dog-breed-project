output$breed_plot <- renderPlot({
  d <- filter(breed_top10, year <= input$breed_year)
  
  ggplot(d, aes(x = year, y = rank)) +
    geom_path(aes(group = grp, colour = Breed), linewidth = 1.2, alpha = 0.5) +
    geom_point(aes(fill = Breed), shape = 21, size = 23,
               colour = "white", stroke = 1) +
    geom_text(aes(label = str_wrap(Breed, 9)),
              colour = "white", size = 2.4, fontface = "bold",
              lineheight = 0.85, family = "sans") +
    scale_x_continuous(breaks = breed_years,
                       limits = c(min(breed_years) - 0.5, max(breed_years) + 0.5)) +
    scale_y_reverse(breaks = 1:10, limits = c(10.5, 0.5)) +   # rank 1 at the top
    scale_colour_manual(values = breed_pal) +
    scale_fill_manual(values = breed_pal) +
    guides(colour = "none", fill = "none") +
    labs(x = "Year", y = "Dog Breed Popularity Rank") +
    theme_minimal(base_size = 14) +
    theme(panel.grid.minor = element_blank())
})