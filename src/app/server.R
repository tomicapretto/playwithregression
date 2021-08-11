source(here("src", "app", "utils", "utils.R"))
source(here("src", "app", "data.R"))

server <- function(input, output, session) {
  data <- RegressionData$new()
  
  # Update sum of squares in the UI.
  observe({
    error = data$get_error()
    if (is.null(error)) {
      error <- ""
    } else {
      error <- round(error, 3)
    }
    shinyjs::html("ss", error)
  })
  
  # Add new data point with coordinates given by `input$new_point`.
  # This input is set in `d3.js`.
  observe({
    data$add_point(input$new_point)
  })
  
  # Clear plot
  observeEvent(input$clear, {
    data$clear()
  })
  
  # Shake points
  observeEvent(input$shake, {
    data$shake()
  })
  
  # Add random points (defaults to 5)
  observeEvent(input$add_points, {
    data$add_random_points()
  })
  
  # Listens to intercept slider, and updates the `data` object accordingly.
  observeEvent(input$intercept, {
    data$set_intercept(input$intercept)
  }, ignoreInit = TRUE)
  
  # Listens to slope slider, and updates the `data` object accordingly.
  observeEvent(input$slope, {
    data$set_slope(input$slope)
  }, ignoreInit = TRUE)
  
  # Update intercept slider when the intercept changes internally in `data`.
  # This happens when we add or modify points, for example.
  observe({
    updateRangeInput("intercept", data$get_intercept())
  })
  
  # Update slope slider when the slope changes internally in `data`.
  observe({
    updateRangeInput("slope", data$get_slope())
  })
  
  # Trigger OLS fit. Expect no changes if intercept/slope were not manipulated.
  observeEvent(input$set_ols, {
    data$set_ols_fit()
  })
  
  # Render D3 plot. All the logic is within `d3.js`
  output$d3 <- renderD3({
    r2d3(
      data = data_to_json(data$get_data_list()),
      script = here("src", "app", "www", "d3.js")
    )
  })
  
  # Create and open a modal when user clicks on how to use button.
  # It contains the content from `howto.md`.
  observeEvent(input$how_to, {
    shiny.semantic::create_modal(
      shiny.semantic::modal(
        id = "simple-modal",
        header = tags$h2("How to use this app"),
        includeMarkdown(here("src", "app", "www", "howto.md"))
      )
    )
  })
}