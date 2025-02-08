# Success Rate Analyzer - Shiny App

This repository contains a Shiny web application that simulates the binomial distribution and visualizes the results through an interactive plot. The app allows users to upload their data, adjust the number of trials and success probability, and generate a graph of the binomial distribution. It also provides a summary of key statistics based on the simulation.

## Features

- **File Upload**: Users can upload a CSV file (if available) to use for the analysis.
- **Simulation Controls**: 
  - Set the number of trials (`n`).
  - Set the probability of success (`p`).
- **Interactive Graph**: Displays a bar chart of the binomial distribution based on the input parameters.
- **Summary Statistics**: Shows important statistical values such as Min, Max, Mean, Median, etc., for the simulation.
- **Reset Option**: Reset inputs to their default values.
- **Animated Background**: Dynamic background animation that changes color during the app's use to enhance user experience.

## Technologies Used

- **R**: The primary programming language used to develop the Shiny application.
- **Shiny**: The framework for building interactive web applications in R.
- **ggplot2**: Used for visualizing the binomial distribution as a bar chart.
- **Shinythemes**: Provides a pre-designed theme for the UI (`sandstone` theme).

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/your-username/success-rate-analyzer.git
