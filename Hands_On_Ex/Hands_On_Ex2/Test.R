pacman::p_load(sf, tmap, tidyverse)
mpsz <- st_read(dsn = "Hands_On_Ex/Hands_On_Ex2/data/geospatial", 
                layer = "MP14_SUBZONE_WEB_PL")
mpsz

popdata <- read_csv("Hands_On_Ex/Hands_On_Ex2/data/aspatial/respopagesexfa2011to2020.csv")

popdata2020 <- popdata %>%
  filter(Time == 2020) %>%
  group_by(PA, SZ, AG) %>%
  summarise(`POP` = sum(`Pop`)) %>%
  ungroup()%>%
  pivot_wider(names_from=AG, 
              values_from=POP) %>%
  mutate(YOUNG = rowSums(.[3:6])
         +rowSums(.[12])) %>%
  mutate(`ECONOMY ACTIVE` = rowSums(.[7:11])+
           rowSums(.[13:15]))%>%
  mutate(`AGED`=rowSums(.[16:21])) %>%
  mutate(`TOTAL`=rowSums(.[3:21])) %>%  
  mutate(`DEPENDENCY` = (`YOUNG` + `AGED`)
         /`ECONOMY ACTIVE`) %>%
  select(`PA`, `SZ`, `YOUNG`, 
         `ECONOMY ACTIVE`, `AGED`, 
         `TOTAL`, `DEPENDENCY`)

popdata2020 <- popdata2020 %>%
  mutate_at(.vars = vars(PA, SZ), 
            .funs = list(toupper)) %>%
  filter(`ECONOMY ACTIVE` > 0)
popdata2020 <- popdata2020 %>%
  mutate_at(.vars = vars(PA, SZ), 
            .funs = list(toupper)) %>%
  filter(`ECONOMY ACTIVE` > 0)

mpsz_pop2020 <- left_join(mpsz, popdata2020,
                          by = c("SUBZONE_N" = "SZ"))

tmap_mode("plot")
qtm(mpsz_pop2020, 
    fill = "DEPENDENCY")

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY", 
          style = "quantile", 
          palette = "Blues",
          title = "Dependency ratio") +
  tm_layout(main.title = "Distribution of Dependency Ratio by planning subzone",
            main.title.position = "center",
            main.title.size = 1.2,
            legend.height = 0.45, 
            legend.width = 0.35,
            frame = TRUE) +
  tm_borders(alpha = 0.5) +
  tm_compass(type="8star", size = 2) +
  tm_scale_bar() +
  tm_grid(alpha =0.2) +
  tm_credits("Source: Planning Sub-zone boundary from Urban Redevelopment Authorithy (URA)\n and Population data from Department of Statistics DOS", 
             position = c("left", "bottom"))

tm_shape(mpsz_pop2020) +
  tm_polygons()

tm_shape(mpsz_pop2020)+
  tm_polygons("DEPENDENCY")

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY")

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY") +
  tm_borders(lwd = 0.1,  alpha = 1)

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY",
          n = 5,
          style = "quantile") +
  tm_borders(alpha = 0.5)

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY",
          n = 5,
          style = "equal") +
  tm_borders(alpha = 0.5)


summary(mpsz_pop2020$DEPENDENCY)

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY",
          breaks = c(0, 0.60, 0.70, 0.80, 0.90, 1.00)) +
  tm_borders(alpha = 0.5)

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY",
          n = 6,
          style = "quantile",
          palette = "Blues") +
  tm_borders(alpha = 0.5)

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY",
          style = "quantile",
          palette = "-Greens") +
  tm_borders(alpha = 0.5)

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY", 
          style = "jenks", 
          palette = "Blues", 
          legend.hist = TRUE, 
          legend.is.portrait = TRUE,
          legend.hist.z = 0.1) +
  tm_layout(main.title = "Distribution of Dependency Ratio by planning subzone \n(Jenks classification)",
            main.title.position = "center",
            main.title.size = 1,
            legend.height = 0.45, 
            legend.width = 0.35,
            legend.outside = FALSE,
            legend.position = c("right", "bottom"),
            frame = FALSE) +
  tm_borders(alpha = 0.5)

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY", 
          style = "quantile", 
          palette = "-Greens") +
  tm_borders(alpha = 0.5) +
  tmap_style("classic")

tm_shape(mpsz_pop2020)+
  tm_fill("DEPENDENCY", 
          style = "quantile", 
          palette = "Blues",
          title = "No. of persons") +
  tm_layout(main.title = "Distribution of Dependency Ratio \nby planning subzone",
            main.title.position = "center",
            main.title.size = 1.2,
            legend.height = 0.45, 
            legend.width = 0.35,
            frame = TRUE) +
  tm_borders(alpha = 0.5) +
  tm_compass(type="8star", size = 2) +
  tm_scale_bar(width = 0.15) +
  tm_grid(lwd = 0.1, alpha = 0.2) +
  tm_credits("Source: Planning Sub-zone boundary from Urban Redevelopment Authorithy (URA)\n and Population data from Department of Statistics DOS", 
             position = c("left", "bottom"))

tmap_style("white")

tm_shape(mpsz_pop2020)+
  tm_fill(c("YOUNG", "AGED"),
          style = "equal", 
          palette = "Blues") +
  tm_layout(legend.position = c("right", "bottom")) +
  tm_borders(alpha = 0.5) +
  tmap_style("white")

tm_shape(mpsz_pop2020)+ 
  tm_polygons(c("DEPENDENCY","AGED"),
              style = c("equal", "quantile"), 
              palette = list("Blues","Greens")) +
  tm_layout(legend.position = c("right", "bottom"))

tm_shape(mpsz_pop2020) +
  tm_fill("DEPENDENCY",
          style = "quantile",
          palette = "Blues",
          thres.poly = 0) + 
  tm_facets(by="REGION_N", 
            free.coords=TRUE, 
            drop.shapes=TRUE) +
  tm_layout(legend.show = FALSE,
            title.position = c("center", "center"), 
            title.size = 20) +
  tm_borders(alpha = 0.5)

youngmap <- tm_shape(mpsz_pop2020)+ 
  tm_polygons("YOUNG", 
              style = "quantile", 
              palette = "Blues")

agedmap <- tm_shape(mpsz_pop2020)+ 
  tm_polygons("AGED", 
              style = "quantile", 
              palette = "Blues")

tmap_arrange(youngmap, agedmap, asp=1, ncol=2)

tm_shape(mpsz_pop2020[mpsz_pop2020$REGION_N=="CENTRAL REGION", ])+
  tm_fill("DEPENDENCY", 
          style = "quantile", 
          palette = "Blues", 
          legend.hist = TRUE, 
          legend.is.portrait = TRUE,
          legend.hist.z = 0.1) +
  tm_layout(legend.outside = TRUE,
            legend.height = 0.45, 
            legend.width = 5.0,
            legend.position = c("right", "bottom"),
            frame = FALSE) +
  tm_borders(alpha = 0.5)
