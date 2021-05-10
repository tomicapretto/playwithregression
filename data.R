# This R6 class stores data and behavior related to the regression fit.
# `self$data` is a `reactiveValues()` object, so changes within these objects
# update the plot.

# scatter: Coordinates of the points
# line: Coordinates of the fitted line.
# rect: Coordinates and dimensions of the squares.
# model: Regression coefficients.

RegressionData = R6::R6Class(
  "RegressionData",
  public = list(
    bgrid = seq(0, 10, length.out = 100), # base grid
    grid = seq(0, 10, length.out = 100),
    data = reactiveValues(),
    
    initialize = function() {
      self$data[["scatter"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["line"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["rect"]] = data.frame(
        x = numeric(0), y = numeric(0), width = numeric(0), height = numeric(0)
      )
      self$data[["model"]] = list("coefficients" = c(0, 0))
    },
    
    # Add a new point and recompute model, fit, and rects.
    add_point = function(coords) {
      if (is.null(coords)) return(NULL)
      isolate({
        self$data[["scatter"]][nrow(self$data[["scatter"]]) + 1, ] = coords
        if (nrow(self$data[["scatter"]]) >= 2) {
          self$compute_model()
          self$compute_line()
          self$compute_rects()
        }
      })
    },
    
    # Fit linear regression via OLS using points in data[["scatter"]]
    compute_model = function() {
      self$data[["model"]] = lm(y ~ x, data = self$data[["scatter"]])
    },
    
    # Compute the coordinates of the line that is shown in the plot.
    compute_line = function() {
      # Avoid plotting outside the plot region delimited by x=[0, 10] y=[0, 10]
      intercept = self$get_intercept()
      slope = self$get_slope()
      y = intercept +  slope * self$bgrid
      
      if (sum(y > 0 & y < 10) > 0) {
        range_bgrid = range(self$bgrid[y > 0 & y < 10])
        self$grid = seq(range_bgrid[1], range_bgrid[2], length.out = 100)
        data = data.frame(
          x = self$grid,
          y = intercept + slope * self$grid
        )
      } else {
        data = data.frame(
          x = numeric(0),
          y = numeric(0)
        )
      }
      self$data[["line"]] = data
    },
    
    # Compute the coordinates and dimensions of the squares.
    compute_rects = function() {
      pred = self$get_intercept() + self$get_slope() * self$data[["scatter"]]$x
      self$data[["rect"]]  = data.frame(
        x = self$data[["scatter"]]$x,
        y = ifelse(
          pred >= self$data[["scatter"]]$y, 
          pred, 
          self$data[["scatter"]]$y
        ),
        width = abs(pred - self$data[["scatter"]]$y),
        height = abs(pred - self$data[["scatter"]]$y)
      )
    },
    
    # Add n random points and re-compute model, line, and squares.
    add_random_points = function(n=5) {
      df_n = nrow(self$data[["scatter"]])
      x = runif(n, 2, 8)
      y = 5 + x * rnorm(1, 0, 0.3) + rnorm(n)
      isolate({
        self$data[["scatter"]] = rbind(
          self$data[["scatter"]], 
          data.frame(x = x, y = y)
        )
        self$compute_model()
        self$compute_line()
        self$compute_rects()
      })
    },
    
    # Shake existing points, re-compute model, line, and squares.
    shake = function() {
      n = nrow(self$data[["scatter"]])
      isolate({
        if (n >= 1) {
          self$data[["scatter"]]$x = shake(self$data[["scatter"]]$x, 0.2)
          self$data[["scatter"]]$y = shake(self$data[["scatter"]]$y, 0.4) 
          self$compute_model()
          self$compute_line()
          self$compute_rects()
        }
      })
    },
    
    # Delete points, line, and squares.
    clear = function() {
      self$data[["scatter"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["line"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["rect"]] = data.frame(
        x = numeric(0), y = numeric(0), width = numeric(0), height = numeric(0)
      )
      self$data[["model"]] = list("coefficients" = c(0, 0))
    },
    
    # Return `self$data` as a list, without including "model".
    get_data_list = function() {
      data = reactiveValuesToList(self$data)
      data[names(data) != "model"]
    },
    
    # Return the value of the intercept of the fitted line
    get_intercept = function() {
      self$data[["model"]]$coefficients[[1]]
    },
    
    # Return the value of the slope of the fitted line
    get_slope = function() {
      self$data[["model"]]$coefficients[[2]]
    },
    
    # Replace existing intercept with a new value, recompute line and squares.
    set_intercept = function(x) {
      self$data[["model"]]$coefficients[[1]] = x
      self$compute_line()
      self$compute_rects()
    },
    
    # Replace existing slope with a new value, recompute line and squares.
    set_slope = function(x) {
      self$data[["model"]]$coefficients[[2]] = x
      self$compute_line()
      self$compute_rects()
    },
    
    # Trigger OLS fit. Useful when intercept and/or slope are manipulated.
    set_ols_fit = function() {
      if (nrow(self$data[["rect"]]) > 0) { 
        self$compute_model()
        self$compute_line()
        self$compute_rects()
      }
    },
    
    # Get sum of squares
    get_error = function() {
      if (nrow(self$data[["rect"]]) > 0) {
        sum(self$data[["rect"]]$height ^ 2)
      } else {
        NULL
      }
    }
  )
)

shake = function(x, sd) {
  x = x + rnorm(length(x), sd = sd)
  x = ifelse(x > 10, 10, x)
  x = ifelse(x < 0, 0, x)
  x
}