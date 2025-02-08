library(shiny)
library(shinythemes)
library(ggplot2)

ui <- fluidPage(
    theme = shinytheme("sandstone"),

    # CSS and Styling
    tags$head(tags$style(HTML("
        @keyframes bgAnimation {
            0% { background-color: #FFEBEE; } 
            25% { background-color: #E3F2FD; } 
            50% { background-color: #E8F5E9; } 
            75% { background-color: #FFF3E0; } 
            100% { background-color: #FFEBEE; } 
        }
        body {
            animation: bgAnimation 15s infinite alternate;
            font-family: 'Times New Roman', serif;
            position: relative;
        }
        .title-container {
            text-align: center;
            font-weight: bold;
            font-size: 40px;
            color: #2c3e50;
            padding: 20px;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.2);
        }
        .box {
            background: linear-gradient(to right, #ffecd2, #fcb69f);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 5px 5px 20px rgba(0,0,0,0.1);
            width: 50%;
            margin: auto;
            text-align: center;
            font-size: 22px;
            position: relative;
            z-index: 2;
            transition: all 0.4s ease-in-out;
        }
        .box:hover {
            background: linear-gradient(to right, #ffb3b3, #ffb3ff);
            box-shadow: 5px 5px 25px rgba(0,0,0,0.3);
            transform: scale(1.05);
        }
        .plot-box {
            background: linear-gradient(to right, #d1c4e9, #c5cae9);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 5px 5px 20px rgba(0,0,0,0.1);
            margin-top: 30px;
            width: 75%;
            margin-left: auto;
            margin-right: auto;
            position: relative;
            z-index: 2;
            transition: all 0.4s ease-in-out;
        }
        .plot-box:hover {
            background: linear-gradient(to right, #b3e5fc, #80deea);
            box-shadow: 5px 5px 25px rgba(0,0,0,0.3);
            transform: scale(1.05);
        }
        .btn-custom {
            background: linear-gradient(to right, #ff6b6b, #ff8e53);
            border: none;
            color: white;
            font-size: 20px;
            font-weight: bold;
            padding: 12px;
            width: 60%;
            border-radius: 8px;
            transition: 0.3s;
        }
        .btn-custom:hover {
            background: linear-gradient(to right, #ff8e53, #ff6b6b);
            box-shadow: 2px 2px 10px rgba(0,0,0,0.3);
            transform: scale(1.05);
        }
        .side-image {
            width: 20%;
            height: auto;
            position: absolute;
            top: 10%;
            opacity: 0.8;
            border-radius: 50%;
            transition: 0.4s ease-in-out;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            z-index: 1;
        }
        .side-image:hover {
            opacity: 1;
            transform: scale(1.1);
        }
        .image-left {
            left: 5%;
        }
        .image-right {
            right: 5%;
        }
        .center-image {
            width: 30%;
            display: block;
            margin: 10px auto;
            border-radius: 50%;
            box-shadow: 2px 2px 10px rgba(0,0,0,0.3);
            transition: 0.3s;
        }
        .center-image:hover {
            transform: scale(1.1);
        }
        .summary-text {
            font-size: 30px; 
            font-weight: bold;
            color: #2c3e50; 
            line-height: 1.6;
        }
        .summary-text .value {
            font-size: 35px; 
            color: #e74c3c; 
            font-weight: bold;
        }
    "))),

    # side image
    img(src="prob.jpg", class="side-image image-left"),
    img(src="prob.jpg", class="side-image image-right"),

    div(class = "title-container", h1("Success Rate Analyzer")),

    
    div(class = "box",
        img(src="set.jpg", class="center-image"),
        h4("Upload and Configure Parameters"),
        fileInput("file", "Upload CSV File", accept = c(".csv")),
        numericInput("n", "Number of Trials (n):", value = 10, min = 1),
        numericInput("p", "Success Probability (p):", value = 0.5, min = 0, max = 1, step = 0.01),
        actionButton("simulate", "Simulate Graph", class = "btn-custom"),
        actionButton("reset", "Reset Inputs", class = "btn-custom", style="margin-top: 10px;")
    ),

    # Plot Box
    div(class = "plot-box",
        h3("Binomial Distribution Visualization"),
        plotOutput("binomPlot", height = "400px")
    ),

    # Summary Box
    div(class = "plot-box",
        h4("Summary Statistics"),
        tags$pre(class = "summary-text", verbatimTextOutput("summary"))
    ),

    # Js 
    tags$script(HTML("
        Shiny.addCustomMessageHandler('reload', function(message) {
            location.reload();
        });

        Shiny.addCustomMessageHandler('resetFileInput', function(message) {
            // Reset the file input by clearing the value
            $('#file').val('');
        });
    "))
)

server <- function(input, output, session) {
    #  Default values
    default_n <- 10
    default_p <- 0.5

    # Simulation
    plot_data <- eventReactive(input$simulate, {
        x <- 0:input$n
        probs <- dbinom(x, size = input$n, prob = input$p)
        list(x = x, probs = probs)
    })

    output$binomPlot <- renderPlot({
        req(plot_data())  
        ggplot(data.frame(x = plot_data()$x, probs = plot_data()$probs), aes(x, probs)) +
            geom_bar(stat = "identity", fill = "#1A237E", alpha = 0.9) +
            labs(title = "Binomial Distribution", x = "Successes", y = "Probability") +
            theme_minimal() +
            theme(
                plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
                axis.text = element_text(size = 18, face = "bold"),
                axis.title = element_text(size = 20, face = "bold")
            )
    })

    # Summary statistics
    output$summary <- renderPrint({
        req(plot_data())  
        summary(dbinom(plot_data()$x, size = input$n, prob = input$p))
    })

    # Reset 
    observeEvent(input$reset, {
        updateNumericInput(session, "n", value = default_n)
        updateNumericInput(session, "p", value = default_p)
        
        # Reset
        session$sendCustomMessage(type = "resetFileInput", message = NULL)

        # Js reload
        session$sendCustomMessage("reload", NULL)
    })
}


shinyApp(ui = ui, server = server)
