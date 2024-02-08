library(shiny)
library(DT)
library(tidyverse)
library(learnPopGen)

ui <- fluidPage(

    # Application title
    titlePanel("Genetic Drift and Selection at a Biallelic Locus"),

    # Sidebar with inputs
    sidebarLayout(
        sidebarPanel(
            sliderInput("p0",
                        "p0 (initial value of p):",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("Ne",
                        "Ne (effective population size):",
                        min = 0,
                        max = 1000,
                        value = 100),
            sliderInput("ngen",
                        "Number of generations):",
                        min = 0,
                        max = 1000,
                        value = 400),
            textInput("nrep",
                      "Number of simulations",
                      5),
            sliderInput("W_AA",
                        "W(AA):",
                        min = 0,
                        max = 2,
                        step = 0.05,
                        value = 1),
            sliderInput("W_Aa",
                        "W(Aa):",
                        min = 0,
                        max = 2,
                        step = 0.05,
                        value = 1),
            sliderInput("W_aa",
                        "W(aa):",
                        min = 0,
                        max = 2,
                        step = 0.05,
                        value = 1),
            checkboxInput("reactive", "reactive (plot changes instantly with new parameter values)", value = FALSE),
            checkboxInput("theoretical", "superimpose theoretical expectation)", value = FALSE),
            textInput("seed",
                      "Set seed (optional)",
                      ),
            actionButton("new_plot", label = "New Plot")
        ),

        # Plot of drift-selection simulation results
        mainPanel(
           plotOutput("plot")
        )
    )
)

# Define server logic
server <- function(input, output) {

    output$plot <- renderPlot({
        if (input$reactive) {
        drift.selection(
            p0 = input$p0,
            Ne = input$Ne,
            w = c(input$W_AA, input$W_Aa, input$W_aa),
            ngen = input$ngen,
            nrep = as.numeric(input$nrep)
            )
        }
    })

    observeEvent(input$new_plot,{
        p0 <- input$p0
        Ne <- input$Ne
        w <- c(input$W_AA,input$W_Aa,input$W_aa)
        ngen <- input$ngen
        nrep <- as.numeric(input$nrep)
        output$plot <- renderPlot({
            drift.selection(
                p0 = p0,
                Ne = Ne,
                w = w,
                ngen = ngen,
                nrep = nrep)
        })
    })
}

# Run the application
shinyApp(ui = ui, server = server)
