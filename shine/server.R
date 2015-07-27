library(shiny)
library(sqldf)
library(reshape2)
library(ggplot2)
library(gridExtra)
library(grid)
wd.datapath = paste0(getwd(),"/data")
wd.init = getwd()
setwd(wd.datapath)

midwest2 = read.csv("midwest.csv", header = TRUE)

midwestNew <- sqldf(c("Alter table midwest2 ADD state_idMW varchar(15)",
  
  "Update midwest2 set state_idMW='ILLINOIS' where midwest2.state='IL'",
  "Update midwest2 set state_idMW='INDIANA' where midwest2.state='IN'",
  "Update midwest2 set state_idMW='MICHIGAN' where midwest2.state='MI'",
  "Update midwest2 set state_idMW='OHIO' where midwest2.state='OH'",
  "Update midwest2 set state_idMW='WISCONSIN' where midwest2.state='WI'",
  
  "Select * from midwest2"))

setwd(wd.init)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
     output$distPlot <- renderPlot({
     
      
       popQuery <- sqldf(paste0( "select sum(popwhite),sum(popblack),sum(popamerindian), sum(popasian), sum(popother),state_idMW   from midwestNew 
         where state_idMW ='", input$Stat, "';" ) )
       print(popQuery)
      
       popQuery2<-sqldf(paste0( "select percpovertyknown,percollege,state_idMW   from midwestNew 
         where state_idMW ='", input$Stat, "';" ) )
       
       popQuery3 <- sqldf(paste0( "select avg(percwhite),avg(percblack),avg(percamerindan), avg(percasian),
                    avg(percother),state_idMW   from midwestNew 
                     where state_idMW ='", input$Stat, "';" ) )
       
       
      m <- melt(popQuery,id.vars="state_idMW", variable.name = "Race", value.name = "Population_by_Race")
       print(m)
       
       n <- melt(popQuery3,id.vars="state_idMW", variable.name = "Race", value.name = "Percentage_by_Population")
       print(n)
       
       
      w<-ggplot(data = m, aes(x=state_idMW ,y=Population_by_Race,fill=Race)) +  geom_histogram(stat="identity",position="dodge")
      
      p <- ggplot(data = popQuery2, aes(y = percpovertyknown, x = percollege)) + geom_point((aes(color = state_idMW))) + ggtitle("College Education Vs Total Proverty") +
      xlab("Percent College Educated") + ylab("Percentage of Total proverty") 
      
 
      
      z <- ggplot(data = n, aes(x = "", y = Percentage_by_Population, fill = Race)) + 
        geom_bar(stat = "identity", color = 'black') + coord_polar(theta="y") + 
        guides(fill=guide_legend(override.aes=list(colour=NA)))
     
      
      pushViewport(viewport(layout = grid.layout(3, 1),width=0.75,height=1))
      
      print(w, vp = viewport(layout.pos.row = 1, layout.pos.col = 1 ))
      
      print(p, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
      
      print(z, vp = viewport(layout.pos.row = 3, layout.pos.col = 1))
        
    
      
      
      
     })
     
  })




