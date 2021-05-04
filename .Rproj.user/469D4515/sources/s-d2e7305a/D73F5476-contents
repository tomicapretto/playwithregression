source("utils.R")

sidebar = function() {
  tags$div(
    class = "ui sidebar inverted vertical visible menu",
    style = "display:flex; flex-direction:column; margin:0;",
    id = "sidebar",
    tags$div(
      class = "item",
      tags$p(
        class = "sidebar_header",
        "Play with Linear Regression"
      )
    ),
    tags$div(
      class = "item",
      ui_row(
        ui_col(
          width = 16,
          shiny.semantic::actionButton(
            "add_points", "Add random points", width = "100%"
          )
        )
      ),
      ui_row(
        ui_col(
          width = 16,
          shiny.semantic::actionButton(
            "shake", "Shake points", width = "100%"
          )
        )
      ),
      ui_row(
        ui_col(
          width = 16,
          shiny.semantic::actionButton(
            "set_ols", "Set Least Squares Fit", width = "100%"
          )
        )
      )
    ),
    tags$div(
      class = "item",
      tags$p(
        "Parameter estimates",
        style = paste(
          "color: rgba(255, 255, 255, .9)",
          "text-align:center",
          "font-weight:bold",
          "margin-bottom:40px",
          sep = ";"
        )
      ),
      ui_row(
        ui_col(
          style = "top: 20%",
          width = 2,
          katexR::katex("\\beta_0"),
        ),
        ui_col(
          width = 14,
          rangeInput("intercept", value = 0, min = -5, max = 15, step = 0.01)
        )
      ),
      ui_row(
        ui_col(
          style = "top: 20%",
          width = 2,
          katexR::katex("\\beta_1"),
        ),
        ui_col(
          width = 14,
          rangeInput("slope", value = 0, min = -2, max = 2, step = 0.01)
        )
      )
    ),
    tags$div(
      class = "item",
      ui_row(
        ui_col(
          width = 16,
          shiny.semantic::actionButton(
            "clear", "Clear plot", width = "100%"
          )
        )
      )
    ),
    
    tags$div(
      class = "item",
      ui_row(
        ui_col(
          width = 16,
          style = "text-align:center",
          tags$p(
            HTML("Sum of squares  <br>"),
            tags$span(id = "ss", style = "font-weight:bold"),
            style = "font-size:20px"
          )
        )
      )
    ),
    
    tags$div(
      class = "item",
      style = "margin-top:auto",
      tags$div(
        class = "ui grid",
        style = "margin: 0; padding:bottom: 1em",
        tags$div(
          class = "row",
          ui_col(
            width = 16,
            style = paste(
              "font-weight: bold",
              "text-align: center",
              sep = ";"
            ),
            actionLink(
              "how_to",
              "How to use this app?",
              style = "font-size:16px;",
              class = "footer-link"
            )
          )
        )
      )
    )
  )
}

body = function() {
  tags$div(
    style = "margin-left: 260px",
    tags$div(
      class = "ui container",
      tags$div(
        align = "center",
        tags$div(
          style = "min-height: 80vh;",
          r2d3::d3Output("d3", width = "800px", height = "800px")
        )
      )
    )
  )
}

ui = function() {
  shiny.semantic::semanticPage(
    tags$head(
      shiny::includeCSS("www/style.css")
    ),
    shinyjs::useShinyjs(),
    sidebar(),
    body()
  )
}
